import QtQuick 2.4
import Prototype.Components 0.3

Item {
    id: root

    property real shortSwipeProgress: 0
    property real inverseShortSwipeProgress: 1 - shortSwipeProgress
    property real secondStageProgress: 0
    property real inverseSecondStageProgress: 1 - secondStageProgress

    // information about the system and surroundings
    property size screenSize: Qt.size(0,0)
    property int itemIndex: 0
    property int totalItemCount: 0
    property real switchPoint: 0.5

    // API
    property point desktopPosition: settings.desktopMode === 'Staged' ? priv.stagedDesktopPosition : priv.windowedDesktopPosition
    property real desktopRotation: settings.desktopMode === 'Staged' ? priv.stagedDesktopRotation : priv.windowedDesktopRotation
    property real desktopScale: settings.desktopMode === 'Staged' ? priv.stagedDesktopScale : priv.windowedDesktopScale
    property real itemZ: settings.desktopMode === 'Staged' ? priv.stagedZ : priv.windowedZ
    property real itemOpacity: settings.desktopMode === 'Staged' ? priv.stagedOpacity : priv.windowedOpacity


    function setNewWindowedPosition(newPosition) {
        priv.windowedPosition = newPosition
    }

    QtObject {
        id: priv

        property real xRand: Math.random()
        property real yRand: Math.random()

        // Position
        property point stagedDesktopPosition: Qt.point(shortSwipeProgress * stagedFirstStagePosition.x + inverseShortSwipeProgress * stagedPosition.x,
                                                       shortSwipeProgress * stagedFirstStagePosition.y + inverseShortSwipeProgress * stagedPosition.y)
        property point windowedDesktopPosition: Qt.point(shortSwipeProgress * windowedFirstStagePosition.x + inverseShortSwipeProgress * windowedPosition.x,
                                                         shortSwipeProgress * windowedFirstStagePosition.y + inverseShortSwipeProgress * windowedPosition.y)
        property point stagedPosition: Qt.point(itemIndex === 0 ? 0 : screenSize.width + itemIndex*units.gu(5), 0)
        property point windowedPosition: Qt.point(xRand*screenSize.width/2, yRand*screenSize.height/2)
        property point stagedFirstStagePosition: {
            if (itemIndex === 0) return Qt.point(units.gu(-0.5), 0)
            else if (itemIndex === 1) return Qt.point(0.4*screenSize.width, 0)
            else return stagedPosition
        }
        property point windowedFirstStagePosition: windowedPosition


        // Rotation
        property real stagedDesktopRotation: shortSwipeProgress * stagedFirstStageRotation + inverseShortSwipeProgress * stagedRotation
        property real windowedDesktopRotation: shortSwipeProgress * windowedFirstStageRotation + inverseShortSwipeProgress * windowedRotation
        property real stagedRotation: MathUtils.clamp( (itemIndex === 0 ? 0 : 55 + itemIndex*10) * inverseSecondStageProgress, 0, 90)
        property real windowedRotation: 0
        property real stagedFirstStageRotation: itemIndex === 0 ? 2 : (itemIndex === 1 ? 5 : stagedRotation)
        property real windowedFirstStageRotation: 0

        // Scale
        property real stagedDesktopScale: shortSwipeProgress * stagedFirstStageScale + inverseShortSwipeProgress * stagedScale
        property real windowedDesktopScale: shortSwipeProgress * windowedFirstStageScale + inverseShortSwipeProgress * windowedScale
        property real stagedScale: itemIndex === 0 ? 1 : 1.6
        property real stagedFirstStageScale: itemIndex === 0 ? 0.95 : (itemIndex === 1 ? 1.1 : 1.6)
        property real windowedScale: 1
        property real windowedFirstStageScale: 1

        // Others
        property real stagedZ: itemIndex
        property real switchWindow: settings.windowedSwitchWindow // change this to have the switch happen in different times
        property real itemSwitchPoint: settings.windowedSwitchInSync ? root.switchPoint : root.switchPoint - switchWindow + switchWindow/root.totalItemCount*itemIndex
        property real windowedZ: secondStageProgress > itemSwitchPoint ? itemIndex : (itemIndex === 1 && shortSwipeProgress > 0 ? totalItemCount + 10 : totalItemCount - itemIndex)
        property real windowedOpacity: {
            var opacityChange = settings.opacityChangeInWindowedSwitch
            var changeDistanceBeforeSwitch = settings.windowedSwitchInSync ? switchWindow : switchWindow/root.totalItemCount / 2
            var changeDistanceAfterSwitch = changeDistanceBeforeSwitch

            if (secondStageProgress > itemSwitchPoint - changeDistanceBeforeSwitch && secondStageProgress <= itemSwitchPoint) {
                return MathUtils.map(secondStageProgress, itemSwitchPoint - changeDistanceBeforeSwitch, itemSwitchPoint, 1, 1-opacityChange)
            } else if (secondStageProgress > itemSwitchPoint && secondStageProgress < itemSwitchPoint + changeDistanceAfterSwitch) {
                return MathUtils.map(secondStageProgress, itemSwitchPoint, itemSwitchPoint + changeDistanceAfterSwitch, 1-opacityChange, 1)
            } else  {
                return 1
            }
        }
        property real stagedOpacity: 1
    }
}

