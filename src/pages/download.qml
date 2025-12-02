import QtQuick
import QtQuick.Layouts
import RinUI

import "../components"

FluentPage {
    title: qsTr("Download Textbooks")

    ColumnLayout{
        Row {
            Layout.fillWidth: true
            TextField {
                id: urlInput
                placeholderText: qsTr("Enter PDF viewer URL")
                width: 400
            }
            Button {
                highlighted: true
                text: qsTr("Resolve Link")
                onClicked: LinkParser.parseLink(urlInput.text)
            }
        }
        InfoBar {
            id: infoBar
            width: parent.width
            Layout.fillWidth: true
            title: qsTr("How to get the viewer URL?")
            text: qsTr("Locate the request address for viewer.html in the \"Network\" tab of your browser's \"Developer Tools\". Alternatively, you can use our browser extension (Still working in progress).")
            closable: false
        }
        
        LinkInfo {
            id: linkInfo
            Layout.fillWidth: true

            link: qsTr("Input URL first...")
            header: qsTr("Input URL first...")
        }
    
        CommandCase {
            id: commandCase
            padding: 48
            Layout.fillWidth: true

            showcase: [
                Column {
                    Text{
                        text: qsTr("Download with...")
                    }
                    ComboBox {
                        model: ["curl", "wget"]
                    }
                }
            ]
        }
    }
    Connections {
        target: LinkParser
        function onLinkParsed(result) {
            console.log("Link parsed:", result)
            if(result.error) {
                floatLayer.createInfoBar({
                                severity: Severity.Error,
                                title: qsTr("Something went wrong."),
                                text: result.error
                            })
                return
            }
            floatLayer.createInfoBar({
                            severity: Severity.Success,
                            title: qsTr("Parsed successfully."),
                        })
            linkInfo.link = result.link
            linkInfo.header = result.header
        }
    }
    
}