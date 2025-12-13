import QtQuick
import RinUI

Dialog {
    property string content_id
    property string path
    property string subject
    property string bookName
    property bool available: path.toLowerCase().indexOf(".pdf") !== -1
    contentWidth: 560
    title: qsTr("Downloading %1 Textbook").arg(subject)
    standardButtons: available ? Dialog.Cancel | Dialog.Ok : Dialog.Cancel

    Text {
        text: available ? qsTr("Please check the information of the textbook you want to download.") : qsTr("No textbooks available.")
        font.pixelSize: 15
        wrapMode: Text.Wrap
        width: parent.width
    }

    Column {
        spacing: 3
        width: parent.width
        //padding: 5

        Text {
            text: qsTr("Book Name")
            font.pixelSize: 13
        }

        Text {
            text: bookName
            font.pixelSize: 15
            wrapMode: Text.Wrap
            elide: Text.ElideNone
            width: parent.width
        }

    }
    Column {
        spacing: 3
        width: parent.width
        //padding: 5

        Text {
            text: qsTr("Content ID")
            font.pixelSize: 13
        }

        Text {
            text: content_id
            font.pixelSize: 15
            wrapMode: Text.WrapAnywhere
            elide: Text.ElideNone
            width: parent.width
        }

    }
    Column {
        spacing: 3
        width: parent.width
        //padding: 5

        Text {
            text: qsTr("Path")
            font.pixelSize: 13
        }

        Text {
            text: available ? path : "N/A"
            wrapMode: Text.WrapAnywhere
            font.pixelSize: 15
            elide: Text.ElideNone
            width: parent.width
        }

    }

    onAccepted: {
        console.log("Dialog accepted:", content_id, path, subject, bookName)
        DownloadManager.addTask(bookName,
                                path,
                                HelperConfig.getHeader(),
                                HelperConfig.getDefaultPath()
                                )
    }
}
