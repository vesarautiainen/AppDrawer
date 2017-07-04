import QtQuick 2.4
import Ubuntu.Components 1.3
import Prototype.Components 0.3
import 'Toolkit 0.4'

Item {
    id: root

    property string screenshot: ''
    property alias title: win.title
    property alias active: win.active

    property real itemRotation: 0
    property real itemScale: 1
    property real centerScale: 1

    property real spreadWidth: units.gu(20)
    property real spreadHeight: units.gu(20)
    property real desktopWidth: settings.desktopMode === 'Windowed' ? appWidth : screenSize.width
    property real desktopHeight: settings.desktopMode === 'Windowed' ? appHeight + priv.titlebarHeight: screenSize.height
    property real appWidth: screenshot !== '' ? appScreenshot.sourceSize.width * zoomLevel: units.gu(60)
    property real appHeight: screenshot !== '' ? appScreenshot.sourceSize.height * zoomLevel : units.gu(50)

    property real titlebarOpacity: 1
    property real titlebarHeight: units.gu(3)
    property size screenSize
    property bool isFocused: false
    property real focusHightlightWidth: units.gu(2)
    property real windowControlsWidth: win.buttons.width

    //property alias shadowOpacity: dropShadow.opacity
    //property alias shadowVisible: dropShadow.visible

    property bool useOpacityMask: false
    property rect maskedRect: Qt.rect(0,0,50,50)
    property real maskedOpacity: 0

    width: spreadWidth * curvedSwitcherProgress + desktopWidth * inverseCurvedSwitcherProgress
    height: spreadHeight  * curvedSwitcherProgress + desktopHeight * inverseCurvedSwitcherProgress

    signal closed()
    signal clicked()
    signal pressed()

    QtObject {
        id: priv
        property real dropshadowWidth: units.gu(2)
        property real titlebarHeight: win.bar.height
    }

    Item {
        id: container
        anchors.fill: parent

        Window {
            id: win
            width: parent.width
            height: parent.height
            bar.height: root.titlebarHeight
            bar.opacity: root.titlebarOpacity
            content.color: 'transparent'

            transform:[
                Rotation {
                    origin.x: 0;
                    origin.y: spreadHeight/2;
                    axis.x:0; axis.y:1; axis.z:0

                    angle: itemRotation
                },
                Scale {
                    xScale: itemScale
                    yScale: xScale
                    origin.x: 0;
                    origin.y: spreadHeight/2;
                },
                Scale {
                    xScale: centerScale
                    yScale: xScale
                    origin.x: root.width/2
                    origin.y: root.height/2
                },
                Scale {
                    id: focusScale
                    xScale: root.isFocused ? 1.01 : 1
                    Behavior on xScale{UbuntuNumberAnimation{duration: UbuntuAnimation.SnapDuration}}
                    yScale: xScale
                    origin.x: root.width/2
                    origin.y: root.height/2
                }
            ]

            Highlight {
                id: tracingPaperHighlight
                width: container.width
                height: container.height
                focusMargin: 0
                focusLineWidth: root.focusHightlightWidth
                color: 'white'
                focusOpacity: 0.55
                fillFocus: true
                focusHighlight: root.isFocused
            }

            Image {
                id: appScreenshot
                anchors {
                    top: parent.top
                    topMargin: priv.titlebarHeight
                }

                width: container.width
                height: container.height - priv.titlebarHeight
                source: root.screenshot
                fillMode: Image.PreserveAspectCrop
                verticalAlignment: Image.AlignTop
                horizontalAlignment: Image.AlignLeft
                antialiasing: true
                visible: root.screenshot !== ''
            }

            Rectangle {
                id: dummy
                anchors.fill: appScreenshot
                visible: !appScreenshot.visible
                color: '#bbbbbb'
                antialiasing: true
                border.color: '#aaaaaa'
                border.width: 1
            }
            Rectangle {
                id: staticDimmingRectangle
                anchors.fill: appScreenshot
                color: 'black'
                opacity: !root.isFocused ? 0.05 : 0
                Behavior on opacity {UbuntuNumberAnimation{duration: UbuntuAnimation.SnapDuration}}
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    root.pressed()
                    mouse.accepted = false
                }
            }

            onClosed: root.closed()
        }
    }

    Item {
        id: opacityMask
        width: container.width
        height: container.height

        Rectangle {
            color: 'yellow'
            width: maskedRect.width
            height: maskedRect.height
            x: maskedRect.x
            y: maskedRect.y
            opacity: maskedOpacity
        }
        visible: useOpacityMask
    }

    ShaderEffect {
        id: opacityEffect
        anchors.fill: container

        property variant source: ShaderEffectSource {
            id: shaderEffectSource
            sourceItem: useOpacityMask ? container : null
            hideSource: true
        }

        property var mask: ShaderEffectSource {
            sourceItem: useOpacityMask ? opacityMask : null
            hideSource: true
        }

        fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            uniform sampler2D source;
            uniform sampler2D mask;
            void main(void)
            {
                highp vec4 sourceColor = texture2D(source, qt_TexCoord0);
                highp vec4 maskColor = texture2D(mask, qt_TexCoord0);

                sourceColor *= 1.0 - maskColor.a;

                gl_FragColor = sourceColor;
            }"
    }

}

