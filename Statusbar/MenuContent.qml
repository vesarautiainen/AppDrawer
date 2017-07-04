import QtQuick 2.4
import Ubuntu.Components 0.1
import "Components"

Showable {
    id: content

    property string menuName: ""
    property string contentScreen: ""

    property bool active: menuName == "Notifications" ? true : false

    clip: true

    Rectangle {
        anchors.fill: parent
        color: "#221e1c"
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: dummyContentImage.height
        flickableDirection: Qt.Vertical
        rebound: Transition {
                NumberAnimation {
                    properties: "y"
                    duration: 600
                    easing.type: Easing.OutCubic
                }
            }

        Image {
            id: dummyContentImage
            anchors {
                top: parent.top
                //verticalCenter: parent.verticalCenter
                left: parent.left
                right: parent.right
            }
            height: width * sourceSize.height / sourceSize.width
            source: contentScreen

            Button {
                id: clearAllButton
                anchors {
                    right: parent.right
                    rightMargin: units.gu(2)
                    bottom: parent.bottom
                    bottomMargin: content.active ? units.gu(-6) : units.gu(2)
                }

                text: content.active ? "Clear all" : "Populate content"
                visible: menuName == "Notifications"
                color: content.active ? "gray" : "black"
                opacity: content.active ? 1 : 0.2
                onClicked: {
                    if (content.active) {
                        content.active = false
                    } else {
                        content.active = true
                    }
                }
            }
        }
    }



    Label {
        text: menuName + " menu content"
        anchors.centerIn: parent
        visible: dummyContentImage.source == ""
    }
}
