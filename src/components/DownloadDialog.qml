import QtQuick
import RinUI

Dialog {
    property string content_id
    property string path
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
            text: qsTr("Path")
            font.pixelSize: 13
        }

        Text {
            text: path
            wrapMode: Text.Wrap
            font.pixelSize: 15
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
