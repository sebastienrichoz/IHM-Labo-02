import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.0

ApplicationWindow {
    visible: true
    Material.theme: Material.Dark
    Material.primary: Material.Red
    Material.accent: Material.Red
    width: 900
    height: 900
    title: qsTr("Video cut")

    header: ToolBar {
        height: 40
        Row {
            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5

            Button {
                id: fileButton
                text: qsTr("File")
                onClicked: fileMenu.open()
                Menu {
                    id: fileMenu
                    y: fileButton.height

                    MenuItem {
                        text: qsTr("Open...")
                    }
                    MenuItem {
                        text: qsTr("Exit")
                        onClicked: Qt.quit()
                    }
                }
            }

            Button {
                id: aboutButton
                text: qsTr("Help")
                onClicked: aboutMenu.open()
                Menu {
                    id: aboutMenu
                    y: aboutButton.height

                    MenuItem {
                        text: qsTr("Help")
                    }
                    MenuItem {
                        text: qsTr("About")
                    }
                }
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: Page1 {}
    }
}
