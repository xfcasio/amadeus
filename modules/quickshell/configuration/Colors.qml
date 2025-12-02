pragma Singleton
import QtQuick

QtObject {
    readonly property color barBackground: "#000A0E"
    readonly property color barBorder: "#111A1F"
    
    readonly property color moduleBackground: "#111A1F"
    readonly property color moduleBackgroundHover: "#1178B892"
    readonly property color moduleBorder: "#171F24"
    readonly property color moduleBorderHover: "#7778B892"
    
    readonly property color cpuIndicator: "#DF5B61"
    readonly property color ramIndicator: "#78B892"
    readonly property color indicatorBackground: "#333B3F"
    
    readonly property color timeText: "#C488EC"

    // Player colors
    readonly property color playerBorderHover: "#77BC83E3"
    readonly property color playerGradientStart: "#171F24"
    readonly property color playerGradientEnd: "#66BC83E3"
    
    // Volume colors
    readonly property color volumeBorderHover: "#77BC83E3"
    readonly property color volumeBackgroundHover: "#11BC83E3"
    readonly property color volumeBarBackground: "#333B3F"
    readonly property color volumeGradientStart: "#6791C9"
    readonly property color volumeGradientEnd: "#BC83E3"
    
    // Weather colors
    readonly property color weatherBackground: "#111A1F"
    readonly property color weatherBackgroundHover: "#226791C9"
    readonly property color weatherBorderHover: "#776791C9"
    readonly property color weatherTemperature: "#E9967E"
    
    // Internet status colors
    readonly property color internetBackground: "#111A1F"
    
    // System tray colors
    readonly property color trayBackgroundHover: "#11A9A9A9"
    readonly property color trayBorderHover: "#77A9A9A9"
    
    // Workspace colors
    readonly property color workspaceBackgroundHover: "#227788AA"
    readonly property color workspaceBorderHover: "#777788AA"
    readonly property color workspaceActive: "#7788AA"
    readonly property color workspaceInactive: "#333B3F"

    // Power button colors
    readonly property color powerBackground: "#1D1A20"
    readonly property color powerBackgroundHover: "#28DF5B61"
    readonly property color powerBorder: "#171F24"
    readonly property color powerBorderHover: "#77DF5B61"
    
    // Battery colors
    readonly property color batteryBackground: "#041011"
    readonly property color batteryHealthy: "#78B892"
    readonly property color batteryMedium: "#ECD28B"
    readonly property color batteryLow: "#DF5B61"
    readonly property color batteryHealthyJuice: "#9978B892"
    readonly property color batteryMediumJuice: "#99ECD28B"
    readonly property color batteryLowJuice: "#99DF5B61"
    
    // Popout colors
    readonly property color popoutBackground: "#111A1F"
    readonly property color popoutBorder: "#171F24"
}
