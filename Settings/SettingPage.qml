import QtQuick 2.4
import Ubuntu.Components 1.3
import Prototype.Components 0.3 as Proto

Flickable {
    id: root
    property string pageName: ''
    property color textColor: 'white'
    property color highlightColor: 'yellow'
    property QtObject defaults: null
    property var settingsContainer: null
    onSettingsContainerChanged: if (settingsContainer) settingsContainer.parent = root.contentItem

    signal helpRequest(string helpText, string helpTitle)

    clip: contentY != 0

    contentHeight: settingsContainer ? settingsContainer.height : 0
    flickableDirection: Qt.Vertical

    function getValue(settingKey) {
        if (!settingsContainer) return undefined

        var resultElement = Proto.ListModelUtils.findFromArray(settingsContainer.children, function (element) {
                            return element.settingKey === settingKey
                        })
        if (resultElement) return resultElement.getValue()
        else return undefined
    }

    function resetAll() {
        if (!settingsContainer) return
        Proto.ListModelUtils.eachForArray(settingsContainer.children, function (element) {
                                    element.reset()
                                })
    }
}
