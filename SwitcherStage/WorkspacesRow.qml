import QtQuick 2.4
import Ubuntu.Components 1.3

Item {
    id: root

    property real screenAspectRatio: 1
    property int activeIndex: 0
    property int focusedIndex: -1

    QtObject {
        id: priv

        // Layout
        property real itemMaxHeight: 0.75 * root.height
        property real itemMaxWidth: root.screenAspectRatio * itemMaxHeight
        property real selectionLineMargin: (root.height - itemMaxHeight) / 4 // line distance to the item bottom
        property real itemSpacing: units.gu(2)
        property real focusSize: Math.min(priv.itemSpacing, 0.65 * priv.selectionLineMargin)
        property real focusOpacity: 0.55
        property real selectionLineWidth: units.dp(2)
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: priv.itemSpacing
        height: priv.itemMaxHeight

        Repeater {
            model: 3
            Item {
                property int itemIndex: index
                anchors.verticalCenter: parent.verticalCenter
                height: priv.itemMaxHeight
                width: priv.itemMaxWidth


                Highlight {
                    id: focusAndSelection
                    width: parent.width
                    height: parent.height
                    focusMargin: 0
                    focusLineWidth: priv.focusSize
                    color: 'white'
                    focusOpacity: priv.focusOpacity
                    fillFocus: true
                    focusHighlight: parent.itemIndex === focusedIndex
                    selectionHighlight: parent.itemIndex === activeIndex
                    selectionMargin: priv.selectionLineMargin
                    selectionLineWidth: priv.selectionLineWidth
                }

                Image {
                    id: wallpaper
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    verticalAlignment: Image.AlignVCenter
                    horizontalAlignment: Image.AlignHCenter
                    source:'../graphics/' + settings.wallpaper
                    sourceSize.width: width
                    sourceSize.height: height
                }

                Rectangle {
                    anchors.fill: parent
                    color: 'black'
                    opacity: 0.35
                    visible: parent.itemIndex !== activeIndex
                }
            }
        }
    }

//    Rectangle {
//        id: activeWorkspaceLine
//        height: units.dp(2)
//        color: 'white'
//        width: priv.itemMaxWidth
//        anchors.top: row.bottom
//        anchors.topMargin: priv.selectionLineMargin
//        x: row.x + activeIndex * (priv.itemMaxWidth + row.spacing)
//    }
}

