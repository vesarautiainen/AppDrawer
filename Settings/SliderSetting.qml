import QtQuick 2.4
import Ubuntu.Components 1.3

SettingsItemBase {
    id: root

    property real minimumValue: 1
    property real maximumValue: 100
    settingsComponent: sliderComponent
    settingItemPosition: 'bottom'

    Component {
        id: sliderComponent
        Slider {
            id: slider
            function formatValue(v) {
                if (root.formatFunction) return formatFunction(v)
                else return v
            }

            function reset() {
                value = root.defaultValue
            }

            width: parent.width
            minimumValue: root.minimumValue
            maximumValue: root.maximumValue
            value: root.defaultValue
            live: true
        }
    }
}
