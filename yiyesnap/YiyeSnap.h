//
//  YiyeSnap.h
//  yiyesnap
//
//  Created by Achilles Xu on 16/5/18.
//  Copyright © 2016年 Hukaa. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

@interface YiyeSnap : NSObject<AVCaptureFileOutputRecordingDelegate> {
    int _videoDeviceIndex;
    int _audioDeviceIndex;
    int _cutBySeconds;
    int _startIndex;
    
    AVCaptureSession *session;
    int outputIndex;
    NSArray *outputArray;
    NSTimer *timer;
}


-(id)initWithVideoDeviceIndex:(int)videoDeviceIndex audioDeviceIndex:(int)audioDeviceIndex cutBySeconds:(int)cutBySeconds startIndex:(int)startIndex;

-(void)startRecording;

@end

