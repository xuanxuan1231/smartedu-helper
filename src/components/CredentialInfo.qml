import QtQuick
import QtQuick.Layouts
import RinUI

Frame {
    id: frame
    property alias cookie: tgcArea.text 
    function save(){
        HelperConfig.setCredential({
            "access_token": accessTokenArea.text,
            "refresh_token": refreshTokenArea.text,
            "expires_at": expirationArea.text,
            "mac_key": keyArea.text
        })
    }

    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    spacing: 4

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Column {
            id: tgcContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 20
            spacing: frame.spacing
            Text {
                text: qsTr("Ticket Granting Cookie (TGC)")
                font.bold: true
            }
            TextArea {
                id: tgcArea
                readOnly: true
                wrapMode: TextEdit.WrapAnywhere
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                width: parent.width
            }
        }

        ColumnLayout {
            id: accessTokenContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            Layout.topMargin: 8
            Layout.bottomMargin: 8
            spacing: frame.spacing
            Text {
                text: qsTr("Access Token")
                font.bold: true
            }
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: frame.spacing

                TextArea {
                    id: accessTokenArea
                    text: HelperConfig.getCredential().access_token
                    readOnly: true
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                Button {
                    id: retrieveButton
                    text: qsTr("Retrieve")
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    highlighted: true
                    onClicked: {
                        enabled = false
                        AuthManager.get_token(cookie)
                    }
                }
            }
        }
        ColumnLayout {
            id: refreshTokenContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            Layout.topMargin: 8
            Layout.bottomMargin: 8
            spacing: frame.spacing
            Text {
                text: qsTr("Refresh Token")
                font.bold: true
            }

            TextArea {
                id: refreshTokenArea
                text: HelperConfig.getCredential().refresh_token
                readOnly: true
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            
        }
        ColumnLayout {
            id: expirationContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            Layout.topMargin: 8
            Layout.bottomMargin: 8
            spacing: frame.spacing
            Text {
                text: qsTr("Expires At")
                font.bold: true
            }

            TextArea {
                id: expirationArea
                text: HelperConfig.getCredential().expires_at
                readOnly: true
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            
        }
        ColumnLayout {
            id: keyContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            Layout.topMargin: 8
            Layout.bottomMargin: 20
            spacing: frame.spacing
            Text {
                text: qsTr("Secret Key")
                font.bold: true
            }

            TextArea {
                id: keyArea
                text: HelperConfig.getCredential().mac_key
                readOnly: true
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            
        }
    }

    Connections {
        target: AuthManager
        function onTokenGot(result) {
            if (result.state === "error") {
                floatLayer.createInfoBar({title: qsTr("Unexpected response from server."), 
                                          text: result.message,
                                          severity: Severity.Error})
            }
            else {
                accessTokenArea.text = result.access_token
                refreshTokenArea.text = result.refresh_token
                expirationArea.text = result.expires_at
                keyArea.text = result.mac_key
                floatLayer.createInfoBar({title: qsTr("Tokens retrieved successfully."),
                                          severity: Severity.Success})
            }
        }
    }
}