/**
  * @File Page.qml
  * @Description This file handles and manages the events launched by
  *               the components from Page1Form.qml
  *
  * @Author Sébastien Richoz & Damien Rochat
  * @Date 10th November 2016
  */

import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtMultimedia 5.6

Page1Form {

    property int stepSize: 1000
    property bool ffmpegCommandIsSelected : false
    property bool isInputChoosed: false
    property bool isOutputChoosed: false
    property bool errorInputFile: false
    property string currentVideoFolder: fileDialogInput.folder

    /**
      * FFMpeg command
      */

    copyButton.onPressed: {
        var ffmpegCommandStr = "ffmpeg -ss "
                + spinboxStart.value
                + " -i "
                + videoInputField.getText(0, videoInputField.text.length)
                + " -t "
                + updateVideoDuration()
                + " -c copy "
                + videoOutputField.getText(0, videoOutputField.length);
        UtilityClass.copyButtonClicked(ffmpegCommandStr);
    }

    ffmpegCommand.onActiveFocusChanged: {
        if (ffmpegCommandIsSelected) {
            ffmpegCommand.undo();
            ffmpegCommandIsSelected = false;
        } else {
            ffmpegCommand.select(2, ffmpegCommand.text.length);
            ffmpegCommandIsSelected = true;
        }
    }

    /**
      * Start and stop spinbox
      */

    // Fixing problem we were having with spinbox values : their value
    // were set to the other spinbox "from" value when they lost focus
    spinboxStart.onActiveFocusChanged: {
        spinboxStart.value = parseInt(control.first.value * video.duration);
    }
    spinboxStop.onActiveFocusChanged: {
        spinboxStop.value = parseInt(control.second.value * video.duration);
    }

    // Manage the changes of start and end points from the spinbox
    // update the rangeslider and the preview of the video
    spinboxStart.up.onPressedChanged: {
        if (spinboxStart.value + stepSize > video.duration)
            video.seek(video.duration);
        else
            video.seek(spinboxStart.value + stepSize);
        control.first.value = video.position / video.duration;
        updateVideoDuration();
    }
    spinboxStart.down.onPressedChanged: {
        if (spinboxStart.value - stepSize < 0)
            video.seek(0);
        else
            video.seek(spinboxStart.value - stepSize);
        control.first.value = video.position / video.duration;
        updateVideoDuration();
    }
    spinboxStop.up.onPressedChanged: {
        if (spinboxStop.value + stepSize > video.duration)
            video.seek(video.duration);
        else
            video.seek(spinboxStop.value + stepSize);
        control.second.value = video.position / video.duration;
        updateVideoDuration();
    }
    spinboxStop.down.onPressedChanged: {
        if (spinboxStop.value - stepSize < 0)
            video.seek(0);
        else
            video.seek(spinboxStop.value - stepSize);
        control.second.value = video.position / video.duration;
        updateVideoDuration();
    }


    /**
      * Cut control
      */

    // Manage the changes of start and end points from slider
    // update the spinbox and the preview of the video
    control.first.onPressedChanged: {
        var pos = parseInt(control.first.value * video.duration);
        video.seek(pos);
        spinboxStart.value = pos;
        video.pause();
        playIcon.visible = true;
        updateVideoDuration();
    }
    control.second.onPressedChanged: {
        var pos = parseInt(control.second.value * video.duration);
        video.seek(pos);
        spinboxStop.value = pos;
        video.pause();
        playIcon.visible = true;
        updateVideoDuration();
    }


    /**
      * Video
      */
    // Handle output video errors
    // Use a tmp video component to test if the output video if correct
    // for example, it prevent to save the video has a .pdf file
    tempVideo.onStatusChanged: {
        var error = "<h2>Error - Invalid Media</h2><p>The output file is not recognized as a media.<p>";
        switch(tempVideo.status) {
        case 7: // Format error
            textAreaError.text = error;
            popupError.open();
            videoOutputField.text = "";
            break;
        case 8: // Unknow error
            textAreaError.text = error;
            popupError.open();
            videoOutputField.text = "";
            errorInputFile = true;
            break;
        }
    }

    // Handle input video errors
    video.onStatusChanged: {
        switch(video.status) {
        case 3: // No error
            errorInputFile = false;
            uploadIcon.visible = false;
            break;
        case 7:  // Format error
            textAreaError.text = "<h2>Error - Invalid Media</h2><p>The media cannot be played.<p>";
            popupError.open();
            videoInputField.text = "";
            uploadIcon.visible = true;
            playIcon.visible = false;
            errorInputFile = true;
            break;
        case 8: // Unknow error
            textAreaError.text = "<h2>Error - Unknown Status</h2><p>The status of the file is not known as a media.<p>";
            popupError.open();
            videoInputField.text = "";
            uploadIcon.visible = true;
            playIcon.visible = false;
            errorInputFile = true;
            break;
        }
        currentVideoFolder = fileDialogInput.folder;
    }

    // Update the new video time and the ffmpeg command on change
    video.onPositionChanged: {
        videoPosition.text = msToTime(video.position)
                + "/"
                + msToTime(video.duration);
        updateFfmpegCommand();

        spinboxStart.to = spinboxStop.value;
        spinboxStop.from = spinboxStart.value;
    }

    // Choose and input video
    mouseArea1.onClicked: {
        if (!video.hasVideo) {
            fileDialogInput.open();
        } else if (video.playbackState === MediaPlayer.PlayingState) {
            video.pause();
            playIcon.visible = true;
        }
        else {
            video.play();
            playIcon.visible = false;
        }
    }
    videoInputButton.onClicked: {
        fileDialogInput.open();
    }

    // Choose and output video
    videoOutputButton.onClicked: {
        if (fileDialogInput.folder && !errorInputFile)
            fileDialogOutput.folder = fileDialogInput.folder;
        fileDialogOutput.open();
    }

    // Update the video informations when loaded
    // And init parameters
    video.onHasVideoChanged: {
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
                + msToTime(video.duration);

        fileDialogInput.folder = currentVideoFolder;

        control.first.value = 0.0;
        control.second.value = 1.0;
        var duration = updateVideoDuration();
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

    // Listen for text change in the input field
    // Enable or disable the parameters
    videoInputField.onTextChanged: {
        if (videoInputField.text.length > 0) {
            textInputFile.text = "<input file>   = "
                    + videoInputField.getText(0, videoInputField.text.length);
            isInputChoosed = true;
            if (isOutputChoosed)
                copyButton.enabled = true;
        } else {
            textInputFile.text = "<input file>   = Choose a video input file";
            isInputChoosed = false;
            copyButton.enabled = false;
        }
    }

    // Listen for text change in the output field
    // Enable or disable the parameters
    videoOutputField.onTextChanged: {
        if (videoOutputField.text.length > 0) {
            textOutputFile.text = "<output file> = "
                    + videoOutputField.getText(0, videoOutputField.text.length);
            isOutputChoosed = true;
            if (isInputChoosed)
                copyButton.enabled = true;
        } else {
            textOutputFile.text = "<output file> = Choose a video output file";
            isOutputChoosed = false;
            copyButton.enabled = false;
        }
    }

    // Handle open input video from textfield
    videoInputField.onFocusChanged: {
        console.log("focus changed : " + currentVideoFolder);
        if (videoInputField.text != video.source) {
            video.source = videoInputField.text;
            fileDialogInput.folder = videoInputField.text;
        }
    }

    // Handle open input video
    fileDialogInput.onAccepted: {
        uploadIcon.visible = false;
        videoInputField.text = UtilityClass.getText(fileDialogInput.fileUrl, 8);
        currentVideoFolder = fileDialogInput.fileUrl
        // Load video
        BusyIndicator.running = true;
        video.source = fileDialogInput.fileUrl;
    }

    // Handle open output video
    fileDialogOutput.onAccepted: {
        videoOutputField.text = UtilityClass.getText(fileDialogOutput.fileUrl, 8);
        tempVideo.source = fileDialogOutput.fileUrl;
    }


    /**
      * Popup for errors
      */

    Popup {
        id: popupError
        x: (parent.width - textAreaError.width) / 2
        y: (parent.height - textAreaError.height) / 3
        width: 400
        height: 100
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        opacity: 0.8

        TextArea {
            id: textAreaError
            x: 133
            y: 270
            width: 350
            height: 100
            color: "#F44336"
            textFormat: TextEdit.RichText
            text: qsTr("<h2>Error</h2>")
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


    /**
      * functions
      */

    // Convert time in ms to readable text
    function msToTime(duration) {
        var seconds = parseInt((duration/1000)%60)
            , minutes = parseInt((duration/(1000*60))%60)
            , hours = parseInt((duration/(1000*60*60))%24);

        hours = (hours < 10) ? "0" + hours : hours;
        minutes = (minutes < 10) ? "0" + minutes : minutes;
        seconds = (seconds < 10) ? "0" + seconds : seconds;

        return hours + ":" + minutes + ":" + seconds;
    }

    // Compute the new video duration
    function updateVideoDuration() {
        var duration = Math.round( (control.second.value - control.first.value)
                                  * video.duration);
        videoDuration.text = "Duration: " + msToTime(duration);
        return duration;
    }

    // Update the command
    function updateFfmpegCommand() {
        ffmpegCommand.text = "$ ffmpeg -ss "
                + spinboxStart.value
                + " -i <input file>"
                + " -t "
                + updateVideoDuration()
                + " -c copy <output file>";
    }
}
