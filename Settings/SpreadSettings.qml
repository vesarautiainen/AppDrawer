import QtQuick 2.4
import Ubuntu.Components 1.3

SettingPage {
    id: root

    settingsContainer: column

    Column {
        id: column
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        spacing: units.gu(1)

        CheckboxSetting {
            id: automaticLayoutSetting
            settingKey: 'automaticLayout'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.automaticLayout
            title: 'Automatic layout'
        }
        SliderSetting {
            id: itemOverlapSetting
            settingKey: 'itemOverlap'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.itemOverlap * 100
            returnValue: value/100
            minimumValue: 1
            maximumValue: 100
            title: 'Overlap amount: ' + value.toFixed(0) + '%'
            formatFunction: function(v) {return  v.toFixed(0)}
            enabled: !automaticLayoutSetting.value
        }
        SliderSetting {
            id: openAppsCountSetting
            settingKey: 'openAppsCount'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.openAppsCount
            minimumValue: 1
            maximumValue: 25
            title: 'Open apps count ' + value.toFixed(0)
            formatFunction: function(v) {return  v.toFixed(0)}
        }
        SliderSetting {
            id: appInfoHeightPercentageSetting
            settingKey: 'appInfoHeightPercentage'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.appInfoHeightPercentage
            returnValue: value/100
            minimumValue: 0
            maximumValue: 100
            title: 'Spread app info height: ' + value.toFixed(0) + ' [% of spread height]'
            formatFunction: function(v) {return  v.toFixed(0)}
            enabled: !automaticLayoutSetting.value
        }
        SliderSetting {
            id: spreadMarginSetting
            settingKey: 'spreadMargin'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.spreadMargin / units.gu(0.5)
            returnValue: Math.round(value) * units.gu(0.5)
            minimumValue: 0
            maximumValue: 20
            title: 'Spread margin: ' + (returnValue/units.gu(1)).toFixed(1) + 'gu'
            formatFunction: function(v) {return  (returnValue/units.gu(1)).toFixed(1)}
            enabled: !automaticLayoutSetting.value
        }
        SliderSetting {
            id: leftRotationAngleSetting
            settingKey: 'leftRotationAngle'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.leftRotationAngle
            minimumValue: 0
            maximumValue: 90
            title: 'Left rotation angle ' + value.toFixed(1) + ' deg'
            formatFunction: function(v) {return  v.toFixed(1)}
        }
        SliderSetting {
            id: rightRotationAngleSetting
            settingKey: 'rightRotationAngle'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.rightRotationAngle
            minimumValue: 0
            maximumValue: 90
            title: 'Right rotation angle ' + value.toFixed(1) + ' deg'
            formatFunction: function(v) {return  v.toFixed(1)}
        }
        SliderSetting {
            id: leftScaleSetting
            settingKey: 'leftScale'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.leftScale * 100
            returnValue: value / 100
            minimumValue: 0
            maximumValue: 100
            title: 'Left stack scale ' + value.toFixed(1) + ' %'
            formatFunction: function(v) {return  v.toFixed(1)}
        }
        SliderSetting {
            id: rightScaleSetting
            settingKey: 'rightScale'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.rightScale * 100
            returnValue: value / 100
            minimumValue: 0
            maximumValue: 100
            title: 'Right stack scale ' + value.toFixed(1) + ' %'
            formatFunction: function(v) {return  v.toFixed(1)}
        }
    }
}

