import QtQuick 2.4
import Ubuntu.Components 1.3

Item {
    id: root

    property bool focusHighlight: true
    property real focusMargin: 0
    property real focusLineWidth: units.dp(2)
    property bool fillFocus: false
    property real focusOpacity: 1

    property bool selectionHighlight: false
    property real selectionMargin: 0
    property real selectionWidth: root.width
    property real selectionLineWidth: units.dp(2)

    property color color: '#19B6EE'
    property color selectionColor: color

    Rectangle {
        id: focus
        anchors.fill: parent
        anchors.margins: -focusLineWidth - focusMargin
        color: fillFocus ? root.color : "transparent"
        antialiasing: true
        visible: focusHighlight
        border.width: focusLineWidth
        border.color: root.color
        opacity: focusOpacity
    }

    Keyline {
        id: selection
        width: selectionWidth
        height: selectionLineWidth
        anchors.top: parent.bottom
        anchors.topMargin: selectionMargin
        anchors.horizontalCenter: parent.horizontalCenter
        antialiasing: true
        visible: selectionHighlight
        color: root.selectionColor
    }
}
