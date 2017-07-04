import QtQuick 2.4
import Ubuntu.Components 1.3

SettingsItemBase {
    id: root
    settingsComponent: colorSelectionComponent
    settingItemPosition: 'side'

    signal add()
    signal remove()

    Component {
        id: colorSelectionComponent

        Item {
            id: dummyApps

            property var value: undefined

            function reset() {
            }

            height: childrenRect.height
            Action {
                id: addAction
                onTriggered: root.add()
                iconSource: "graphics/add.svg"
            }
            Action {
                id: closeAction
                onTriggered: root.remove()
                iconSource: "graphics/remove.svg"
            }
            Button {
                id: removeButton
                anchors {
                    right: parent.right
                    //rightMargin:units.gu(2)
                    //verticalCenter: parent.verticalCenter
                }
                height: units.gu(3)
                width: height
                action: closeAction
                color: UbuntuColors.coolGrey
            }
            Button {
                id: addButton
                anchors {
                    right: removeButton.left
                    rightMargin:units.gu(2)
                    //verticalCenter: parent.verticalCenter
                }
                height: units.gu(3)
                width: height
                action: addAction
                color: UbuntuColors.coolGrey
            }
        }
    }
}
