import QtQuick 2.4
import Ubuntu.Components 0.1

Rectangle {
    id: indicatorsBar

    property bool locked: false
    property bool itemUpdateAllowed: true
    property string currentIndicator: row.currentItemName
    property real minimisedHeight: units.gu(3)
    property real maximisedHeight: units.gu(7)
    property real lateralPosition: -1
    property real verticalVelocity: 0
    property ListModel indicatorsModel: null

    property real rowMappedLateralPosition: {
        // just to automatically invoke this calculation when scrolling offset changes
        var dummyvar = row.scrollingOffset

        var mapped = indicatorsBar.mapToItem(row, lateralPosition, 0)
        return mapped.x
    }

    color: "black"

    height: state == "minimised" ? minimisedHeight : maximisedHeight
    Behavior on height {NumberAnimation {duration: UbuntuAnimation.SnapDuration; easing: UbuntuAnimation.StandardEasing}}

    function releasedReset(targetOpened) {
        if (!targetOpened) {
            resetScrollingOffsetAnimation.restart()
            flickable.interactive = false
        }
    }

    function reset() {
        row.resetCurrentItem()
        row.scrollingOffset = 0
    }

    function getRowMappedX(barPosition) {
        var mapped = indicatorsBar.mapToItem(row, barPosition, 0)
        return mapped.x
    }

    function updateInitialItem(lateralPosition) {
            row.updateInitialItem(getRowMappedX(lateralPosition))
    }

    // change the name of this function!!
    function switchToFlickable() {
        if (!row.animationRunning) {
            flickable.interactive = true
            calculateContentXToEnsureCurrentItemVisibility()
            resetOffsetAnimation.restart()
        } else {
            indicatorsBar.switchToFlickablePending = true
        }
    }

    property bool switchToFlickablePending: false

    function calculateContentXToEnsureCurrentItemVisibility() {
        if (row.combinedOffset < flickable.width - row.width) {
            // row is not left enough so fill the gap between its left edge and the left edge of the screen
            resetOffsetAnimation.contentXToValue = 0
        } else {
            // calculate the current item left and right positions in respect to the whole visible indicators bar
            var currentItemLeftEdgePositionWithinBar = row.currentItem.x - row.combinedOffset - row.width + flickable.width
            var currentItemRightEdgePositionWithinBar = currentItemLeftEdgePositionWithinBar + row.currentItem.width
            if (currentItemRightEdgePositionWithinBar > flickable.width) { // check if current item is partially outside of the right edge
                resetOffsetAnimation.contentXToValue = row.currentItem.x + row.currentItem.width - flickable.width
            } else if (currentItemLeftEdgePositionWithinBar < 0) { // check if current item is partially outside of the left edge
                resetOffsetAnimation.contentXToValue = row.currentItem.x
            } else { // default option, keep the row still. Current item is visible on the screen
                resetOffsetAnimation.contentXToValue = row.width - flickable.width + row.combinedOffset
            }
        }
    }

    ScrollArea {
        id: leftScrollArea
        width: units.gu(6)
        anchors.left: parent.left
        height: parent.height
        forceScrollingPercentage: 0.3
        thresholdAreaWidth: units.gu(0.5)
        lateralPosition: {
            var mapped = indicatorsBar.mapToItem(this, indicatorsBar.lateralPosition, 0)
            return mapped.x
        }
        direction: Qt.RightToLeft

        onScroll: {
            if ((indicatorsBar.state == "expanded" || indicatorsBar.state == "dragging") && verticalVelocity < units.gu(10)) {
                row.addScrollingOffset(-scrollAmount)
            }
        }
    }

    ScrollArea {
        id: rightScrollArea
        width: units.gu(6)
        anchors.right: parent.right
        height: parent.height
        forceScrollingPercentage: 0.3
        thresholdAreaWidth: units.gu(0.5)
        lateralPosition: {
            var mapped = indicatorsBar.mapToItem(this, indicatorsBar.lateralPosition, 0)
            return mapped.x
        }

        onScroll: if ((indicatorsBar.state == "expanded" || indicatorsBar.state == "dragging") && verticalVelocity < units.gu(10)) row.addScrollingOffset(scrollAmount)
    }

    Flickable {
        id: flickable
        flickableDirection: Qt.Horizontal
        anchors.fill: parent
        contentWidth: width
        interactive: false

        rebound: Transition {
                NumberAnimation {
                    properties: "x"
                    duration: 600
                    easing.type: Easing.OutCubic
                }
            }

        IndicatorsRow {
            id: row

            locked: indicatorsBar.locked
            scrollingOffset: 0
            property real combinedOffset: -rowOffset + scrollingOffset
            function addScrollingOffset(scrollAmount) {
                var combinedUpperLimit = 0
                var combinedLowerLimit = indicatorsBar.width - row.width

                // disable left scrolling area if row is not all the way to left yet
                if (-combinedOffset > row.width - flickable.width && scrollAmount < 0) {
                    return;
                }

                // restrict scrolling from the both ends
                var newOffset = combinedOffset + scrollAmount
                if (newOffset >= combinedUpperLimit && scrollAmount > 0) {
                    scrollAmount = combinedUpperLimit - combinedOffset
                } else if (newOffset <= combinedLowerLimit && scrollAmount < 0) {
                    scrollAmount = combinedLowerLimit - combinedOffset
                }

                scrollingOffset += scrollAmount
            }

            indicatorsModel: indicatorsBar.indicatorsModel
            height: parent.height
            anchors.right: parent.right
            anchors.rightMargin: combinedOffset
            state: indicatorsBar.state
            maximisedHeight: indicatorsBar.maximisedHeight
            lateralPosition: rowMappedLateralPosition
            itemUpdateAllowed: indicatorsBar.itemUpdateAllowed

            onAnimationRunningChanged: {
                if (!animationRunning && indicatorsBar.switchToFlickablePending) {
                    indicatorsBar.switchToFlickablePending = false
                    indicatorsBar.switchToFlickable()
                }
            }
        }
    }

    ParallelAnimation {
        id: resetScrollingOffsetAnimation
        NumberAnimation {
            target: row
            property: "scrollingOffset"
            to: 0
            duration: UbuntuAnimation.SnapDuration; easing: UbuntuAnimation.StandardEasing
        }
        NumberAnimation {
            target: flickable
            property: "contentWidth"
            to: flickable.width
            duration: UbuntuAnimation.SnapDuration; easing: UbuntuAnimation.StandardEasing
        }
    }

    ParallelAnimation {
        id: resetOffsetAnimation

        property real contentXToValue: 0

        NumberAnimation {
            target: row
            property: "combinedOffset"
            to: 0
            duration: UbuntuAnimation.BriskDuration; easing: UbuntuAnimation.StandardEasing
        }
        NumberAnimation {
            target: flickable
            property: "contentWidth"
            to: row.width
            duration: UbuntuAnimation.BriskDuration; easing: UbuntuAnimation.StandardEasing
        }
        NumberAnimation {
            target: flickable
            property: "contentX"
            to: resetOffsetAnimation.contentXToValue
            duration: UbuntuAnimation.BriskDuration; easing: UbuntuAnimation.StandardEasing
        }
    }
}
