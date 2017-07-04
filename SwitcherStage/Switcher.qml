import QtQuick 2.4
import Ubuntu.Components 1.3
import Prototype.Components 0.3 as Proto

Item {
    id: root

    property var settings
    property size screenSize: Qt.rect(0,0)
    property real switcherProgress: 0
    property real shortSwipeProgress: 0
    readonly property string currentlyFocusedAppName: container.currentlyFocusedAppName

    signal appClosed(string appId)

    function toggleSwitcher() {
         if (switcherProgress < 0.5) {
             edges.emulateLongSwipe('right')
         } else {
             root.switcherProgress = root.switcherProgress
             switcherResetAnimation.restart()
             edges.reset()
         }
     }

    function createAppInstance(data) {
        container.createAppInstance(data)
    }

    function focusToApp(appId) {
        container.focusToApp(appId)
    }

    function closeApp(appId) {
        container.closeApp(appId)
    }

    QtObject {
        id: layout
        property real workspacesTopMargin:  settings.showWorkspaces ? 0.05 * root.height : 0
        property real workspacesHeight: settings.showWorkspaces ? 0.2 * root.height : 0
        property real spreadHeight: root.height - workspacesHeight - workspacesTopMargin
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        color: 'black'
        opacity: {
            if (settings.desktopMode === 'Windowed') return settings.switcherOverlayOpacity * container.switcherProgress
            else return 1 - (1 - settings.switcherOverlayOpacity)* container.switcherProgress
        }
    }

    Item {
        width: parent.width
        height: layout.workspacesTopMargin
        visible: settings.showDebugRects
        Proto.DebugRect { color: 'green'; visible: settings.showDebugRects}
    }

    WorkspacesRow {
        id: workspaces

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: layout.workspacesTopMargin
        }
        height: layout.workspacesHeight

        visible: settings.showWorkspaces
        opacity: Proto.MathUtils.map(container.switcherProgress, 0.7, 1, 0, 1)
        screenAspectRatio: screenSize.width / screenSize.height

        Proto.DebugRect { color: 'red'; visible: settings.showDebugRects}
    }

    ApplicationsContainer {
        id: container

        anchors.fill: parent
        settings: root.settings
        spreadHeight: layout.spreadHeight
        screenSize: root.screenSize
        switcherProgress: root.switcherProgress
        shortSwipeProgress: root.shortSwipeProgress

        onItemSelected: {
            // break the bindings
            root.switcherProgress = root.switcherProgress
            root.shortSwipeProgress = root.shortSwipeProgress

            switcherResetAnimation.restart()
            edges.reset()
        }
        onAppClosed: root.appClosed(appId)
    }

    SequentialAnimation {
        id: switcherResetAnimation
        ParallelAnimation {
            UbuntuNumberAnimation {
                target: root
                property: 'switcherProgress'
                to: 0
                duration: container.state === "switcher" ? UbuntuAnimation.FastDuration : 0

            }
            UbuntuNumberAnimation {
                target: root
                property: 'shortSwipeProgress'
                to: 0
                duration: container.state === "switcher" ? UbuntuAnimation.FastDuration : 0
            }
        }
        ScriptAction {
            script: container.focusingFinished()
        }
    }

    Proto.EdgeGestureDetector {
        id: edges
        anchors.fill: parent
        anchors.leftMargin: -0.05 * parent.width // this way full gesture can't be performed before releasing
        enabled: gestureActive || container.state !== "switcher"
        edgeWidth: units.gu(1)
        longSwipeThreshold: 0.2
        rightEdgeActive: true
        animationDuration: UbuntuAnimation.FastDuration //* settings.animationDurationFactor
        onGestureStarted: {
            root.switcherProgress = Qt.binding(function() {
                        return edges.longProgress
                    })

            root.shortSwipeProgress = Qt.binding(function() {
                        return edges.limitedShortProgress
                    })
        }
        onGestureEnded: {
            if (edgeId == 'right' && direction === Qt.RightToLeft && gestureType === 'short') {
                    root.switcherProgress = root.switcherProgress
                    root.shortSwipeProgress = root.shortSwipeProgress
                    edges.reset()
                    container.finishShortSwipe()
            }
        }
    }

}

