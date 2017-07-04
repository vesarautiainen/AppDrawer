import QtQuick 2.4

Item {
    id: root
    focus: true

    signal altTabPressed(bool isAutoRepeat)
    signal returnPressed()
    signal toggle()
    signal settings()
    signal addDummyApp()
    signal closeDummyApp()
    signal toLeft(bool isAutoRepeat)
    signal toRight(bool isAutoRepeat)
    signal toUp()
    signal toDown()

    signal testSignal() // just to test anything random

    signal altReleased()

    signal workspaceNavigation(int direction)

    Keys.onPressed: {
        // CONTROL modifier
        if (event.modifiers & Qt.ControlModifier) {
            if (event.key === Qt.Key_Tab) {
                root.altTabPressed(event.isAutoRepeat)
            }
        }

        // SHIFT modifier
        if (event.modifiers & Qt.ShiftModifier) {
            if (event.key === Qt.Key_Right && !event.isAutoRepeat) {
                root.workspaceNavigation(Qt.LeftToRight)
            } else if (event.key === Qt.Key_Left && !event.isAutoRepeat) {
                root.workspaceNavigation(Qt.RightToLeft)

            }
        }


        if (event.key === Qt.Key_T) {
            root.toggle()
        } else if (event.key === Qt.Key_S) {
            root.settings()
        } else if (event.key === Qt.Key_Plus) {
            root.addDummyApp()
        } else if (event.key === Qt.Key_Minus) {
            root.closeDummyApp()
        } else if (event.key === Qt.Key_Left) {
            root.toLeft(event.isAutoRepeat)
        } else if (event.key === Qt.Key_Right) {
            root.toRight(event.isAutoRepeat)
        } else if (event.key === Qt.Key_Down) {
            root.toDown()
        } else if (event.key === Qt.Key_Up) {
            root.toUp()
        } else if (event.key === Qt.Key_Return) {
            root.returnPressed()
        } else if (event.key === Qt.Key_Q) {
            root.testSignal()
        }
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Control) {
            root.altReleased()
        }
    }
}
