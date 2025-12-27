import QtQuick
import QtQuick.Layouts
import RinUI

import "../../components"

FluentPage {
    title: qsTr("Special School Textbooks")
    // Avoid null deref during shutdown when context properties disappear
    property bool hasBookList: typeof SpecialBookList !== "undefined" && SpecialBookList !== null
    // Local caches to avoid implicit global writes
    property var categories: []
    property var periods: []
    property var subjects: []
    property var grades: []
    property var volumes: []
    property var books: []
    // Currently selected book item
    property var selectedBook: bookList.model && bookList.currentIndex >= 0 ? bookList.model[bookList.currentIndex] : null

    function updateBookList() {
        if (!hasBookList || categoryCombo.currentIndex < 0 || periodCombo.currentIndex < 0 ||
                subjectCombo.currentIndex < 0 || gradeCombo.currentIndex < 0 || volumeCombo.currentIndex < 0) {
            bookList.model = []
            return
        }

        bookList.model = SpecialBookList.get_books(
                    categoryCombo.currentIndex,
                    periodCombo.currentIndex,
                    subjectCombo.currentIndex,
                    gradeCombo.currentIndex,
                    volumeCombo.currentIndex)
    }

    RowLayout {
        Layout.fillHeight: true
        Layout.fillWidth: true

        GridLayout {
            columns: 2
            rows: 5
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true

            Text {
                text: qsTr("Category")
            }

            ComboBox {
                id: categoryCombo

                Layout.preferredWidth: 200
                Layout.maximumWidth: 200
                model: hasBookList ? SpecialBookList.get_categories() : []
                onCurrentIndexChanged: {
                    if (!hasBookList) {
                        periodCombo.model = []
                        subjectCombo.model = []
                        gradeCombo.model = []
                        volumeCombo.model = []
                        updateBookList();
                        return
                    }
                    periods = SpecialBookList.get_periods(currentIndex);
                    periodCombo.model = periods;
                    if (periods && periods.length > 0) {
                        periodCombo.currentIndex = -1; // 触发上级combobox内容不变的combobox的更新 for refreshed model
                        periodCombo.currentIndex = 0;
                    } else {
                        periodCombo.currentIndex = -1;
                        subjectCombo.model = [];
                        gradeCombo.model = [];
                        volumeCombo.model = [];
                        updateBookList();
                    }
                    updateBookList();
                }
            }

            Text {
                text: qsTr("Period")
            }

            ComboBox {
                id: periodCombo

                Layout.preferredWidth: 200
                Layout.maximumWidth: 200
                model: hasBookList ? SpecialBookList.get_periods(categoryCombo.currentIndex) : []
                onCurrentIndexChanged: {
                    if (!hasBookList) {
                        subjectCombo.model = []
                        gradeCombo.model = []
                        volumeCombo.model = []
                        updateBookList();
                        return
                    }
                    subjects = SpecialBookList.get_subjects(categoryCombo.currentIndex, currentIndex);
                    subjectCombo.model = subjects;
                    if (subjects && subjects.length > 0) {
                        subjectCombo.currentIndex = -1; // 触发上级combobox内容不变的combobox的更新
                        subjectCombo.currentIndex = 0;
                    } else {
                        subjectCombo.currentIndex = -1;
                        gradeCombo.model = [];
                        volumeCombo.model = [];
                        updateBookList();
                    }
                    updateBookList();
                }
            }

            Text {
                text: qsTr("Subject")
            }

            ComboBox {
                id: subjectCombo

                Layout.preferredWidth: 200
                Layout.maximumWidth: 200
                model: hasBookList ? SpecialBookList.get_subjects(categoryCombo.currentIndex, periodCombo.currentIndex) : []
                onCurrentIndexChanged: {
                    if (!hasBookList) {
                        gradeCombo.model = []
                        volumeCombo.model = []
                        updateBookList();
                        return
                    }
                    grades = SpecialBookList.get_grades(categoryCombo.currentIndex, periodCombo.currentIndex, currentIndex);
                    gradeCombo.model = grades;
                    if (grades && grades.length > 0) {
                        gradeCombo.currentIndex = -1; // 触发上级combobox内容不变的combobox的更新
                        gradeCombo.currentIndex = 0;
                    } else {
                        gradeCombo.currentIndex = -1;
                        volumeCombo.model = [];
                        updateBookList();
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
                model: hasBookList ? SpecialBookList.get_grades(categoryCombo.currentIndex, periodCombo.currentIndex, subjectCombo.currentIndex) : []
                onCurrentIndexChanged: {
                    if (!hasBookList) {
                        volumeCombo.model = []
                        updateBookList();
                        return
                    }
                    volumes = SpecialBookList.get_volumes(categoryCombo.currentIndex, periodCombo.currentIndex, subjectCombo.currentIndex, currentIndex);
                    volumeCombo.model = volumes;
                    if (volumes && volumes.length > 0) {
                        volumeCombo.currentIndex = -1; // 触发上级combobox内容不变的combobox的更新
                        volumeCombo.currentIndex = 0;
                    } else {
                        volumeCombo.currentIndex = -1;
                        updateBookList();
                    }
                    updateBookList();
                }
            }

            Text {
                text: qsTr("Volume")
            }

            ComboBox {
                id: volumeCombo

                Layout.preferredWidth: 200
                Layout.maximumWidth: 200
                model: hasBookList ? SpecialBookList.get_volumes(categoryCombo.currentIndex, periodCombo.currentIndex, subjectCombo.currentIndex, gradeCombo.currentIndex) : []
                onCurrentIndexChanged: {
                    if (!hasBookList) {
                        updateBookList();
                        return
                    }
                    books = SpecialBookList.get_books(categoryCombo.currentIndex, periodCombo.currentIndex, subjectCombo.currentIndex, gradeCombo.currentIndex, currentIndex);
                        updateBookList();
                }
            }

            Component.onCompleted: {
                if (hasBookList && categoryCombo.model && categoryCombo.model.length > 0) {
                    categoryCombo.currentIndex = 0;
                }
            }
        }

        ListView {
            id: bookList

            width: 200
            height: 400
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: hasBookList ? SpecialBookList.get_books(categoryCombo.currentIndex, periodCombo.currentIndex, subjectCombo.currentIndex, gradeCombo.currentIndex, volumeCombo.currentIndex) : []

            delegate: ListViewDelegate {
                middleArea: [
                    Text {
                        text: modelData.name
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        font.pixelSize: 16
                    },
                    Text {
                        text: modelData.path
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
        DownloadDialog {
            id: downloadDialog

            content_id: selectedBook ? selectedBook.content_id : ""
            path: selectedBook ? selectedBook.path : ""
            subject: selectedBook ? subjectCombo.currentText : ""
            bookName: selectedBook ? selectedBook.name : ""
        }
    }

}