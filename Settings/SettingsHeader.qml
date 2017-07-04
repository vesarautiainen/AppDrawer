import QtQuick 2.4
import Ubuntu.Components 1.3

Item {
    id: root

    property color textColor: 'white'
    property bool showDoneButton: false

    height: headerTitle.height + units.gu(1)

    signal resetAll()
    signal done()

    Label {
        id: headerTitle
        anchors {
            left: parent.left
            leftMargin: units.gu(2)
            verticalCenter: parent.verticalCenter
        }
        text: "Settings"
        fontSize:  "large"
        color: root.textColor
    }
    Item {
        id: resetAll
        width: units.gu(9)
        height: units.gu(3)
        anchors {
            right: parent.right
            rightMargin: units.gu(2)
            verticalCenter: parent.verticalCenter
        }
        Rectangle {
            anchors.fill: parent
            radius: units.gu(0.5)
            color: "transparent"
            border.width: 1
            border.color: root.textColor
            opacity: 0.6
            MouseArea {
                anchors.fill: parent
                onClicked: root.resetAll()
            }
        }

        Label {
            text: "Reset all"
            fontSize: "medium"
            color: root.textColor
            anchors.centerIn: parent

        }
    }
    Item {
        id: done
        width: units.gu(9)
        height: units.gu(3)
        visible: root.showDoneButton
        anchors {
            right: resetAll.left
            rightMargin: units.gu(2)
            verticalCenter: parent.verticalCenter
        }
        Rectangle {
            anchors.fill: parent
            radius: units.gu(0.5)
            color: "transparent"
            border.width: 1
            border.color: root.textColor
            opacity: 0.6
            MouseArea {
                anchors.fill: parent
                onClicked: root.done()
            }
        }

        Label {
            text: "Done"
            fontSize: "medium"
            color: root.textColor
            anchors.centerIn: parent
        }
    }
}
