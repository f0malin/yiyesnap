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
    outputIndex = 0;
    outputArray = [[NSArray alloc] initWithObjects:[[AVCaptureMovieFileOutput alloc] init], [[AVCaptureMovieFileOutput alloc] init], nil];
    
    return self;
}

-(void)startRecording {
    // 初始化视频捕捉
    NSArray *devices;
    devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    if (devices.count > _videoDeviceIndex) {
        AVCaptureDevice *device = devices[_videoDeviceIndex];
        
        // 看看设备能力
        AVCaptureDeviceFormat *bestFormat = nil;
        AVFrameRateRange *bestFrameRateRange = nil;
        for ( AVCaptureDeviceFormat *format in [device formats] ) {
            for ( AVFrameRateRange *range in format.videoSupportedFrameRateRanges ) {
                if ( range.maxFrameRate > bestFrameRateRange.maxFrameRate ) {
                    bestFormat = format;
                    bestFrameRateRange = range;
                }
            }
        }
        if ( bestFormat ) {
            if ( [device lockForConfiguration:NULL] == YES ) {
                device.activeFormat = bestFormat;
                device.activeVideoMinFrameDuration = bestFrameRateRange.minFrameDuration;
                device.activeVideoMaxFrameDuration = bestFrameRateRange.minFrameDuration;
                [device unlockForConfiguration];
                NSLog(@"device format set");
            }
        }
        
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
    [session addOutput:outputArray[0]];
    [session addOutput:outputArray[1]];
    NSLog(@"output device added");
    
    [session startRunning];
    
    [self switchOutputFile];
}

-(void)switchOutputFile {
    NSString *strUrl = [NSString stringWithFormat:@"yy_%d.tmp.mp4", _startIndex];
    NSURL *url = [NSURL fileURLWithPath:strUrl];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        NSError *err;
        if (![[NSFileManager defaultManager] removeItemAtPath:[url path] error:&err])
        {
            NSLog(@"Error deleting existing movie %@",[err localizedDescription]);
        }
    }
    
    [outputArray[outputIndex] startRecordingToOutputFileURL:url recordingDelegate:self];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:_cutBySeconds target:self selector:@selector(finishOneRecord:) userInfo:nil repeats:NO];
}

-(void)finishOneRecord:(NSTimer *)timer {
    [outputArray[outputIndex] stopRecording];
    NSLog(@"stopping %d", _startIndex);
    outputIndex ++;
    if (outputIndex >= outputArray.count) {
        outputIndex = 0;
    }
    _startIndex ++;
    [self switchOutputFile];
}

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    if (error) {
        NSLog(@"error: %@", error);
        NSError *err = nil;
        [[NSFileManager defaultManager] removeItemAtPath:[outputFileURL path] error:&err];
        return;
    }
    NSString *finalPath = [[outputFileURL path] stringByReplacingOccurrencesOfString:@".tmp" withString:@""];
    //NSLog(@"finished %@ %@", [outputFileURL path], finalPath);
    NSURL *finalUrl = [NSURL fileURLWithPath:finalPath];
    NSError *err = nil;
    [[NSFileManager defaultManager] moveItemAtURL:outputFileURL toURL:finalUrl error:&err];
}

@end
