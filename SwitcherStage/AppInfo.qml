import QtQuick 2.4
import Ubuntu.Components 1.3


Item {
    id: root

    property real iconHeight: (height - labelHeight) * 0.65
    property real iconMargin: (height - labelHeight) * 0.25
    property real labelMargin: (height - labelHeight) * 0.1
    property real labelHeight: showLabel ? label.height : 0

    property int labelPlacement: Qt.Horizontal // Qt.Horizontal (= on the right of the icon) or Qt.Vertical (= on the bottom of the icon)
    property bool showLabel: true

    property string icon: ''
    property string label: ''
    property alias fontSize: label.fontSize

    width: Math.max(label.width, icon.width)
    height: units.gu(10)

    signal clicked()

    UbuntuShape {
        id: icon
        anchors {
            top: parent.top
            topMargin: iconMargin
            left: parent.left
        }

        width:  units.gu(8) / units.gu(7.5) * height
        height: iconHeight
        color: '#bbbbbb'
        radius: "small"
        borderSource: "undefined"
            image: Image {
                sourceSize.width: icon.width
                source: root.icon
                fillMode: Image.PreserveAspectCrop
                verticalAlignment: Image.AlignVCenter
            }

        MouseArea {
            anchors.fill: parent
            onClicked: root.clicked()
        }
    }

    Label {
        id: label
        anchors {
            left: icon.left
            top: icon.bottom
            topMargin: labelMargin
        }
        text: root.label
        fontSize: 'small'
        color: 'white'
        visible: showLabel
    }
}


