import QtQuick
import QtQuick.Layouts

FocusScope {
    id: root

    required property var flow

    readonly property string message: flow ? flow.message : ""
    readonly property string actionId: flow ? flow.actionId : ""
    readonly property string inputPrompt: flow ? flow.inputPrompt : ""
    readonly property string supplementary: flow ? flow.supplementaryMessage : ""
    readonly property bool supplementaryIsError: flow ? flow.supplementaryIsError : false
    readonly property bool responseRequired: flow ? flow.isResponseRequired : false
    readonly property bool failed: flow ? flow.failed : false
    readonly property bool responseVisible: flow ? flow.responseVisible : false

    readonly property bool busy: flow ? (!flow.isResponseRequired && !flow.isCompleted) : false

    property bool detailsOpen: false

    readonly property string fieldLabel: {
        const p = inputPrompt.replace(/[:：]\s*$/, "").trim();
        return p.length > 0 ? p : "Password";
    }

    readonly property string helperText: {
        if (supplementary.length > 0) return supplementary;
        if (failed) return "Authentication failed. Try again.";
        return "";
    }
    readonly property bool helperIsError: supplementary.length > 0 ? supplementaryIsError : failed

    function submit() {
        if (!responseRequired || field.text.length === 0) return;
        flow.submit(field.text);
        field.text = "";
    }

    function cancel() {
        if (flow) flow.cancelAuthenticationRequest();
    }

    Keys.onEscapePressed: root.cancel()

    Connections {
        target: root.flow
        function onAuthenticationFailed() {
            shakeAnim.restart();
            field.forceActiveFocus();
        }
    }

    Rectangle {
        id: scrim
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.42)
        opacity: 0

        Behavior on opacity {
            NumberAnimation { duration: 250 }
        }
        Component.onCompleted: opacity = 1


        MouseArea {
            anchors.fill: parent
        }
    }

    Rectangle {
        id: card

        anchors.centerIn: parent
        width: Math.min(parent.width - 48, 400)
        height: content.implicitHeight + 48
        radius: 28 
        color: Colors.surfaceContainerHigh

        transformOrigin: Item.Center
        scale: 0.88
        opacity: 0

        transform: Translate {
            id: shake
            x: 0
        }

        Behavior on scale {
            NumberAnimation {
                duration: 400
                easing.type: Easing.BezierSpline
                easing.bezierCurve: [0.05, 0.7, 0.1, 1.0, 1.0, 1.0]
            }
        }
        Behavior on opacity {
            NumberAnimation { duration: 180 }
        }

        Component.onCompleted: {
            scale = 1;
            opacity = 1;
            field.forceActiveFocus();
        }

        SequentialAnimation {
            id: shakeAnim
            NumberAnimation { target: shake; property: "x"; to: -12; duration: 50 }
            NumberAnimation { target: shake; property: "x"; to: 12; duration: 70 }
            NumberAnimation { target: shake; property: "x"; to: -8; duration: 60 }
            NumberAnimation { target: shake; property: "x"; to: 6; duration: 50 }
            NumberAnimation { target: shake; property: "x"; to: 0; duration: 40 }
        }

        ColumnLayout {
            id: content
            spacing: 0
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 24
            }

            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: 64
                implicitHeight: 64
                radius: 32
                color: Colors.secondaryContainer

                LockGlyph {
                    anchors.centerIn: parent
                    color: Colors.fgOnSecondaryContainer
                    holeColor: Colors.secondaryContainer
                }
            }

            Text {
                Layout.fillWidth: true
                Layout.topMargin: 16
                horizontalAlignment: Text.AlignHCenter
                text: "Authentication required"
                color: Colors.fgOnSurface
                font.family: Colors.fontFamily
                font.pixelSize: 24
                wrapMode: Text.WordWrap
            }

            Text {
                Layout.fillWidth: true
                Layout.topMargin: 8
                horizontalAlignment: Text.AlignHCenter
                text: root.message
                visible: text.length > 0
                color: Colors.fgOnSurfaceVariant
                font.family: Colors.fontFamily
                font.pixelSize: 14
                lineHeight: 1.25
                wrapMode: Text.Wrap
            }

            MTextField {
                id: field
                Layout.fillWidth: true
                Layout.topMargin: 24
                label: root.fieldLabel
                password: !root.responseVisible
                error: root.helperIsError
                enabled: root.responseRequired
                onAccepted: root.submit()
            }

            Text {
                Layout.fillWidth: true
                Layout.topMargin: 6
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                visible: text.length > 0
                text: root.helperText
                color: root.helperIsError ? Colors.error : Colors.fgOnSurfaceVariant
                font.family: Colors.fontFamily
                font.pixelSize: 12
                wrapMode: Text.Wrap
            }

            Text {
                Layout.topMargin: 12
                Layout.leftMargin: 20
                text: root.detailsOpen ? "Hide details" : "Show details"
                color: Colors.primary
                font.family: Colors.fontFamily
                font.pixelSize: 14
                font.weight: Font.Medium

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -8
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.detailsOpen = !root.detailsOpen
                }
            }

            Item {
                id: detailsClip
                Layout.fillWidth: true
                Layout.topMargin: root.detailsOpen ? 8 : 0
                clip: true

                property real shownHeight: root.detailsOpen ? detailsBox.implicitHeight : 0
                Behavior on shownHeight {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: [0.05, 0.7, 0.1, 1.0, 1.0, 1.0]
                    }
                }
                Layout.preferredHeight: shownHeight

                Rectangle {
                    id: detailsBox
                    width: parent.width
                    implicitHeight: detailsText.implicitHeight + 24
                    radius: 16
                    color: Colors.surfaceContainer

                    Text {
                        id: detailsText
                        anchors {
                            left: parent.left
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            margins: 16
                        }
                        text: "Action: " + root.actionId
                        color: Colors.fgOnSurfaceVariant
                        font.family: "monospace"
                        font.pixelSize: 12
                        wrapMode: Text.WrapAnywhere
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 24
                spacing: 8

                Item { Layout.fillWidth: true }

                MButton {
                    text: "Cancel"
                    onClicked: root.cancel()
                }

                MButton {
                    text: root.busy ? "Checking…" : "Authenticate"
                    filled: true
                    enabled: root.responseRequired && field.text.length > 0
                    onClicked: root.submit()
                }
            }
        }
    }
}
