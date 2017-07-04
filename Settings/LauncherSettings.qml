import QtQuick 2.4
import Ubuntu.Components 1.3
import Prototype.Components 0.3

SettingPage {
    id: root

    settingsContainer: container
    interactive: false

    Column {
        id: container
        anchors.fill: parent
        spacing: units.gu(1)

        SliderSetting {
            id: launcherBackgroundOpacitySetting
            settingKey: 'launcherBackgroundOpacity'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.launcherBackgroundOpacity * 100
            minimumValue: 0
            maximumValue: 100
            returnValue: value / 100
            title: 'Launcher background opacity ' + returnValue.toFixed(2)
            formatFunction: function(v) {return  v.toFixed(0)}
        }
        SliderSetting {
            id: drawerBackgroundOpacitySetting
            settingKey: 'drawerBackgroundOpacity'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.drawerBackgroundOpacity * 100
            minimumValue: 0
            maximumValue: 100
            returnValue: value / 100
            title: 'Drawer background opacity ' + returnValue.toFixed(2)
            formatFunction: function(v) {return  v.toFixed(0)}
        }
        SliderSetting {
            id: drawerBlurAmountSetting
            settingKey: 'drawerBlurAmount'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.drawerBlurAmount
            minimumValue: 0
            maximumValue: 100
            title: 'Drawer blur amount ' + value.toFixed(0)
            formatFunction: function(v) {return  v.toFixed(0)}
        }
        SliderSetting {
            id: launcherDarkeningOpacitySetting
            settingKey: 'launcherDarkeningOpacity'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.launcherDarkeningOpacity * 100
            minimumValue: 0
            maximumValue: 100
            returnValue: value / 100
            title: 'Launcher darkening opacity ' + returnValue.toFixed(2)
            formatFunction: function(v) {return  v.toFixed(0)}
        }
        SliderSetting {
            id: drawerMaxPercentageSetting
            settingKey: 'drawerMaxPercentage'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.drawerMaxPercentage * 100
            minimumValue: 20
            maximumValue: 100
            returnValue: value / 100
            title: 'Drawer max percentage ' + value.toFixed(0)
            formatFunction: function(v) {return  v.toFixed(0)}
        }
        PopoverSelectionsSetting {
            id: deviceTypeSetting
            settingKey: 'openingConcept'
            valueOptions: ['Concept1','Animated hint','Specified','Concept4']
            textColor: root.textColor
            highlightColor: root.highlightColor
            width: parent.width
            defaultValue: defaults.openingConcept
            title: 'Opening concept'
        }
        PopoverSelectionsSetting {
            id: dummyDrawerContentSetting
            settingKey: 'dummyDrawerContent'
            valueOptions: ['None', 'drawer-phone.png','drawer-tablet.png']
            textColor: root.textColor
            highlightColor: root.highlightColor
            width: parent.width
            defaultValue: defaults.dummyDrawerContent
            title: 'Dummy drawer content'
        }
        CheckboxSetting {
            id: showLauncherDebugSetting
            settingKey: 'showLauncherDebug'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.showLauncherDebug
            title: 'Show launcher debug'
        }
        CheckboxSetting {
            id: hideSwipeFromAnywhereSetting
            settingKey: 'hideSwipeFromAnywhere'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.hideSwipeFromAnywhere
            title: 'Close swipe from anywhere'
        }
        CheckboxSetting {
            id: scrollbarEnabledSetting
            settingKey: 'scrollbarEnabled'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.scrollbarEnabled
            title: 'Scrollbar enabled'
        }
    }
}

