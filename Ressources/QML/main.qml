import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.0
import QtGraphicalEffects 1.0

ApplicationWindow {
    visible: true
    Material.theme: Material.Dark
    Material.primary: Material.Red
    Material.accent: Material.Red
    width: 900
    height: 900
    title: qsTr("Video cutter")

    property color menuBackgroundColor: "#F44336"
    property color menuBorderColor: "#282828"
    property double menuBackgroundOpacity: 0.0

    // TODO actions sur les boutons du menu
    header: ToolBar {
        height: 40

        Item {
            id: item2
            width: 100
            height: 40
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0

            Button {
                id: fileButton
                Material.primary: Material.Yellow
                Material.accent: Material.Yellow
                width: 100
                height: 40
                text: qsTr("File")
                anchors.fill: parent
                Layout.columnSpan: 1
                Layout.rowSpan: 1
                Layout.maximumHeight: 100
                Layout.maximumWidth: 100
                Layout.fillWidth: true
                rightPadding: 8
                Layout.fillHeight: true

                background: Rectangle {
                    id: rect
                    border.color: menuBorderColor
                    color: menuBackgroundColor
                    opacity: menuBackgroundOpacity
                }

                onClicked: fileMenu.open()
                Menu {
                    id: fileMenu
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 50
                        color: "#4b4b4b"
                        opacity: 0.6
                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 3
                            verticalOffset: 5
                            radius: 15.0
                            samples: 17
                            color: "#80000000"
                        }
                    }
                    y: fileButton.height
                    MenuItem {
                        text: qsTr("Exit")
                        onClicked: Qt.quit()
                    }
                }
            }
        }
        Item {
            id: item3
            width: 100
            height: 40
            anchors.left: item2.right
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0

            Button {
                id: helpButton
                text: qsTr("Help")
                anchors.fill: parent
                Layout.columnSpan: 1
                Layout.rowSpan: 1
                Layout.maximumHeight: 100
                Layout.maximumWidth: 100
                spacing: 0
                leftPadding: 8
                checkable: false
                Layout.fillWidth: true
                Layout.fillHeight: true

                background: Rectangle {
                    id: rect2
                    border.color: menuBorderColor
                    color: menuBackgroundColor
                    opacity: menuBackgroundOpacity
                }

                onClicked: helpMenu.open()
                Menu {
                    id: helpMenu
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 80
                        color: "#4b4b4b"
                        opacity: 0.6
                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 3
                            verticalOffset: 5
                            radius: 15.0
                            samples: 17
                            color: "#80000000"
                        }
                    }
                    y: helpButton.height

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
