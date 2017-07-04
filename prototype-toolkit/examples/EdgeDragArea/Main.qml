import QtQuick 2.4
import Prototype.Components 0.3

MainView {
    id: root
    width: units.gu(70)
    height: units.gu(60)
    backgroundColor: 'white'
    debug: true
    property string title: 'Edge Drag Area Demo'

    property real xProgress: {
        return (parent.width * leftEdge.progress) +
               (-parent.width * rightEdge.progress)
    }
    property real xAbsProgress: {
        return (parent.width * leftEdge.absProgress) +
               (-parent.width * rightEdge.absProgress)
    }
    property real xAbsProgressRestrained: {
        return (parent.width * leftEdge.absProgressRestrained) +
               (-parent.width * rightEdge.absProgressRestrained)
    }
    property real yProgress: {
        return (parent.height * topEdge.progress) +
               (-parent.height * bottomEdge.progress)
    }
    property int edgeProgressMode: 1

    Rectangle {
        color: 'forestgreen'
        width: parent.width
        height: parent.height
        y: 0
        x: (root.width / 2) * (1 - rightEdge.progress)
        transform: Rotation {
            origin.x: width
            origin.y: height
            angle: 90 * (1 - rightEdge.progress)
        }
    }

    Rectangle {
        color: 'steelblue'
        width: parent.width
        height: parent.height
        y: (root.height / 4) * (1 - leftEdge.progress)
        x: 0
        transform: Rotation {
            origin.x: 0
            origin.y: height
            angle: 90 * (1 - leftEdge.progress)
        }
    }

    Rectangle {
        color: 'tomato'
        width: parent.width
        height: parent.height
        y: yProgress
        x: {
            if (edgeProgressMode === 2) return xAbsProgress
            if (edgeProgressMode === 3) return xAbsProgressRestrained
            return xProgress
        }
    }

    Text {
        text: {
            var text = 'Progress mode: '
            if (root.edgeProgressMode === 1) {
                text += 'progress.'
            } else if (root.edgeProgressMode === 2) {
                text += 'absProgress.'
            } else if (root.edgeProgressMode === 3) {
                text += 'absProgressRestrained.'
            }
            return text
        }
        font.pointSize: 12
        anchors.centerIn: parent
        MouseArea {
            anchors.fill: parent
            onClicked: {
                edgeProgressMode = edgeProgressMode === 3? 1 : (edgeProgressMode + 1)
            }
        }
    }

    EdgeDragArea {
        id: topEdge
        edge: Qt.TopEdge
        height: units.gu(8)
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        Rectangle {
            color: 'white'
            opacity: 0.2
            anchors.fill: parent
        }
    }

    EdgeDragArea {
        id: bottomEdge
        edge: Qt.BottomEdge
        height: units.gu(8)
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        Rectangle {
            color: 'white'
            opacity: 0.2
            anchors.fill: parent
        }
    }

    EdgeDragArea {
        id: leftEdge
        edge: Qt.LeftEdge
        width: units.gu(8)
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        Rectangle {
            color: 'white'
            opacity: 0.2
            anchors.fill: parent
        }
    }

    EdgeDragArea {
        id: rightEdge
        edge: Qt.RightEdge
        width: units.gu(8)
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        Rectangle {
            color: 'white'
            opacity: 0.2
            anchors.fill: parent
        }
    }
}
