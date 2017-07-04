import QtQuick 2.4
import Ubuntu.Components 1.3
import Prototype.Components 0.3

Item {
    id: root

    property var settings
    property alias commitPointX: commitPoint.x

    Rectangle {
        id: limit1
        property bool active: limit1.width < limit2.width
        property color debugColor: 'chartreuse'
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        width: root.width * settings.drawerMaxPercentage
        border {
            width: units.dp(1)
            color: debugColor
        }
        color: 'transparent'


        Label {
            text: settings.drawerMaxPercentage + ' * device width'
            color: parent.debugColor
            fontSize: 'small'
            anchors {
                top: parent.top
                right: parent.right
                margins: units.gu(0.5)
            }
        }

        Rectangle {
            anchors.fill: parent
            color: parent.debugColor
            opacity: parent.active ?  0.1 : 0
        }
    }

    Rectangle {
        id: limit2
        property bool active: limit1.width > limit2.width
        property color debugColor: 'cyan'
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        width: units.gu(90)*settings.drawerMaxPercentage
        border {
            width: units.dp(1)
            color: debugColor
        }
        color: 'transparent'

        Label {
            text: settings.drawerMaxPercentage + ' * 90 gu'
            color: parent.debugColor
            fontSize: 'small'
            anchors {
                top: parent.top
                right: parent.right
                margins: units.gu(0.5)
            }
        }

        Rectangle {
            anchors.fill: parent
            color: parent.debugColor
            opacity: parent.active ?  0.15 : 0
        }
    }


    // commit point
    Rectangle {
        id: commitPoint
        width: units.dp(2)
        anchors {
            top: parent.top
            bottom: parent.bottom
        }
        color: 'black'

    }
 }
