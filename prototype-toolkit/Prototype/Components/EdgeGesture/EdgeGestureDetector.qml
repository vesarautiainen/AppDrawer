import QtQuick 2.4
import Ubuntu.Components 1.3
import "../MathUtils.js" as MathUtils

Item {
    id: edges

    property real gestureProgress
    property real shortProgress
    property real limitedShortProgress
    property real longProgress
    property real longSwipeThreshold: 0.3
    property bool gestureActive: dragging || finishProgressAnimation.running
    property bool dragging: __activeEdge.dragging
    property bool leftEdgeActive: false
    property bool rightEdgeActive: false
    property var __activeEdge: rightEdge
    property real animationDuration: UbuntuAnimation.FastDuration
    property int animationEasingType: UbuntuAnimation.StandardEasing.type
    property real edgeWidth: units.gu(2)

    signal gestureStarted(string edgeId)
    signal gestureEnded(string edgeId, int direction, string gestureType)
    signal gestureFinished(string edgeId, int direction, string gestureType)

    function emulateLongSwipe(edge) {
        var direction = edge === 'left' ? Qt.LeftToRight : Qt.RightToLeft
        __activeEdge = edge === 'left' ? leftEdge : rightEdge
        shortProgress = 0
        longProgress = 0

        edges.gestureStarted(edge)
        edges.gestureEnded(edge, direction, 'long')
        finishGesture(edge, direction, 'long')
    }

    function reset() {
        finishProgressAnimation.stop()
        shortProgress = 0
        gestureProgress = 0
        longProgress = 0
        limitedShortProgress = 0
    }

    function finishGesture(edgeId, direction, gestureType) {
        finishProgressAnimation.gestureType = gestureType
        finishProgressAnimation.edge = edgeId
        finishProgressAnimation.direction = direction
        finishProgressAnimation.restart()
    }

    function clamp(value, min, max) {
        if (value < min) return min
        if (value > max) return max
        return value
    }

    function linearAnimation(startProgress, endProgress, startValue, endValue, progress) {
        // progress : progressDiff = value : valueDiff => value = progress * valueDiff / progressDiff
        return (progress - startProgress) * (endValue - startValue) / (endProgress - startProgress) + startValue;
    }

    Binding {
        target: edges
        property: "limitedShortProgress"
        value: {
            if (gestureProgress <= longSwipeThreshold) {
                return clamp(MathUtils.map(edges.shortProgress, 0, edges.longSwipeThreshold, 0, 1), 0 ,1)
            } else {
                return 1
            }
        }
        when: __activeEdge && __activeEdge.dragging
    }

    Binding {
        target: edges
        property: "gestureProgress"
        value: clamp(linearAnimation(0, 1, 0, 1, __activeEdge.progress), 0, 1)
        when: __activeEdge && __activeEdge.dragging
    }

    Binding {
        target: edges
        property: "longProgress"
        value: clamp(linearAnimation(longSwipeThreshold, 1, 0, 1, __activeEdge.progress), 0, 1)
        when: __activeEdge && __activeEdge.dragging && __activeEdge.progress > longSwipeThreshold
    }

    Binding {
        target: edges
        property: "shortProgress"
        value: {
            if (__activeEdge.progress <= longSwipeThreshold) {
                return clamp(linearAnimation(0, longSwipeThreshold, 0, longSwipeThreshold, __activeEdge.progress), 0, 1)
            } else {
                return clamp(linearAnimation(longSwipeThreshold, 1, longSwipeThreshold, 0, __activeEdge.progress), 0, 1)
            }
        }
        when: __activeEdge && __activeEdge.dragging
    }

    EdgeDragArea {
        id: leftEdge
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }
        edge: Qt.LeftEdge
        width: edgeWidth
        visible: leftEdgeActive
        onPressed: edges.__activeEdge = this
        onDraggingChanged: {
            if (dragging) {
                edges.gestureStarted('left')
            } else {
                var direction = dragVelocity > 0 ? Qt.LeftToRight : Qt.RightToLeft
                var gestureType = leftEdge.progress > edges.longSwipeThreshold ? 'long' : 'short'
                edges.gestureEnded('left', direction, gestureType)

                edges.finishGesture('left', direction, gestureType)
            }
        }
    }

    EdgeDragArea {
        id: rightEdge
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
        edge: Qt.RightEdge
        width: edgeWidth
        visible: rightEdgeActive
        onPressed: edges.__activeEdge = this
        onDraggingChanged: {
            if (dragging) {
                edges.gestureStarted('right')
            } else {
                var direction = dragVelocity > 0 ? Qt.LeftToRight : Qt.RightToLeft
                var gestureType = rightEdge.progress > edges.longSwipeThreshold ? 'long' : 'short'
                edges.gestureEnded('right', direction, gestureType)

                edges.finishGesture('right', direction, gestureType)
            }
        }
    }

    SequentialAnimation {
        id: finishProgressAnimation
        property int direction: Qt.RightToLeft
        property string edge
        property string gestureType
        property real toValue: {
            if ((edge === 'right' && direction === Qt.RightToLeft) ||
                (edge === 'left' && direction === Qt.LeftToRight) ) {
                return 1
            } else {
                return 0
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: edges
                property: 'longProgress'
                to: finishProgressAnimation.gestureType === 'long' ? finishProgressAnimation.toValue : 0
                duration: edges.animationDuration
                easing.type: edges.animationEasingType
            }
            NumberAnimation {
                target: edges
                property: 'gestureProgress'
                to: finishProgressAnimation.toValue
                duration: edges.animationDuration
                easing.type: edges.animationEasingType
            }
            NumberAnimation {
                target: edges
                property: 'shortProgress'
                to: finishProgressAnimation.gestureType === 'long' ? 0 : finishProgressAnimation.toValue
                duration: edges.animationDuration
                easing.type: edges.animationEasingType
            }
            NumberAnimation {
                target: edges
                property: 'limitedShortProgress'
                to: finishProgressAnimation.toValue
                duration: edges.animationDuration
                easing.type: edges.animationEasingType
            }
        }
        ScriptAction {
            script: {
                edges.gestureFinished(finishProgressAnimation.edge, finishProgressAnimation.direction, finishProgressAnimation.gestureType)
            }
        }
    }

}
