import QtQuick
import RinUI

Dialog {
    property string content_id
    property string number
    property string subject
    property string bookName

    title: qsTr("Downloading %1 Textbook").arg(subject)
    standardButtons: Dialog.Ok | Dialog.Cancel

    Text {
        text: qsTr("Please check the information of the textbook you want to download.")
        font.pixelSize: 15
    }

    Column {
        spacing: 3
        //padding: 5

        Text {
            text: qsTr("Book Name")
            font.pixelSize: 13
        }

        Text {
            text: bookName
            font.pixelSize: 15
            wrapMode: Text.Wrap
        }

    }
    Column {
        spacing: 3
        //padding: 5

        Text {
            text: qsTr("Content ID")
            font.pixelSize: 13
        }

        Text {
            text: content_id
            font.pixelSize: 15
        }

    }
    Column {
        spacing: 3
        //padding: 5

        Text {
            text: qsTr("Number")
            font.pixelSize: 13
        }

        Text {
            text: number
            font.pixelSize: 15
        }

    }

}
