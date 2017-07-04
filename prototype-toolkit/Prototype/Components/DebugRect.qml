import QtQuick 2.4

Item {
    id: root
    property color color: 'red'
    property real lineWidth: 2

    property bool fill: false
    property color fillColor: color

    anchors.fill: parent

    Rectangle {
        id: rect
        anchors.fill: parent
        color: root.fill ? root.fillColor : 'transparent'
        border.width: root.lineWidth
        border.color: root.color
    }
}
