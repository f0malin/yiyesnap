//
//  YiyeSnap.m
//  yiyesnap
//
//  Created by Achilles Xu on 16/5/18.
//  Copyright © 2016年 Hukaa. All rights reserved.
//

#import "YiyeSnap.h"

@implementation YiyeSnap {
    
}



-(id)initWithVideoDeviceIndex:(int)videoDeviceIndex audioDeviceIndex:(int)audioDeviceIndex cutBySeconds:(int)cutBySeconds startIndex:(int)startIndex {
    self = [super init];
    _videoDeviceIndex = videoDeviceIndex;
    _audioDeviceIndex = audioDeviceIndex;
    _cutBySeconds = cutBySeconds;
    _startIndex = startIndex;
    
    session = [[AVCaptureSession alloc] init];
    output = [[AVCaptureMovieFileOutput alloc] init];
    
    return self;
}

-(void)startRecording {
    // 初始化视频捕捉
    NSArray *devices;
    devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    if (devices.count > _videoDeviceIndex) {
        AVCaptureDevice *device = devices[_videoDeviceIndex];
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (input) {
            [session addInput:input];
            NSLog(@"video device added");
        }
    }
    // 初始化音频捕捉
    devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    if (devices.count > _audioDeviceIndex) {
        AVCaptureDevice *device = devices[_audioDeviceIndex];
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (input) {
            [session addInput:input];
            NSLog(@"audio device added");
        }
    }
    // 初始化输出
    [session addOutput:output];
    NSLog(@"output device added");
    
    [session startRunning];
    
    [self switchOutputFile];
}

-(void)switchOutputFile {
    NSString *strUrl = [NSString stringWithFormat:@"yy_%d.mp4", _startIndex];
    NSURL *url = [NSURL fileURLWithPath:strUrl];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        NSError *err;
        if (![[NSFileManager defaultManager] removeItemAtPath:[url path] error:&err])
        {
            NSLog(@"Error deleting existing movie %@",[err localizedDescription]);
        }
    }
    
    [output startRecordingToOutputFileURL:url recordingDelegate:self];
    _startIndex ++;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:_cutBySeconds target:self selector:@selector(finishOneRecord:) userInfo:nil repeats:NO];
}

-(void)finishOneRecord:(NSTimer *)timer {
    [self switchOutputFile];
}

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    NSLog(@"finished %@", [outputFileURL path]);
}

@end
