import QtQuick
import QtQuick.Layouts
import RinUI

import "../components"

FluentPage {
    id: downloadsPage
    title: qsTr("Downloads")

    ColumnLayout {
        Repeater {
            id: repeater
            Layout.fillWidth: true
            model: DownloadManager.getTasks()
            delegate: DownloadItem {
                Layout.fillWidth: true
                name: modelData.name
                url: modelData.url
                status: modelData.status
                progress: modelData.progress !== undefined ? modelData.progress : 0
            }
        }
    }

    Connections {
        target: DownloadManager
        function onDataUpdated() {
            repeater.model = DownloadManager.getTasks()
        }
    }
}