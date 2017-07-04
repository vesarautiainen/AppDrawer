import QtQuick 2.4
import Ubuntu.Components 1.3

Item {
    id: root

    property real settingTopMargin: 0
    property string title: 'Default title'
    property string settingKey: ''
    property var defaultValue
    property color textColor: 'white'
    property color highlightColor: 'white'
    property bool selectedItem: false
    property var value: settingsItemLoader.item ? settingsItemLoader.item.value : undefined
    property Component settingsComponent: null
    property var formatFunction: undefined
    property var returnValue: undefined
    property string helpText: ''
    property string settingItemPosition: 'side' // possible values: side, bottom
    onSettingItemPositionChanged: {
        if (settingItemPosition !== 'side' && settingItemPosition !== 'bottom') {
            console.error('Error: Invalid settingItemPosition. Possible values are \'side\' and \'bottom\'')
            settingItemPosition = 'bottom'
        }
    }

    signal helpRequest()

    height: container.height
    opacity: enabled ? 1 : 0.6

    Component.onCompleted: reset()

    function getValue() {
        if (returnValue !== undefined) {
            return returnValue
        } else {
            return root.value
        }
    }

    function reset() {
        if (settingsItemLoader.item) settingsItemLoader.item.reset()
    }

    Rectangle {
        anchors.fill: parent
        color: 'transparent'
        border.width: 1
        border.color: '#19B6EE'
        radius: units.gu(0.5)
        visible: selectedItem
    }

    Item {
        id: container
        anchors {
            left: parent.left
            leftMargin: units.gu(1)
            right: parent.right
            rightMargin: units.gu(1)
        }
        height: childrenRect.height

        Label {
            id: label
            color: root.textColor
            text: root.title
            fontSize: "small"
            MouseArea {
                anchors.fill: parent
                onDoubleClicked: root.reset()
            }
        }

        Image {
            id: helpButton
            height: visible ? label.height : 0
            width: sourceSize.width / sourceSize.height * height
            source: 'graphics/help.png'
            antialiasing: false
            smooth: true
            visible: root.helpText !== ''
            enabled: visible
            anchors {
                left: label.right
                leftMargin: units.gu(1)
                verticalCenter: label.verticalCenter
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.helpRequest()
            }
        }

        Loader {
            id: settingsItemLoader
            anchors {
                top: settingItemPosition === 'bottom' ? label.bottom : label.top
                topMargin: root.settingTopMargin
                left: settingItemPosition === 'bottom' ? container.left : undefined
                right: settingItemPosition === 'bottom' ? parent.right : container.right
                rightMargin: settingItemPosition === 'bottom' ? 0 : units.gu(1)
            }
            sourceComponent: root.settingsComponent
        }
    }
}
