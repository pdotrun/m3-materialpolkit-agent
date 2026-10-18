import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Polkit

ShellRoot {

    PolkitAgent {
        id: agent
    }

    LazyLoader {
        active: agent.isActive

        PanelWindow {

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore

            WlrLayershell.namespace: "materialpolkit"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            AuthDialog {
                anchors.fill: parent
                flow: agent.flow
            }
        }
    }
}
