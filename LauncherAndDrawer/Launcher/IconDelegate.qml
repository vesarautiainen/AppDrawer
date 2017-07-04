import QtQuick 2.4
import Ubuntu.Components 0.1

Item {
    id: root

    property alias source: appIcon
    property string appName: appName
    property string appId: appId

    height: shape.height

    signal clicked()

    UbuntuShape {
        id: shape
        anchors {
            left: parent.left
            right: parent.right
            margins: units.gu(1)
        }

        height: units.gu(7.5) / units.gu(8) * width
        radius: "medium"
        borderSource: 'undefined'
        image: Image {
            sourceSize.width: appIcon.width
            source: root.source != '' ? 'graphics/icons/' + root.source : ''
            fillMode: Image.PreserveAspectCrop
            verticalAlignment: Image.AlignVCenter
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }
    }
}

