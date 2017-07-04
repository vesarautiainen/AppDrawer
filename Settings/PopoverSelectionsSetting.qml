import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem

SettingsItemBase {
    id: root

    property var valueOptions: []

    settingsComponent: comboComponent
    settingItemPosition: 'side'

    QtObject {
        id: priv
        property int originalZ: -1
    }

    Component {
        id: comboComponent
        Item {
            id: pointerNavigationCombo

            property string value: pointerNavigationCombo.selectedText

            property int selectedIndex: 0
            property string selectedText: valueOptions[selectedIndex]

            function reset() {
                for (var i = 0; i < valueOptions.length; i++) {
                    if (valueOptions[i] === root.defaultValue) {
                        selectedIndex = i
                        break;
                    }
                }
            }

            width: units.gu(30)
            height: trigger.height + units.gu(0.5)
            // eating mouse events to leak to other controls and close the popover when clicked
            // A bit hackish but couldn't get the default popover auto hide functionality work
            MouseArea {
                anchors.fill: parent
                anchors.margins: -units.gu(1000)
                enabled: popover.visible
                onClicked: popover.hide()
            }

            Rectangle {
                anchors.fill: parent
                color: 'transparent'
                border.width: 1
                border.color: 'yellow'
                visible: false
            }

            Label {
                id: trigger
                text: selectedText
                color: root.highlightColor
                anchors.right: parent.right
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // set topmost
                        priv.originalZ = root.z
                        root.z = 10000
                        popover.show()
                    }
                }
            }

            Popover {
                id: popover
                Column {
                    id: containerLayout
                    anchors {
                        left: parent.left
                        top: parent.top
                        right: parent.right
                    }
                    Repeater {
                        model: valueOptions.length

                        ListItem.Standard {
                            text: valueOptions[index]
                            onClicked: {
                                pointerNavigationCombo.selectedIndex = index
                                root.z = priv.originalZ
                                popover.hide()
                            }
                        }
                    }
                }
            }
        }
    }
}

