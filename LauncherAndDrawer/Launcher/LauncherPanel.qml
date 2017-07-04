import QtQuick 2.4
import Ubuntu.Components 0.1
import 'Components'
import '..'

Item {
    id: root

    property var settings
    property bool locked: false
    property bool rotated: settings.deviceType !== 'Desktop'
    property alias darken: darkeningOverlay.opacity
    property var model: LauncherModel {}

    width: units.gu(8)
    height: units.gu(100)

    signal itemClicked(string appId)
    signal pressAndHold(string appId, Item targetItem)

    // mouse event eater
    MouseArea {
        id: hoverarea
        anchors.fill: parent
        hoverEnabled: true
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: '#000000'
        opacity: settings.launcherBackgroundOpacity
    }

    Item {
        id: clipper
        clip: true
        height: listView.height
        width: listView.width * 2
        anchors {
            top: rotated ? undefined : parent.top
            topMargin: homeIcon.height
            bottom: rotated ? parent.bottom : undefined
            bottomMargin: homeIcon.height
        }
    }

    ListView {
        id: listView
        parent: clipper
        width: root.width
        height: root.height - homeIcon.height
        model: root.model
        spacing: units.gu(1)
        topMargin: units.gu(1)
        rotation: root.rotated ? 180 : 0
        delegate: AppIconDelegate {
            property string appId: model && model.appId ?  model.appId : ''
            rotation: root.rotated ? 180 : 0
            width: units.gu(6) // same as launcher icon size
            anchors.horizontalCenter: parent.horizontalCenter
            sourceImage: appIcon !== '' ? '../../graphics/icons/' + appIcon : ''
            label: model && model.appName ?  model.appName : ''
            showLabel: false
            highlighted: false
            function resetMenu() {
                highlighted = false
            }

            onClicked: root.itemClicked(appId)
            onPressAndHold: {
//                highlighted = true
//                root.pressAndHold(appId, this)
            }
        }
    }

    HomeIcon {
        id: homeIcon

        rotated: root.rotated
        onRotatedChanged: height = width - units.gu(1)
        anchors {
            bottom: root.rotated ? parent.bottom : undefined
            top: root.rotated ? undefined : parent.top
        }
        width: root.width
        height: width - units.gu(1)
        onClicked: root.appOpened("home")
    }

    Rectangle {
        id: darkeningOverlay
        anchors.fill: parent
        color: 'black'
    }
}
