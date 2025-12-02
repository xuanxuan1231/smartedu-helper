import QtQuick
import QtQuick.Layouts
import RinUI

Frame {
    id: frame
    default property alias content: commandContainer.data
    property alias showcase: caseContainer.data

    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    spacing: 4

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Column {
            id: commandContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 20
            spacing: frame.spacing
        }

        Rectangle {
            id: right
            width: 200
            Layout.fillHeight: true
            implicitHeight: caseContainer.implicitHeight + 2 * 16
            radius: Theme.currentTheme.appearance.smallRadius
            color: Theme.currentTheme.colors.backgroundAcrylicColor
            border.width: Theme.currentTheme.appearance.borderWidth
            border.color: Theme.currentTheme.colors.cardBorderColor

            Column {
                id: caseContainer
                anchors.fill: parent
                anchors.margins: 16
                spacing: 4
            }
        }
    }
}