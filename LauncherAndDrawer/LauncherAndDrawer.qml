import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Prototype.Components 0.3 as Proto
import 'Launcher'
import '../BezierCurve'
import '../'

Item {
    id: root

    property alias allAppsModel: drawer.allAppsModel
    property alias mostUsedAppsModel: drawer.mostUsedAppsModel
    property alias launcherAppsModel: launcher.model

    property var settings
    property Item blurSource: null
    property real launcherProgress
    property real drawerProgress
    property real deviceWidth: width


    signal applicationFocusRequest(string appId)
    signal uninstallRequest(string appId)

    QtObject {
        id: priv

        property real launcherAndDrawerWidth:  Math.min(settings.drawerMaxPercentage*root.width, units.gu(90)*settings.drawerMaxPercentage)
        property real drawerWidth: launcherAndDrawerWidth - launcher.width
        property real commitPoint: Math.min(0.4, units.gu(30) / leftEdgeSwipe.width)  // % of long swipe progress

        // helpers
        property real longSwipeTotalWidth: (1 - leftEdgeSwipe.longSwipeThreshold) * leftEdgeSwipe.width
    }

    function unbindProgresses() {
        unbindLauncherProgress()
        unbindDrawerProgress()
    }

    function unbindLauncherProgress() {
        root.launcherProgress = root.launcherProgress
    }

    function unbindDrawerProgress() {
        root.drawerProgress = root.drawerProgress
    }

    function show(showLauncher, showDrawer) {
        showHideAnimation.launcherFinalState = showLauncher ? 'show' : 'hide'
        showHideAnimation.drawerFinalState = showDrawer ? 'show' : 'hide'

        showHideAnimation.restart()
    }

    function hide(hideLauncher, hideDrawer) {
        showHideAnimation.launcherFinalState = !hideLauncher ? 'show' : 'hide'
        showHideAnimation.drawerFinalState = !hideDrawer ? 'show' : 'hide'

        showHideAnimation.restart()
    }

    function showLauncherAndDrawer() {
        show(true, true)
    }

    function hideDrawer() {
        hide(false, true)
    }

    function hideLauncherAndDrawer() {
        hide(true, true)
    }

    function bindLauncherProgress() {
        root.launcherProgress = Qt.binding(function() { return conceptProperties.launcherOpeningProgress})
    }

    function bindDrawerProgress() {
        root.drawerProgress = Qt.binding(function() { return conceptProperties.drawerOpeningProgress})
    }

    function showUninstallDialog(appId, appName) {
        if (!dialogLoader.active) {
            dialogLoader.sourceComponent = uninstallDialogComponent;
            dialogLoader.appId = appId
            dialogLoader.appName = appName
            dialogLoader.focus = true;
            dialogLoader.active = true;
        }
    }

    MouseArea {
        id: closer
        anchors.fill: parent
        hoverEnabled: true
        visible: root.state === 'launcher' || root.state === 'drawer'

        onPressed: {
            mouse.accepted = false
            hideLauncherAndDrawer()
        }
    }

    BackgroundBlur {
        id: backgroundBlur
        anchors.fill: parent
        visible: root.blurSource && blurAmount > 0 && root.launcherProgress > 0
        blurAmount: settings.drawerBlurAmount
        sourceItem: root.blurSource
        blurMask: Item {
            width: backgroundBlur.width
            height: backgroundBlur.height

            Rectangle {
                color: 'yellow'
                width: parent.width - (drawer.x + drawer.width)
                height: drawer.height
                anchors.right: parent.right
            }
        }
    }

    Drawer {
        id: drawer

        settings: root.settings
        height: parent.height
        width: priv.drawerWidth
        x: conceptProperties.drawerX
        opacity: 1
        contentOpacity: Proto.MathUtils.map(drawerProgress, 0.02,priv.commitPoint,0,1)
        enabled: root.state === 'drawer' || root.state === 'moving'
        deviceWidth: root.deviceWidth
        onClosingDragStarted: {
            root.state = 'moving'
            var maxPos = launcher.width + startX
            var minPos = 0
            var dragX = launcher.width + closingDragX
            root.drawerProgress = Qt.binding(function() { return Proto.MathUtils.clamp(Proto.MathUtils.map(launcher.width + closingDragX, minPos, maxPos, 0, 1), 0, 1)})
            root.launcherProgress = Qt.binding(function() { return Proto.MathUtils.clamp(Proto.MathUtils.map(closingDragX, -launcher.width, 0, 0, 1), 0, 1)})
        }
        onClosingDragEnded: {
            unbindProgresses()
            if (direction === Qt.RightToLeft)  {
                hideLauncherAndDrawer()
            } else {
                showLauncherAndDrawer()
            }
        }
        onItemClicked: {
            root.applicationFocusRequest(appId)
            hideLauncherAndDrawer()
        }
        onUninstallRequest: showUninstallDialog(appId, appName)
    }

    LauncherPanel {
        id: launcher
        settings: root.settings
        locked: false
        height: parent.height
        darken: settings.launcherDarkeningOpacity * Proto.MathUtils.clamp(Proto.MathUtils.map(drawerProgress, 0, priv.commitPoint, 0, 1), 0, 1)
        x: conceptProperties.launcherX
        onItemClicked: {
            root.applicationFocusRequest(appId)
            hideLauncherAndDrawer()
            //root.state = 'hidden'
        }
    }

    Proto.EdgeGestureDetector {
        id: leftEdgeSwipe
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }
        width: launcher.width + drawer.width
        enabled: true
        edgeWidth: units.gu(1)
        longSwipeThreshold: conceptProperties.longSwipeThreshold
        leftEdgeActive: true
        animationDuration: 0
        onGestureStarted: {
            if (root.state === 'hidden' || root.state === 'launcher') bindDrawerProgress()
            if (root.state === 'hidden') bindLauncherProgress()

            root.state = 'moving'
        }
        onGestureEnded: {
            unbindProgresses()
            if (edgeId == 'left' && direction === Qt.LeftToRight && gestureType === 'short') {
                hideDrawer()
            } else if (edgeId == 'left' && direction === Qt.LeftToRight && gestureType === 'long') {
                if (leftEdgeSwipe.longProgress < priv.commitPoint) {
                    hideDrawer()
                } else {
                    drawer.focusSearch()
                    showLauncherAndDrawer()
                }
            } else if (edgeId == 'left' && direction === Qt.RightToLeft) {
                hideLauncherAndDrawer()
            }
        }
        onGestureFinished: reset()
    }

    // Not used currently since creating a custom curve everywhere in our UI is not a very good practice
    BezierCurve {
        id: drawerOpeningCurve
        controlPoint2: {'x': settings.drawerCurveControlPoints[0].x, 'y': settings.drawerCurveControlPoints[0].y}
        controlPoint3: {'x': settings.drawerCurveControlPoints[1].x, 'y': settings.drawerCurveControlPoints[1].y}
    }

    SequentialAnimation {
        id: showHideAnimation

        property string launcherFinalState: 'show'// ['show', 'hide']
        property string drawerFinalState: 'show'// ['show', 'hide']

        property real animationDuration: UbuntuAnimation.FastDuration
        property int animationEasingType: UbuntuAnimation.StandardEasing.type

        ScriptAction {
            script: {
                if (showHideAnimation.launcherFinalState === 'show') {
                    if (showHideAnimation.drawerFinalState === 'show') root.state = 'drawer'
                    else root.state = 'launcher'
                } else {
                    root.state = 'hidden'
                }
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: root
                property: 'launcherProgress'
                to: showHideAnimation.launcherFinalState === 'show' ? 1 : 0
                duration: showHideAnimation.animationDuration
                easing.type: showHideAnimation.animationEasingType
            }
            NumberAnimation {
                target: root
                property: 'drawerProgress'
                to: showHideAnimation.drawerFinalState === 'show' ? 1 : 0
                duration: showHideAnimation.animationDuration
                easing.type: showHideAnimation.animationEasingType
            }
        }
    }

    state: 'hidden'
    //onStateChanged: console.log('state', state)
    states: [
        State {
            name: 'hidden'
        },
        State {
            name: 'launcher'
        },
        State {
            name: 'drawer'
        },
        State {
            name: 'moving'
        }
    ]

    Item {
        id: conceptProperties

        property real launcherX: currentConcept.launcherX
        property real launcherOpeningProgress: currentConcept.launcherOpeningProgress
        property real drawerX: currentConcept.drawerX
        property real drawerOpeningProgress: currentConcept.drawerOpeningProgress
        property real longSwipeThreshold: currentConcept.longSwipeThreshold

        property Component currentConceptComponent: {
            var concept
            switch(settings.openingConcept) {
                case "Concept1":
                    concept = concept1
                    break;
                case "Animated hint":
                    concept = animatedHint
                    break;
                case "Specified":
                    concept = specified
                    break;
                case "Concept4":
                    concept = concept4
                    break;

            }
            return concept
        }

        property QtObject currentConcept: currentConceptLoader.item

        Loader {
            id: currentConceptLoader
            sourceComponent: conceptProperties. currentConceptComponent
        }

        Component {
            id: concept1
            QtObject {
                property real launcherX: -launcher.width + root.launcherProgress * launcher.width
                property real launcherOpeningProgress: leftEdgeSwipe.limitedShortProgress
                property real drawerX: (launcher.x + launcher.width) - drawer.width + root.drawerProgress * drawer.width
                property real drawerOpeningProgress:  Proto.Easing.easeInOutCubic(leftEdgeSwipe.longProgress)
                property real longSwipeThreshold: launcher.width / leftEdgeSwipe.width
            }
        }

        Component {
            id: animatedHint
            Item {
                QtObject {
                    id: p

                    property real launcherHintAmount: units.gu(1)
                    property real launcherHintPercentage: launcherHintAmount / (longSwipeThreshold * leftEdgeSwipe.width)

                    // @todo: this fails
                    property real launcherHintProgress: leftEdgeSwipe.dragging && leftEdgeSwipe.limitedShortProgress > 0.00001 ? launcherHintPercentage : 0
                    Behavior on launcherHintProgress {UbuntuNumberAnimation {duration: UbuntuAnimation.SnapDuration }}

                    property real drawerHintAmount: units.gu(1.5)
                    property real drawerHintPercentage: drawerHintAmount / ((1 - longSwipeThreshold) * leftEdgeSwipe.width)

                    // @todo: this fails
                    property real drawerHintProgress: leftEdgeSwipe.dragging && leftEdgeSwipe.longProgress > 0.00001 ? drawerHintPercentage : 0
                    Behavior on drawerHintProgress {UbuntuNumberAnimation {duration: UbuntuAnimation.SnapDuration }}
                }

                property real launcherX: -launcher.width + root.launcherProgress * launcher.width
                property real launcherOpeningProgress: {
                    var revealProgress = (1 - p.launcherHintPercentage) * leftEdgeSwipe.limitedShortProgress
                    return p.launcherHintProgress + revealProgress
                }
                property real drawerX: (launcher.x + launcher.width) - drawer.width + root.drawerProgress * drawer.width
                property real drawerOpeningProgress: {
                    var revealProgress = (1 - p.drawerHintPercentage) * Proto.Easing.easeInOutCubic(leftEdgeSwipe.longProgress)
                    return p.drawerHintProgress + revealProgress
                }
                property real longSwipeThreshold: (launcher.width - p.launcherHintAmount) / leftEdgeSwipe.width
            }
        }

        Component {
            id: specified
            Item {
                QtObject {
                    id: p
                    property real launcherHintAmount: units.gu(1)
                    property real drawerHintAmount: units.gu(1.5)
                }

                property real launcherX: -launcher.width + root.launcherProgress * launcher.width
                property real launcherOpeningProgress: {
                    var shortSwipeWidth = longSwipeThreshold * leftEdgeSwipe.width
                    var hintAmount = p.launcherHintAmount / shortSwipeWidth
                    var hintProgress = Proto.MathUtils.clamp(Proto.MathUtils.map(leftEdgeSwipe.limitedShortProgress, 0, hintAmount/4, 0, hintAmount), 0, hintAmount)
                    var revealProgress = (1 - hintProgress) * leftEdgeSwipe.limitedShortProgress
                    return hintProgress + revealProgress
                }
                property real drawerX: (launcher.x + launcher.width) - drawer.width + root.drawerProgress * drawer.width
                property real drawerOpeningProgress: {
                    var hintAmount = p.drawerHintAmount / ((1 - longSwipeThreshold) * leftEdgeSwipe.width)
                    var hintProgress = Proto.MathUtils.clamp(Proto.MathUtils.map(leftEdgeSwipe.longProgress, 0, hintAmount/4, 0, hintAmount), 0, hintAmount)
                    var revealProgress = (1 - hintAmount) * Proto.Easing.easeInOutCubic(leftEdgeSwipe.longProgress)
                    return hintProgress + revealProgress
                }
                property real longSwipeThreshold: (launcher.width - p.launcherHintAmount) / leftEdgeSwipe.width
            }
        }

        Component {
            id: concept4
            QtObject {
                property real launcherX: -launcher.width + root.launcherProgress * launcher.width
                property real launcherOpeningProgress: leftEdgeSwipe.limitedShortProgress
                property real drawerX: (launcher.x + launcher.width) - drawer.width + root.drawerProgress * drawer.width
                property real drawerOpeningProgress: {
                    var hintAmount = 0.022
                    var hintProgress = hintAmount * Proto.MathUtils.clamp(Proto.MathUtils.map(leftEdgeSwipe.longProgress, 0, 0.01, 0, 1), 0, 1)
                    var revealProgress = (1 - hintAmount) * Proto.Easing.easeInOutCubic(leftEdgeSwipe.longProgress)

                    // replace previous line with this if want to use custom bezier curve
                    //var revealProgress = (1 - hintAmount) * drawerOpeningCurve.getYFromX(leftEdgeSwipe.longProgress)

                    return hintProgress + revealProgress
                }
                property real longSwipeThreshold: (launcher.width - units.gu(1)) / leftEdgeSwipe.width
            }
        }
    }

    LauncherDebugInfo {
        id: launcherDebug
        visible: settings.showLauncherDebug
        anchors.fill: parent
        settings: root.settings
        commitPointX: launcher.width + priv.commitPoint * priv.longSwipeTotalWidth
    }


