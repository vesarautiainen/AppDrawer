import QtQuick 2.4

DraggingArea {
    id: root

    // Use one of these: Qt.LeftEdge, Qt.RightEdge, Qt.TopEdge, Qt.BottomEdge
    property real edge: -1

    property real progress: 0
    property real absProgress: 0
    property real absProgressRestrained: 0

    // edgeDirection is deprecated and replaced by edge
    property real edgeDirection: -1
    function edgeDirectionCompat() {
        if (edge === -1 && edgeDirection === -1) {
            console.warn('[EdgeDragArea] "edge" property not set')
        }

        var warnMessage = '[EdgeDragArea] the "edgeDirection" property is ' +
                          'deprecated, please use "edge" instead.'
        var setMessage = '[EdgeDragArea] "edge" property set to '

        if (edge === -1 && edgeDirection !== -1) {
            if (edgeDirection === Qt.LeftToRight) {
                edge = Qt.LeftEdge
                setMessage += 'Qt.LeftEdge'
            } else if (edgeDirection === Qt.RightToLeft) {
                edge = Qt.RightEdge
                setMessage += 'Qt.RightEdge'
            } else {
                setMessage = ''
            }
            console.warn(warnMessage)
            if (setMessage) console.warn(setMessage)
        }
    }

    Component.onCompleted: {
        edgeDirectionCompat()
    }

    width: units.gu(2)

    onPositionChanged: {
        var xpos = __pressedPosition.x
        var ypos = __pressedPosition.y
        switch (edge) {
            case Qt.LeftEdge:
                progress = (mouseX - xpos) / (parent.width - xpos)
                absProgress = (mouseX - xpos) / parent.width
                absProgressRestrained = mouseX / parent.width
                break
            case Qt.RightEdge:
                progress = -(mouseX - xpos) / (parent.width - (root.width - xpos))
                absProgress = -(mouseX - xpos) / parent.width
                absProgressRestrained = (-mouseX + root.width) / parent.width
                break
            case Qt.TopEdge:
                progress = (mouseY - ypos) / (parent.height - ypos)
                absProgress = (mouseY - ypos) / parent.height
                absProgressRestrained = mouseY / parent.height
                break
            case Qt.BottomEdge:
                progress = -(mouseY - ypos) / (parent.height - (root.height - ypos))
                absProgress = -(mouseY - ypos) / parent.height
                absProgressRestrained = (-mouseY + root.height) / parent.height
                break
        }
    }

    onReleased: {
        progress = 0
        absProgress = 0
        absProgressRestrained = 0
    }
}
