import QtQuick
import QtQuick.Layouts
import RinUI
import QtQuick.Controls

import "../components"

FluentPage {
    id: root

    title: qsTr("Credential")

    InfoBar {
        id: instrucBar
        width: parent.width
        Layout.fillWidth: true
        title: qsTr("What's this?")
        text: qsTr("You can log in to SmartEdu so we can help you obtain the credentials, saving you the trouble of doing it manually.")
        closable: false
    }

    ColumnLayout {
        Layout.fillWidth: true
        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            Button {
                text: qsTr("Login with SmartEdu")
                onClicked: AuthManager.open_login()
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: qsTr("Save")
                highlighted: true
                onClicked: credentialInfo.save()
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }

        }
        CredentialInfo {
            id: credentialInfo
            Layout.fillWidth: true
            Layout.fillHeight: true

            cookie: AuthManager.get_tgc()
        }
    }
    Connections {
        target: AuthManager
        function onTgcCookie() {
            credentialInfo.cookie = AuthManager.get_tgc()
        }
    }
}
