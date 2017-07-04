import QtQuick 2.4
import Ubuntu.Components 1.3
import Prototype.Components 0.3 as Proto

Item {
    id: root

    property alias sourceImage: sourceImage.source
    property alias borderSource: appIcon.borderSource
    property alias label: label.text
    property bool highlighted: false
    property bool showLabel: true

    width: units.gu(10)
    height: showLabel ? appIcon.height + label.anchors.topMargin + label.height : appIcon.height

    signal clicked()
    signal pressAndHold()

    QtObject {
        id: priv

        //layout
        property real labelTopMargin: units.gu(1)
    }

    UbuntuShape {
        id: appIcon
        width: parent.width
        height: 7.5 / 8 * width
        backgroundMode: UbuntuShape.SolidColor
        backgroundColor: UbuntuColors.lightGrey
        radius: "medium"
        borderSource: 'undefined'
        source: Image {
            id: sourceImage
            sourceSize.width: appIcon.width
            source: ""
        }
        sourceFillMode: UbuntuShape.PreserveAspectCrop
    }

    UbuntuShape {
        id: highlight
        anchors.fill: appIcon
        backgroundMode: UbuntuShape.SolidColor
        backgroundColor: 'white'
        radius: "medium"
        borderSource: 'undefined'
        visible: opacity > 0.01
        opacity: highlighted ? 0.4 : 0
        Behavior on opacity {UbuntuNumberAnimation {duration: UbuntuAnimation.SnapDuration}}
    }

    Label {
        id: label
        anchors {
            horizontalCenter: appIcon.horizontalCenter
            top: appIcon.bottom
            topMargin: priv.labelTopMargin
        }
        fontSize: 'small'
        color: 'white'
        visible: showLabel
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }
        onPressAndHold: root.pressAndHold()
    }
 }
