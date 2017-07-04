import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import Ubuntu.Components.Popups 1.3

Item {
    id: popover

    height: units.gu(5)

    Rectangle {
        id: background
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        height: parent.height
        color: 'white'
        opacity: 0.1
        radius: units.gu(1)
    }

    Row {
        spacing: units.gu(1)
        height: parent.height
        anchors {
            left: parent.left
            leftMargin: units.gu(1)
        }
        Rectangle {
            width: units.gu(0)
            height: width
            anchors.verticalCenter: parent.verticalCenter
            color: 'white'
            opacity: 0
        }
        Image {
            height: units.gu(2)
            width: height * sourceSize.width / sourceSize.height
            source: 'graphics/stock_application.png'
            anchors.verticalCenter: parent.verticalCenter
        }
        Label {
            text: 'More apps in the store'
            color: 'white'
            anchors.verticalCenter: parent.verticalCenter
            fontSize: 'small'
        }

        Image {
            height: units.gu(2)
            width: height * sourceSize.width / sourceSize.height
            source: 'graphics/chevron.png'
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}

