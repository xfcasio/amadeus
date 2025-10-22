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
  width: 28
  height: 64
  radius: innerModulesRadius
  color: (hoverHandler.hovered) ? "#1178B892" : "#111A1F"

  HoverHandler { id: hoverHandler }

  border.width: 1
  border.color: (hoverHandler.hovered) ? "#7778B892" : "#171F24"

  Behavior on border.color {
    ColorAnimation { duration: 200 }
  }

  ColumnLayout {
    anchors.centerIn: parent
    spacing: 0

    // Battery Module
    QtObject {
      id: batteryModule
      property real batteryLevel: 100

      function getBatteryColor(percent, color_type) {
        if (percent === 100) return ((color_type == 'JUICE') ? "#9978B8a2" : "#78B8a2")
        if (percent >= 30) return ((color_type == 'JUICE') ? "#9978B892" : "#78B892")
        if (percent >= 15) return ((color_type == 'JUICE') ? "#99ECD28B" : "#ECD28B")
        return ((color_type == 'JUICE') ? "#99DF5B61" : "#DF5B61")
      }
    }

    Item {
      Layout.alignment: Qt.AlignHCenter
      Layout.topMargin: 2
      width: 28
      height: 34

      Process {
        id: batteryProcess
        running: true
        command: [ "cat", "/sys/class/power_supply/BAT1/capacity" ]
        stdout: SplitParser {
          onRead: percent => batteryModule.batteryLevel = percent
        }
      }

      Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: { batteryProcess.running = true }
      }

      Rectangle {
        anchors.centerIn: parent
        width: 16
        height: 28
        color: "transparent"

        ColumnLayout {
          anchors.centerIn: parent
          spacing: 0

          Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 8
            height: 1
            radius: 4
            color: batteryModule.getBatteryColor(batteryModule.batteryLevel, 'BORDER')
          }

          Rectangle {
            width: 14
            height: 24
            radius: 4
            color: "#041011"
            border.color: batteryModule.getBatteryColor(batteryModule.batteryLevel, 'BORDER')
            border.width: 2

            Rectangle {
              id: batteryFill
              anchors.bottom: parent.bottom
              anchors.horizontalCenter: parent.horizontalCenter
              anchors.bottomMargin: 3
              anchors.leftMargin: 2
              anchors.rightMargin: 2
              width: parent.width - 6
              height: Math.max(0, (parent.height - 6) * (batteryModule.batteryLevel / 100))
              radius: 2

              gradient: Gradient {
                GradientStop {
                  position: 0.0
                  color: batteryModule.getBatteryColor(batteryModule.batteryLevel, 'JUICE')
                }
                GradientStop {
                  position: 1.0
                  color: batteryModule.getBatteryColor(batteryModule.batteryLevel, 'JUICE')
                }
              }
            }
          }
        }
      }
    }

    // Internet Module
    QtObject {
      id: internetModule
      property bool internetConnected: false
    }

    Item {
      Layout.alignment: Qt.AlignHCenter
      width: 28
      height: 22

      Process {
        id: internetProcess
        running: true
        command: [ "ping", "-c1", "1.0.0.1" ]

        property string fullOutput: ""

        stdout: SplitParser {
          onRead: out => {
            internetProcess.fullOutput += out + "\n"
            if (out.includes("0% packet loss")) internetModule.internetConnected = true
          }
        }

        onExited: {
          internetModule.internetConnected = fullOutput.includes("0% packet loss")
          fullOutput = ""
        }
      }

      Timer {
        id: updateTimer
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
          internetProcess.running = true
        }
      }

      Image {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        width: 23
        height: 23
        source: `file:///home/${username}/.config/quickshell/svg/${internetModule.internetConnected ? 'connected' : 'disconnected'}.svg`
        sourceSize.width: 30
        sourceSize.height: 30
      }
    }
  }
}
