import QtQuick 2.4
import Ubuntu.Components 1.3
import Prototype.Components 0.3 as Proto



TextField {
    id: search

    property bool active: text !== ''

    placeholderText: 'Search...'
    hasClearButton: true
    width: parent.width

    StyleHints {
        borderColor: 'white'
        color: 'lightGray'
        background: backgroundComponent
        backgroundColor: 'transparent'
    }

    Component {
        id: backgroundComponent
        Rectangle {
            anchors.fill: parent
            color: 'transparent'
            border.color: 'white'
            border.width: 1
            radius: units.gu(0.5)
            opacity: 0.6
        }
    }
}






