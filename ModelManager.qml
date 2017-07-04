import QtQuick 2.4
import Ubuntu.Components 1.3
import Prototype.Components 0.3 as Proto

Item {
    id: root

    property var initialLauncherApps: ['dialer', 'messaging', 'contacts','camera', 'systemsettings', 'gallery', 'browser', 'email', 'calendar']

    property ListModel allAppsModel: ApplicationsModel {}
    property alias mostUsedAppsModel: mostUsedSorted
    property ListModel runningAppsModel: allAppsModel
    property alias launcherAppsModel: favouriteFiltered

    function isRunning(appId) {
        var data = Proto.ListModelUtils.find(allAppsModel, function(element) {
                    if (element.appId === appId) return element
                })
        return data.running
    }

    function getData(appId) {
        var data = Proto.ListModelUtils.find(allAppsModel, function(element) {
                    if (element.appId === appId) return element
                })
        return data
    }

    function setRunning(appId, setValue) {
        var data = Proto.ListModelUtils.find(allAppsModel, function(element) {
                    if (element.appId === appId) return element
                })
        data.running = setValue
    }

    function addUsage(appId) {
        var data = Proto.ListModelUtils.find(allAppsModel, function(element) {
                    if (element.appId === appId) return element
                })
        data.usage++
    }

    function setFavourite(appId, setValue) {
        var data = Proto.ListModelUtils.find(allAppsModel, function(element) {
                    if (element.appId === appId) return element
                })
        data.favourite = setValue
    }

    function remove(appId) {
        var index = Proto.ListModelUtils.findIndex(allAppsModel, function(element) {
                    if (element.appId === appId) return element
                })

        allAppsModel.remove(index, 1)
    }

    SortFilterModel {
        id: mostUsedSorted
        model: root.allAppsModel
        sort.property: "usage"
        sort.order: Qt.DescendingOrder
    }

    SortFilterModel {
        id: favouriteFiltered
        model: root.allAppsModel
        filter.property: "favourite"
        filter.pattern: /true/
    }

    Component.onCompleted: initFavourites()

    function initFavourites() {
        for (var i = 0; i < initialLauncherApps.length; i++) {
            Proto.ListModelUtils.find(allAppsModel, function(element) {
                                if (element.appId === initialLauncherApps[i]) element.favourite = true
                            })
        }
    }
}
