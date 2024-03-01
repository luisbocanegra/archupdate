import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.plasma.plasmoid

import "../_toolbox" as Tb
import "../service" as Sv

PlasmoidItem {
    id: archupdate

    //preferredRepresentation: compactRepresentation
    compactRepresentation: Compact {}

    // load one instance of each needed service
    Sv.Updater{ id: updater }
    Sv.Checker{ id: checker }
    Tb.Cmd { id: cmd }

    // this is mendatory to have that in the root elem's : https://techbase.kde.org/Development/Tutorials/Plasma4/JavaScript/API-PlasmoidObject#Context_menu
    function action_launchUpdate() {
        updater.launchUpdate()
    }

    Component.onCompleted: {
      Plasmoid.setAction("launchUpdate", "Update", "preferences-other")
      checker.konsole()
      checker.checkupdates()
    }
}
