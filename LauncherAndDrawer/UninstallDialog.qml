/*
The SDK Dialog component fails to show itself in a correct z position so using this
tweaked implementation the way Shell uses it currently.
The implementation is copied from the Unity Shell /qml/Components/ShellDialog.qml
*/

import QtQuick 2.4

import Ubuntu.Components 1.3
import Ubuntu.Components.Themes 1.3
import Ubuntu.Components.Popups 1.3

/*
    A Dialog configured for use as a proper in-scene Dialog

    This is a helper component for Dialogs.qml, thus some assumptions
    on context are (or will be) made here.
 */
Dialog {
    automaticOrientation: false

    // NB: PopupBase, Dialog's superclass, will check for the existence of this property
    property bool reparentToRootItem: false

    onVisibleChanged: { if (!visible && dialogLoader) { dialogLoader.active = false; } }

    Keys.onEscapePressed: hide()

    focus: true

    // FIXME: this is a hack because Dialog subtheming seems broken atm
    // https://bugs.launchpad.net/ubuntu/+source/ubuntu-ui-toolkit/+bug/1555548
    ThemeSettings {
        id: themeHack
    }

    Component.onCompleted: {
        themeHack.palette.normal.overlay = "white";
        themeHack.palette.normal.overlayText = UbuntuColors.slate;
        __foreground.theme = themeHack
        show();
    }
}
