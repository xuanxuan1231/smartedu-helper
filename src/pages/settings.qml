import QtQuick
import QtQuick.Layouts
import RinUI

FluentPage {
    title: qsTr("Settings")
    ColumnLayout {
        spacing: Theme.currentTheme.appearance.pageItemSpacing

        SettingCard {
            Layout.fillWidth: true
            //icon: "ic_fluent_translate_20_regular" // Fluent icon name for the left area
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
    }
}