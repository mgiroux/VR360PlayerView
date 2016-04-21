# Native 360 Player for iOS
---

### Note

This library can be used in Objedtive-C and Swift 2+.

### Install

You must first download the trial version or the full version of the Kaboore 360 Player on
[Kaboore's official site](http://kaboore.com/#products).

You need to include the framework in your project and Apple's SceneKit framework.

	#import <SceneKit/SceneKit.h>
	#import <KabooreMedia/KabooreMedia.h>

Note that you have to add the _kaboore_ framework to the "Embedded Binaries" section in your project.

### Loading the player

You have 2 choices as of now. Cardboard or Touch. You have 2 init methods, 1 for each type.

Objective-C

```objective-c
	player          = [[FW360PlayerViewController alloc] initWithCardboard:url];
	player.delegate = self;
	[self presentViewController:player animated:YES completion:nil];
```

Swift

```swift
	player          = FW360PlayerViewController(cardboard: url);
	player.delegate = self;
	self.presentViewController(player, animated: YES, completion: nil);
```

The player should load and start playing

For TouchPlayer:	

Objective-C 

```objective-c
	player = [[FW360PlayerViewController alloc] initWithTouch:url];
	player.delegate = self;
	[self presentViewController:player animated:YES completion:nil];
```

Swift
	
```swift
	player          = FW360PlayerViewController(touch: url);
	player.delegate = self;
	self.presentViewController(player, animated: YES, completion: nil);
```	

To work properly, you view controller needs to implement the `FW360PlayerDelegate` protocol. There is 2 optional methods called `FWPlayerDidAppear` and `FWPlayerDidDisappear` that you can use to perform tasks after the view appeared and after it disappeared.

You have access to `play` and `pause` for the player. You can also seek programatically with `seekToTime` and you can set the speed of the touch controls and fields of view (Fov) with `setToucheControlSpeed` and `setFieldOfView`.

You also have access to the following properties: `duration`, `isPlaying` and `playerView`.