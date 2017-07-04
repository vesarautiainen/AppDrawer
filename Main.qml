import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.Window 2.2
import 'Settings'
import 'SwitcherStage'
import 'LauncherAndDrawer'
import 'Statusbar'
import Prototype.Components 0.3
import QtGraphicalEffects 1.0

Window {
    id: root
    // Note! applicationName needs to match the "name" field of the click manifest
    //applicationName: "applicationdrawer.vesar"

    property bool embeddedSettings: false

    // Scaling function
    property real zoomLevel: settings.settingValues.appZoomLevel
//    function u(value) {
//        return (
//            typeof units !== 'undefined'? units.gu(value) : value * 8
//        ) * zoomLevel
//    }

    width: {
        var returnValue
        switch (settings.settingValues.deviceType) {
            case '40 GU Phone':
                returnValue = units.gu(40)
                break
            case '50 GU Phone':
                returnValue = units.gu(50)
                break
            case '90 GU Tablet':
                returnValue = units.gu(160) //landscape
                break
            case 'Desktop':
                returnValue = units.gu(160)
                break
            default:
                returnValue = units.gu(50)
                break
        }
        return returnValue
    }

    height: {
        var returnValue
        switch (settings.settingValues.deviceType) {
            case '40 GU Phone':
                returnValue = units.gu(71)
                break
            case '50 GU Phone':
                returnValue = units.gu(89)
                break
            case '90 GU Tablet':
                returnValue = units.gu(90)
                break
            case 'Desktop':
                returnValue = units.gu(90)
                break
            default:
                returnValue = units.gu(89)
                break
        }
        return returnValue
    }

    function focusToApp(appId) {
        if (models.isRunning(appId)) {
            switcher.focusToApp(appId)
        } else {
            models.setRunning(appId, true)
            switcher.createAppInstance(models.getData(appId))
        }

        models.addUsage(appId)
    }

    function uninstallApp(appId) {
        if (models.isRunning(appId)) {
            switcher.closeApp(appId)
        }
        models.remove(appId)
    }

    Item {
        id: shell
        anchors.fill: parent
        anchors.topMargin: statusbar.minimisedHeight

        Image {
            id: background
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            verticalAlignment: Image.AlignVCenter
            horizontalAlignment: Image.AlignHCenter
            source: 'graphics/' + settings.settingValues.wallpaper
        }

        FastBlur {
            anchors.fill: parent
            source: background
            radius: {
                if (settings.settingValues.desktopMode === 'Windowed') {
                    return settings.settingValues.wallpaperBlurAmount
                    * MathUtils.map(switcher.switcherProgress, settings.settingValues.windowedSwitchPoint, 1, 0, 1)
                } else {
                    return settings.settingValues.wallpaperBlurAmount
                }
            }
        }

        Switcher {
            id: switcher
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            settings: settings.settingValues
            screenSize: Qt.size(root.width, root.height)

            onAppClosed: models.setRunning(appId, false)
        }
    }

    LauncherAndDrawer {
        id: launcherAndDrawer
        anchors.fill: parent
        anchors.topMargin: statusbar.minimisedHeight

        allAppsModel: models.allAppsModel
        mostUsedAppsModel: models.mostUsedAppsModel
        launcherAppsModel: models.launcherAppsModel

        settings: settings.settingValues
        blurSource: shell

        onApplicationFocusRequest: root.focusToApp(appId)
        onUninstallRequest: root.uninstallApp(appId)
    }

    Statusbar {
        id: statusbar
        width: parent.width
        height: parent.height
        y: 0
        locked: false
        orangeLineHeight: 0
        hintProgress: 0
        indicatorsWidth: Math.min(units.gu(50), root.width)
        backgroundColor: '#111111'
        title: settings.settingValues.desktopMode === 'Windowed' ? switcher.currentlyFocusedAppName : ''
        Component.onCompleted: statusbar.close()
    }

    ModelManager {
        id: models
    }

    Item {
        id: settingsContainer
        anchors.fill: parent
        parent: root.embeddedSettings ? root : settingsWindow.contentItem
        visible: embeddedSettings ? false : true
        Rectangle {
            anchors.fill: parent
            color: settings.backgroundColor
            opacity: 0.3
        }

        // event eater
        MouseArea {
            anchors.fill: parent
        }

        Settings {
            id: settings
            width: units.gu(40)
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            backgroundColor: '#FAFAFA'
            textColor: '#111111'
            highlightColor: '#dd4814'
            helpDialogBackgroundColor: '#111111'
            helpDialogTextColor: '#EEEEEE'

            showDoneButton: embeddedSettings
            onDone: settingsContainer.visible = false
        }
    }

    Window {
        id: settingsWindow
        width: units.gu(40)
        height: units.gu(71)
        visible: embeddedSettings ? false : true        
    }

    KeyEventManager {
         id: keyEventManager
         onToggle: switcher.toggleSwitcher()
         onSettings: {
             if (embeddedSettings) {
                 settingsContainer.visible = true
             } else {
                 settingsWindow.show()
                 settingsWindow.requestActivate()
             }
         }
    }

    MouseArea {
        id: settingsIcon
        visible: embeddedSettings && !settingsContainer.visible
        width: units.gu(4)
        height: width
        anchors {
            top: parent.top
            right: parent.right
        }
        onClicked: settingsContainer.visible = true
        Image {
            width: units.gu(2)
            height: width
            anchors.centerIn: parent
            source: ''//'graphics/settings.png'
        }
    }

    MouseArea {
        id: toggleIcon
        visible: embeddedSettings
        width: units.gu(4)
        height: width
        anchors {
            top: parent.top
            left: parent.left
        }

        onClicked: switcher.toggleSwitcher()

        Image {
            width: units.gu(2)
            height: width
            anchors.centerIn: parent
            source: ''//'graphics/swap.png'
        }
    }
 }
