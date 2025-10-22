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
import 'components' as Components

Rectangle {
  Layout.fillWidth: true
  Layout.preferredHeight: columnLayout.implicitHeight + 12
  color: "transparent"

  property real innerModulesRadius: 3

  // System info properties
  property real cpuUsage: 0.3
  property real ramUsage: 0.6

  Behavior on Layout.preferredHeight {
    NumberAnimation {
      duration: 1000
      easing.type: Easing.InOutQuart
    }
  }

  property string username: ""

  Process {
    command: ["whoami"]
    running: true
    stdout: SplitParser { onRead: name => username = name }
  }

  // CPU monitoring
  Process {
    id: cpuProcess
    command: ["sh", "-c", "top -bn1 | grep '%Cpu(s):' | awk '{print $2}' | sed 's/%us,//'"]
    running: true

    stdout: SplitParser {
      onRead: data => {
        let usage = parseFloat(data.trim())
        if (!isNaN(usage)) cpuUsage = Math.round(usage)
      }
    }
  }

  // RAM monitoring  
  Process {
    id: ramProcess
    command: ["sh", "-c", "free | grep Mem: | awk '{printf \"%.0f\", ($2-$7)/$2*100}'"]
  running: true

    stdout: SplitParser {
      onRead: data => {
        let usage = parseInt(data.trim())
        if (!isNaN(usage)) ramUsage = usage
      }
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: {
      cpuProcess.running = true
      ramProcess.running = true
    }
  }


  ColumnLayout {
    id: columnLayout
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 2
    spacing: 6

    Components.BarProfilePicture {}
    Components.BarVolumeControl {}
    Components.BarWeatherStatus {}

    // CPU and RAM indicators
    Rectangle {
      Layout.alignment: Qt.AlignHCenter
      width: 28
      height: 60
      radius: innerModulesRadius

      color: (hoverHandler.hovered) ? "#1178B892" : "#111A1F"

      HoverHandler { id: hoverHandler }
      Behavior on border.color {
        ColorAnimation { duration: 200 }
      }

      border.width: 1
      border.color: (hoverHandler.hovered) ? "#7778B892" : "#171F24"

      ColumnLayout {
        anchors.centerIn: parent
        spacing: 2

        // CPU indicator
        Components.RadialIndicator {
          Layout.alignment: Qt.AlignHCenter
          percent: cpuUsage
          indicatorColor: "#DF5B61"
          backgroundColor: "#333B3F"
          size: 24
        }

        // RAM indicator
        Components.RadialIndicator {
          Layout.alignment: Qt.AlignHCenter
          percent: ramUsage
          indicatorColor: "#78B892"
          backgroundColor: "#333B3F"
          size: 24
        }
      }
    }

    Components.BarSystemTray {}
  }
}
