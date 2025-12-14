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
        SettingExpander {
            Layout.fillWidth: true
            icon.name: "ic_fluent_virtual_network_20_regular"
            title: qsTr("Proxy")
            description: qsTr("Use a proxy for downloading textbooks. Linux users may not be able to use the \"System\" option.")

            content: ComboBox {
                property var data: ["no", "system", "custom"]
                property bool initialized: false
                model: ListModel {
                    ListElement { text: qsTr("Direct") }
                    ListElement { text: qsTr("System") }
                    ListElement { text: qsTr("Custom") }
                    //ListElement { text: qsTr("Oversea") }
                }

                Component.onCompleted: {
                    currentIndex = data.indexOf(HelperConfig.getProxyEnabled())
                    console.log("FileServer: " + HelperConfig.getProxyEnabled())
                    initialized = true
                }

                onCurrentIndexChanged: {
                    if (initialized) {
                        console.log("FileServer changed to: " + data[currentIndex])
                        HelperConfig.setProxyEnabled(data[currentIndex])
                    }
                }
            }
            SettingItem {
                ColumnLayout {
                    RowLayout {
                        id: proxyRow
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        ComboBox {
                            id: protocolBox
                            Layout.alignment: Qt.AlignVCenter
                            model: ListModel {
                                ListElement { text: "http" }
                                ListElement { text: "https" }
                                ListElement { text: "socks5" }
                            }
                        }
                        Text {
                            text: "://"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        TextField {
                            id: usernameField
                            Layout.alignment: Qt.AlignVCenter
                            placeholderText: qsTr("Username")
                            width: 100
                        }
                        Text {
                            text: ":"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        TextField {
                            id: passwordField
                            Layout.alignment: Qt.AlignVCenter
                            placeholderText: qsTr("Password")
                            echoMode: TextInput.Password
                            width: 120
                        }
                        Text {
                            text: "@"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        TextField {
                            id: ipField
                            Layout.alignment: Qt.AlignVCenter
                            placeholderText: qsTr("IP Address")
                            width: 120
                        }
                        Text {
                            text: ":"
                            Layout.alignment: Qt.AlignVCenter
                        }
                        SpinBox {
                            id: portField
                            Layout.alignment: Qt.AlignVCenter
                            from: 1
                            to: 65535
                            value: 8080
                            width: 80
                        }
                    }
                    RowLayout {
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            text: protocolBox.currentText + "://" + ((usernameField.text.length > 0 && passwordField.text.length > 0) ? usernameField.text + ":" + passwordField.text + "@" : "") + ((ipField.text.length > 0) ? ipField.text + ":" + portField.value.toString() : "")
                            font.pixelSize: 18
                        }
                        Button {
                            text: qsTr("Save")
                            highlighted: true
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            onClicked: {
                                HelperConfig.setProxy(
                                    ipField.text,
                                    portField.value.toString(),
                                    protocolBox.currentText,
                                    usernameField.text,
                                    passwordField.text
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}