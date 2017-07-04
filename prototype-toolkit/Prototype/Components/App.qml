import QtQuick 2.4
import QtQuick.Window 2.0
import Ubuntu.Components 1.3
import Ubuntu.PerformanceMetrics 1.0
import Ubuntu.Components.Popups 1.0
import '.' as Utils

Window {
  id: appWindow
  title: 'Prototype app'
  width: units.gu(150)
  height: units.gu(80)
  property bool debug: false
  property bool showResponsiveControls: false

  property string orientation: 'landscape'

  property string breakpoint: (function(){
    return 'disabled'
    var names = Object.keys(breakpoints);
    var widthValue = orientation === 'landscape'? width : height;
    var validBreakPoints = names.filter(function(name) {
      return breakpoints[name][0] < widthValue &&
             breakpoints[name][1] === orientation
    });
    validBreakPoints.sort(function(a, b) {
      var width1 = breakpoints[a][0];
      var width2 = breakpoints[b][0];
      if (width1 < width2) return 1;
      if (width1 > width2) return -1;
      return 0;
    });
    return validBreakPoints[0];
  }())

  property var orientations: [ 'Portrait', 'Landscape' ]
  property var commonSizes: [
    { name: 'Small', width: units.gu(40), height: units.gu(72) },
    { name: 'Medium', width: units.gu(66), height: units.gu(80) },
    { name: 'Large', width: units.gu(80), height: units.gu(120) }
  ]

  PerformanceOverlay {
    active: debug
  }

  ResponsiveControls {
    id: respControls
    visible: showResponsiveControls
    orientationsModel: orientations
    commonSizesModel: commonSizes
    // activeOrientation: 2
    onActiveOrientationChanged: {
      orientation = orientations[activeOrientation].toLowerCase()
      var height = appWindow.height;
      var width = appWindow.width;
      var changeToPortrait = orientation === 'portrait' &&
                             width > height
      var changeToLandscape = orientation === 'landscape' &&
                              height > width
      if (changeToPortrait) {
        appWindow.width = height;
        appWindow.height = width;
      } else if (changeToLandscape) {
        appWindow.width = height;
        appWindow.height = width;
      }
    }
  }

  function positionApp(app) {
    app.x = Screen.desktopAvailableWidth/2 - width/2
    app.y = Screen.desktopAvailableHeight/2 - height/2
  }

  Component.onCompleted: {
    positionApp(appWindow);
    if (showResponsiveControls) {
      respControls.show();
    }
  }
}
