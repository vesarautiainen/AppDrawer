import QtQuick 2.4
import Ubuntu.Components 1.3
import Prototype.Components 0.3 as Proto
import '../BezierCurve'


Item {
    id: root

    property size screenSize: Qt.size(0,0)
    property var settings
    property real spreadHeight

    property real switcherProgress: 0
    property real inverseSwitcherProgress: 1 - switcherProgress

    property real shortSwipeProgress: 0
    property real inverseShortSwipeProgress: 1 - shortSwipeProgress

    property string currentlyFocusedAppName: {
        if (root.state === 'switcher') return ''

        var item = Proto.ListModelUtils.findFromArray(container.children, function(element) {
            if (element.itemIndex === 0) return element
        })

        if (item) return item.appName
        else return  ''
    }

    signal itemSelected()
    signal appClosed(string appId)

    QtObject {
        id: priv

        property real itemOverlap: {
            var spreadAspectRatioReferencePoint = 1.0 // ref screen height in gu
            var valueAtRefeferencePoint = 0.74 // of screen height at the reference point
            var itemOverlapValueChange = -0.068
            var minOverlap = 0.55
            var maxOverlap = 0.82
            var spreadAspectRatio = spreadWidth/stackHeight // spread stack aspect ratio (app info not included)

            return settings.automaticLayout
                    ? Proto.MathUtils.clamp(valueAtRefeferencePoint + itemOverlapValueChange * (spreadAspectRatio - spreadAspectRatioReferencePoint), minOverlap, maxOverlap)
                    : settings.itemOverlap
        }

        property real appInfoHeight: {
            var screenHeightReferencePoint = 40 // ref screen height in gu
            var valueAtRefeferencePoint = 0.17 // of screen height at the reference point
            var appInfoHeightValueChange = -0.0014 // units / gu
            var minAppInfoHeight = 0.08
            var maxAppInfoHeight = 0.2
            var screenHeightInGU = screenSize.height / units.gu(1) // screenHeight in gu

            return (settings.automaticLayout
                    ? Proto.MathUtils.clamp(valueAtRefeferencePoint + appInfoHeightValueChange * (screenHeightInGU - screenHeightReferencePoint), minAppInfoHeight, maxAppInfoHeight)
                    : settings.appInfoHeightPercentage) * screenSize.height
        }

        property real rotationAngleFactor: {
            var spreadHeightReferencePoint = 28 // reference spread height in gu
            var valueAtRefeferencePoint = 1.3
            var rotationAngleValueChange = -0.008 // units / gu
            var minRotationAngleFactor = 0.6
            var maxRotationAngleFactor = 1.5
            var spreadHeightInGU = spreadHeight / units.gu(1)

            return settings.automaticLayout
                    ? Proto.MathUtils.clamp(valueAtRefeferencePoint + rotationAngleValueChange * (spreadHeightInGU - spreadHeightReferencePoint), minRotationAngleFactor, maxRotationAngleFactor)
                    : 1
        }

        // other spread shape and layout parameters
        property real spreadItemHeight: 0.84 * spreadHeight
        property real stackHeight: spreadItemHeight - appInfoHeight
        property real contentMargin: 0.16 * spreadHeight
        property real contentTopMargin: 0.65 * contentMargin
        property real contentBottomMargin: 0.35 * contentMargin
        property real windowTitleTopMargin: 3/4 * (contentTopMargin - windowTitle.height)
        property real leftStackScale: settings.leftScale
        property real rightStackScale: settings.rightScale
        property real leftRotationAngle: settings.leftRotationAngle * rotationAngleFactor
        property real rightRotationAngle: settings.rightRotationAngle * rotationAngleFactor
        property real spreadItemWidth: stackHeight

        property real spreadTopMargin: root.height - spreadHeight // spread stack distance to the top of the switcher
        property real visibleItemCount: (spreadWidth / spreadItemWidth) / (1 - itemOverlap)
        property real totalItemCount: container.children.length
        property real leftStackXPos: settings.automaticLayout ?  0.03 * screenSize.width : settings.spreadMargin
        property real rightStackXPos: root.width - 1.5 * leftStackXPos
        property real stackWidth: Math.min(leftStackXPos/3, units.gu(1.5))
        property int stackItemCount: 3
        property real spreadWidth: rightStackXPos - leftStackXPos

        property real switchPoint: settings.windowedSwitchPoint
        property real spreadTotalWidth: totalItemCount * spreadWidth / visibleItemCount
        property SpreadDelegate focusingItem: null // the item that is currently under focus animation. Only animation related.
        property SpreadDelegate focusedItem: null // the item that has mouse focus currently
    }

    function closeApp(appId) {
        var item = Proto.ListModelUtils.findFromArray(container.children, function(element) {
            if (element.appId === appId) return element
        })

        if (item) {
            Proto.ListModelUtils.eachForArray(container.children, function(element) {
                if (element.itemIndex > item.itemIndex) element.itemIndex--
            })

            closeAnimation.itemToClose = item
            closeAnimation.restart()
        }
    }

    function createAppInstance(data) {
        var component = itemComponent
        var object = component.createObject(container)

        object.appId = data.appId
        object.appName = data.appName
        object.appScreenshot = data.screenshot
        object.appIcon = data.appIcon
        object.itemIndex = 0

        Proto.ListModelUtils.eachForArray(container.children, function(element) {
            if (element !== object) element.itemIndex++
        })

        object.itemIndex = 0

        openAnimation.itemToOpen = object
        openAnimation.restart()
    }

    function focusToApp(appId) {
        var item = Proto.ListModelUtils.findFromArray(container.children, function(element) {
            if (element.appId === appId) return element
        })

        focusToItem(item)
    }

    function finishShortSwipe() {
        var shortSwipeFinishAnimation = settings.desktopMode === 'Staged' ? stagedShortSwipeFinishAnimation : windowedShortSwipeFinishAnimation

        // search the focusing item from the correct container
        var focusingItemContainer = settings.desktopMode === 'Staged' ? container : animationContainer

        shortSwipeFinishAnimation.hideItem = Proto.ListModelUtils.findFromArray(container.children, function(element) {
            if (element.itemIndex === 0) return element
        })

        shortSwipeFinishAnimation.focusItem = Proto.ListModelUtils.findFromArray(focusingItemContainer.children, function(element) {
            if (element.itemIndex === 1) return element
        })

        shortSwipeFinishAnimation.restart()
    }

    function reset() {
        priv.focusingItem = null
        priv.focusedItem = null
        flickable.contentX = 0
    }

    function focusToItem(item) {
        priv.focusingItem = item
        root.itemSelected()
    }

    function startFocusAnimation(selectedItem) {
        focusAnimation.focusItem = selectedItem
        focusAnimation.restart()
    }

    function focusingFinished() {
        Proto.ListModelUtils.eachForArray(container.children, function(element) {
            if (element.itemIndex < priv.focusingItem.itemIndex) element.itemIndex++
        })

        priv.focusingItem.itemIndex = 0

        reset()
    }

    function easeOutCubic(t) { return (--t)*t*t+1 }

    Label {
        id: windowTitle

        width: Math.min(implicitWidth, 0.5*root.width)
        elide: Qt.ElideMiddle
        anchors.horizontalCenter: parent.horizontalCenter
        y: priv.spreadTopMargin + priv.windowTitleTopMargin + settings.spreadOffset + settings.titleOffset
        visible: height < priv.contentTopMargin && settings.showTitle
        opacity: Proto.MathUtils.map(switcherProgress, 0.7, 1, 0, 1)
        text: priv.focusedItem ? priv.focusedItem.title : ''
        fontSize: root.height < units.gu(85) ? 'medium' : 'large'
        color: 'white'
    }

    Flickable {
        id: flickable
        anchors.fill: root
        contentWidth: priv.spreadTotalWidth
        contentHeight: height
        flickableDirection: Qt.Horizontal
        rightMargin: leftMargin
        onFlickStarted: priv.focusedItem = null
        onDragStarted: priv.focusedItem = null
        leftMargin: {
            var stepOnXAxis = 1 / priv.visibleItemCount
            var distanceToIndex1 = curve.getYFromX(stepOnXAxis)
            var middlePartDistance = curve.getYFromX(0.5 + stepOnXAxis/2) - curve.getYFromX(0.5 - stepOnXAxis/2)
            return 1.2 * (middlePartDistance - distanceToIndex1) * priv.spreadWidth
        }
        interactive: root.state === 'switcher'

        Component.onCompleted: {
            maximumFlickVelocity = maximumFlickVelocity * (units.gu(1) / 8)
            flickDeceleration = flickDeceleration * (units.gu(1) / 8)
        }
    }

    BezierCurve {
        id: curve
        controlPoint2: {'x': settings.spreadCurveControlPoints[0].x, 'y': settings.spreadCurveControlPoints[0].y}
        controlPoint3: {'x': settings.spreadCurveControlPoints[1].x, 'y': settings.spreadCurveControlPoints[1].y}
    }

    BezierCurve {
        id: longSwipeCurve
        controlPoint2: {'x': settings.longSwipeCurveControlPoints[0].x, 'y': settings.longSwipeCurveControlPoints[0].y}
        controlPoint3: {'x': settings.longSwipeCurveControlPoints[1].x, 'y': settings.longSwipeCurveControlPoints[1].y}
    }

    Item {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: priv.spreadTopMargin + priv.contentTopMargin
        }
        height: priv.stackHeight
        Proto.DebugRect {
            color: 'pink'
            visible: settings.showDebugRects
        }
    }

    property real curvedSwitcherProgress: settings.desktopMode === 'Staged' ? root.switcherProgress : longSwipeCurve.getYFromX(root.switcherProgress)
    property real inverseCurvedSwitcherProgress: 1 - curvedSwitcherProgress


    Item {
        id: container
        width: root.width
        height: root.height
        parent: flickable
    }

    Component {
        id: itemComponent
        SpreadDelegate {
            id: spreadItem

            //Application data
            property string appName
            property string appId
            property string appScreenshot
            property string appIcon
            property int itemIndex

            property real spreadPosition: itemIndex/priv.visibleItemCount - flickable.contentX/priv.spreadWidth // 0 -> left stack, 1 -> right stack
            property real leftStackingProgress: Proto.MathUtils.clamp(Proto.MathUtils.map(spreadPosition, 0, -priv.stackItemCount/priv.visibleItemCount  , 0, 1), 0, 1)
            property real rightStackingProgress: Proto.MathUtils.clamp(Proto.MathUtils.map(spreadPosition, 1, 1 + priv.stackItemCount/priv.visibleItemCount  , 0, 1), 0, 1)
            property real stackingX: (easeOutCubic(rightStackingProgress) - easeOutCubic(leftStackingProgress)) * priv.stackWidth

            property real switcherRotation: Proto.MathUtils.clamp(Proto.MathUtils.map(x, priv.leftStackXPos, priv.rightStackXPos, priv.leftRotationAngle, priv.rightRotationAngle), Math.min(priv.leftRotationAngle, priv.rightRotationAngle), Math.max(priv.leftRotationAngle, priv.rightRotationAngle))
            property real desktopRotation: maths.desktopRotation
            property point desktopPosition: maths.desktopPosition
            property point switcherPosition: {
                var switcherX = priv.leftStackXPos +
                                priv.spreadWidth * curve.getYFromX(spreadPosition + centeringOffset) +
                                stackingX

                return Qt.point(switcherX, 0)
            }
            property real switcherScale: Proto.MathUtils.clamp(Proto.MathUtils.map(spreadPosition, 0, 1, priv.leftStackScale, priv.rightStackScale), priv.leftStackScale, priv.rightStackScale)
            property real switchProgress: Proto.MathUtils.map(curvedSwitcherProgress, itemIndex * 1/priv.totalItemCount, (itemIndex + 1) * 1/priv.totalItemCount , 0, 1)
            property real centeringOffset: Math.max(priv.spreadWidth - flickable.contentWidth ,0) / (2 * priv.spreadWidth)

            spreadWidth: priv.spreadItemWidth // item width in spread to be more precise
            spreadHeight: priv.stackHeight
            screenSize: root.screenSize
            titlebarOpacity: settings.desktopMode === 'Windowed' ? Proto.MathUtils.clamp(Proto.MathUtils.map(curvedSwitcherProgress, priv.switchPoint - 0.1, priv.switchPoint + 0.05, 1, 0), 0,1) : 0
            titlebarHeight: settings.desktopMode === 'Windowed' ? Proto.MathUtils.clamp(Proto.MathUtils.map(curvedSwitcherProgress, priv.switchPoint + 0.05, 1, units.gu(2.5), 0), 0, units.gu(2.5)) : 0
            title: appName
            isFocused: priv.focusedItem === this
            active: itemIndex === 0

            visible: {
                var leftStackHidden
                var rightStackHidden

                if (root.state !== 'switcher') {
                    return true
                } else {
                    leftStackHidden = spreadPosition < -(priv.stackItemCount + 1)/priv.visibleItemCount

                    // don't hide the rightmost
                    rightStackHidden = (spreadPosition > 1 + (priv.stackItemCount)/priv.visibleItemCount) && itemIndex !== priv.totalItemCount - 1
                    return !leftStackHidden && !rightStackHidden
                }
            }

//            shadowOpacity: {
//                var returnValue = 0

//                if (root.state === 'switcher') returnValue =  0.2 * (1  - rightStackingProgress) * (1 - leftStackingProgress)
//                else if (root.state === 'windowed') itemIndex === 0 ? returnValue = 0.35 : returnValue = 0.20
//                else if (root.state === 'staged') returnValue = shortSwipeProgress > 0 ? 0.15 : 0

//                return returnValue
//            }
//            Behavior on shadowOpacity {enabled: root.state !== 'switcher'; UbuntuNumberAnimation{duration: UbuntuAnimation.SnapDuration}}

            screenshot: appScreenshot !== ''?  '../graphics/screens/' + appScreenshot : ''
            state: root.state
            itemRotation: curvedSwitcherProgress * switcherRotation + inverseCurvedSwitcherProgress * desktopRotation
            itemScale: curvedSwitcherProgress * switcherScale + inverseCurvedSwitcherProgress * maths.desktopScale
            focusHightlightWidth: appInfo.iconMargin / 2

            // In windowed mode and is the item that is next to be focused
            property bool windowedFocusing: itemIndex === 1 && root.state === 'windowed' && shortSwipeProgress > 0 && curvedSwitcherProgress <= 0
            useOpacityMask: windowedFocusing
            parent: windowedFocusing ? animationContainer : container
            maskedOpacity: useOpacityMask ? inverseShortSwipeProgress : 1
            maskedRect: {
                if (useOpacityMask) {
                    var currentlyFocused = Proto.ListModelUtils.findFromArray(container.children, function(element) {
                        if (element.itemIndex === 0) return element
                    })
                    var intersectionRect = Proto.MathUtils.intersectionRect(this, currentlyFocused)
                    return Qt.rect(intersectionRect.x - this.x, intersectionRect.y - this.y, intersectionRect.width,intersectionRect.height)
                } else {
                    return Qt.rect(0,0,0,0)
                }
            }

            x: curvedSwitcherProgress * switcherPosition.x + inverseCurvedSwitcherProgress * desktopPosition.x
            y: curvedSwitcherProgress * (switcherPosition.y + priv.spreadTopMargin + priv.contentTopMargin + settings.spreadOffset) + inverseCurvedSwitcherProgress * desktopPosition.y
            z: maths.itemZ

            opacity: maths.itemOpacity

            Component.onDestruction: root.appClosed(appId)


            Item {
                id: mouseContainer
                anchors.fill: parent

                // Switcher hover and selection area
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: root.state === 'switcher'
                    onEntered: priv.focusedItem = spreadItem
                    onClicked: root.startFocusAnimation(spreadItem)
                }

                // Dragging area
                MouseArea {
                    anchors {
                        left: parent.left
                        leftMargin: spreadItem.windowControlsWidth
                        right: parent.right
                        top: parent.top
                    }
                    height: spreadItem.titlebarHeight
                    drag.target: root.state === 'windowed' ? spreadItem : null
                    drag.minimumY: 0
                    drag.maximumY: root.height - spreadItem.titlebarHeight
                    drag.threshold: 0
                    drag.filterChildren: true
                    drag.onActiveChanged: maths.setNewWindowedPosition(Qt.point(spreadItem.x, spreadItem.y))
                    onPressed: root.focusToItem(spreadItem)
                }
            }

            AppInfo {
                id: appInfo

                anchors {
                    left: parent.left
                    top: parent.bottom
                    topMargin: settings.iconsOffset
                }
                height: priv.appInfoHeight
                icon: appIcon !== '' ? '../graphics/icons/' + appIcon : ''
                label: appName
                opacity: Math.min(Proto.MathUtils.clamp(Proto.MathUtils.map(leftStackingProgress, 0 , 1/(priv.stackItemCount*3), 1, 0), 0 , 1),
                                      Proto.MathUtils.clamp(Proto.MathUtils.map(spreadPosition, 0.9 , 1, 1, 0), 0 , 1)) * Proto.MathUtils.map(curvedSwitcherProgress, 0.7, 0.9, 0, 1)
                fontSize: root.height < units.gu(85) ? 'small' : 'medium'

                onClicked: root.focusToItem(spreadItem)

                Proto.DebugRect {color: 'yellow'; visible: settings.showDebugRects; lineWidth: 1}
            }

            DelegateMaths {
                id: maths
                itemIndex: parent.itemIndex
                screenSize: root.screenSize

                shortSwipeProgress: root.shortSwipeProgress
                secondStageProgress: root.curvedSwitcherProgress
                totalItemCount: priv.totalItemCount
                state: root.state
                switchPoint: priv.switchPoint
            }

            onClosed: closeApp(appId)
            onPressed: if (root.state === 'windowed') root.focusToItem(spreadItem)
        }
    }

    Item {
        id: animationContainer
        anchors.fill: container
    }

    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: priv.contentBottomMargin
        visible: settings.showDebugRects

        Proto.DebugRect {
            color: 'green'
        }
    }

    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: priv.spreadTopMargin
        height: priv.contentTopMargin
        visible: settings.showDebugRects

        Proto.DebugRect {
            color: 'green'
        }
    }

    Column {
        anchors.right: parent.right
        Label {
            text: 'spread width: ' + priv.spreadWidth / units.gu(1) + ' gu'
            color: 'green'
            visible: settings.showDebugRects
        }
        Label {
            text: 'spread height: ' + root.spreadHeight / units.gu(1) + ' gu'
            color: 'green'
            visible: settings.showDebugRects
        }
    }

    // ANIMATIONS

    // Finalising short swipe animation in staged mode
    SequentialAnimation {
        id: stagedShortSwipeFinishAnimation
        property Item hideItem
        property Item focusItem
        property int animationDuration: UbuntuAnimation.FastDuration //* settings.animationDurationFactor
        ParallelAnimation {
            UbuntuNumberAnimation {
                target: stagedShortSwipeFinishAnimation.hideItem
                property: 'x'
                to: -units.gu(5)
                duration: stagedShortSwipeFinishAnimation.animationDuration
            }
            UbuntuNumberAnimation {
                target: stagedShortSwipeFinishAnimation.hideItem
                property: 'itemRotation'
                to: 15
                duration: stagedShortSwipeFinishAnimation.animationDuration
            }
            UbuntuNumberAnimation {
                target: stagedShortSwipeFinishAnimation.hideItem
                property: 'itemScale'
                to: 0.8
                duration: stagedShortSwipeFinishAnimation.animationDuration
            }
            UbuntuNumberAnimation {
                target: stagedShortSwipeFinishAnimation.hideItem
                property: 'opacity'
                to: 0
                duration: stagedShortSwipeFinishAnimation.animationDuration
            }
            UbuntuNumberAnimation {
                target: stagedShortSwipeFinishAnimation.focusItem
                properties: 'x,y,itemRotation'
                to: 0
                duration: stagedShortSwipeFinishAnimation.animationDuration
            }
            UbuntuNumberAnimation {
                target: stagedShortSwipeFinishAnimation.focusItem
                property: 'itemScale'
                to: 1
                duration: stagedShortSwipeFinishAnimation.animationDuration
            }
        }
        // Need to set back to original after the animation as otherwise the item will
        // remain hidden with 0 opacity because it's value is not updated by anything
        PropertyAction {
            target: stagedShortSwipeFinishAnimation.hideItem
            property: 'opacity'
            value: 1
        }
        ScriptAction {
            script: focusToItem(stagedShortSwipeFinishAnimation.focusItem)
        }
    }

    // Finalising short swipe animation in windowed mode
    SequentialAnimation {
        id: windowedShortSwipeFinishAnimation
        property Item focusItem
        property Item hideItem // not used but is here just for the calling logic convenience
        property int animationDuration: UbuntuAnimation.SnapDuration //* settings.animationDurationFactor
        ParallelAnimation {
            UbuntuNumberAnimation {
                target: windowedShortSwipeFinishAnimation.focusItem
                property: 'itemScale'
                to: 1
                duration: windowedShortSwipeFinishAnimation.animationDuration
            }
            UbuntuNumberAnimation {
                target: windowedShortSwipeFinishAnimation.focusItem
                property: 'maskedOpacity'
                to: 0
                duration: windowedShortSwipeFinishAnimation.animationDuration
            }
        }
        ScriptAction {
            script: {
                focusToItem(windowedShortSwipeFinishAnimation.focusItem)
            }
        }
    }

    // Focusing to an app in windowed mode
    SequentialAnimation {
        id: focusAnimation
        property Item focusItem
        property int animationDuration: UbuntuAnimation.SnapDuration //* settings.animationDurationFactor

        PropertyAction {
            target: root
            properties: "shortSwipeProgress,switcherProgress"
            value: 0
        }
        ScriptAction {
            script: focusToItem(focusAnimation.focusItem)
        }
        UbuntuNumberAnimation {
            target: focusAnimation.focusItem
            property: 'centerScale'
            from: 0.96
            to: 1
            duration: focusAnimation.animationDuration
        }
    }

    SequentialAnimation {
        id: openAnimation
        property Item itemToOpen
        property int animationDuration: UbuntuAnimation.SnapDuration
        property int animationDelay: UbuntuAnimation.FastDuration

        PropertyAction {
            target: openAnimation.itemToOpen
            properties: "opacity"
            value: 0
        }
        PauseAnimation { duration: openAnimation.animationDelay }
        ParallelAnimation {
            UbuntuNumberAnimation {
                target: openAnimation.itemToOpen
                property: 'centerScale'
                from: 0.85
                to: 1
                duration: openAnimation.animationDuration
            }
            UbuntuNumberAnimation {
                target: openAnimation.itemToOpen
                property: 'opacity'
                to: 1
                duration: openAnimation.animationDuration
            }
        }
    }

    SequentialAnimation {
        id: closeAnimation
        property Item itemToClose
        property int animationDuration: UbuntuAnimation.SnapDuration

        ParallelAnimation {
            UbuntuNumberAnimation {
                target: closeAnimation.itemToClose
                property: 'centerScale'
                to: 0.85
                easing: UbuntuAnimation.StandardEasingReverse
                duration: closeAnimation.animationDuration
            }
            UbuntuNumberAnimation {
                target: closeAnimation.itemToClose
                property: 'opacity'
                to: 0
                easing: UbuntuAnimation.StandardEasingReverse
                duration: closeAnimation.animationDuration
            }
        }
        ScriptAction {
            script: closeAnimation.itemToClose.destroy()
        }
    }

    states: [
        State {
            name: 'windowed'
            when: (switcherProgress < priv.switchPoint) && settings.desktopMode === 'Windowed'
        },
        State {
            name: 'staged'
            when: (switcherProgress < priv.switchPoint) && settings.desktopMode === 'Staged'
        },
        State {
            name: 'switcher'
            when: switcherProgress >= priv.switchPoint
        }
    ]
}
