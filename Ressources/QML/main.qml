import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.0
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0

ApplicationWindow {
    id: appWindow
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
                        text: qsTr("About")
                        onClicked: popup.open()

                        Popup {
                            id: popup
                            x: (appWindow.width - textArea1.width) / 3
                            y: (appWindow.height - textArea1.height) / 3
                            width: 400
                            height: 300
                            modal: true
                            focus: true
                            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                            opacity: 0.8

                                TextArea {
                                    id: textArea1
                                    x: 133
                                    y: 270
                                    width: 350
                                    height: 200
                                    color: "#FFFFFF"
                                    textFormat: TextEdit.RichText
                                    text: qsTr("
    <h2>Version 1.0</h2>
    <h4>10<sup>th</sup> November 2016</h4>
    <p>Created by <i>Sébastien Richoz & Damien Rochat</i></p>
    <p><b>Video cutter</b> helps you to edit video files.
    It generates an ffmpeg command to trim a video.</p>
    ")
                                    anchors.verticalCenterOffset: 0
                                    anchors.horizontalCenterOffset: 0
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    wrapMode: Text.WordWrap
                                    enabled: false
                                }
                        }
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
