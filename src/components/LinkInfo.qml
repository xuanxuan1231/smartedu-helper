import QtQuick
import QtQuick.Layouts
import RinUI

Frame {
    id: frame
    default property alias link: linkArea.text 
    property alias header: headerArea.text

    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    spacing: 4

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Column {
            id: linkContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 20
            spacing: frame.spacing
            Text {
                text: qsTr("Link")
                font.bold: true
            }
            TextArea {
                id: linkArea
                readOnly: true
                wrapMode: TextEdit.WrapAnywhere
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                width: parent.width
            }
        }

        ColumnLayout {
            id: headerContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 20
            spacing: frame.spacing
            Text {
                text: qsTr("Header")
                font.bold: true
            }
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: frame.spacing

                TextArea {
                    id: headerArea
                    readOnly: true
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                Button {
                    text: qsTr("Save")
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    highlighted: true
                    onClicked: console.log("本来这是要把header存下来下载用的，但是还没写ww")
                }
            }
        }
    }
}