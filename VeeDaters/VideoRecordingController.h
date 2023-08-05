//
//  VideoRecordingController.h
//  CustomVideoRecording
//
//  Created by 郭伟林 on 17/1/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoRecordingControllerDelegate <NSObject>
@optional
- (void)didFinishVideoRecordingController:(UIViewController * )controller;
@end

@interface VideoRecordingController : UIViewController

@property (nonatomic, weak) id <VideoRecordingControllerDelegate> delegate;

@end
