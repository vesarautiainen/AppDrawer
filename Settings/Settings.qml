import QtQuick 2.4
import Ubuntu.Components 1.3

Item {
    id: root

    property color backgroundColor: 'black'
    property color textColor: 'white'
    property color highlightColor: '#dd4814'
    property color helpDialogBackgroundColor: 'white'
    property color helpDialogTextColor: 'black'
    property alias showDoneButton: header.showDoneButton
    property alias settingValues: values

    signal done()

    function animateSwitcherProgress(newValue) {
        switcherProgressAnimation.finalValue = newValue
        switcherProgressAnimation.restart()
    }

    QtObject {
        id: values

        // Launcher settings
        property real launcherBackgroundOpacity: launcherSettings.getValue('launcherBackgroundOpacity')
        property real drawerBackgroundOpacity: launcherSettings.getValue('drawerBackgroundOpacity')
        property int drawerBlurAmount: launcherSettings.getValue('drawerBlurAmount')
        property real launcherDarkeningOpacity: launcherSettings.getValue('launcherDarkeningOpacity')
        property real drawerMaxPercentage: launcherSettings.getValue('drawerMaxPercentage')
        property string openingConcept: launcherSettings.getValue('openingConcept')
        property string dummyDrawerContent: launcherSettings.getValue('dummyDrawerContent')
        property bool useDummyDrawerContent: dummyDrawerContent !== 'None' // No setting component for this
        property bool showLauncherDebug: launcherSettings.getValue('showLauncherDebug')
        property bool hideSwipeFromAnywhere: launcherSettings.getValue('hideSwipeFromAnywhere')
        property bool scrollbarEnabled: launcherSettings.getValue('scrollbarEnabled')

        // General settings
        property real appZoomLevel: generalSettings.getValue('appZoomLevel')
        property string deviceType: generalSettings.getValue('deviceType')
        property bool forceDesktopMode: generalSettings.getValue('forceDesktopMode')
        property string desktopMode: forceDesktopMode ? generalSettings.getValue('desktopMode') : (deviceType === 'Desktop' ? 'Windowed' : 'Staged') //generalSettings.getValue('desktopMode') //['Staged','Windowed']
        property bool showWorkspaces: generalSettings.getValue('showWorkspaces')
        property bool showDebugRects: generalSettings.getValue('showDebugRects')
        property bool showTitle: generalSettings.getValue('showTitle')
        property string wallpaper: generalSettings.getValue('wallpaper')
        property real wallpaperBlurAmount: generalSettings.getValue('wallpaperBlurAmount')
        property real switcherOverlayOpacity: generalSettings.getValue('switcherOverlayOpacity')

        // Spread layout settings
        property bool automaticLayout: spreadSettings.getValue('automaticLayout')
        property real itemOverlap: spreadSettings.getValue('itemOverlap')
        property int openAppsCount: spreadSettings.getValue('openAppsCount')
        property real appInfoHeightPercentage: spreadSettings.getValue('appInfoHeightPercentage')
        property real spreadMargin: spreadSettings.getValue('spreadMargin')
        property real leftRotationAngle: spreadSettings.getValue('leftRotationAngle')
        property real rightRotationAngle: spreadSettings.getValue('rightRotationAngle')
        property real leftScale: spreadSettings.getValue('leftScale')
        property real rightScale: spreadSettings.getValue('rightScale')

        // Curve
        property var drawerCurveControlPoints: curveSettings.getValue('drawerCurveControlPoints')
        property var spreadCurveControlPoints: defaultValues.spreadCurveControlPoints //curveSettings.getValue('spreadCurveControlPoints')
        property var longSwipeCurveControlPoints: defaultValues.longSwipeCurveControlPoints//curveSettings.getValue('longSwipeCurveControlPoints')
        //property real curveProgress: curveSettings.getValue('curveProgress')

        // Temp settings
        property real spreadOffset: tempSettings.getValue('spreadOffset')
        property real iconsOffset: tempSettings.getValue('iconsOffset')
        property real titleOffset: tempSettings.getValue('titleOffset')
        //property real animationDurationFactor: tempSettings.getValue('animationDurationFactor')
        //property real desktopScale: tempSettings.getValue('desktopScale')

        // Windowed mode switch properties
        property real windowedSwitchPoint: tempSettings.getValue('windowedSwitchPoint')
        property bool windowedSwitchInSync: tempSettings.getValue('windowedSwitchInSync')
        property real windowedSwitchWindow: tempSettings.getValue('windowedSwitchWindow')
        property real opacityChangeInWindowedSwitch: tempSettings.getValue('opacityChangeInWindowedSwitch')
    }



    QtObject {
        id: defaultValues

        // Launcher settings
        property real launcherBackgroundOpacity: 0.92
        property real drawerBackgroundOpacity: 0.75
        property int drawerBlurAmount: 50
        property real launcherDarkeningOpacity: 0.4
        property real drawerMaxPercentage: 0.9 // drawer + launcher of the screen width
        property string openingConcept: 'Animated hint' // ['Concept1','Animated hint', 'Specified', 'Concept4']
        property string dummyDrawerContent: 'None' //['None', 'drawer-phone.png','drawer-tablet.png']
        property bool showLauncherDebug: false
        property bool hideSwipeFromAnywhere: true
        property bool scrollbarEnabled: false

        // General settings
        property real appZoomLevel: 0.5
        property string deviceType: 'Desktop' // ['40 GU Phone','50 GU Phone', '90 GU Tablet', 'Desktop']
        property bool forceDesktopMode: false
        property string desktopMode: 'Staged' // ['Staged','Windowed']
        property bool showWorkspaces: true
        property bool showDebugRects: false
        property bool showTitle: true
        property string wallpaper: 'wallpaper.jpg' // ['wallpaper.jpg','wallpaper2.jpg', wallpaper3.jpg]
        property real wallpaperBlurAmount: 32
        property real switcherOverlayOpacity: 0.6

        // Spread layout settings
        property bool automaticLayout: true
        property real itemOverlap: 0.62
        property int openAppsCount: 5
        property real appInfoHeightPercentage: 15 // %
        property real spreadMargin: units.gu(1.5)
        property real leftRotationAngle: 22 //degrees
        property real rightRotationAngle: 32 //degrees
        property real leftScale: 0.82 //degrees
        property real rightScale: 1.0 //degrees

        // Curve
        property var drawerCurveControlPoints: [{x:0.73,y:0},{x:0,y:0.68}]
        property var spreadCurveControlPoints: [{x:0.19,y:0},{x:0.91,y:1}]
        property var longSwipeCurveControlPoints: [{x:0.98,y:0.58},{x:0.11,y:0.5}]
        //property real curveProgress: 0

        // Temp settings
        property real spreadOffset: 0
        property real iconsOffset: 0
        property real titleOffset: 0
        //property real switcherProgress: 0
       // property real animationDurationFactor: 1
       // property real desktopScale: 1

        // New ones for the sprint
        property real windowedSwitchPoint: 0.5
        property bool windowedSwitchInSync: true
        property real windowedSwitchWindow: 0.02
        property real opacityChangeInWindowedSwitch: 0.1
    }


    function resetAll() {
        generalSettings.resetAll()
        spreadSettings.resetAll()
        curveSettings.resetAll()
        tempSettings.resetAll()
    }

    Rectangle {
        color: root.backgroundColor
        opacity: 1
        anchors.fill: parent
    }

    SettingsHeader {
        id: header
        anchors {
            top: parent.top
            topMargin: units.gu(1)
            left: parent.left
            right: parent.right
        }
        textColor: root.textColor

        onResetAll: root.resetAll()
        onDone: root.done()
    }

    PageSelector {
        id: pageSelector
        pages: [generalSettings, launcherSettings, curveSettings]
        anchors {
            top: header.bottom
            topMargin: units.gu(1)
            left: parent.left
            right: parent.right
        }
        height: units.gu(3)
        currentPage: launcherSettings
        textColor: root.textColor
        highlightColor: '#dd4814'
    }

    Item {
        id: pageContainer
        anchors {
            left: parent.left
            leftMargin: units.gu(1)
            right: parent.right
            rightMargin: units.gu(1)
            top: pageSelector.bottom
            bottom: parent.bottom
            topMargin: units.gu(4)
        }

        GeneralSettings {
            id: generalSettings
            defaults: defaultValues
            anchors.fill: parent
            pageName: 'General'
            textColor: root.textColor
            highlightColor: root.highlightColor
            visible: pageSelector.currentPage === this
            onHelpRequest: help.show(helpText, helpTitle)
        }
        LauncherSettings {
            id: launcherSettings
            defaults: defaultValues
            anchors.fill: parent
            pageName: 'Launcher'
            textColor: root.textColor
            highlightColor: root.highlightColor
            visible: pageSelector.currentPage === this
            onHelpRequest: help.show(helpText, helpTitle)
        }
        SpreadSettings {
            id: spreadSettings
            defaults: defaultValues
            anchors.fill: parent
            pageName: 'Layout'
            textColor: root.textColor
            highlightColor: root.highlightColor
            visible: pageSelector.currentPage === this
            onHelpRequest: help.show(helpText, helpTitle)
        }
        CurveSettings {
            id: curveSettings
            defaults: defaultValues
            anchors.fill: parent
            pageName: 'Curve'
            textColor: root.textColor
            highlightColor: root.highlightColor
            visible: pageSelector.currentPage === this
            onHelpRequest: help.show(helpText, helpTitle)
        }
        TempSettings {
            id: tempSettings
            defaults: defaultValues
            anchors.fill: parent
            pageName: 'Misc'
            textColor: root.textColor
            highlightColor: root.highlightColor
            visible: pageSelector.currentPage === this
            onHelpRequest: help.show(helpText, helpTitle)
        }
    }

    HelpDialog {
        id: help
        anchors.fill: parent
        backgroundColor: root.helpDialogBackgroundColor
        textColor: root.helpDialogTextColor
    }

    NumberAnimation {
        id: switcherProgressAnimation

        property real finalValue
        target: values
        property: 'switcherProgress'
        to: switcherProgressAnimation.finalValue
        duration: UbuntuAnimation.FastDuration //* values.animationDurationFactor
        easing.type: Easing.OutCubic
    }
}
