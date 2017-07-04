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

        SliderSetting {
           id: windowedSwitchPointSetting
           settingKey: 'windowedSwitchPoint'
           textColor: root.textColor
           width: parent.width
           defaultValue: defaults.windowedSwitchPoint * 100
           returnValue: value / 100
           minimumValue: 0
           maximumValue: 100
           title: 'Windowed mode switch point: ' + returnValue.toFixed(2)
           formatFunction: function(v) {return  returnValue.toFixed(2)}
        }
        CheckboxSetting {
            id: windowedSwitchInSyncSetting
            settingKey: 'windowedSwitchInSync'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.windowedSwitchInSync
            title: 'Windowed switch in sync between the items'
       }
       SliderSetting {
           id: windowedSwitchWindowSetting
           settingKey: 'windowedSwitchWindow'
           textColor: root.textColor
           width: parent.width
           defaultValue: defaults.windowedSwitchWindow * 100
           returnValue: value / 100
           minimumValue: 0
           maximumValue: 100
           title: 'Windowed mode switch window [%]: ' + returnValue.toFixed(2)
           formatFunction: function(v) {return  returnValue.toFixed(2)}
       }
        SliderSetting {
           id: opacityChangeInWindowedSwitchSetting
           settingKey: 'opacityChangeInWindowedSwitch'
           textColor: root.textColor
           width: parent.width
           defaultValue: defaults.opacityChangeInWindowedSwitch * 100
           returnValue: value / 100
           minimumValue: 0
           maximumValue: 100
           title: 'Opacity change in windowed mode switch: ' + returnValue.toFixed(2)
           formatFunction: function(v) {return  returnValue.toFixed(2)}
       }

         SliderSetting {
            id: spreadOffsetSetting
            settingKey: 'spreadOffset'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.spreadOffset + maximumValue/2
            returnValue: (value - maximumValue/2) * units.gu(1)
            minimumValue: 0
            maximumValue: 100
            title: 'Spread offset (gu)'
            formatFunction: function(v) {return  (value - maximumValue/2).toFixed(1)}
        }

        SliderSetting {
            id: iconsOffsetSetting
            settingKey: 'iconsOffset'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.iconsOffset + maximumValue/2
            returnValue: (value - maximumValue/2) * units.gu(1)
            minimumValue: 0
            maximumValue: 50
            title: 'Icons offset (gu)'
            formatFunction: function(v) {return  (value - maximumValue/2).toFixed(1)}
        }
        SliderSetting {
            id: titleOffsetSetting
            settingKey: 'titleOffset'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.titleOffset + maximumValue/2
            returnValue: (value - maximumValue/2) * units.gu(1)
            minimumValue: 0
            maximumValue: 50
            title: 'Title offset (gu)'
            formatFunction: function(v) {return  (value - maximumValue/2).toFixed(1)}
        }
//        SliderSetting {
//            id: switcherProgressSetting
//            settingKey: 'switcherProgress'
//            textColor: root.textColor
//            width: parent.width
//            defaultValue: defaults.switcherProgress * 100
//            returnValue: value/100
//            minimumValue: 0
//            maximumValue: 100
//            title: 'Manual switcher progress: '
//            formatFunction: function(v) {return value.toFixed(1)}
//        }
//        SliderSetting {
//            id: animationDurationFactorSetting
//            settingKey: 'animationDurationFactor'
//            textColor: root.textColor
//            width: parent.width
//            defaultValue: defaults.animationDurationFactor * 100
//            returnValue: value/100
//            minimumValue: 0
//            maximumValue: 4000
//            title: 'AnimationDurationFactor: ' + returnValue.toFixed(1)
//            formatFunction: function(v) {return returnValue.toFixed(1)}
//            helpText: 'Slows down the switch animation by the given factor so it is easier to follow what happens during the animation.'
//            onHelpRequest: root.helpRequest(helpText, 'Animation duration factor')
//        }
//        SliderSetting {
//            id: desktopScaleSetting
//            settingKey: 'desktopScale'
//            textColor: root.textColor
//            width: parent.width
//            defaultValue: defaults.desktopScale * 100
//            returnValue: value/100
//            minimumValue: 0
//            maximumValue: 200
//            title: 'Desktop scale: ' + returnValue.toFixed(1) + ' [BROKEN ATM!!!]'
//            formatFunction: function(v) {return returnValue.toFixed(1)}
//        }
    }
}
