import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.workspace.components 2.0 as WorkspaceComponents
import "components" as Components

Row {
  id: row

  property string iconUpdate: "software-update-available.svg"
  property string iconRefresh: "arch-unknown.svg"
  property string total: "0"
  property bool debug: plasmoid.configuration.debugMode

  Layout.minimumWidth: PlasmaCore.Units.iconSizes.small
  Layout.minimumHeight: PlasmaCore.Units.iconSizes.small
  anchors.fill: parent

  // updates the icon according to the refresh status
  function updateUi(refresh: boolean) {
    if (refresh) {
      updateIcon.source=iconRefresh
      total="↻"
    } else {
      updateIcon.source=iconUpdate
    }
  }

  // event handler for the left click on MouseArea
  function onLClick() {
    updater.count()
  }

  // event handler for the middle click on MouseArea
  function onMClick() {
    updater.launchUpdate()
  }

  // return true if the widget area is vertical
  function isBarVertical() {
    return row.width < row.height;
  }

  // map the cmd signal with the widget
  Connections {
    target: cmd

    function onConnected(source) {
      if (debug) console.log('ARCHUPDATE - cmd connected: ', source)
      updateUi(true)
    }

    function onExited(cmd, exitCode, exitStatus, stdout, stderr) {
      if (debug) console.log('ARCHUPDATE - cmd exited: ', JSON.stringify({cmd, exitCode, exitStatus, stdout, stderr}))
      total = stdout.replace(/\n/g, '')

      // update the count after the update
      if (cmd === "konsole -e 'sudo pacman -Syu'") onLClick()

      // handle the result for the checker
      if (cmd === "konsole -v") checker.validateKonsole(stderr)
      if (cmd === "checkupdates --version") checker.validateCheckupdates(stderr)

      updateUi(false)
    }
  }

  Item {
    id: container
    height: isBarVertical() ? row.width : row.height // usefull if the taskbar is vertical
    width: height

    anchors.centerIn: parent

    Components.PlasmoidIcon {
      id: updateIcon
      width: isBarVertical() ? container.height : container.width
      height: width
      source: iconUpdate
    }

    WorkspaceComponents.BadgeOverlay { // for the horizontal bar
      anchors {
        bottom: container.bottom
        horizontalCenter: container.right
      }
      visible: !isBarVertical()
      text: total
      icon: updateIcon
    }

    WorkspaceComponents.BadgeOverlay { // for the vertical bar
      anchors {
        verticalCenter: container.bottom
        right: container.right
      }
      visible: isBarVertical()
      text: total
      icon: updateIcon
    }

    MouseArea {
      anchors.fill: container // cover all the zone
      cursorShape: Qt.PointingHandCursor // give user feedback
      acceptedButtons: Qt.LeftButton | Qt.MiddleButton
      onClicked: (mouse) => {
        if (mouse.button == Qt.LeftButton) {
          onLClick()
        } else if (mouse.button == Qt.MiddleButton) {
          onMClick()
        }
      }
    }
  }
}
