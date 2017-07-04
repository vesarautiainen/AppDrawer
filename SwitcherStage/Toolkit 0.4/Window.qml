import QtQuick 2.4
import QtGraphicalEffects 1.0

MouseArea {
    id: root

    // Detect u(), units.gu(), or just multiply by 8
    function gu(val) {
        if (typeof u !== 'undefined') return u(val)
        if (typeof units.gu !== 'undefined') return units.gu(val)
        return val * 8
    }

    property string title: 'Window'
    property real radius: gu(0.35)

    property alias bar: bar
    property alias buttons: buttons
    property alias content: content

    property bool active: true

    // Triggered when the close button is clicked
    signal closed()

    // Test if the coordinates are inside an item or not
    function inItem(item, coordinates) {
        var coords = item.mapFromItem(root, coordinates.x, coordinates.y)
        return item.contains(coords)
    }
    function inTitleBar(coordinates) {
        return inItem(bar, coordinates)
    }
    function inTitleBarOutsideButtons(coordinates) {
        return inTitleBar(coordinates) && !inItem(buttons, coordinates)
    }

    width: gu(50)
    height: gu(40)

    RectangularGlow {
        width: parent.width
        height: parent.height
        y: gu(0.2)
        glowRadius: gu(4)
        spread: 0
        color: Qt.rgba(0, 0, 0, active? 0.3 : 0.15)
        cornerRadius: glowRadius
    }

    // Bar
    Rectangle {
        id: bar
        color: '#111'
        width: parent.width
        height: gu(3)
        radius: root.radius
        clip: true

        Rectangle {
            color: bar.color
            width: parent.width
            height: parent.height / 2
            anchors.bottom: parent.bottom
        }

        Item {
            id: buttons
            width: buttonsRow.width + gu(1)
            height: gu(2)
            y: parent.height / 2 - height / 2

            Row {
                id: buttonsRow

                height: parent.height
                x: gu(0.5)
                spacing: gu(0.5)

                Item {
                    id: windowClose
                    width: gu(2)
                    height: gu(2)
                    Image {
                        anchors.centerIn: parent
                        source: 'Window/window-close.svg'
                        width: gu(1)
                        height: gu(1)
                        smooth: true
                        antialiasing: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        preventStealing: true
                        onClicked: closed()
                    }
                }
                Item {
                    width: gu(2)
                    height: gu(2)
                    Image {
                        anchors.centerIn: parent
                        source: 'Window/window-minimize.svg'
                        width: gu(1) / 27 * 23
                        height: gu(1) / 27 * 4
                        smooth: true
                        antialiasing: true
                    }
                }
                Item {
                    width: gu(2)
                    height: gu(2)
                    Image {
                        anchors.centerIn: parent
                        source: 'Window/window-maximize.svg'
                        width: gu(1)
                        height: gu(1)
                        smooth: true
                        antialiasing: true
                    }
                }
            }
        }

        Text {
            id: barLabel
            visible: root.title
            x: buttons.width + gu(1)
            y: parent.height / 2 - height / 2
            text: root.title
            color: 'white'
            font.pixelSize: gu(1.5)
            font.family: 'Ubuntu'
            antialiasing: true
        }
    }

    // Content
    Rectangle {
        id: content
        width: parent.width
        height: parent.height - bar.height
        y: bar.height
        color: 'white'
        radius: root.radius

        Rectangle {
            color: parent.color
            width: parent.width
            height: parent.height / 2
        }
    }
}
