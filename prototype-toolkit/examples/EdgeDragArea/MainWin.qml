import QtQuick 2.4
import QtQuick.Window 2.2

Window {
    id: root
    title: app.title || ''
    width: app.width
    height: app.height
    Main {
        id: app
    }
    Component.onCompleted: {
        root.x = Screen.width / 2 - root.width / 2
        root.y = Screen.height / 2 - root.height / 2
    }
}
