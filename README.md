# yiyesnap

Capture from camera with AVFoundation and save to video slicing files on OSX.

## Usage

### list devices

Just call it without arguments.

    yiyesnap

### capture videos

Call it with 4 arguments.

    yiyesnap <videoDeviceIndex> <audioDeviceIndex> <cutBySeconds> <startIndex>

### example

    yiyesnap 0 0 60 55

Above will capture from the first video device and first audio device, switch recording to new file every 60 seconds.

Recorded videos will be saved in the current working dir, and be named like yy_55.mp4, yy_56.mp4, yy_57.mp4, etc.