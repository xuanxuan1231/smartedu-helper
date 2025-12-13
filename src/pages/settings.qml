import QtQuick
import QtQuick.Layouts
import RinUI

FluentPage {
    title: qsTr("Settings")
    ColumnLayout {
        spacing: Theme.currentTheme.appearance.pageItemSpacing

        SettingCard {
            Layout.fillWidth: true
            icon.name: "ic_fluent_translate_20_regular"
            title: qsTr("Display Language")
            description: qsTr("Select your preferred language for Smartedu Helper.")

            ComboBox {
                property var data: [HelperConfig.getSystemLanguage(), "en_US", "zh_CN"]
                property bool initialized: false
                model: ListModel {
                    ListElement { text: qsTr("Use System Language") }
                    ListElement { text: "English (US)" }
                    ListElement { text: "简体中文" }
                }

                Component.onCompleted: {
                    currentIndex = data.indexOf(HelperConfig.getLanguage())
                    console.log("Language: " + HelperConfig.getLanguage())
                    initialized = true
                }

                onCurrentIndexChanged: {
                    if (initialized) {
                        console.log("Language changed to: " + data[currentIndex])
                        HelperConfig.setLanguage(data[currentIndex])
                    }
                }
            }
        }

        SettingExpander {
            Layout.fillWidth: true
            icon.name: "ic_fluent_arrow_download_20_regular"
            title: qsTr("File Server")
            description: qsTr("Select a download server.")

            content: ComboBox {
                property var data: ["1", "2", "3"/*, "oversea"*/]
                property bool initialized: false
                model: ListModel {
                    ListElement { text: "1" }
                    ListElement { text: "2" }
                    ListElement { text: "3" }
                    //ListElement { text: qsTr("Oversea") }
                }

                Component.onCompleted: {
                    currentIndex = data.indexOf(HelperConfig.getFileServer())
                    console.log("FileServer: " + HelperConfig.getFileServer())
                    initialized = true
                }

                onCurrentIndexChanged: {
                    if (initialized) {
                        console.log("FileServer changed to: " + data[currentIndex])
                        HelperConfig.setFileServer(data[currentIndex])
                    }
                }
            }
            SettingItem {
                title: qsTr("Use Oversea Server")
                description: qsTr("Download textbooks from oversea server. No need to parse header. Users in China cannot access this server.")
                Switch {
                    checked: HelperConfig.getOverseaServer()
                    onCheckedChanged: {
                        HelperConfig.setOverseaServer(checked)
                    }
                }
            }
        }
    }
}