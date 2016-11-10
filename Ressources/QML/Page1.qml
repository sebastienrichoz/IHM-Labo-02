import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtMultimedia 5.6

Page1Form {

    property int stepSize: 1000
    property bool ffmpegCommandIsSelected : false
    property bool isInputChoosed: false
    property bool isOutputChoosed: false

    /**
      * FFMpeg command
      */

    copyButton.onPressed: {
        console.log("copyButton.onPressed");
        var ffmpegCommandStr = "ffmpeg -ss "
                + spinboxStart.value
                + " -i "
                + videoInputField.getText(0, videoInputField.text.length)
                + " -t "
                + updateVideoDuration()
                + " -c copy "
                + videoOutputField.getText(0, videoOutputField.length)
        _TestClass.copyButtonClicked(ffmpegCommandStr);
    }

    ffmpegCommand.onActiveFocusChanged: {
        if (ffmpegCommandIsSelected) {
            ffmpegCommand.undo()
            ffmpegCommandIsSelected = false;
        } else {
            ffmpegCommand.select(2, ffmpegCommand.text.length)
            ffmpegCommandIsSelected = true;
            console.log("text selected");
        }
    }

    /**
      * Start and stop spinbox
      */
    // Fixing problem we were having with spinbox values : their value
    // were set to the other spinbox "from" value when they lost focus
    spinboxStart.onActiveFocusChanged: {
        spinboxStart.value = parseInt(control.first.value * video.duration)
    }
    spinboxStop.onActiveFocusChanged: {
        spinboxStop.value = parseInt(control.second.value * video.duration)
    }

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
        playIcon.visible = true
        updateVideoDuration()
    }

    control.second.onPressedChanged: {
        console.log("control.second.onPressedChanged")
        var pos = parseInt(control.second.value * video.duration)
        video.seek(pos)
        spinboxStop.value = pos;
        video.pause()
        playIcon.visible = true
        updateVideoDuration()
    }


    /**
      * Video
      */

    video.onPositionChanged: {
        console.log("video.onPositionChanged")
        videoPosition.text = msToTime(video.position)
                + "/"
                + msToTime(video.duration)
        updateFfmpegCommand()

        spinboxStart.to = spinboxStop.value
        spinboxStop.from = spinboxStart.value
    }

    mouseArea1.onClicked: {
        console.log("mouseArea1.onClicked")
        if (!video.hasVideo)
            fileDialogInput.open()
        else if (video.playbackState === MediaPlayer.PlayingState) {
            video.pause()
            playIcon.visible = true
        }
        else {
            video.play()
            playIcon.visible = false
        }
    }

    videoInputButton.onClicked: {
        console.log("videoInputButton.onClicked")
        fileDialogInput.open()
    }

    videoOutputButton.onClicked: {
        console.log("videoOutputButton.onClicked")
        fileDialogOutput.folder = fileDialogInput.folder ?
                    fileDialogInput.folder : shortcuts.movies
        fileDialogOutput.open()
    }

    video.onHasVideoChanged: {
        console.log("video.onHasVideoChanged")
        videoTitle.text = "Title: " + video.metaData.title;

        videoSampleRate.text = "Sample Rate: "
                + video.metaData.sampleRate
                + " Hz";

        videoBitRate.text = "Bit Rate: "
                + video.metaData.videoBitRate
                + " bit/s";

        videoFrameRate.text = "Frame Rate: "
                + video.metaData.videoFrameRate
                + " FPS";

        videoPosition.text = msToTime(video.position)
                + "/"
                + msToTime(video.duration)

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
        playIcon.visible = true;
        control.enabled = true;
        updateFfmpegCommand();
    }

    videoInputField.onTextChanged: {
        if (videoInputField.text.length > 0) {
            textInputFile.text = "<input file> = "
                    + videoInputField.getText(0, videoInputField.text.length);
            isInputChoosed = true;
            if (isOutputChoosed)
                copyButton.enabled = true;
        } else {
            textInputFile.text = "<input file> = Choose a video input file"
            isInputChoosed = false;
            copyButton.enabled = false;
        }
    }

    videoOutputField.onTextChanged: {
        if (videoOutputField.text.length > 0) {
            textOutputFile.text = "<output file> = "
                    + videoOutputField.getText(0, videoOutputField.text.length);
            isOutputChoosed = true;
            if (isInputChoosed)
                copyButton.enabled = true;
        } else {
            textOutputFile.text = "<output file> = Choose a video output file"
            isOutputChoosed = false;
            copyButton.enabled = false;
        }
    }

    fileDialogInput.onAccepted: {
        console.log("fileDialogInput.onAccepted")
        uploadIcon.visible = false;
        videoInputField.text = _TestClass.getText(fileDialogInput.fileUrl, 8);

        // Load video
        BusyIndicator.running = true;
        video.source = fileDialogInput.fileUrl
    }

    fileDialogInput.onRejected: {
        console.log("fileDialogInput.onRejected")
    }

    fileDialogOutput.onAccepted: {
        console.log("fileDialogOutput.onAccepted")
        videoOutputField.text = _TestClass.getText(fileDialogOutput.fileUrl, 8);
    }

    fileDialogOutput.onRejected: {
        console.log("fileDialogOutput.onRejected")
    }


    /**
      * functions
      */

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
        var duration = Math.round( (control.second.value - control.first.value)
                                  * video.duration);
        videoDuration.text = "Duration: " + msToTime(duration);
        return duration;
    }

    function updateFfmpegCommand() {
        ffmpegCommand.text = "$ ffmpeg -ss "
                + spinboxStart.value
                + " -i <input file>"
                + " -t "
                + updateVideoDuration()
                + " -c copy <output file>";
    }
}
