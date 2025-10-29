import QtQuick

Canvas {
    id: root

    property var rings: []
    property real size: 60
    property color backgroundColor: "#333"
    property real ringWidth: 3
    property real ringSpacing: 1

    width: size
    height: size

    onPaint: {
        let ctx = getContext("2d")
        let centerX = width / 2
        let centerY = height / 2

        ctx.clearRect(0, 0, width, height)
        //ctx.lineCap = "round"

        let currentOffset = 0

        for (let i = 0; i < rings.length; i++) {
            let thickness = rings[i].thickness !== undefined ? rings[i].thickness : ringWidth
            let spacing = rings[i].spacing !== undefined ? rings[i].spacing : ringSpacing
            let radius = width / 2 - (thickness / 2) - currentOffset

            // background ring
            ctx.strokeStyle = backgroundColor
            ctx.lineWidth = thickness
            ctx.beginPath()
            ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI)
            ctx.stroke()

            // progress ring
            let progress = rings[i].value / 100
            if (progress > 0) {
                ctx.strokeStyle = rings[i].color
                ctx.lineWidth = thickness
                ctx.beginPath()
                ctx.arc(centerX, centerY, radius, -Math.PI / 2, -Math.PI / 2 + 2 * Math.PI * progress)
                ctx.stroke()
            }

            currentOffset += thickness + spacing
        }
    }

    onRingsChanged: requestPaint()
    onBackgroundColorChanged: requestPaint()
}
