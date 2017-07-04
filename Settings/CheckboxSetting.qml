import QtQuick 2.4
import Ubuntu.Components 1.3

SettingsItemBase {
    id: root

    settingsComponent: checkboxComponent
    settingItemPosition: 'side'

    Component {
        id: checkboxComponent
        CheckBox {
            id: checkbox

            property bool value: checked

            function reset() {
                checked = root.defaultValue
            }
        }
    }
}
