import QtQuick 2.4
import Ubuntu.Components 0.1
import 'Components'

Item {
    id: root

    property bool locked: false
    property real longSwipeProgress: 0
    property bool longSwipeActive: false
    property color overlayColor: 'black'

    readonly property real openProgress: 1 + panel.x / panel.width
    property alias shown: panel.shown
    property alias revealer: panelRevealer

    signal longSwipeFinished(bool finishToRight)
    signal appOpened(string appName)

    function hide() {
        panel.hide()
    }

    Rectangle {
        id: dismissOverlay
        color: overlayColor
        opacity: !panel.shown || (longSwipeActive ) ? 0 : 0.6
        Behavior on opacity {
            SequentialAnimation {
                PauseAnimation { duration: 50 }
                NumberAnimation{
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }
        }
        anchors.fill: parent
        MouseArea {
            anchors.fill: parent
            visible: panel.shown
            onPressed: panel.hide()
        }
    }

    LauncherPanel {
        id: panel
        locked: root.locked
        property int animationDuration: 500
        height: parent.height
        shown: false
        showAnimation: NumberAnimation {
            property: 'x'
            duration: panel.animationDuration
            to: panelRevealer.openedValue
            easing.type: Easing.OutCubic
        }
        hideAnimation: NumberAnimation {
            property: 'x'
            duration: panel.animationDuration
            to: panelRevealer.closedValue
            easing.type: Easing.OutCubic
        }
        onAppOpened: {
            root.appOpened(appName)
            panel.hide()
        }
    }

    Revealer {
        id: panelRevealer

        target: panel
        orientation: Qt.Horizontal
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        hintDisplacement: units.gu(1)
        handleSize: target.shown ? units.gu(4) : units.gu(2)
        openedValue: 0
        closedValue: -panel.width
        width: panel.width + units.gu(3)

        onDragPositionChanged: {
            if (panelRevealer.dragging) {
                if (dragPosition >= panel.width + units.gu(0.5)) {
                    longSwipeActive = true
                    longSwipeProgress = (panelRevealer.dragPosition - panel.width) / (root.width - panel.width)
                } else {
                    longSwipeActive = false
                }
            }
        }
        onReleased: {
            var longSwipeThreshold = root.width/2
            if (signedDragVelocity > 0 && dragPosition >= longSwipeThreshold) {
                root.longSwipeFinished(true)
                panelHideAnimation.restart()
            } else  {
                root.longSwipeFinished(false)
            }

            longSwipeActive = false
        }
    }

    SequentialAnimation {
        id: panelHideAnimation
        PauseAnimation { duration: 50 }
        ScriptAction {
            script: panel.hide()
        }
    }
}
