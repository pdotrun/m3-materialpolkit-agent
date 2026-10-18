import QtQuick

FocusScope {
    id: root

    property string label: "Password"
    property alias text: input.text
    property bool password: true
    property bool revealed: false
    property bool error: false

    signal accepted()

    implicitHeight: 56
    implicitWidth: 300
    opacity: enabled ? 1 : 0.6
    Behavior on opacity { NumberAnimation { duration: 150 } }

    readonly property bool floating: input.activeFocus || input.text.length > 0

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: Colors.surfaceContainerHighest
        border.width: (input.activeFocus || root.error) ? 2 : 0
        border.color: root.error ? Colors.error : Colors.primary

        Behavior on border.width { NumberAnimation { duration: 120 } }
    }

    Text {
        id: lbl
        x: 20
        y: root.floating ? 9 : (root.height - height) / 2
        text: root.label
        font.family: Colors.fontFamily
        font.pixelSize: root.floating ? 12 : 16
        color: root.error ? Colors.error
             : input.activeFocus ? Colors.primary
             : Colors.fgOnSurfaceVariant

        Behavior on y {
            NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
        }
        Behavior on font.pixelSize {
            NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
        }
    }

    TextInput {
        id: input
        anchors {
            left: parent.left
            right: reveal.visible ? reveal.left : parent.right
            bottom: parent.bottom
            leftMargin: 20
            rightMargin: 12
            bottomMargin: 10
        }
        focus: true
        clip: true
        selectByMouse: true
        echoMode: (root.password && !root.revealed) ? TextInput.Password : TextInput.Normal
        passwordCharacter: "•"
        inputMethodHints: Qt.ImhSensitiveData | Qt.ImhNoPredictiveText
        color: Colors.fgOnSurface
        selectionColor: Colors.primary
        selectedTextColor: Colors.fgOnPrimary
        font.family: Colors.fontFamily
        font.pixelSize: 16
        onAccepted: root.accepted()

        cursorDelegate: Rectangle {
            width: 2
            color: Colors.primary
        }
    }

    Text {
        id: reveal
        visible: root.password
        anchors {
            right: parent.right
            rightMargin: 20
            verticalCenter: parent.verticalCenter
        }
        text: root.revealed ? "Hide" : "Show"
        color: Colors.fgOnSurfaceVariant
        font.family: Colors.fontFamily
        font.pixelSize: 13
        font.weight: Font.Medium

        MouseArea {
            anchors.fill: parent
            anchors.margins: -8
            cursorShape: Qt.PointingHandCursor
            onClicked: root.revealed = !root.revealed
        }
    }
}
