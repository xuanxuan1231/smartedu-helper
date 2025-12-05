import QtQuick
import QtQuick.Layouts
import RinUI

FluentPage {
    title: qsTr("Junior High School Textbooks")
    // 其实是通用的 其他的可以照搬

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
                model: JuniorBookList.get_subjects()
                onCurrentIndexChanged: {
                    versions = JuniorBookList.get_versions(currentIndex);
                    versionCombo.model = versions;
                    if (versions && versions.length > 0) {
                        // 有可用版本
                        // 初始化版本
                        versionCombo.currentIndex = 0;
                        // 顺便初始化年级
                        grades = JuniorBookList.get_grades(currentIndex, versionCombo.currentIndex);
                        gradeCombo.model = grades;
                        if (grades && grades > 0) {
                            // 有可用年级
                            gradeCombo.currentIndex = 0;
                            // 再顺便初始化书籍
                            books = JuniorBookList.get_books(subjectCombo.currentIndex, versionCombo.currentIndex, gradeCombo.currentIndex);
                            bookList.model = books;
                        } else {
                            gradeCombo.currentIndex = -1;
                        }
                    } else {
                        versionCombo.currentIndex = -1;
                        gradeCombo.model = [];
                    }
                }
            }

            Text {
                text: qsTr("Version")
            }

            ComboBox {
                id: versionCombo

                Layout.preferredWidth: 200
                Layout.maximumWidth: 200
                model: JuniorBookList.get_versions(subjectCombo.currentIndex)
                onCurrentIndexChanged: {
                    grades = JuniorBookList.get_grades(subjectCombo.currentIndex, currentIndex);
                    gradeCombo.model = grades;
                    if (grades && grades.length > 0) {
                        gradeCombo.currentIndex = 0;
                        books = JuniorBookList.get_books(subjectCombo.currentIndex, versionCombo.currentIndex, gradeCombo.currentIndex);
                        bookList.model = books;
                    } else {
                        gradeCombo.currentIndex = -1;
                    }
                }
            }

            Text {
                text: qsTr("Grade")
            }

            ComboBox {
                id: gradeCombo

                Layout.preferredWidth: 200
                Layout.maximumWidth: 200
                model: JuniorBookList.get_grades(subjectCombo.currentIndex, versionCombo.currentIndex)
                onCurrentIndexChanged: {
                    books = JuniorBookList.get_books(subjectCombo.currentIndex, versionCombo.currentIndex, currentIndex);
                    bookList.model = books;
                }
            }}

            ListView {
                id: bookList

                width: 200
                height: 400
                Layout.fillWidth: true
                Layout.fillHeight: true

                model: JuniorBookList.get_books(subjectCombo.currentIndex, versionCombo.currentIndex, gradeCombo.currentIndex)

                delegate: ListViewDelegate {
                    middleArea: [
                        // middleArea takes a list of items for its ColumnLayout
                        Text {
                            text: subjectCombo.currentText + " " + gradeCombo.currentText + modelData.name
                            font.bold: true
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                            font.pixelSize: 18
                        },
                        Text {
                            text: modelData.content_id + " " + modelData.number // Secondary text from model
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
                            console.log("还没有 等着");
                        }
                    }

                }

            }

        }

    }

