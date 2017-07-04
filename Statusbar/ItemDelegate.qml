import QtQuick 2.4
import Ubuntu.Components 0.1

Item {
    id: itemDelegate

    property bool animationRunning: numberAnimation.running
    property real maximisedHeight: 0
    property real maximisedWidth: units.gu(10)
    property real minimisedWidth: initiallyVisible ? itemIcon == "" ? text.width + units.gu(1) : indicatorImage.width + units.gu(1) : 0
    property bool selected: false
    property int ownIndex: index

    signal clicked()

    width: state == "minimised" ?  minimisedWidth : maximisedWidth
    Behavior on width { NumberAnimation{id: numberAnimation; duration: UbuntuAnimation.SnapDuration; easing: UbuntuAnimation.StandardEasing}}

    clip: true

    MouseArea {
        anchors.fill: parent
        visible: itemDelegate.state == "opened"
        onClicked: itemDelegate.clicked()
    }

    Label {
        id: text
        text: itemText
        fontSize: "small"
        color: "#BBBBBB"
        visible: itemIcon == ""
        anchors.centerIn: parent
        anchors.verticalCenterOffset: itemDelegate.state == "minimised" ? 0 : -units.gu(1)
        Behavior on anchors.verticalCenterOffset {NumberAnimation{duration: UbuntuAnimation.SnapDuration; easing: UbuntuAnimation.StandardEasing}}
    }

    Image {
        id: indicatorImage
        width: sourceSize.width / sourceSize.height * height
        height: itemDelegate.state == "minimised" ? units.gu(2) : units.gu(2)
        Behavior on height { NumberAnimation{duration: UbuntuAnimation.SnapDuration; easing: UbuntuAnimation.StandardEasing}}
        source: active ? itemIconActive : itemIcon
        anchors.centerIn: parent
        anchors.verticalCenterOffset: itemDelegate.state == "minimised" ? 0 : -units.gu(1)
        Behavior on anchors.verticalCenterOffset {NumberAnimation{duration: UbuntuAnimation.SnapDuration; easing: UbuntuAnimation.StandardEasing}}
        opacity: !initiallyVisible && itemDelegate.state == "minimised" ? 0 : 1
        Behavior on opacity {NumberAnimation{duration: UbuntuAnimation.SnapDuration; easing: UbuntuAnimation.StandardEasing}}
    }

    Label {
        id: indicatorName
        text: itemName
        fontSize: "x-small"
        color: selected && itemDelegate.state != "minimised" ? "white" : "#4c4c4c"
        Behavior on color {ColorAnimation{duration: UbuntuAnimation.SnapDuration}}
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: text.visible ? text.bottom : indicatorImage.bottom
        anchors.topMargin: units.gu(0.5)
        opacity: itemDelegate.state == "minimised" ? 0 : 1
        Behavior on opacity {NumberAnimation{duration: UbuntuAnimation.SnapDuration; easing: UbuntuAnimation.StandardEasing}}
    }
}
