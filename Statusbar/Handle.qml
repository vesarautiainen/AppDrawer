import QtQuick 2.4
import Ubuntu.Components 0.1

Rectangle {
    id: handle
    color: "#333333"
    width: units.gu(50)
    height: units.gu(2)
    anchors.bottom: orangeLine.top
    property bool active: false

    Row {
        id: dots
        width: childrenRect.width
        height: children.height
        anchors.centerIn: parent
        spacing: units.gu(0.5)
        Repeater {
            model: 3
            delegate: Rectangle {
                id: dot
                width: units.gu(0.33)
                height: width
                color: handle.active ? "#FFFFFF" : "#717171"
                radius: units.dp(1)
            }
        }
    }
}
