import QtQuick 2.7
import QtQuick.Controls 2.0
import QtMultimedia 5.6

Video {
    id: video
    width : 800
    height : 600
    source: "file:///C:/Users/sebri/Documents/HEIG-VD/SEM5/IHM/Labos/IHM-Labo-02/IHM-Labo-02/test.avi"

    MouseArea {
        anchors.fill: parent
        onClicked: {
            video.play()
        }
    }

    focus: true
    Keys.onSpacePressed: video.playbackState == MediaPlayer.PlayingState ? video.pause() : video.play()
    Keys.onLeftPressed: video.seek(video.position - 5000)
    Keys.onRightPressed: video.seek(video.position + 5000)
}
