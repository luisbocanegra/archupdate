import QtQuick 2.15
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.workspace.components as WorkspaceComponents
import "."
import org.kde.kirigami as Kirigami

Item {
    id: root
    anchors.centerIn: parent
    property var source

    Kirigami.Icon {
        anchors.centerIn: parent
        width: Math.min(parent.height, parent.width)
        height: width
        source: Qt.resolvedUrl("../../assets/" + root.source)
        active: compact.containsMouse
        isMask: true
        color: Kirigami.Theme.textColor
        opacity: compact.isEnabled ? 1 : 0.5
    }

}
