import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtMultimedia 5.6
import QtQuick.Controls.Material 2.0
import QtQuick.Dialogs 1.2

Item {
    id: item1
    property alias textField1: textField1
    property alias button1: button1
    property alias spinboxStart: spinboxStart
    property alias spinboxStop: spinboxStop
    property alias control: control
    property alias mouseArea1: mouseArea1
    property alias video: video
    property alias fileDialog: fileDialog
    property alias videoDuration: videoDuration
    property alias videoPosition: videoPosition
    property alias image1: image1
    property alias image2: image2
    property alias videoTitle: videoTitle
    property alias videoSampleRate: videoSampleRate
    property alias videoBitRate: videoBitRate
    property alias videoFrameRate: videoFrameRate

    FileDialog {
        id: fileDialog
        title: "Please choose a video file"
        folder: shortcuts.movies
        nameFilters: [ "Video files (*.mp4 *.avi)", "All files (*)" ]
        selectMultiple: false
        Component.onCompleted: visible = false
    }

    ColumnLayout {
        id: columnLayout1
        anchors.rightMargin: 30
        anchors.leftMargin: 30
        anchors.bottomMargin: 30
        anchors.topMargin: 30
        anchors.fill: parent

        RowLayout {
            id: rowLayout1
            width: 780
            height: 40
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.columnSpan: 0
            Layout.rowSpan: 0
            Layout.preferredHeight: -1
            Layout.preferredWidth: -1
            spacing: 10
            Layout.fillWidth: true
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top

            TextField {
                id: textField1
                Layout.fillWidth: true
                Layout.minimumWidth: 0
                placeholderText: qsTr("Enter video filename")
            }

            Button {
                id: button1
                text: qsTr("Open Video...")
                Layout.maximumWidth: 150
                Layout.fillWidth: true
                autoExclusive: false
            }
        }


        RowLayout {
            id: rowLayout4
            width: 100
            height: 100

            Text {
                id: videoTitle
                width: 780
                height: 14
                color: "#8b8b8b"
                text: qsTr("No video file selected")
                verticalAlignment: Text.AlignVCenter
                Layout.preferredHeight: 30
                Layout.fillHeight: false
                Layout.fillWidth: true
                font.pixelSize: 12
            }

            Text {
                id: videoBitRate
                color: "#8b8b8b"
                text: qsTr("")
                Layout.fillWidth: true
                font.pixelSize: 12
            }

            Text {
                id: videoFrameRate
                color: "#8b8b8b"
                text: qsTr("")
                Layout.fillWidth: true
                font.pixelSize: 12
            }

            Text {
                id: videoSampleRate
                color: "#8b8b8b"
                text: qsTr("")
                Layout.fillWidth: true
                font.pixelSize: 12
            }
        }

        Video {
            id: video
            z: 2
            width: 346
            height: 203
            Layout.fillHeight: true
            Layout.fillWidth: true

            BusyIndicator {
                id: busyIndicator1
                x: 380
                y: 199
                running: false
            }

            MouseArea {
                id: mouseArea1
                anchors.fill: parent

                Image {
                    id: image1
                    x: 310
                    y: 131
                    width: 200
                    height: 200
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    Layout.minimumHeight: 100
                    Layout.minimumWidth: 100
                    Layout.maximumHeight: 256
                    Layout.maximumWidth: 256
                    Layout.fillWidth: false
                    clip: false
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    fillMode: Image.PreserveAspectFit
                    visible: false
                    source: "../img/play-icon.png"
                }

                Image {
                    id: image2
                    x: 310
                    y: 131
                    width: 200
                    height: 200
                    opacity: 0.7
                    visible: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    source: "../img/upload-video.png"
                }
            }


            //            focus: true
            //            Keys.onSpacePressed: video.playbackState == MediaPlayer.PlayingState ? video.pause() : video.play()
            //            Keys.onLeftPressed: video.seek(video.position - 5000)
            //            Keys.onRightPressed: video.seek(video.position + 5000)
        }

        Text {
            id: videoPosition
            color: "#8b8b8b"
            text: qsTr("00:00:00/00:00:00")
            font.pixelSize: 12
        }

        RangeSlider {
            id: control
            width: 780
            height: 40
            wheelEnabled: false
            to: 1.0
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.fillWidth: true
            first.value: 0.0
            second.value: 0.0

            background: Rectangle {
                x: control.leftPadding
                y: control.topPadding + control.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 4
                width: control.availableWidth
                height: implicitHeight
                radius: 2
                color: "#bdbebf"

                Rectangle {
                    x: control.first.visualPosition * parent.width
                    width: control.second.visualPosition * parent.width - x
                    height: parent.height
                    color: "#f20808"
                    radius: 2
                }
            }
        }


        RowLayout {
            id: rowLayout3
            width: 819
            height: 43
            Layout.preferredWidth: -1
            Layout.fillWidth: true

            SpinBox {
                id: spinboxStart
                Layout.minimumWidth: 150
                enabled: false
                stepSize: 1000
                Material.foreground: "white"
                Material.background: "grey"
                Layout.maximumWidth: 65535
                Layout.fillWidth: true
                transformOrigin: Item.Left
                from: 0
                to: 2000
            }

            Text {
                id: videoDuration
                color: "#8b8b8b"
                text: qsTr("Select a video file")
                Layout.minimumWidth: 200
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillWidth: true
                font.pixelSize: 12
            }

            SpinBox {
                id: spinboxStop
                Layout.minimumWidth: 150
                enabled: false
                stepSize: 1000
                Material.foreground: "white"
                Material.background: "grey"
                from: 0
                to: 2000
                Layout.maximumWidth: 65535
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                transformOrigin: Item.Right

                //        validator: DoubleValidator {
                //            bottom: Math.min(spinbox.from, spinbox.to)
                //            top:  Math.max(spinbox.from, spinbox.to)
                //        }

                //        textFromValue: function(value, locale) {
                //            return Number(value / 100).toLocaleString(locale, 'f', spinbox.decimals)
                //        }

                //        valueFromText: function(text, locale) {
                //            return Number.fromLocaleString(locale, text) * 100
                //        }
            }

        }



        RowLayout {
            id: rowLayout2
            width: 100
            height: 100
            spacing: 10


            TextField {
                id: textField2
                placeholderText: qsTr("Name of output file")
                Layout.fillWidth: true
            }

            Button {
                id: button3
                text: qsTr("Select Output File")
                Layout.minimumWidth: 150
            }


        }


        TextEdit {
            id: textEdit1
            width: 80
            height: 20
            color: "#000000"
            text: qsTr("$ ffmpeg ... do it dynamically")
            selectionColor: "#ed0d0d"
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            anchors.horizontalCenter: item1.horizontalCenter
            font.pixelSize: 16
        }




    }

}
