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

Rectangle {
  Layout.alignment: Qt.AlignHCenter
  Layout.topMargin: 4
  height: 28
  width: 28
  radius: innerModulesRadius
  color: hoverHandler.hovered ? "#28DF5B61" : "#1D1A20"

  border.width: 1
  border.color: hoverHandler.hovered ? "#44DF5B61" : "#171F24"

  HoverHandler { id: hoverHandler }

  Behavior on border.color {
    ColorAnimation { duration: 200 }
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
