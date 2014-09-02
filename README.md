# VKVideoPlayer

![VKVideoPlayer](http://engineering.viki.com/images/blog/video_player_running_man.jpg)

VKVideoPlayer is the same battle tested video player used in our [Viki iOS App](https://itunes.apple.com/app/id445553058?mt=8&&referrer=click%3Dda6fe9d2-66b5-4f5e-a45e-8aa1eb02b82b) enjoyed by millions of users all around the world.

[Read The Intro on Our Engineering Blog](http://engineering.viki.com/blog/2014/a-full-featured-custom-video-player-for-ios-vkvideoplayer/)

Some of the  advance features are:
- Fully customizable UI
- No full screen restrictions (have it any size and position you would like!)
- Display subtitles (SRT supported out of the box)
- Customize subtitles (use CSS for styling courtesy of DTCoreText)
- Supports HTTP Live Streaming protocol
- Orientation change support (even when orientation lock is enabled)
- Bulletproof event machine to easily integrate features like video ads
- Lots of delegate callbacks for your own logging requirements

## Introduction & Dev Notes

The VKVideoPlayer is a simple plugin that will handle all the technical details for video playback. By default, the library utilizes the `AVPlayer` and `AVPlayerItem` classes to play a video on a `VKVideoPlayerView`. This is achieved by passing in a track object implementing the `VKVideoPlayerTrackProtocol` protocol. The default video player will create the `AVPlayer` and `AVPlayerItem` objects to play the video.

### States
There are a total of 7 possible states that the video player can be in. Note that you **SHOULD NOT** manually change the player state by calling the setter method (e.g. `player.state = VKVideoPlayerStateContentPaused`). Instead, use the available APIs to issue commands to the player and let the state machine maintain it's state.
The details are as follows:

-   VKVideoPlayerStateUnknown

    This is the initial state that the player starts it. It is basically an idle state with no media loaded.

-   VKVideoPlayerStateContentLoading
    
    This state occurs when content is being loaded, typically by calling the `loadVideoWithTrack:` method.

-   VKVideoPlayerStateContentPaused

    This state occurs when content has been loaded but is not playing. There are several methods or commands that will trigger this state, to name a few:

    - `playerItemReadyToPlay`
    - `pauseContent`
    - `scrubbingBegin`

-   VKVideoPlayerStateContentPlaying
    
    This state occurs when content is being played by the video player. There are several methods or commands that will trigger this state, to name a few:

    - `playContent`
    - `scrubbingEnd`
    - `seekToLastWatchedDuration`

-   VKVideoPlayerStateSuspend
    
    This state occurs when an ad is playing. You can trigger this state by calling the `beginAdPlayback` method. To exit this state, call the `endAdPlayback` method.

-   VKVideoPlayerStateError

    This state occurs when there was an error loading or playing content.

-   VKVideoPlayerStateDismissed
    
    This state occurs when the video player is dismissed. It should no longer respond to commands. Trigger this state by calling the `dismiss` method.

## Usage

To run the Demo project; clone the repo, and run `pod install` from the VKVideoPlayer directory first.
After installed pod, open `VKVideoPlayer.xcworkspace` in Xcode to run Demo Application.

## Installation

VKVideoPlayer is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "VKVideoPlayer", "~> 0.1.1"

## Getting Started
The easiest way to start playing content via HLS is to simply call the `playVideoWithStreamURL:` method after initializing a `VKVideoPlayerViewController`.

    VKVideoPlayerViewController *viewController = [[VKVideoPlayerViewController alloc] init];
    [self presentModalViewController:viewController animated:YES];
    [viewController playVideoWithStreamURL:[NSURL URLWithString:@"http://content.viki.com/test_ios/ios_240.m3u8"]];

Alternatively, you can initialize a `VKVideoPlayer` object and supply it a `VKVideoPlayerView` view. After the video player has been initialized, load in a track object implementing the `VKVideoPlayerTrackProtocol` protocol. Depending on your autoplay settings (using the shouldVideoPlayer:startVideo: delegate method), you can then play the video.

    VKVideoPlayer *player = [[VKVideoPlayer alloc] initWithVideoPlayerView:aVideoPlayerView];
    id<VKVideoPlayerTrackProtocol> track = aTrackObject;
    [player loadVideoWithTrack:track];

    // If not auto playing, play content some time later
    // NOTE: Content will only be played after the AVPlayerItem and AVPlayer is ready to play
    [player playContent];

## Customize
### Video Player
The best way to customize the video player is to subclass the `VKVideoPlayer` class and override existing methods or create new methods. Understanding the state machine and the commands which trigger different states will help you implement new control flows without messing with the internal state machine. You use this method to implement additional features like Ads, or Google Cast etc.

For example, if you want to use a separate player (e.g. Google Cast) instead of the `AVPlayer` class, you can subclass the VKVideoPlayer object and override the `initPlayerWithTrack:` method, defining your own implementation in the overridden method. Note that whatever player you use **MUST** implement the `VKPlayer` protocol.

    @interface MyVideoPlayer : VKVideoPlayer <...>
    ...
    @end

    @implementation MyVideoPlayer
    ...
    - (void)initPlayerWithTrack:(id<VKVideoPlayerTrackProtocol>)track {
      if (shouldUseChromeCast) {
        // Get stream
        NSURL *streamURL = [track streamURL];
        
        // If no stream found, return
        if (!streamURL) return;

        // Change state to loading
        self.state = VKVideoPlayerStateContentLoading;

        // Init the player
        self.player = [MyChromeCastPlayer newPlayer];   // MyChromeCastPlayer class MUST implement the VKPlayer protocol
        [self.player loadStreamUrl:streamURL];
      }
      else {
        // Use default AVPlayer
        [super initPlayerWithTrack:track];
      }
    }
    ...
    @end

### Video Player View
You can play the video in any `UIView`. Simply add the player's view to your `UIView`.

    self.player = [[VKVideoPlayer alloc] initWithVideoPlayerView:[[VKVideoPlayerView alloc] init]];
    self.player.delegate = self;
    [self.view addSubview:self.player.view]

You can also customize `VKVideoPlayerView` by adding or removing controls using the following methods:

    - (void)addSubviewForControl:(UIView *)view;
    - (void)addSubviewForControl:(UIView *)view toView:(UIView*)parentView;
    - (void)addSubviewForControl:(UIView *)view toView:(UIView*)parentView forOrientation:(UIInterfaceOrientationMask)orientation;

Example:

    // Display newButton when screen is landscape mode.
    [self.player.view addSubviewForControl:newButton toView:self.player.view forOrientation:UIInterfaceOrientationMaskLandscape]


### Orientation
You can configure the the video player's orientation settings with the following properties.

    @property (nonatomic, assign) BOOL forceRotate;   // changes auto orientation behavior

Setting `forceRotate` to `YES` will automatically enable a `fullScreenButton` which will forcefully rotate the video player to full screen landscape mode. Rotating the phone to landscape will also rotate the video player to full screen.

Setting `forceRotate` to `NO` will disable any video player rotation.

    @property (nonatomic, assign) CGRect portraitFrame;
This property defines the frame of the video player view when it is in portrait mode.

    @property (nonatomic, assign) CGRect landscapeFrame;
This property defines the frame of the video player view when it is in landscape mode.

### Subtitles
There are two main ways to customize subtitles.

The first and simplest method is use the `VKSharedUtility` singleton to set the subtitle size using the key `kVKSettingsSubtitleSizeKey`. There are 3 default values.

    // value accepts @0, @1, @2 or @3;
    // @0 : Tiny
    // @1 : Medium
    // @2 : Large
    // @3 : Huge
    [VKSharedUtility setValue:@1 forKey:kVKSettingsSubtitleSizeKey];

Alternatively, you can manually override the `captionStyleSheet:` method to customize your subtitle style using CSS.

    - (DTCSSStylesheet*)captionStyleSheet:(NSString*)color {
      float fontSize = 1.3f;
      float shadowSize = 1.0f;

      switch ([[VKSharedUtility setting:kVKSettingsSubtitleSizeKey] integerValue]) {
        case 1:
          fontSize = 1.5f;
          break;
        case 2:
          fontSize = 2.0f;
          shadowSize = 1.2f;
          break;
        case 3:
          fontSize = 3.5f;
          shadowSize = 1.5f;
          break;
      }

      DTCSSStylesheet* stylesheet = [[DTCSSStylesheet alloc] initWithStyleBlock:[NSString stringWithFormat:@"body{\
        text-align: center;\
        font-size: %fem;\
        font-family: Helvetica Neue;\
        font-weight: bold;\
        color: %@;\
        text-shadow: -%fpx -%fpx %fpx #000, %fpx -%fpx %fpx #000, -%fpx %fpx %fpx #000, %fpx %fpx %fpx #000;\
        vertical-align: bottom;\
        }", fontSize, color, shadowSize, shadowSize, shadowSize, shadowSize, shadowSize, shadowSize, shadowSize, shadowSize, shadowSize, shadowSize, shadowSize, shadowSize]];
      return stylesheet;
    }


### Delegate methods
VKVideoPlayer uses the `VKVideoPlayerDelegate` protocol to communicate with its delegate.
You can use these methods for logging or control flow purposes. All the methods defined are `@optional`.

    - (BOOL)shouldVideoPlayer:(VKVideoPlayer*)videoPlayer changeStateTo:(VKVideoPlayerState)toState;
This method is called before a state change occurs. You can prevent the state change by returning `NO`.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer willChangeStateTo:(VKVideoPlayerState)toState;
This method is called after a state change is guaranteed to occur, but before it actually occurs.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer didChangeStateFrom:(VKVideoPlayerState)fromState;
This method is called after a state change occurs.

    - (BOOL)shouldVideoPlayer:(VKVideoPlayer*)videoPlayer startVideo:(id<VKVideoPlayerTrackProtocol>)track;
This method is called after a video has been loaded and is ready to play. Returning `YES` will automatically begin playback.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer willStartVideo:(id<VKVideoPlayerTrackProtocol>)track;
This method is called before starting playback.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer didStartVideo:(id<VKVideoPlayerTrackProtocol>)track;
This method is called after starting playback.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer didPlayFrame:(id<VKVideoPlayerTrackProtocol>)track time:(NSTimeInterval)time lastTime:(NSTimeInterval)lastTime;
This method is called every second during video playback. You can use it to update external models or views based on the values passed.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer didPlayToEnd:(id<VKVideoPlayerTrackProtocol>)track;
This method is called when a video has been played to the end. You can use it to play the next video.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer didControlByEvent:(VKVideoPlayerControlEvent)event;
This method is called when user input is generated.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer didChangeSubtitleFrom:(NSString*)fronLang to:(NSString*)toLang;
This method is called when a user changes the bottom caption (subtitle) language.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer willChangeOrientationTo:(UIInterfaceOrientation)orientation;
This method is called before the video player rotates to a new orientation.

    - (void)videoPlayer:(VKVideoPlayer*)videoPlayer didChangeOrientationFrom:(UIInterfaceOrientation)orientation;
This method is called after the video player rotates to a new orientation.

    - (void)handleErrorCode:(VKVideoPlayerErrorCode)errorCode track:(id<VKVideoPlayerTrackProtocol>)track customMessage:(NSString*)customMessage;
This method is called when an error occurs.


## Available Subtitle Formats
- SRT

## Requirements

iOS 5.0 or later

## Credits

This project uses the following 3rd party libraries:

- DTCoreText
- CocoaLumberjack

## License

VKVideoPlayer is licensed under the Apache License, Version 2.0. See the LICENSE file for more info.
