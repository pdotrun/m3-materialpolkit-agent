import QtQuick

Item {
    id: root

    property string text
    property bool filled: false

    signal clicked()

    implicitHeight: 40
    implicitWidth: label.implicitWidth + 48

    scale: mouse.pressed ? 0.96 : 1
    Behavior on scale { NumberAnimation { duration: 100 } }

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: !root.filled ? "transparent"
             : root.enabled ? Colors.primary
             : Qt.alpha(Colors.fgOnSurface, 0.12)
        Behavior on color { ColorAnimation { duration: 150 } }
    }

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: root.filled ? Colors.fgOnPrimary : Colors.primary
        opacity: !root.enabled ? 0 : mouse.pressed ? 0.10 : mouse.containsMouse ? 0.08 : 0
        Behavior on opacity { NumberAnimation { duration: 120 } }
    }

    Text {
        id: label
        anchors.centerIn: parent
        text: root.text
        font.family: Colors.fontFamily
        font.pixelSize: 14
        font.weight: Font.Medium
        color: !root.enabled ? Qt.alpha(Colors.fgOnSurface, 0.38)
             : root.filled ? Colors.fgOnPrimary
             : Colors.primary
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
