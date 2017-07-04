import QtQuick 2.4

Item {
    id: root

    property bool rotated: false

    rotation: rotated ? 180 : 0

    signal clicked()

    Rectangle {
        anchors.fill: parent
        color: '#de4814'
    }

    Image {
        id: icon
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter:  parent.verticalCenter
            margins: units.gu(1.5)
        }
        height: width * sourceSize.height/sourceSize.width

        rotation: rotated ? 180 : 0
        source: 'graphics/icons/launcher-home.png'
    }

    Image {
        id: divider
        width: parent.width
        height: 2
        anchors {
            bottom: parent.bottom
        }
        rotation: rotated ? 180 : 0
        source: 'graphics/launcher_divider.png'
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }
    }
}
