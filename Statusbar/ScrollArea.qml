import QtQuick 2.4
import Ubuntu.Components 0.1

Item {
    id: scrollArea

    property real __previousMouseX: -1
    property real __progression: 0
    property real __previousMouseXHelper: -1
    property real thresholdAreaWidth: units.gu(1)
    property bool showDebugRectangles: false
    property int direction: Qt.LeftToRight
    property real baseScrollAmount:  units.dp(2)
    property real maximumScrollAmount: units.dp(6)

    property real lateralPosition: -1
    property bool areaActive: lateralPosition >= 0
    onAreaActiveChanged: {
        if (areaActive) {
            handleEnter()
        } else {
            handleExit()
        }
    }

    // from 0 to 1
    property real forceScrollingPercentage: 0.4
    signal scroll(real scrollAmount)

    width: 200
    height: 200
    rotation: direction == Qt.LeftToRight ? 0 : 180

    function handleEnter() {
        thresholdRect.x = -scrollArea.thresholdAreaWidth
        scrollTimer.restart()
    }
    onLateralPositionChanged: {
        if (scrollArea.areaActive) {

            // store the previous x value
            __previousMouseX = __previousMouseXHelper
            __previousMouseXHelper = lateralPosition

            if (lateralPosition > width * (1 - forceScrollingPercentage)) {
                thresholdRect.x = width * (1 - forceScrollingPercentage)
                if (!scrollTimer.running) scrollTimer.restart()
            } else if (lateralPosition > thresholdRect.x + thresholdRect.width) {
                thresholdRect.x = lateralPosition - thresholdRect.width
                if (!scrollTimer.running) scrollTimer.restart()
            } else if (lateralPosition < thresholdRect.x) {
                thresholdRect.x = lateralPosition
                scrollTimer.stop()
            }

            __progression = lateralPosition / width
        }
    }

    function handleExit() {
        thresholdRect.x = -scrollArea.thresholdAreaWidth
        scrollTimer.stop()
    }

    Timer {
        id: scrollTimer
        interval: 5
        repeat: true
        onTriggered: scrollArea.scroll(scrollArea.baseScrollAmount + scrollArea.maximumScrollAmount*scrollArea.__progression)
    }

    Rectangle {
        color: "yellow"
        opacity: 0.2
        anchors.fill: scrollArea
        visible: showDebugRectangles
    }

    Rectangle {
        color: "red"
        opacity: 0.2
        height: scrollArea.height
        width: scrollArea.width * forceScrollingPercentage
        anchors.right: parent.right
        visible: showDebugRectangles
    }

    Rectangle {
        id: thresholdRect
        opacity: 0.4
        height: parent.height
        width: scrollArea.thresholdAreaWidth
        x: -scrollArea.thresholdAreaWidth
        color: showDebugRectangles ? "blue" : "transparent"
    }

}
