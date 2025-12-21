import QtQuick
import QtQuick.Layouts
import QtWebView
import RinUI

import "../components"

FluentPage {
    property url smartEduUrl: "https://auth.smartedu.cn/uias"

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
                onClicked: loginDialog.open()
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
    Dialog {
        id: loginDialog

        modal: true
        title: qsTr("SmartEdu Login")
        contentWidth: 1024
        contentHeight: 720
        standardButtons: Dialog.Close

        WebView {
            id: webView
            Layout.fillWidth: true
            Layout.fillHeight: true
            // Delay loading until the dialog opens to avoid unnecessary webview work
            url: ""
            onUrlChanged: {
                if (webView.url.startswith("https://www.smartedu.cn")) {
                    close()
                }
            }
        }

        onOpened: webView.url = smartEduUrl
        onClosed: webView.url = ""

        

    }
    Connections {
        target: AuthManager
        function onTgcCookie() {
            credentialInfo.cookie = AuthManager.get_tgc()
            loginDialog.close()
        }
    }
}
