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
  id: playerModule
  Layout.alignment: Qt.AlignHCenter
  implicitHeight: playing ? 120 : 28
  layer.enabled: true
  width: 28
  radius: innerModulesRadius
  color: Colors.moduleBackground

  HoverHandler { id: hoverHandler }

  border.width: 1
  border.color: (hoverHandler.hovered && !playing) ? Colors.playerBorderHover : Colors.moduleBackground

  Behavior on border.color {
    ColorAnimation { duration: 200 }
  }

  property bool playing: false
  property string artUrl: ''

  Process { id: playerPrev; running: false; command: [ "playerctl", "previous" ] }
  Process { id: playerPlayPause; running: false; command: [ "playerctl", "play-pause" ] }
  Process { id: playerNext; running: false; command: [ "playerctl", "next" ] }

  Process {
    id: statusUpdater
    running: true
    command: [ "playerctl", "status" ]
    stdout: SplitParser {
      onRead: s => {
        if (s === "Playing") {
          playing = true;
          if (artUrl === '') { artUrl = `file:///home/${username}/.config/quickshell/svg/player-background.png` }
        } else playing = false
      }
    }

    stderr: SplitParser {
      onRead: err => {
        if (err === "No player could handle this command") {
          artUrl = `file:///home/${username}/.config/quickshell/svg/player-background.png`
          playing = false
        }
      }
    }
  }

  Process {
    id: artUrlUpdater
    running: true
    command: [ "playerctl", "metadata", "mpris:artUrl" ]
    stdout: SplitParser {
      onRead: art => {
        if (art && art.trim() !== "") { artUrl = art.trim() }
        else { artUrl = `file:///home/${username}/.config/quickshell/svg/player-background.png` }
      }
    }

    stderr: SplitParser {
      onRead: err => {
        if (err === "No player could handle this command") {
          artUrl = `file:///home/${username}/.config/quickshell/svg/player-background.png`
          playing = false
        }
      }
    }
  }

  Timer {
    interval: 600
    running: true
    repeat: true
    onTriggered: { artUrlUpdater.running = true }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: { statusUpdater.running = true }
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

    onWheel: () => {}

    onClicked: (mouse) => {
      if (mouse.button === Qt.LeftButton) { playerPrev.running = true; }
      else if (mouse.button === Qt.RightButton) { playerNext.running = true; }
      else if (mouse.button === Qt.MiddleButton) { playerPlayPause.running = true; }
    }
  }

  Behavior on implicitHeight {
    NumberAnimation {
      duration: 1000
      easing.type: Easing.InOutQuart
    }
  }

  Rectangle {
    id: gradientBorder
    anchors.fill: parent
    radius: parent.radius
    visible: playing
    opacity: hoverHandler.hovered ? 1 : 0

    Behavior on opacity {
      NumberAnimation {
        duration: 300
      }
    }

    gradient: Gradient {
      GradientStop { position: 0.6; color: Colors.playerGradientStart }
      GradientStop { position: 1.0; color: Colors.playerGradientEnd }
    }

    Rectangle {
      anchors.fill: parent
      anchors.margins: 1
      radius: parent.radius
      color: "#171F24"
    }
  }

  Rectangle {
    id: topHalf
    visible: height > 5
    anchors.top: parent.top
    anchors.topMargin: 1
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 24
    anchors.left: parent.left
    anchors.leftMargin: 1
    anchors.right: parent.right
    anchors.rightMargin: 1
    height: playing ? 96 : 0
    clip: true

    Behavior on height {
      NumberAnimation {
        duration: 1000
        easing.type: Easing.InOutQuart
      }
    }

    Image {
      anchors.fill: parent
      source: artUrl
      fillMode: Image.PreserveAspectCrop
      horizontalAlignment: Image.AlignHCenter
      verticalAlignment: Image.AlignVCenter
      cache: false

      Rectangle {
        anchors.fill: parent
        gradient: Gradient {
          GradientStop { position: 0.3; color: "#00000000" }
          GradientStop { position: 0.95; color: (hoverHandler.hovered) ? "#111A1F" : "#131B1F" }
        }
      }
    }

    layer.enabled: true
    layer.effect: OpacityMask {
      maskSource: Rectangle {
        width: topHalf.width
        height: topHalf.height
        radius: topHalf.height > playerModule.radius ? playerModule.radius : 0
      }
    }
  }

  Rectangle {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 1
    height: 26
    width: 26
    radius: playerModule.radius
    color: (hoverHandler.hovered && !playing) ? "#02BC83E3" : "#111A1F"

    Image {
      anchors.centerIn: parent
      width: 18
      height: 18
      source: `file:///home/${username}/.config/quickshell/svg/headphones.svg`
      sourceSize.width: 36
      sourceSize.height: 36
    }
  }
}
