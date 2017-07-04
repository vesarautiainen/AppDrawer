import QtQuick 2.4
import QtQuick.Window 2.0
import Ubuntu.Components 1.3

Window {
  id: root
  title: 'Responsive Settings'
  property var orientationsModel
  property var commonSizesModel
  property int activeOrientation: orientationSelector.selectedIndex
  property int activeCommonSize: commonSizeSelector.selectedIndex
  visible: false
  MainView {
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
      title: root.title
      Item {
        anchors.fill: parent
        anchors.margins: units.gu(2)
        Column {
          anchors.fill: parent
          spacing: units.gu(2)
          OptionSelector {
            id: orientationSelector
            text: 'Orientation'
            model: orientationsModel
            expanded: true
          }
          OptionSelector {
            id: commonSizeSelector
            text: 'Common Sizes'
            model: commonSizesModel
            expanded: true
            delegate: Component {
              OptionSelectorDelegate {
                text: '%1 (%2x%3)'.arg(modelData.name)
                                  .arg(modelData.width)
                                  .arg(modelData.height)
              }
            }
          }
        }
      }
    }
    Component.onCompleted: {
      if (root.visible) {
        alignToolWindow(root, appWindow)
      }
    }
  }
}
