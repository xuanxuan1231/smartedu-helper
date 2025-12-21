import QtQuick
import QtQuick.Layouts
import RinUI

Frame {
    id: downloadItem
    property string name
    property string url
    property string mac
    property string status
    property int progress: 0

    leftPadding: 15
    rightPadding: 15
    topPadding: 13
    bottomPadding: 13
    // implicitHeight: 62

    RowLayout {
        anchors.fill: parent
        spacing: 16

        RowLayout {
            id: leftContent
            Layout.maximumWidth: parent.width * 0.6
            Layout.fillHeight: true
            spacing: 16

            Icon {
                id: icon
                size: 20
                visible: name !== "" || source !== ""
                name: status === "completed" ? "ic_fluent_checkmark_circle_20_filled" : status === "in_progress" ? "ic_fluent_arrow_circle_down_20_filled" : status === "error" ? "ic_fluent_error_circle_20_filled" : "ic_fluent_arrow_sync_circle_20_filled"
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0
                Text {
                    id: nameLabel
                    Layout.fillWidth: true
                    typography: Typography.Body
                    text: name
                    maximumLineCount: 2
                    elide: Text.ElideRight
                }

                Text {
                    id: urlLabel
                    Layout.fillWidth: true
                    typography: Typography.Caption
                    text: url + "\n" + mac
                    color: Theme.currentTheme.colors.textSecondaryColor
                    wrapMode: Text.Wrap
                    maximumLineCount: 3
                    elide: Text.ElideRight
                }
            }
        }
        RowLayout {
            id: rightContent
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignRight
            spacing: 16

            ProgressRing {
                from: 0
                to: 100
                value: progress ? progress : 0
                state: ProgressRing.Running
            }
        }
    }
}
