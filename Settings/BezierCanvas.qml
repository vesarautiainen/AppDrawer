import QtQuick 2.4
import Ubuntu.Components 1.3
import Prototype.Components 0.3
import '../BezierCurve/'
import '../BezierCurve/cubic-bezier.js' as Bezier

SettingsItemBase {
    id: root

    property real testValue: 0

    property var controlPoints: getControlPoints()
    function getControlPoints() {
        return [{x:canvas.controlPoint1.x / canvas.width, y:(canvas.height - canvas.controlPoint1.y) / canvas.height},
                {x:canvas.controlPoint2.x / canvas.width, y:(canvas.height - canvas.controlPoint2.y) / canvas.height}]
    }

    function getValue() {
        return getControlPoints()
    }

    function reset() {
        point1.x = canvas.width * defaultValue[0].x - point1.width/2
        point1.y = (1-defaultValue[0].y) * canvas.height - point1.height/2
        point2.x = canvas.width * defaultValue[1].x - point2.width/2
        point2.y = (1-defaultValue[1].y) * canvas.height - point2.height/2
    }


    Rectangle {
        color: 'white'
        anchors.fill: parent

        MouseArea {
            anchors.fill: parent
            onDoubleClicked: root.reset()
        }

        Canvas {
            id: canvas
            anchors.fill: parent

            property point controlPoint1: Qt.point(point1.x + point1.width/2, point1.y + point1.height/2)
            property point controlPoint2: Qt.point(point2.x + point2.width/2, point2.y + point2.height/2)

            onControlPoint1Changed: {
                canvas.requestPaint()
            }
            onControlPoint2Changed: {
                canvas.requestPaint()
            }

            onPaint: {
                var ctx = canvas.getContext('2d');
                ctx.save();
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                ctx.globalAlpha = 1.0;
                ctx.strokeStyle = 'blue';
                ctx.fillStyle = 'transparent';
                ctx.lineWidth = 2

                ctx.beginPath();
                ctx.moveTo(0,canvas.height);
                ctx.bezierCurveTo(controlPoint1.x,controlPoint1.y,controlPoint2.x,controlPoint2.y,canvas.width,0);
                ctx.stroke();
                ctx.restore();
            }
        }

        Rectangle {
            id: redDot
            color: 'red'
            width: units.gu(1)
            height: width
            radius: width / 2
            x: -width/2 + curve.getValues(root.testValue).x * canvas.width
            y: -height/2 + canvas.height - curve.getValues(root.testValue).y * canvas.height
            onXChanged: {
                opacity = 1
                timer.restart()
            }
            Behavior on opacity {NumberAnimation{duration: UbuntuAnimation.FastDuration}}

            Timer {
                id: timer
                interval: 2000
                onTriggered: redDot.opacity = 0
            }
        }

        Column {
            Label {
                text: 'cp1: (' + controlPoints[0].x.toFixed(2) + ', ' + controlPoints[0].y.toFixed(2) + ')'
                fontSize: 'x-small'
            }
            Label {
                text: 'cp2: (' + controlPoints[1].x.toFixed(2) + ', ' + controlPoints[1].y.toFixed(2) + ')'
                fontSize: 'x-small'
            }
        }
    }

    BezierCurve {
        id: curve
        controlPoint2: {'x': controlPoints[0].x, 'y': controlPoints[0].y}
        controlPoint3: {'x': controlPoints[1].x, 'y': controlPoints[1].y}
    }

    Line {
        x1: 0
        x2: root.width
        y1: root.height
        y2: 0
        antialiasing: true
        lineWidth: 3
        opacity: 0.05
    }

    // -------------ControlPoint 1-------------------------------
    Line {
        x1: 0
        x2: point1.x + point1.width/2
        y1: root.height
        y2: point1.y + point1.height/2

        antialiasing: true
        lineWidth: 1
        opacity: 0.5
    }

    MouseArea {
        id: point1
        x: -width / 2
        y: root.height - height / 2
        width: units.gu(2)
        height: width
        drag {
            target: this
            minimumX: -width / 2
            //maximumX: root.width - width / 2
            minimumY: -height / 2
            //maximumY: root.height - height / 2
            threshold: 0
        }
        Rectangle {
            anchors.centerIn: parent
            width: units.gu(1)
            height: units.gu(1)
            radius: width/2
            color: 'lightBlue'
            border.width: units.dp(1)
            border.color: 'black'
        }
    }


    // -------------ControlPoint 2-------------------------------
    Line {
        x1: root.width
        x2: point2.x + point2.width/2
        y1: 0
        y2: point2.y + point2.height/2
        antialiasing: true
        lineWidth: 1
        opacity: 0.5
    }

    MouseArea {
        id: point2
        x: root.width - width / 2
        y: -height / 2
        width: units.gu(2)
        height: width
        drag {
            target: this
            minimumX: -width / 2
            maximumX: root.width - width / 2
            minimumY: -height / 2
            maximumY: root.height - height / 2
            threshold: 0
        }
        Rectangle {
            anchors.centerIn: parent
            width: units.gu(1)
            height: units.gu(1)
            radius: width/2
            color: 'lightGreen'
            border.width: units.dp(1)
            border.color: 'black'
        }
    }
}
