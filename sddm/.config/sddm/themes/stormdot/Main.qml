// ┌─────────────────────────────────────────────────────────────┐
// │  Stormdot SDDM Theme · Main.qml                             │
// │  Minimalista: fondo Nord + reloj + campo password           │
// └─────────────────────────────────────────────────────────────┘

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#2e3440"   // nord0 (Polar Night)

    // ── Reloj centrado en la parte superior ──────────────────
    Text {
        id: clock
        anchors.top: parent.top
        anchors.topMargin: 80
        anchors.horizontalCenter: parent.horizontalCenter

        text: Qt.formatTime(timeSource.currentTime, "HH:mm")
        color: "#eceff4"     // nord6
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 96
        font.weight: Font.Bold
    }

    Text {
        id: date
        anchors.top: clock.bottom
        anchors.topMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter

        text: Qt.formatDate(timeSource.currentTime, "dddd, d MMMM yyyy")
        color: "#d8dee9"     // nord4
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 18
    }

    // Timer para actualizar el reloj
    QtObject {
        id: timeSource
        property date currentTime: new Date()
        function update() { currentTime = new Date() }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: timeSource.update()
    }

    // ── Zona central: usuario + password ─────────────────────
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        // Nombre de usuario (seleccionado automáticamente)
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: userModel.lastUser || "user"
            color: "#88c0d0"     // nord8 (frost cyan)
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 20
            font.weight: Font.DemiBold
        }

        // Campo password
        Rectangle {
            Layout.preferredWidth: 360
            Layout.preferredHeight: 54
            color: "#3b4252"     // nord1
            border.color: "#88c0d0"
            border.width: 2
            radius: 12

            TextField {
                id: passwordField
                anchors.fill: parent
                anchors.margins: 2

                placeholderText: "Password"
                placeholderTextColor: "#616e88"
                color: "#eceff4"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 16
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter

                echoMode: TextInput.Password
                focus: true

                background: Rectangle { color: "transparent" }

                Keys.onReturnPressed:  sddm.login(userModel.lastUser, text, sessionModel.lastIndex)
                Keys.onEnterPressed:   sddm.login(userModel.lastUser, text, sessionModel.lastIndex)
            }
        }

        // Mensaje de error
        Text {
            id: errorMsg
            Layout.alignment: Qt.AlignHCenter
            text: ""
            color: "#bf616a"     // nord11 (rojo)
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 14
            opacity: 0
            Behavior on opacity { NumberAnimation { duration: 200 } }
        }
    }

    // ── Info de sesión y botones de power (esquina inferior) ──
    RowLayout {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 30
        spacing: 20

        Text {
            text: "" + Qt.formatTime(timeSource.currentTime, "HH:mm")
            color: "#4c566a"     // nord3
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 12
        }
    }

    // ── Conexión con SDDM ────────────────────────────────────
    Connections {
        target: sddm
        function onLoginFailed() {
            errorMsg.text = "Password incorrecto"
            errorMsg.opacity = 1
            passwordField.text = ""
            passwordField.focus = true
        }
        function onLoginSucceeded() {
            errorMsg.text = ""
            errorMsg.opacity = 0
        }
    }
}
