import QtQuick
import QtQuick.Layouts
import RinUI

import "../../components"

FluentPage {
    title: qsTr("Primary School Textbooks")
    // 其实是通用的 其他的可以照搬

    // Avoid null deref during shutdown when context properties disappear
    property bool hasBookList: typeof PrimaryBookList !== "undefined" && PrimaryBookList !== null
    // Local caches to avoid implicit global writes
    property var versions: []
    property var grades: []
    property var books: []
    // Currently selected book item
    property var selectedBook: bookList.model && bookList.currentIndex >= 0 ? bookList.model[bookList.currentIndex] : null

    function updateBookList() {
        if (!hasBookList || subjectCombo.currentIndex < 0 || versionCombo.currentIndex < 0 || gradeCombo.currentIndex < 0) {
            bookList.model = []
            return
        }

        bookList.model = PrimaryBookList.get_books(subjectCombo.currentIndex, versionCombo.currentIndex, gradeCombo.currentIndex)
    }

    RowLayout {
        Layout.fillHeight: true
        Layout.fillWidth: true

        GridLayout {
            columns: 2
            rows: 3
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true

            Text {
                text: qsTr("Subject")
            }

            ComboBox {
                id: subjectCombo

                Layout.preferredWidth: 200
                Layout.maximumWidth: 200
                model: hasBookList ? PrimaryBookList.get_subjects() : []
                onCurrentIndexChanged: {
                    if (!hasBookList) {
                        versionCombo.model = []
                        gradeCombo.model = []
                        updateBookList();
                        return
                    }
                    versions = PrimaryBookList.get_versions(currentIndex);
                    versionCombo.model = versions;
                    if (versions && versions.length > 0) {
                        // 强制 currentIndex 变化以确保触发刷新
                        versionCombo.currentIndex = -1;
                        versionCombo.currentIndex = 0;
                    } else {
                        versionCombo.currentIndex = -1;
                        gradeCombo.model = [];
                        updateBookList();
                    }
                    updateBookList();
                }
            }

            Text {
                text: qsTr("Version")
            }

            ComboBox {
                id: versionCombo

                Layout.preferredWidth: 200
                Layout.maximumWidth: 200
                model: hasBookList ? PrimaryBookList.get_versions(subjectCombo.currentIndex) : []
                onCurrentIndexChanged: {
                    if (!hasBookList) {
                        gradeCombo.model = []
                        updateBookList();
                        return
                    }
                    grades = PrimaryBookList.get_grades(subjectCombo.currentIndex, currentIndex);
                    gradeCombo.model = grades;
                    if (grades && grades.length > 0) {
                        gradeCombo.currentIndex = -1; // force signal
                        gradeCombo.currentIndex = 0;
                    } else {
                        gradeCombo.currentIndex = -1;
                    }
                    updateBookList();
                }
            }

            Text {
                text: qsTr("Grade")
            }

            ComboBox {
                id: gradeCombo

                Layout.preferredWidth: 200
                Layout.maximumWidth: 200
                model: hasBookList ? PrimaryBookList.get_grades(subjectCombo.currentIndex, versionCombo.currentIndex) : []
                onCurrentIndexChanged: {
                    if (!hasBookList) {
                        updateBookList();
                        return
                    }
                    updateBookList();
                }
            }}

            ListView {
                id: bookList

                width: 200
                height: 400
                Layout.fillWidth: true
                Layout.fillHeight: true

                model: hasBookList ? PrimaryBookList.get_books(subjectCombo.currentIndex, versionCombo.currentIndex, gradeCombo.currentIndex) : []

                delegate: ListViewDelegate {
                    middleArea: [
                        // middleArea takes a list of items for its ColumnLayout
                        Text {
                            text: modelData.name
                            
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                            font.pixelSize: 16
                        },
                        Text {
                            text: modelData.path // Secondary text from model
                            font.pixelSize: 12
                            color: Theme.currentTheme.colors.textSecondaryColor
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    ]

                    leftArea: IconWidget {
                        icon: "ic_fluent_book_information_20_regular"
                        size: 22
                        Layout.alignment: Qt.AlignVCenter
                    }

                    rightArea: ToolButton {
                        icon.name: "ic_fluent_arrow_download_20_regular"
                        flat: true
                        size: 16
                        Layout.alignment: Qt.AlignVCenter
                        onClicked: {
                            bookList.currentIndex = index;
                            downloadDialog.open();
                        }
                    }

                }

            }

        }
        DownloadDialog {
            id: downloadDialog

            content_id: selectedBook ? selectedBook.content_id : ""
            path: selectedBook ? selectedBook.path : ""
            subject: selectedBook ? subjectCombo.currentText : ""
            bookName: selectedBook ? selectedBook.name : ""
        }
    }

