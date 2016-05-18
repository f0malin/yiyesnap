//
//  main.m
//  yiyesnap
//
//  Created by Achilles Xu on 16/5/18.
//  Copyright © 2016年 Hukaa. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;
#import "YiyeSnap.h"

void printDevices() {
    NSArray *devices;
    devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    NSLog(@"Video devices:");
    for (int i=0;i<devices.count;i++) {
        AVCaptureDevice *device = devices[i];
        NSLog(@"\t[%d] name: %@, ID: %@", i, device.localizedName, device.uniqueID);
    }
    devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    NSLog(@"Audio devices:");
    for (int i=0;i<devices.count;i++) {
        AVCaptureDevice *device = devices[i];
        NSLog(@"\t[%d] name: %@, ID: %@", i, device.localizedName, device.uniqueID);
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc == 1) {
            printDevices();
        } else if (argc == 5) {
            int videoDeviceIndex = atoi(argv[1]);
            int audioDeviceIndex = atoi(argv[2]);
            int cutBySeconds = atoi(argv[3]);
            int startIndex = atoi(argv[4]);
            YiyeSnap *snapper = [[YiyeSnap alloc] initWithVideoDeviceIndex:videoDeviceIndex audioDeviceIndex:audioDeviceIndex cutBySeconds:cutBySeconds startIndex:startIndex];
            [snapper startRecording];
            [[NSRunLoop currentRunLoop] run];
        }
    }
    return 0;
}




