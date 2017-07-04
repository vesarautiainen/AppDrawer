import QtQuick 2.4
import Ubuntu.Components 1.3

SettingPage {
    id: root

    settingsContainer: container
    interactive: true

    Column {
        id: container
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        spacing: units.gu(5)

        BezierCanvas {
            id: drawerCurveControlPointsSetting
            settingKey: 'drawerCurveControlPoints'
            width: units.gu(30)
            defaultValue: defaults.drawerCurveControlPoints
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
        }

//        BezierCanvas {
//            id: spreadCurveControlPointsSetting
//            settingKey: 'spreadCurveControlPoints'
//            width: units.gu(30)
//            defaultValue: defaults.spreadCurveControlPoints
//            height: width
//            anchors.horizontalCenter: parent.horizontalCenter
//            testValue: curveProgressSetting.returnValue
//        }

//        SliderSetting {
//            id: curveProgressSetting
//            settingKey: 'curveProgress'
//            textColor: root.textColor
//            width: parent.width
//            defaultValue: defaults.curveProgress
//            returnValue: value/100
//            minimumValue: 0
//            maximumValue: 100
//            title: 'Curve progress: '  + returnValue.toFixed(2)
//            formatFunction: function(v) {return  returnValue.toFixed(2)}
//        }
    }
}

