import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes
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
  anchors.horizontalCenter: parent.horizontalCenter
  implicitHeight: childrenRect.height + 34
  width: 24
  radius: 2
  color: (hoverHandler.hovered) ? Colors.workspaceBackgroundHover : Colors.moduleBackground

  HoverHandler { id: hoverHandler }

  border.width: 1
  border.color: (hoverHandler.hovered) ? Colors.workspaceBorderHover : Colors.moduleBorder

  Behavior on border.color {
    ColorAnimation { duration: 400 }
  }

  ColumnLayout {
    anchors.centerIn: parent
    spacing: 3

    ColumnLayout {
      spacing: 3

      Repeater {
        model: Hyprland.workspaces

        Rectangle {
          required property var modelData
          property bool hovered: false

          width: 4
          Layout.preferredHeight: modelData.active ? 36 : 12
          Layout.alignment: Qt.AlignHCenter
          radius: 1

          color: (modelData.active || hovered) ? Colors.workspaceActive : Colors.workspaceInactive

          MouseArea {
            anchors.fill: parent
            onClicked: Hyprland.dispatch(`workspace ${modelData.id.toString()}`)

            hoverEnabled: true
            onEntered: { parent.hovered = true }
            onExited: { parent.hovered = false }
          }
        }
      }
    }
  }
}
