import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtMultimedia 5.6

Page1Form {

    property int stepSize: 1000

    spinboxStart.up.onPressedChanged: {
        if (spinboxStart.value + stepSize > video.duration)
            video.seek(video.duration)
        else
            video.seek(spinboxStart.value + stepSize)
        control.first.value = video.position / video.duration
    }

    spinboxStart.down.onPressedChanged: {
        if (spinboxStart.value - stepSize < 0)
            video.seek(0)
        else
            video.seek(spinboxStart.value - stepSize)
        control.first.value = video.position / video.duration
    }

    spinboxStop.up.onPressedChanged: {
        if (spinboxStop.value + stepSize > video.duration)
            video.seek(video.duration)
        else
            video.seek(spinboxStop.value + stepSize)
        control.second.value = video.position / video.duration
    }

    spinboxStop.down.onPressedChanged: {
        if (spinboxStop.value - stepSize < 0)
            video.seek(0)
        else
            video.seek(spinboxStop.value - stepSize)
        control.second.value = video.position / video.duration
    }

    control.first.onPressedChanged:   {
        video.seek(parseInt(control.first.value * video.duration))
        spinboxStart.value = video.position;
        video.pause()
    }

    video.onPositionChanged: {
        updateVideoDuration()
        videoPosition.text = msToTime(video.position) + "/" + msToTime(video.duration)
        console.log("control first value: " + control.first.value)
        console.log("control second value: " + control.second.value)
        spinboxStart.value = Math.round(control.first.value * video.duration);
        spinboxStop.value = Math.round(control.second.value * video.duration);
    }

    control.second.onPressedChanged: {
        video.seek(parseInt(control.second.value * video.duration))
        spinboxStop.value = video.position;
        video.pause()
    }

    mouseArea1.onClicked: {
        if (!video.hasVideo)
            fileDialog.open()
        else {
            video.playbackState == MediaPlayer.PlayingState ? video.pause() : video.play()
            image1.visible = false;
        }
    }

    button1.onClicked: {
        onClicked: fileDialog.open()
    }

    video.onHasVideoChanged: {
        console.log("yo")
        videoData.text = "Title: " + video.metaData.title +
                          ". Sample Rate: " + video.metaData.sampleRate + " Hz" +
                          ". Bit Rate: " + video.metaData.videoBitRate + " bit/s" +
                          ". Frame Rate: " + video.metaData.videoFrameRate + " FPS";
        control.first.value = 0.0;
        control.second.value = 1.0;
        var duration = updateVideoDuration()
        spinboxStart.to = duration;
        spinboxStop.to = duration;
        spinboxStop.value = duration;
        spinboxStart.stepSize = stepSize;
        spinboxStop.stepSize = stepSize;
        spinboxStart.enabled = true;
        spinboxStop.enabled = true;
        spinboxStart.textFromValue = function(value) {
            return msToTime(value);
        }
        spinboxStop.textFromValue = function(value) {
            return msToTime(value);
        }
        BusyIndicator.running = false;
        image1.visible = true;
    }

    fileDialog.onAccepted: {
        image2.visible = false;
        textField1.text = fileDialog.fileUrl

        // Load video
        BusyIndicator.running = true;
        video.source = fileDialog.fileUrl
    }

    fileDialog.onRejected: {
        console.log("Canceled")
    }

    function msToTime(duration) {
        var seconds = parseInt((duration/1000)%60)
            , minutes = parseInt((duration/(1000*60))%60)
            , hours = parseInt((duration/(1000*60*60))%24);

        hours = (hours < 10) ? "0" + hours : hours;
        minutes = (minutes < 10) ? "0" + minutes : minutes;
        seconds = (seconds < 10) ? "0" + seconds : seconds;

        return hours + ":" + minutes + ":" + seconds;
    }

    function updateVideoDuration() {
        var duration = Math.round( (control.second.value - control.first.value) * video.duration);
        videoDuration.text = "Duration: " + msToTime(duration);
        return duration;
    }
}
