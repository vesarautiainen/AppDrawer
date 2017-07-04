import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Prototype.Components 0.3 as Proto
import '../Components'

Item {
    id: root

    property var settings
    property int itemsPerRow: 4
    property real contentOpacity: 1
    property real closingDragX
    property var allAppsModel: DrawerApplicationsModel {}
    property var mostUsedAppsModel: null
    property real deviceWidth

    signal itemClicked(string appId)
    signal closingDragStarted(real startX)
    signal closingDragEnded(real endX, int direction)
    signal uninstallRequest(string appId, string appName)

    enabled: false

    function focusSearch() {
        search.focus = true
    }

    QtObject {
        id: priv
        property real iconAspectRatio: 8 / 7.5
        property real verticalComponentMargin: units.gu(1)
        property real horizontalContentMargin: units.gu(1)
        property var alphabet: ['A','B','C','D','E','F','G','H','I','J','K','L','M',
                                   'N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
    }

    //eater
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            //Accept the mouse event so that propagated events don't fall through any further
            mouse.accepted = true
            closerArea.resetValues()
        }
    }

    Rectangle {
        anchors.fill: parent
        color: 'black'
        opacity: settings.drawerBackgroundOpacity
    }

    Item {
        id: contentContainer
        anchors {
            fill: parent
            topMargin: units.gu(1.5)
        }

        opacity: contentOpacity
        visible: !settings.useDummyDrawerContent

        SearchField {
            id: search
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: priv.horizontalContentMargin
                rightMargin: priv.horizontalContentMargin
            }
//            onTriggered: // open some app here
//            onAccepted: // or here
        }

        Flickable {
            id: flickable
            anchors {
                top: search.bottom
                topMargin: priv.verticalComponentMargin
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            flickableDirection: Qt.Vertical
            interactive: !closerArea.horizontalConfirmed
            contentHeight: column.height
            clip: true

            Column {
                id: column
                width: parent.width
                spacing: priv.verticalComponentMargin

                Sections {
                    id: sections
                    x: priv.horizontalContentMargin
                    actions: [
                        Action {
                            text: "A-Z"
                        },
                        Action {
                            text: "Most used"
                        }
                    ]

                    Rectangle {
                        anchors.bottom: parent.bottom
                        height: units.dp(1)
                        color: 'gray'
                        width: contentContainer.width
                        x: -priv.horizontalContentMargin
                    }
                }

                MoreAppsItem {
                    id: moreApps
                    anchors {
                        left: parent.left
                        right: parent.right
                        leftMargin: priv.horizontalContentMargin
                        rightMargin: priv.horizontalContentMargin
                    }
                }

                // Load either a-z content or most used apps content depending on the section header state
                Loader {
                    sourceComponent: sections.selectedIndex === 0 ? aToZPage : mostUsedPage
                    anchors {
                        left: parent.left
                        right: parent.right
                        leftMargin: priv.horizontalContentMargin
                        rightMargin: priv.horizontalContentMargin
                    }
                }
            }
        }

        Scrollbar {
            id: scrollbar
            flickableItem: flickable
            align: Qt.AlignTrailing
            visible: settings.scrollbarEnabled
        }
    }

    Component {
        id: aToZPage
        Column {
            width: parent ? parent.width : 0
            spacing: priv.verticalComponentMargin
            Repeater {
                model: priv.alphabet

                ApplicationSection {
                    id: section
                    visible: model && model.count > 0
                    width: parent.width
                    model: search.active ? searchSortedModel : alphabeticallySortedModel
                    settings: root.settings
                    deviceWidth: root.deviceWidth
                    title: priv.alphabet[index]

                    onItemClicked: root.itemClicked(appId)
                    onPressAndHold: {
                        contextMenu.target = this
                        contextMenu.caller = caller
                        contextMenu.pointerTarget = caller
                        contextMenu.targetAppId = appId
                        contextMenu.targetAppName = appName
                        contextMenu.show()
                    }

                    SortFilterModel {
                        id: searchSortedModel
                        model: search.active ? alphabeticallySortedModel : null
                        filter.property: "appName"
                        filter.pattern: new RegExp("^" + search.text, "i")
                    }

                    SortFilterModel {
                        id: alphabeticallySortedModel
                        model: root.allAppsModel
                        filter.property: "appName"
                        filter.pattern: new RegExp("^" + section.title)
                        sort.property: "appName"
                        sort.order: Qt.AscendingOrder
                    }
                }
            }
        }
    }

    Component {
        id: mostUsedPage
        Column {
            width: parent ? parent.width : 0
            spacing: priv.verticalComponentMargin
            ApplicationSection {
                id: section
                width: parent.width
                model: search.active ? searchSortedModel : root.mostUsedAppsModel
                visible: model && model.count > 0
                settings: root.settings
                deviceWidth: root.deviceWidth
                title: ''

                onItemClicked: root.itemClicked(appId)
                onPressAndHold: {
                    contextMenu.target = this
                    contextMenu.caller = caller
                    contextMenu.targetAppId = appId
                    contextMenu.targetAppName = appName
                    contextMenu.show()
                }

                SortFilterModel {
                    id: searchSortedModel
                    model: search.active ? root.mostUsedAppsModel : null
                    filter.property: "appName"
                    filter.pattern: new RegExp("^" + search.text, "i")
                }

            }
        }
    }

    Label {
        anchors.centerIn: parent
        color: 'white'
        fontSize: 'medium'
        width: root.width * 0.8
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        horizontalAlignment: Text.AlignHCenter
        text: sections.selectedIndex === 0 ? 'No applications' : 'No most used applications'
        visible: (!(root.allAppsModel && root.allAppsModel.count > 0) && sections.selectedIndex === 0) ||
                 (!(root.mostUsedAppsModel && root.mostUsedAppsModel.count > 0) && sections.selectedIndex === 1)
    }

    ContextMenu {
        id: contextMenu
        onUninstall: {
            target.resetHighlights()
            root.uninstallRequest(contextMenu.targetAppId, contextMenu.targetAppName)
            contextMenu.hide()
        }
        onHideRequest: {
            target.resetHighlights()
            contextMenu.hide()
        }
        onVisibleChanged: if (!visible) target.resetHighlights()
    }

    Proto.DraggingArea {
        id: closerArea

        property point initialMousePos
        property real initialRootX: root.x
        property real threshold: units.gu(2)
        property bool verticalConfirmed
        property bool horizontalConfirmed

        function resetValues() {
            verticalConfirmed = false
            horizontalConfirmed = false
            root.closingDragX = -1
        }

        parent: settings.useDummyDrawerContent ? dummyContentContainer : flickable
        propagateComposedEvents: true // to get the click events to the content components
        orientation: Qt.Horizontal
        anchors.top: parent.top
        anchors.topMargin: sections.height
        width: settings.scrollbarEnabled ? parent.width - scrollbar.width : parent.width
        height: parent.height
        enabled: settings.hideSwipeFromAnywhere
        x: initialRootX - root.x // to compensate root element movement and to keep the mouse area still during the close drag

        onPressed: {
            resetValues()
            propagateComposedEvents = true
            initialRootX = root.x
            initialMousePos = Qt.point(mouseX, mouseY)
        }
        onMouseXChanged: {
            if (horizontalConfirmed) {
                // calculate here the closing progress
                root.closingDragX = mouseX
            }
        }
        onPositionChanged: {
            if (!verticalConfirmed && !horizontalConfirmed) {
                if (Math.abs(initialMousePos.y - mouseY) > closerArea.threshold) {
                    // vertical drag confirmed
                    verticalConfirmed = true
                }
                else if (Math.abs(initialMousePos.x - mouseX) > closerArea.threshold) {
                    // horizontal drag confirmed
                    horizontalConfirmed = true
                    root.closingDragX = mouseX
                    root.closingDragStarted(mouseX)
                }
            }
        }
        onReleased: {
            var direction
            if (horizontalConfirmed) {
                direction = dragVelocity > 0 ? Qt.LeftToRight : Qt.RightToLeft
                root.closingDragEnded(mouseX, direction)
                propagateComposedEvents = false
            }

            resetValues()
        }
    }

    Item {
        id: dummyContentContainer
        anchors.fill: parent
        opacity: contentOpacity
        visible: settings.useDummyDrawerContent

        Image {
            width: parent.width
            height: sourceSize.height / sourceSize.width * width
            source: settings.useDummyDrawerContent ? 'graphics/' + settings.dummyDrawerContent : ''
        }
    }
 }
