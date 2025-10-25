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
  Layout.topMargin: 4
  height: 28
  width: 28
  radius: innerModulesRadius
  color: hoverHandler.hovered ? Colors.powerBackgroundHover : Colors.powerBackground

  border.width: 1
  border.color: hoverHandler.hovered ? Colors.powerBorderHover : Colors.powerBorder

  HoverHandler { id: hoverHandler }

  Behavior on border.color {
    ColorAnimation { duration: 400 }
  }

  Image {
    anchors.centerIn: parent
    width: 16
    height: 16
    source: `file:///home/${username}/.config/quickshell/svg/power.svg`
    sourceSize.width: 26
    sourceSize.height: 26
  }
}
