import QtQuick

Item {
    id: root

    property color color: "white"
    property color holeColor: "black"

    implicitWidth: 28
    implicitHeight: 28

    Rectangle {
        width: 16
        height: 18
        radius: 8
        y: 1
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
        border.width: 3
        border.color: root.color
    }

    Rectangle {
        width: 24
        height: 16
        radius: 5
        y: 11
        anchors.horizontalCenter: parent.horizontalCenter
        color: root.color
    }

    Rectangle {
        width: 4
        height: 4
        radius: 2
        y: 16
        anchors.horizontalCenter: parent.horizontalCenter
        color: root.holeColor
    }
}
