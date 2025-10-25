import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris
import Qt5Compat.GraphicalEffects
import qs.configuration

Rectangle {
  Layout.alignment: Qt.AlignHCenter
  Layout.preferredHeight: childrenRect.height + 10
  visible: SystemTray.items.values.length
  width: 28
  radius: innerModulesRadius
  color: (hoverHandler.hovered) ? Colors.trayBackgroundHover : Colors.moduleBackground

  HoverHandler { id: hoverHandler }

  border.width: 1
  border.color: (hoverHandler.hovered) ? Colors.trayBorderHover : Colors.moduleBorder

  Behavior on border.color {
    ColorAnimation { duration: 400 }
  }

  ColumnLayout {
    anchors.centerIn: parent
    spacing: 3

    Repeater {
      model: SystemTray.items

      Rectangle {
        required property var modelData
        Layout.alignment: Qt.AlignHCenter
        height: 18
        width: 18
        color: "transparent"

        Image {
          anchors.centerIn: parent
          width: 17
          height: 17
          source: modelData.icon
        }

        MouseArea {
          anchors.fill: parent
          onClicked: {
            if (modelData.hasMenu) QsMenuAnchor.open(modelData.menu)
          }
        }
      }
    }
  }
}
