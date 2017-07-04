import QtQuick 2.4
import Ubuntu.Components 1.3
import Prototype.Components 0.3 as Proto
import QtGraphicalEffects 1.0

Item {
    id: root

    property int blurAmount: 32
    property Item sourceItem
    property Item blurMask

    FastBlur {
        id: blurredBackground
        anchors.fill: parent
        source: sourceItem
        radius: blurAmount
    }

    ShaderEffect {
        id: maskedBlurEffect
        anchors.fill: parent

        property variant source: ShaderEffectSource {
            id: shaderEffectSource
            sourceItem: blurredBackground//useOpacityMask ? container : null
            hideSource: true
        }

        property var mask: ShaderEffectSource {
            sourceItem: blurMask //useOpacityMask ? opacityMask : null
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
