//
//  FW360PlayerViewController.h
//  FW360Player
//
//  Created by Marc Giroux on 2016-04-18.
//  Copyright © 2016 5th Wall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <KabooreMedia/KabooreMedia.h>

@class FW360PlayerViewController;

@protocol FW360PlayerDelegate <NSObject>

/** Event for when the video ended */
- (void)FWPlayerDidFinishPlaying:(FW360PlayerViewController *)controller;

@optional

/** Event for when the view is touched in Touch mode */
- (void)FWPlayerDidTouch:(FW360PlayerViewController *)controller;

/** Event for when the player appeared */
- (void)FWPlayerDidAppear:(FW360PlayerViewController *)controller;

/** Event for when the player disappeared */
- (void)FWPlayerDidDisappear:(FW360PlayerViewController *)controller;

@end

@interface FW360PlayerViewController : UIViewController <KMPlaybackDelegate>
{
    int touchSpeedX;
    int touchSpeedY;
    int playerType;
    KMPlayer360DoubleViewController *cardboardPlayer;
    KMPlayer360ViewController *touchPlayer;
    UITapGestureRecognizer *recognizer;
}

/** Indicates if the playing is playing */
@property (nonatomic, readonly) BOOL isPlaying;

/** Setup a delegate for the player's events */
@property (nonatomic, weak) id<FW360PlayerDelegate> delegate;

/** The actual player view */
@property (nonatomic, readonly) UIView *playerView;

/** Duration of the video */
@property (nonatomic, readonly) int duration;

/** Set KabooreMedia's key */
+ (void)setPlayerAppKey:(NSString *)key;

/** Initialize 360 player in Cardboard mode */
- (instancetype)initWithCardboard:(NSURL *)video;

/** Initiliaze 360 player in Touch mode */
- (instancetype)initWithTouch:(NSURL *)video;

/** Set the speed at which the panning will be (Touch only) */
- (void)setTouchControlSpeed:(int)x y:(int)y;

/** Set the field of view (how close/far you are from the video) */
- (void)setFieldOfView:(double)base;

/** Seek to specific time (in seconds) */
- (void)seekTotime:(int)seconds;

/** Play video */
- (void)play;

/** Pause video */
- (void)pause;

@end
