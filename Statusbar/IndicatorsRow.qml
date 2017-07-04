import QtQuick 2.4
import Ubuntu.Components 0.1
import "Components/Math.js" as MathLocal

Item {
    id: indicatorsRow

    property bool locked: false

    property ListModel indicatorsModel: null
    property bool animationRunning: {
        var childItem = null

        // find the 0 index item (leftmost)
        if (childItem == null || childItem == repeater) {
            for (var i = 0; row.children.length; i++) {
                if (row.children[i].ownIndex == 0) {
                    childItem = row.children[i]
                    break;
                }
            }
        }
        return childItem.animationRunning
    }

    property real lateralPosition: -1
    onLateralPositionChanged: {
        updateCurrentItem(lateralPosition)
        highlight.calculateHighlightCenterOffset()
    }

    property real scrollingOffset: 0
    property bool itemUpdateAllowed: true
    property int currentItemIndex: currentItem ? currentItem.ownIndex : -1
    property string currentItemName: currentItem ? indicatorsModel.get(currentItemIndex).itemName : ""
    property real maximisedHeight: 0
    property var currentItem: null
    property var initialItem: null
    onInitialItemChanged: currentItem = initialItem

    property real rowOffset: {
        var currentDistanceFromRight
        if (!initialItem) {
            return 0
        } else {
            currentDistanceFromRight = row.width - initialItem.x - initialItem.width / 2
            return currentDistanceFromRight - __originalDistanceFromRight
        }
    }

    property real __originalDistanceFromRight: -1

    onStateChanged: highlight.highlightCenterOffset = 0

    function resetCurrentItem() {
        initialItem = null
        currentItem = null
    }

    function updateInitialItem(position) {
        var childItem = row.childAt(position,0)

        // find the 0 index item (leftmost)
        if (childItem == null || childItem == repeater) {
            for (var i = 0; row.children.length; i++) {
                if (row.children[i].ownIndex == 0) {
                    childItem = row.children[i]
                    break;
                }
            }
        }

        indicatorsRow.__originalDistanceFromRight = row.width - childItem.x - childItem.width / 2
        initialItem = childItem
    }

    function updateCurrentItem(lateralPosition) {
        if (itemUpdateAllowed && (indicatorsBar.state == "expanded" || indicatorsBar.state == "dragging")) {
            var newItem = row.childAt(lateralPosition,0)
            if (newItem != null && newItem != repeater) {
                currentItem = newItem
            }
        }
    }

    width: row.width

    Row {
        id: row
        width: children.width
        height: parent.height

        Repeater {
            id: repeater
            model: indicatorsModel
            delegate: ItemDelegate {
                id: itemDelegate
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height
                state: indicatorsRow.state
                maximisedHeight: indicatorsRow.maximisedHeight
                selected: indicatorsRow.currentItem === this
                onClicked: indicatorsRow.currentItem = this
                visible: !indicatorsRow.locked || showWhenLocked
            }
        }
    }

    Rectangle {
        id: grayLine
        height: units.dp(2)
        width: parent.width
        anchors.bottom: row.bottom
        color: "#4c4c4c"
        opacity: indicatorsRow.state == "minimised" ? 0 : 1
        Behavior on opacity {NumberAnimation{duration: UbuntuAnimation.SnapDuration}}
    }

    Rectangle {
        id: highlight

        // micromovements of the highlight line when user moves the finger across the items while pulling
        // the handle downwards.
        property real highlightCenterOffset: 0

        function calculateHighlightCenterOffset() {
            var maximumCentreOffset = units.gu(1)
            // variying from -1 to 1. Left edge being -1, center 0 and right edge 1
            var centerPercentageOffset = 0

            if (currentItem && itemUpdateAllowed && !animationRunning && indicatorsRow.state != "opened") {
                var mappedToItem = row.mapToItem(currentItem, indicatorsRow.lateralPosition, 0)
                if (mappedToItem && currentItem.width != 0) {
                    centerPercentageOffset = (mappedToItem.x - currentItem.width/2) / (currentItem.width/2)
                } else {
                    centerPercentageOffset = 0
                }

                // respect the left and right borders
                if (currentItem && currentItemIndex == 0 && centerPercentageOffset < 0) {
                    centerPercentageOffset = 0
                } else if (currentItem && currentItemIndex == indicatorsModel.count-1 & centerPercentageOffset > 0) {
                    centerPercentageOffset = 0
                }

            } else {
                centerPercentageOffset = 0
            }

            highlightCenterOffset = centerPercentageOffset * maximumCentreOffset
        }

        Behavior on highlightCenterOffset {
            enabled: !animationRunning
            SmoothedAnimation {duration:UbuntuAnimation.FastDuration; velocity: 50}
        }


        anchors.bottom: row.bottom
        height: units.dp(2)
        width: currentItem ? currentItem.width : 0
        color: "#FFFFFF" //#de4814"

        opacity: currentItem && currentItem.state != "minimised" ? 0.9 : 0
        Behavior on opacity {NumberAnimation{duration: UbuntuAnimation.SnapDuration}}

        property real currentItemX: currentItem ? currentItem.x : 0 // having Behavior
        Behavior on currentItemX {
            id: currentItemXBehavior
            enabled: !animationRunning
            UbuntuNumberAnimation { duration: UbuntuAnimation.FastDuration; easing: UbuntuAnimation.StandardEasing }
        }
        x: currentItemX + highlightCenterOffset
    }
}
