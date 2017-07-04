import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.Window 2.2
import Prototype.Components 0.3 as Proto
import '../Components'


Item {
    id: root

    property var model
    property var settings
    property alias title: sectionTitle.text
    property bool showTitle: title !== ''
    property real deviceWidth
    property alias backgroundHeight: background.height

    height: sectionTitle.anchors.topMargin + sectionTitle.height + 2*gridView.anchors.topMargin + gridView.height

    Proto.DebugRect{color: 'pink'; visible: settings.showLauncherDebug}

    signal itemClicked(string appId)
    signal pressAndHold(string appId, string appName, var caller)

    function resetHighlights() {
        priv.highlightedItems = []
    }

    QtObject {
        id: priv
        property var highlightedItems: []
    }

    Rectangle {
        id: background
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        height: parent.height
        color: 'white'
        opacity: 0.1
        radius: units.gu(1)
    }

    Label {
        id: sectionTitle
        anchors {
            left: parent.left
            leftMargin: units.gu(1)
            top: parent.top
            topMargin: showTitle ? units.gu(1) : 0
        }
        height: showTitle ? implicitHeight : 0
        text: 'TITLE'
        fontSize: 'medium'
        color: 'white'
        visible: text !== ''
    }

    ResponsiveGridView {
        id: gridView
        Proto.DebugRect{color: 'yellow'; visible: settings.showLauncherDebug}
        property int rows: model ? Math.ceil(model.count / columns) : 0
        anchors {
            top: sectionTitle.bottom
            topMargin: units.gu(1.5)
        }
        width: parent.width
        height: rows * delegateHeight + (rows - 1) * verticalSpacing
        model: root.model
        delegate: delegateComponent
        interactive: false
        columns: Math.round(Proto.MathUtils.clamp(Proto.MathUtils.map(deviceWidth, units.gu(40), units.gu(90), 2.6, 6), 1, 6))

        //layout
        delegateWidth: units.gu(10)
        delegateHeight: units.gu(9)
        minimumHorizontalSpacing: 0 //units.gu(0.5)
        verticalSpacing: units.gu(1)
    }

    Component {
        id: delegateComponent

        Item {
            id: delegateItem
            width: gridView.cellWidth
            height: gridView.delegateHeight
            Proto.DebugRect{lineWidth: 1; visible: settings.showLauncherDebug}
            GridView.onRemove: SequentialAnimation {
                        PropertyAction { target: delegateItem; property: "GridView.delayRemove"; value: true }
                        PauseAnimation { duration: UbuntuAnimation.BriskDuration }
                        ParallelAnimation {
                            UbuntuNumberAnimation { target: delegateItem; property: "opacity"; to: 0; duration: UbuntuAnimation.FastDuration }
                            UbuntuNumberAnimation { target: delegateItem; properties: "scale"; to: 0.5; duration: UbuntuAnimation.FastDuration }
                        }
                        PropertyAction { target: delegateItem; property: "GridView.delayRemove"; value: false }
                    }
            AppIconDelegate {
                id: appDelegate
                property string appId: model.appId
                property string appName: model.appName
                width: units.gu(6) // same as launcher icon size
                anchors.horizontalCenter: parent.horizontalCenter
                sourceImage: appIcon !== '' ? '../graphics/icons/' + appIcon : ''
                label: appName
                highlighted: Proto.ListModelUtils.findFromArray(priv.highlightedItems, function(element) { if (element === delegateItem) return true })

                onClicked: root.itemClicked(appId)
                onPressAndHold: {
                    var tempArray = priv.highlightedItems
                    tempArray.push(delegateItem)
                    priv.highlightedItems = tempArray
                    root.pressAndHold(appId, appName, appDelegate)
                }
            }
        }
    }
}
