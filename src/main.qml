import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import RinUI

FluentWindow {
    id: root
    title: qsTr("Smartedu Helper")
    width: 900
    height: 600

    minimumWidth: 500
    minimumHeight: 400
    visible: true

    navigationItems: [
        /*{
            title: qsTr("Download Textbooks"),
            icon: "ic_fluent_arrow_download_20_regular",
            page: Qt.resolvedUrl("pages/download.qml"),
        },*/
        {
            title: qsTr("Credential"),
            icon: "ic_fluent_contact_card_20_regular",
            page: Qt.resolvedUrl("pages/credential.qml"),
        },
        {
            title: qsTr("Textbooks"),
            icon: "ic_fluent_book_20_regular",
            subItems: [
                {
                    title: qsTr("Primary School"),
                    page: Qt.resolvedUrl("pages/book/primary.qml"),
                },
                {
                    title: qsTr("Junior High School"),
                    page: Qt.resolvedUrl("pages/book/junior.qml"),
                },
                {
                    title: qsTr("Primary School (Five-year school system)"),
                    page: Qt.resolvedUrl("pages/book/primary54.qml"),
                },
                {
                    title: qsTr("Junior High School (Five-year school system)"),
                    page: Qt.resolvedUrl("pages/book/junior54.qml"),
                },
                {
                    title: qsTr("Senior High School"),
                    page: Qt.resolvedUrl("pages/book/senior.qml"),
                }
            ],
        },
        {
            title: qsTr("Downloads"),
            icon: "ic_fluent_task_list_square_ltr_20_regular",
            page: Qt.resolvedUrl("pages/downloads.qml"),
        },
        {
            title: qsTr("Settings"),
            icon: "ic_fluent_settings_20_regular",
            page: Qt.resolvedUrl("pages/settings.qml"),
        },
    ]

    navigationView.navigationBar.minimumExpandWidth: width + 1
    navigationView.navigationBar.collapsed: true

    Connections {
        target: DownloadManager
        function onTaskError(name, msg) {
            floatLayer.createInfoBar({
                severity: Severity.Error,
                title: qsTr("An error occurred while downloading %1").arg(name),
                text: msg,
                position: Position.TopRight,
                timeout: 5000
            })
        }
    }
}