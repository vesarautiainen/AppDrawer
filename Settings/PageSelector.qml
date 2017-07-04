import QtQuick 2.4
import Ubuntu.Components 1.3

Item {
    id: root

    property var pages: []
    property var currentPage: null
    property color textColor: 'white'
    property color highlightColor: 'yellow'
    height: childrenRect.height

    Rectangle {
        anchors.fill: parent
        color: 'lightGray'
        opacity: 0.1
    }

    Row {
        id: row
        height: childrenRect.height
        width: childrenRect.width
        anchors.centerIn: parent
        spacing: (root.width - row.width) / (pages.length + 2)
        Repeater {
            model: pages.length
            Label {
                text: pages[index].pageName
                color: root.currentPage === pages[index] ? root.highlightColor : root.textColor
                fontSize: 'medium'
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.currentPage = pages[index]
                }
            }
        }
    }
}
