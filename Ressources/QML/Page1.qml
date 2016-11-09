import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtMultimedia 5.6

Page1Form {

    property int stepSize: 1000


    /**
      * Start and stop spinbox
      */

    // TODO : gérer le problème des spinbox qui se réinitilisent mutuellement
    // TODO : rendre impossible que la valeur de la spinboxstart soit supérieure à celle de spinboxstop et spinboxstop ne doit pas pouvoir etre inferieur a spinboxstart

    spinboxStart.up.onPressedChanged: {
        console.log("spinboxStart.up.onPressedChanged");
        if (spinboxStart.value + stepSize > video.duration)
            video.seek(video.duration)
        else
            video.seek(spinboxStart.value + stepSize)
        control.first.value = video.position / video.duration
        updateVideoDuration()
    }

    spinboxStart.down.onPressedChanged: {
        console.log("spinboxStart.down.onPressedChanged");
        if (spinboxStart.value - stepSize < 0)
            video.seek(0)
        else
            video.seek(spinboxStart.value - stepSize)
        control.first.value = video.position / video.duration
        updateVideoDuration()
    }

    spinboxStop.up.onPressedChanged: {
        console.log("spinboxStop.up.onPressedChanged");
        if (spinboxStop.value + stepSize > video.duration)
            video.seek(video.duration)
        else
            video.seek(spinboxStop.value + stepSize)
        control.second.value = video.position / video.duration
        updateVideoDuration()
    }

    spinboxStop.down.onPressedChanged: {
        console.log("spinboxStop.down.onPressedChanged");
        if (spinboxStop.value - stepSize < 0)
            video.seek(0)
        else
            video.seek(spinboxStop.value - stepSize)
        control.second.value = video.position / video.duration
        updateVideoDuration()
    }


    /**
      * Cut control
      */

    control.first.onPressedChanged: {
        console.log("control.first.onPressedChanged")
        var pos = parseInt(control.first.value * video.duration)
        video.seek(pos)
        spinboxStart.value = pos;
        video.pause()
        image1.visible = true
        updateVideoDuration()
    }

    control.second.onPressedChanged: {
        console.log("control.second.onPressedChanged")
        var pos = parseInt(control.second.value * video.duration)
        video.seek(pos)
        spinboxStop.value = pos;
        video.pause()
        image1.visible = true
        updateVideoDuration()
    }


    /**
      * Video
      */

    video.onPositionChanged: {
        console.log("video.onPositionChanged")
        videoPosition.text = msToTime(video.position) + "/" + msToTime(video.duration)
    }

    mouseArea1.onClicked: {
        console.log("mouseArea1.onClicked")
        if (!video.hasVideo)
            fileDialog.open()
        else if (video.playbackState === MediaPlayer.PlayingState) {
            video.pause()
            image1.visible = true
        }
        else {
            video.play()
            image1.visible = false
        }
    }

    button1.onClicked: {
        console.log("button1.onClicked")
        onClicked: fileDialog.open()
    }

    video.onHasVideoChanged: {
        console.log("video.onHasVideoChanged")
        videoTitle.text = "Title: " + video.metaData.title;
        videoSampleRate.text = "Sample Rate: " + video.metaData.sampleRate + " Hz";
        videoBitRate.text = "Bit Rate: " + video.metaData.videoBitRate + " bit/s";
        videoFrameRate.text = "Frame Rate: " + video.metaData.videoFrameRate + " FPS";

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
        console.log("fileDialog.onAccepted")
        image2.visible = false;
        textField1.text = fileDialog.fileUrl

        // Load video
        BusyIndicator.running = true;
        video.source = fileDialog.fileUrl
    }

    fileDialog.onRejected: {
        console.log("fileDialog.onRejected")
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
