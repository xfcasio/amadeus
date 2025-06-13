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
  width: 24
  height: 24
  radius: innerModulesRadius
  color: "#111A1F"
  
  property bool internetConnected: false

  Process {
    id: internetProcess
    running: true
    command: [ "ping", "-c1", "1.0.0.1" ]

    property string fullOutput: ""

    stdout: SplitParser {
      onRead: out => {
        internetProcess.fullOutput += out + "\n"
        if (out.includes("0% packet loss")) internetConnected = true
      }
    }

    onExited: {
      internetConnected = fullOutput.includes("0% packet loss")
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
    anchors.centerIn: parent
    width: 20
    height: 20
    source: `file:///home/${username}/.config/quickshell/svg/${internetConnected ? 'connected' : 'disconnected'}.svg`
  }
}
