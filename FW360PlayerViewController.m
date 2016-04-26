//
//  FW360PlayerViewController.m
//  FW360Player
//
//  Created by Marc Giroux on 2016-04-18.
//  Copyright © 2016 5th Wall. All rights reserved.
//

#import "FW360PlayerViewController.h"

@implementation FW360PlayerViewController
@synthesize isPlaying, delegate, playerView, duration;

- (instancetype)initWithCardboard:(NSURL *)video withLicense:(NSString *)license
{
    self       = [super init];
    playerType = 1;
    
    cardboardPlayer                            = [[KMPlayer360DoubleViewController alloc] initWithContentURL:video andAppKey:license];
    cardboardPlayer.moviePlayer.delegate       = self;
    cardboardPlayer.moviePlayer.shouldAutoplay = YES;
    cardboardPlayer.moviePlayer.repeatMode     = KMMovieRepeatModeNone;
    
    isPlaying = true;
    
    // Default settings for Stepping
    cardboardPlayer.moviePlayer.stepX = 2;
    cardboardPlayer.moviePlayer.stepY = 2;
    
    // Default Fovs
    SCNView *videoView = (SCNView *)cardboardPlayer.view.subviews[0].subviews[0];
    SCNCamera *camera  = (SCNCamera *)videoView.scene.rootNode.childNodes[0].camera;
    
    camera.yFov = 60;
    camera.xFov = camera.yFov * 1.22;
    
    playerView = cardboardPlayer.view;
    duration   = CMTimeGetSeconds(cardboardPlayer.moviePlayer.duration);
    
    return self;
}

- (instancetype)initWithTouch:(NSURL *)video withLicense:(NSString *)license
{
    self       = [super init];
    playerType = 2;
    
    touchPlayer                            = [[KMPlayer360ViewController alloc] initWithContentURL:video andAppKey:license];
    touchPlayer.moviePlayer.delegate       = self;
    touchPlayer.moviePlayer.shouldAutoplay = YES;
    touchPlayer.moviePlayer.repeatMode     = KMMovieRepeatModeNone;
    
    isPlaying = true;
    
    // Default settings for Stepping
    touchPlayer.moviePlayer.stepX = 2;
    touchPlayer.moviePlayer.stepY = 2;
    
    // Default Fovs
    SCNView *videoView = (SCNView *)touchPlayer.view.subviews[0].subviews[0];
    SCNCamera *camera  = (SCNCamera *)videoView.scene.rootNode.childNodes[0].camera;
    
    camera.yFov = 60;
    camera.xFov = camera.yFov * 1.22;
    
    playerView = touchPlayer.view;
    duration   = CMTimeGetSeconds(touchPlayer.moviePlayer.duration);
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    
    return self;
}

- (void)setTouchControlSpeed:(int)x y:(int)y
{
    touchSpeedX = x;
    touchSpeedY = y;
    
    if (playerType == 1) {
        cardboardPlayer.moviePlayer.stepX = x;
        cardboardPlayer.moviePlayer.stepY = y;
    } else {
        touchPlayer.moviePlayer.stepX = x;
        touchPlayer.moviePlayer.stepY = y;
    }
}

- (void)setFieldOfView:(double)base
{
    SCNView *videoView = (SCNView *)cardboardPlayer.view.subviews[0].subviews[0];
    SCNCamera *camera  = (SCNCamera *)videoView.scene.rootNode.childNodes[0].camera;
    
    camera.yFov = base;
    camera.xFov = camera.yFov * 1.22;
}

- (void)play
{
    isPlaying = true;
    
    if (playerType == 1) {
        [cardboardPlayer.moviePlayer play];
    } else {
        [touchPlayer.moviePlayer play];
    }
}

- (void)pause
{
    isPlaying = false;
    
    if (playerType == 1) {
        [cardboardPlayer.moviePlayer pause];
    } else {
        [touchPlayer.moviePlayer pause];
    }
}

- (void)seekTotime:(int)seconds
{
    CMTimeScale videoTimeScale;
    
    if (playerType == 1) {
        videoTimeScale = [cardboardPlayer.moviePlayer getVideoTimeScale];
        [cardboardPlayer.moviePlayer pause];
    } else {
        videoTimeScale = [touchPlayer.moviePlayer getVideoTimeScale];
        [touchPlayer.moviePlayer pause];
    }
    
    CMTime seekTime = CMTimeMakeWithSeconds(seconds, videoTimeScale);
    
    if (playerType == 1) {
        [cardboardPlayer.moviePlayer seekToTime:seekTime];
        [cardboardPlayer.moviePlayer play];
    } else {
        [touchPlayer.moviePlayer seekToTime:seekTime];
        [touchPlayer.moviePlayer play];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (delegate != nil && playerType == 1) {
        [delegate FWPlayerDidTouch:self];
    }
}

- (void)didTap:(UITapGestureRecognizer *)tap
{
    if (delegate != nil) {
        [delegate FWPlayerDidTouch:self];
    }
}

#pragma mark - Player Delegate

- (void)playerPlaybackDidFinish
{
    if (delegate != nil) {
        [delegate FWPlayerDidFinishPlaying:self];
    }
}

- (void)setInitialRotation:(int)initialRotation
{
    if (playerType == 1) {
        cardboardPlayer.moviePlayer.addedRotation = initialRotation;
    } else {
        touchPlayer.moviePlayer.addedRotation = initialRotation;
    }
}

#pragma mark - Private methods

- (void)viewDidAppear:(BOOL)animated
{
    if (playerType == 1) {
        [self.view addSubview:cardboardPlayer.view];
    } else {
        [self.view addSubview:touchPlayer.view];
        [self.view addGestureRecognizer:recognizer];
    }
    
    if (delegate != nil) {
        if ([delegate respondsToSelector:@selector(FWPlayerDidAppear:)]) {
            [delegate FWPlayerDidAppear:self];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (delegate != nil) {
        if ([delegate respondsToSelector:@selector(FWPlayerDidDisappear:)]) {
            [delegate FWPlayerDidDisappear:self];
        }
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (playerType == 1) {
        return UIInterfaceOrientationMaskLandscapeRight;
    } else {
        return UIInterfaceOrientationMaskLandscape;
    }
}

-(BOOL)shouldAutorotate
{
    return YES;
}

@end
