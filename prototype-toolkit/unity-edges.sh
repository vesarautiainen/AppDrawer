#!/bin/sh

OverwrittenLauncher() {
cat << _EOF_
import QtQuick 2.0
import Ubuntu.Components 0.1

LauncherOriginal {
    id: root
    Timer {
        interval: 1000; running: true; repeat: false
        onTriggered: {
            root.anchors.bottom = undefined
            root.height = units.gu(10)
        }
    }
}
_EOF_
}

OverwrittenEdgeDragArea() {
cat << _EOF_
import QtQuick 2.0
import Ubuntu.Components 0.1

EdgeDragAreaOriginal {
    id: root
    Timer {
        interval: 1000; running: true; repeat: false
        onTriggered: {
            if ('dragAreaWidth' in root.parent &&
                'maximizedAppTopMargin' in root.parent &&
                'interactive' in root.parent &&
                'spreadEnabled' in root.parent &&
                'inverseProgress' in root.parent) {
                root.anchors.bottom = undefined
                root.height = units.gu(10)
            }
        }
    }
}
_EOF_
}

EnableEdges() {
    if [ ! -f "/usr/share/unity8/Launcher/LauncherOriginal.qml" ] && [ ! -f "/usr/share/unity8/Components/EdgeDragAreaOriginal.qml" ]; then
        echo 'Unity edges are already enabled.'
        exit 0
    fi

    sudo mv "/usr/share/unity8/Launcher/LauncherOriginal.qml" "/usr/share/unity8/Launcher/Launcher.qml"
    sudo mv "/usr/share/unity8/Components/EdgeDragAreaOriginal.qml" "/usr/share/unity8/Components/EdgeDragArea.qml"
    echo 'Unity Edges enabled. Reboot Reload Unity using the command "reboot".'
}

DisableEdges() {
    if [ -f "/usr/share/unity8/Launcher/LauncherOriginal.qml" ] || [ -f "/usr/share/unity8/Components/EdgeDragAreaOriginal.qml" ]; then
        echo 'Unity edges are already disabled.'
        exit 0
    fi

    # Backup files, just in case
    sudo cp /usr/share/unity8/Launcher/Launcher.qml /usr/share/unity8/Launcher/Launcher.qml.backup
    sudo cp /usr/share/unity8/Components/EdgeDragArea.qml /usr/share/unity8/Components/EdgeDragArea.qml.backup

    sudo mv "/usr/share/unity8/Launcher/Launcher.qml" "/usr/share/unity8/Launcher/LauncherOriginal.qml"
    sudo echo "$(OverwrittenLauncher)" > "/usr/share/unity8/Launcher/Launcher.qml"

    sudo mv "/usr/share/unity8/Components/EdgeDragArea.qml" "/usr/share/unity8/Components/EdgeDragAreaOriginal.qml"
    sudo echo "$(OverwrittenEdgeDragArea)" > "/usr/share/unity8/Components/EdgeDragArea.qml"

    echo 'Unity Edges disabled. Reboot Reload Unity using the command "reboot".'
}

if [ "$1" = 'disable' ]; then
    DisableEdges
elif [ "$1" = 'enable' ]; then
    EnableEdges
else
    echo 'You must specify "enable" or "disable"'
    exit 1
fi
