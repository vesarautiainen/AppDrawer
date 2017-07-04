import QtQuick 2.4
import Ubuntu.Components 1.3 as Ubuntu
import 'QmlUtils.js' as QUtils

Ubuntu.MainView {
  id: root
  useDeprecatedToolbar: false

  property bool quitOnCtrlQ: true
  default property alias data: focusContainer.data
  property bool debug: false

  FocusScope {
    id: focusContainer
    anchors.fill: parent
    focus: true
    Component.onCompleted: focusContainer.forceActiveFocus()
    Keys.onPressed: {
      // Quit on Ctrl+Q
      if (root.quitOnCtrlQ && Qt.Key_Q === event.key &&
          event.modifiers === Qt.ControlModifier) {
        Qt.quit()
      }
    }
  }
}
