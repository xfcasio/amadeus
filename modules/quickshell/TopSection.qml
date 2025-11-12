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
import qs.configuration

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
      width: 30
      height: 32
      radius: innerModulesRadius

      color: (hoverHandler.hovered) ? Colors.moduleBackgroundHover : Colors.moduleBackground

      HoverHandler { id: hoverHandler }
      Behavior on border.color {
        ColorAnimation { duration: 400 }
      }

      border.width: 1
      border.color: (hoverHandler.hovered) ? Colors.moduleBorderHover : Colors.moduleBorder

      ColumnLayout {
        anchors.centerIn: parent
        spacing: 2

        // radial indicator
        Components.MultiRingIndicator {
          size: 24
          backgroundColor: Colors.indicatorBackground
          rings: [
            { value: ramUsage, color: Colors.ramIndicator, thickness: 3, spacing: 1.2 },
            { value: cpuUsage, color: Colors.cpuIndicator, thickness: 3.4 },
          ]
        }
      }
    }

    Components.BarSystemTray {}
  }
}
