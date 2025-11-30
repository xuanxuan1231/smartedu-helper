import QtQuick
import QtQuick.Layouts
import RinUI

FluentPage {
    title: qsTr("Download Textbooks")

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
    Row {
        Row {

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
            }
        }
    }
    
}