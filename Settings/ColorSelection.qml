import QtQuick 2.4
import Ubuntu.Components 1.3

SettingsItemBase {
    id: root
    settingsComponent: colorSelectionComponent
    settingItemPosition: 'bottom'
    settingTopMargin: units.gu(0.5)
    property var colors: ['#ffffff','#dd4814', '#000000']

    Component {
        id: colorSelectionComponent

        Item {
            id: container

            property color value

            width: childrenRect.width
            height: childrenRect.height + units.gu(0.5)

            function reset() {
                container.value = root.defaultValue
            }

            Row {
                height: units.gu(3)
                Repeater {
                    model: root.colors.length
                    Rectangle {
                        id: rect
                        height: parent.height
                        width: units.gu(4)
                        color: root.colors[index]
                        border.width: color === root.value ? units.dp(2) : units.dp(1)
                        border.color: color === root.value ? '#19B6EE' : 'white'

                        MouseArea {
                            anchors.fill: parent
                            onClicked: container.value = rect.color
                        }
                    }
                }
            }

//            ListModel {
//                id: colorsModel
//                ListElement {
//                    color: '#ffffff'
//                }
//                ListElement {
//                    color: '#dd4814'
//                }
//                ListElement {
//                    color: 'lightGray'
//                }
//                ListElement {
//                    color: '#808080'
//                }
//                ListElement {
//                    color: '#404040'
//                }
//                ListElement {
//                    color: '#000000'
//                }
//            }
        }
    }
}
