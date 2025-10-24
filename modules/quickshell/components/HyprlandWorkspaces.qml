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

Rectangle {
  Layout.alignment: Qt.AlignHCenter
  anchors.horizontalCenter: parent.horizontalCenter
  implicitHeight: childrenRect.height + 28
  width: 24
  radius: 2
  color: (hoverHandler.hovered) ? "#11C0837F" : "#111A1F"

  HoverHandler { id: hoverHandler }

  border.width: 1
  border.color: (hoverHandler.hovered) ? "#77C0837F" : "#171F24"

  Behavior on border.color {
    ColorAnimation { duration: 400 }
  }

  ColumnLayout {
    anchors.centerIn: parent
    spacing: 3

    ColumnLayout {
      spacing: -3

      Repeater {
        model: Hyprland.workspaces

        Item {
          required property var modelData
          property bool hovered: false

          width: 12
          Layout.preferredHeight: modelData.active ? 40 : 15
          Layout.alignment: Qt.AlignHCenter

          Shape {
            anchors.centerIn: parent
            width: 8
            height: parent.height
            antialiasing: true
            smooth: true
            layer.enabled: true
            layer.samples: 8

            ShapePath {
              fillColor: (modelData.active || parent.hovered) ? "#C0837F" : "#333B3F"
              strokeColor: "transparent"
              strokeWidth: 0

              startX: 0   // top-left
              startY: 6   // offset down

              PathLine { x: 8; y: 0 }         // top-right (up and right)
              PathLine { x: 8; y: height - 6 } // bottom-right (straight down, offset up)
              PathLine { x: 0; y: height }    // bottom-left (down and left)
              PathLine { x: 0; y: 6 }         // back to start (straight up)
            }
          }

//          Behavior on Layout.preferredHeight {
//            NumberAnimation {
//              duration: 160
//              easing.type: Easing.InOutQuart
//            }
//          }

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
