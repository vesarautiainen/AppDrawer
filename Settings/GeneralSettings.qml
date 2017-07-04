import QtQuick 2.4
import Ubuntu.Components 1.3

SettingPage {
    id: root

    settingsContainer: container
    interactive: false

    Column {
        id: container
        anchors.fill: parent
        spacing: units.gu(3)

        SliderSetting {
            id: appZoomLevelSetting
            settingKey: 'appZoomLevel'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.appZoomLevel * 100
            returnValue: value/100
            minimumValue: 10
            maximumValue: 300
            title: 'Application zoom level: ' + value.toFixed(0) + ' %'
            formatFunction: function(v) {return  v.toFixed(0)}
        }
        PopoverSelectionsSetting {
            id: deviceTypeSetting
            settingKey: 'deviceType'
            valueOptions: ['40 GU Phone','50 GU Phone', '90 GU Tablet', 'Desktop']
            textColor: root.textColor
            highlightColor: root.highlightColor
            width: parent.width
            defaultValue: defaults.deviceType
            title: 'Device type'
            enabled: !forceDesktopModeSetting.value
        }
        CheckboxSetting {
            id: forceDesktopModeSetting
            settingKey: 'forceDesktopMode'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.forceDesktopMode
            title: 'Force desktop mode'
        }
        PopoverSelectionsSetting {
            id: desktopModeSetting
            settingKey: 'desktopMode'
            valueOptions: ['Staged','Windowed']
            textColor: root.textColor
            highlightColor: root.highlightColor
            width: parent.width
            defaultValue: defaults.desktopMode
            title: 'Desktop mode'
            enabled: forceDesktopModeSetting.value
        }
        CheckboxSetting {
            id: showWorkspacesSetting
            settingKey: 'showWorkspaces'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.showWorkspaces
            title: 'Show workspaces'
        }
        CheckboxSetting {
            id: showDebugRectsSetting
            settingKey: 'showDebugRects'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.showDebugRects
            title: 'Show debug rectangles'
        }
        CheckboxSetting {
            id: showTitleSetting
            settingKey: 'showTitle'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.showTitle
            title: 'Show title'
        }
        PopoverSelectionsSetting {
            id: wallpaperSetting
            settingKey: 'wallpaper'
            valueOptions: ['wallpaper.jpg','wallpaper2.jpg', 'wallpaper3.jpg']
            textColor: root.textColor
            highlightColor: root.highlightColor
            width: parent.width
            defaultValue: defaults.wallpaper
            title: 'Wallpaper version'
        }
        SliderSetting {
            id: wallpaperBlurAmountSetting
            settingKey: 'wallpaperBlurAmount'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.wallpaperBlurAmount
            minimumValue: 0
            maximumValue: 64
            title: 'Wallpaper blur amount ' + value.toFixed(0)
            formatFunction: function(v) {return  v.toFixed(0)}
        }
        SliderSetting {
            id: switcherOverlayOpacitySetting
            settingKey: 'switcherOverlayOpacity'
            textColor: root.textColor
            width: parent.width
            defaultValue: defaults.switcherOverlayOpacity * 100
            returnValue: value/100
            minimumValue: 0
            maximumValue: 100
            title: 'Switcher overlay opacity ' + value.toFixed(0)
            formatFunction: function(v) {return  v.toFixed(0)}
        }
    }
}