// -------------------Dialog---------------------------------------------------------------
    Component {
           id: dialogComponent
        Dialog {
            id: dialog
            title: "Input dialog"
            // the dialog and its children will use SuruDark
            theme: ThemeSettings {
                name: "Ubuntu.Components.Themes.SuruDark"
            }
            TextField {
                placeholderText: "enter text"
            }
            Button {
                text: "Close"
                onClicked: PopupUtils.close(dialog)
            }
            onParentChanged: console.log('parent', parent)
        }
    }

    Component {
        id: uninstallDialogComponent
        UninstallDialog {
            id: uninstallDialog

            // title
            Label {
                text: "Do you want to uninstall " + dialogLoader.appName
                wrapMode: Text.Wrap
                maximumLineCount: 2
                elide: Text.ElideRight
                textSize: Label.Large
                color: theme.palette.normal.overlayText
                visible: (text !== "")
            }

            // text
            Label {
                text: "This app and its data will be deleted permanently"
                color: theme.palette.normal.overlayText
                wrapMode: Text.Wrap
                visible: (text !== "")
            }

            // divider
            Rectangle {
                width: parent.width
                height: units.dp(1)
                color: UbuntuColors.lightGrey
            }

            // buttons
            Item {
                id: container
                width: parent.width
                height: childrenRect.height

                Item {
                    id: cancel
                    width: uninstallButton.width
                    height: uninstallButton.height
                    anchors {
                        right: uninstallButton.left
                        rightMargin: units.gu(1)
                    }

                    Label {
                        text: i18n.tr("Cancel")
                        color: UbuntuColors.darkGrey
                        anchors {
                            centerIn: parent
                        }

                        MouseArea {
                            anchors {
                                fill: parent
                                margins: units.gu(0.5)
                            }
                            onClicked: {
                                uninstallDialog.hide();
                            }
                        }
                    }
                }
                Button {
                    id: uninstallButton
                    text: i18n.tr("Uninstall")
                    anchors {
                        right: parent.right
                        rightMargin: units.gu(1)
                    }
                    onClicked: {
                        root.uninstallRequest(dialogLoader.appId)
                        uninstallDialog.hide();
                    }
                    color: UbuntuColors.red
                }
            }
        }
    }
    Loader {
        id: dialogLoader

        property string appId
        property string appName

        objectName: "dialogLoader"
        anchors.fill: parent
        active: false
    }
 }
