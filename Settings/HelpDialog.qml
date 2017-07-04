import QtQuick 2.4
import Ubuntu.Components 1.3

Item {
    id: root

    property color backgroundColor: 'black'
    property color textColor: 'white'

    width: 100
    height: 62
    opacity: 0
    visible: opacity > 000000.1

    Behavior on opacity {UbuntuNumberAnimation{}}

    function show(text, title) {
        titleLabel.text = title
        label.text = text
        root.opacity = 1
    }

    function hide() {
        root.opacity = 0
    }

    Rectangle {
        anchors.fill: parent
        color: root.backgroundColor
        opacity: 0.9
    }

    Label {
        id: titleLabel
        anchors {
            bottom: label.top
            bottomMargin: units.gu(3)
            left: label.left
        }
        fontSize: 'Medium'
        font.bold: true
        color: root.textColor
    }

    Label {
        id: label
        anchors {
            left: parent.left
            right: parent.right
            margins: units.gu(3)
            verticalCenter: parent.verticalCenter
        }
        fontSize: 'small'
        color: root.textColor
        wrapMode: Text.WordWrap
    }

    MouseArea {
        anchors.fill: parent
        onClicked: hide()
    }
}
