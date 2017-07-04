import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import Ubuntu.Components.Popups 1.3

Popover {
    id: root

    property Item target: null
    property string targetAppId
    property string targetAppName

    signal hideRequest()
    signal uninstall()

    contentWidth: units.gu(25) //@todo: replace with some dynamic value
    Column {
        id: containerLayout
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }
        ListItem.Standard { text: "App info"; /*onClicked: root.hideRequest()*/ }
        ListItem.Standard { text: "Uninstall"; onClicked: root.uninstall() }
        ListItem.Standard { text: "Pin to Launcher"; /*onClicked: root.hideRequest()*/ }
    }
}

