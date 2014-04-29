//
//  BlitFeedback.h
//  BlitFeedback
//
//  Created by jorge cabezas garcia on 26/04/13.
//  Copyright (c) 2013 blit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//----------------------------------
// Dependencies: AVFoundation, CoreVideo, CoreMedia, libz.dylib, MediaPlayer, QuartzCore, MessageUI, SystemConfiguration, CoreFoundation
//

@protocol BlitFeedbackDelegate <NSObject>
- (void) reportSent;
- (void) reportFailed;
- (void) reportCancelled;
@end

@interface BlitFeedback : NSObject
{
    
}

+ (BlitFeedback *) sharedInstance;

@property (nonatomic, weak) id<BlitFeedbackDelegate> delegate;

- (void) start:(NSString *)_key;
- (void) attach;
- (void) attach:(UIWindow *)_window;
- (void) detach;
- (BOOL)redirectNSLog:(BOOL)_redirect;

#pragma mark custom integration methods

- (BOOL) enterFeedbackScreen;
- (BOOL) enterFeedbackScreenWithImage:(UIImage *)_image;
- (BOOL) captureScreenshot;
- (BOOL) startScreencast;
- (BOOL) stopScreencast;

#pragma mark -
@end
