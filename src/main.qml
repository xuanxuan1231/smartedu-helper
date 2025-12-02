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
        {
            title: qsTr("Download Textbooks"),
            icon: "ic_fluent_arrow_download_20_regular",
            page: Qt.resolvedUrl("pages/download.qml"),
        },
        {
            title: qsTr("Browser Extension"),
            icon: "ic_fluent_apps_add_in_20_regular",
            page: Qt.resolvedUrl("pages/browser_ext.qml"),
        },
        {
            title: qsTr("Settings"),
            icon: "ic_fluent_settings_20_regular",
            page: Qt.resolvedUrl("pages/settings.qml"),
        },
    ]

    navigationView.navigationBar.minimumExpandWidth: width + 1
    navigationView.navigationBar.collapsed: true
}