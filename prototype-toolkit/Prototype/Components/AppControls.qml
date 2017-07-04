import QtQuick 2.4
import QtQuick.Window 2.0
import Ubuntu.Components 1.3

Window {
  id: root
  title: page.title
  property alias data: content.children
  MainView {
    id: main
    width: root.width
    height: root.height
    function alignToolWindow(window, appWindow) {
      var margin = units.gu(4);
      var screenWidth = Screen.desktopAvailableWidth;
      var screenHeight = Screen.desktopAvailableHeight;
      var width = (screenWidth - appWindow.width) - margin * 3;
      window.width = width > units.gu(40)? width : units.gu(40);
      appWindow.x = margin;
      appWindow.y = margin;
      window.x = screenWidth- window.width - margin;
      window.y = margin;
      window.height = screenHeight- margin * 2
    }
    Page {
      id: page
      title: 'Prototype Tools'
      Item {
        anchors.fill: parent
        anchors.margins: units.gu(2)
        Column {
          id: content
          anchors.fill: parent
          spacing: units.gu(2)
        }
      }
    }
    Component.onCompleted: alignToolWindow(root, appWindow)
  }
}
