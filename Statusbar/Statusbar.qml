import QtQuick 2.4
import Ubuntu.Components 0.1
import "Components"

Item {
    id: root

    property bool locked: false
    property int minimisedHeight: indicatorsBar.minimisedHeight + orangeLineHeight
    property int orangeLineHeight: units.dp(2)
    property real contentHeight: content.height + handle.height + extraHeight
    property real extraHeight: indicatorsBar.height - units.gu(5)
    property real indicatorsWidth: root.width
    property color backgroundColor: 'black'
    property alias title: applicationTitle.text

    property real hintProgress: 1

    property alias contentRevealer: contentRevealer

    state: "minimised"

    function open() {
        root.state = "expanded"
        indicatorsBar.updateInitialItem(indicatorsBar.width)
    }

    function close() {
        root.state = "minimised"
        indicatorsBar.releasedReset(false)
        indicatorsBar.reset()
    }

    // I don't know what this is.. just commented away
//    Rectangle {
//        id: hintmask
//        color: 'black'
//        height: units.gu(10)
//        width: parent.width
//        anchors.bottom: orangeLine.top
//    }

    MenuContent {
        id: content
        height: 0
        anchors {
            right: parent.right
            top: indicatorsBar.bottom
        }
        width: indicatorsWidth
        menuName: indicatorsBar.currentIndicator
        contentScreen: {
            for (var i = 0; i < indicatorsModel.count; i++) {
                if (indicatorsModel.get(i).itemName === content.menuName) {
                    if (indicatorsModel.get(i).active) {
                        return indicatorsModel.get(i).menuSourceActive
                    } else {
                        return indicatorsModel.get(i).menuSource
                    }
                }
            }
            return ""
        }

        property int animationDuration: UbuntuAnimation.SlowDuration
        showAnimation: ParallelAnimation {
            id: sequentialShowAnimation
            property var target: null
            SequentialAnimation {
                ScriptAction {
                    script: {
                        root.state = "opened"
                        indicatorsBar.releasedReset(true)
                    }
                }
                NumberAnimation {
                    target: sequentialShowAnimation.target
                    property: "height"
                    duration: content.animationDuration
                    to: contentRevealer.openedValue
                    easing.type: Easing.OutCubic
                }
            }
        }

        hideAnimation: ParallelAnimation {
            id: sequentialHideAnimation
            property var target: null
            SequentialAnimation {
                ScriptAction {
                    script: {
                        root.state = "minimised"
                        indicatorsBar.releasedReset(false)
                    }
                }
                NumberAnimation {
                    target: sequentialHideAnimation.target
                    property: "height"
                    duration: content.animationDuration
                    to: contentRevealer.closedValue
                    easing.type: Easing.OutCubic
                }
                ScriptAction {
                    script: indicatorsBar.reset()
                }
            }
        }
        shown: false
        onShownChanged: {
            if (shown) indicatorsBar.switchToFlickable()
        }
        onActiveChanged: {
            for (var i = 0; i < indicatorsModel.count; i++) {
                if (indicatorsModel.get(i).itemName == content.menuName) {
                    indicatorsModel.set(i, {"active": content.active})
                    indicatorsModel.set(i, {"initiallyVisible": content.active})
                    return
                }
            }
        }
    }

    Revealer {
        id: contentRevealer

        target: content
        boundProperty: "height"
        orientation: Qt.Vertical
        anchors {
            left: target.left
            right: target.right
            top: parent.top
        }
        hintDisplacement: handle.height
        handleSize: target.shown ? units.gu(2) : indicatorsBar.minimisedHeight
        openedValue: root.height - orangeLine.height - indicatorsBar.maximisedHeight
        closedValue: indicatorsBar.minimisedHeight - indicatorsBar.minimisedHeight
        height: root.height
        onOpenPressed: {
            root.state = "expanded"
            indicatorsBar.updateInitialItem(pressMouseDetector.pressedXValue)
        }
        onClosePressed: handle.active = true
        onReleased: handle.active = false
        // this is needed because revealer's lateralPosition is incorrect when openPressed signal is emitted
        MouseArea {
            id: pressMouseDetector
            property real pressedXValue: -1
            anchors.fill: parent
            onPressed: {
                pressedXValue = mouseX
                mouse.accepted = false
            }
        }
        onLateralPositionChanged: {
            if (dragging) indicatorsBar.lateralPosition = lateralPosition
        }

        function dragToValue(dragPosition) {
            // magical:( Overridden function from revealer. I don't know exactly where that magic number units.gu(3)
            // comes from but it works here
            return dragPosition + closedValue - hintDisplacement - units.gu(3)
        }

        Connections {
            target: contentRevealer.target
            onHeightChanged: {
                if (target.height > contentRevealer.hintDisplacement && contentRevealer.dragging) {
                    root.state = "dragging"
                    handle.active = true
                }
            }
        }
    }

    Handle {
        id: handle
        width: indicatorsWidth
        anchors.right: parent.right
        height: units.gu(2)
        visible: hintProgress === 0
    }

    Rectangle {
        id: background
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        color: root.backgroundColor
        height: minimisedHeight
    }

    IndicatorsBar {
        id: indicatorsBar
        width: indicatorsWidth
        anchors.right: parent.right
        state: root.state
        verticalVelocity: contentRevealer.dragVelocity
        indicatorsModel: indicatorsModel
        itemUpdateAllowed: !content.shown
        locked: root.locked
        color: root.backgroundColor
        clip: indicatorsWidth < root.width
    }

    Label {
        id: applicationTitle
        color: 'white'
        fontSize: 'medium'
        anchors {
            left: background.left
            leftMargin: units.gu(2)
            verticalCenter: background.verticalCenter
        }
    }

    Rectangle {
        id: orangeLine
        color: "#de4814"
        width: parent.width
        height: orangeLineHeight
        anchors.top: content.bottom
        anchors.topMargin: units.gu(2) * hintProgress
    }

    // onStateChanged: console.log('root state:', state)
    states: [
        State {
            name: "minimised"
        },
        State {
            name: "expanded"
        },
        State {
            name: "dragging"
        },
        State {
            name: "opened"
        }
    ]

    ListModel {
        id: indicatorsModel
        ListElement {
            itemIcon: "graphics/transfer-none.svg"
            itemIconActive: "graphics/transfer-none.svg"
            itemText: ""
            itemName: "Transfers"
            initiallyVisible: false
            showWhenLocked: true
            menuSource: "graphics/contentPages/empty.jpg"
            menuSourceActive: "graphics/contentPages/empty.jpg"
            active: false
        }
        ListElement {
            itemIcon: "graphics/gps.svg"
            itemIconActive: "graphics/gps.svg"
            itemText: ""
            itemName: "Location"
            initiallyVisible: false
            showWhenLocked: true
            menuSource: "graphics/contentPages/location.jpg"
            menuSourceActive: "graphics/contentPages/location.jpg"
            active: false
        }
        ListElement {
            itemIcon: "graphics/bluetooth-active.svg"
            itemIconActive: "graphics/bluetooth-active.svg"
            itemText: ""
            itemName: "Bluetooth"
            initiallyVisible: true
            showWhenLocked: true
            menuSource: "graphics/contentPages/bluetooth.jpg"
            menuSourceActive: "graphics/contentPages/bluetooth.jpg"
            active: false
        }
        ListElement {
            itemIcon: "graphics/wifi-high.svg"
            itemIconActive: "graphics/wifi-high.svg"
            itemText: ""
            itemName: "Network"
            initiallyVisible: true
            showWhenLocked: true
            menuSource: "graphics/contentPages/network.jpg"
            menuSourceActive: "graphics/contentPages/network.jpg"
            active: false
        }
        ListElement {
            itemIcon: "graphics/messages-inactive.png"
            itemIconActive: "graphics/messages-active.png"
            itemText: ""
            itemName: "Notifications"
            initiallyVisible: true
            showWhenLocked: false
            menuSource: "graphics/contentPages/empty-long.jpg"
            menuSourceActive: "graphics/contentPages/messages.jpg"
            active: true
        }
        ListElement {
            itemIcon: "graphics/battery-080.svg"
            itemIconActive: "graphics/battery-080.svg"
            itemText: ""
            itemName: "Battery"
            initiallyVisible: true
            showWhenLocked: true
            menuSource: "graphics/contentPages/battery.jpg"
            menuSourceActive: "graphics/contentPages/battery.jpg"
            active: false
        }
        ListElement {
            itemIcon: "graphics/audio-volume-low.svg"
            itemIconActive: "graphics/audio-volume-low.svg"
            itemText: ""
            itemName: "Sound"
            initiallyVisible: true
            showWhenLocked: true
            menuSource: "graphics/contentPages/sound.jpg"
            menuSourceActive: "graphics/contentPages/sound.jpg"
            active: false
        }
        ListElement {
            itemIcon: ""
            itemIconActive: ""
            itemText: "12:02"
            itemName: "Upcoming"
            initiallyVisible: true
            showWhenLocked: true
            menuSource: "graphics/contentPages/timeanddate.jpg"
            menuSourceActive: "graphics/contentPages/timeanddate.jpg"
            active: false
        }
    }
}
