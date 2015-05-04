//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "DemoVideoPlayerViewController.h"
#import "VKVideoPlayer.h"
#import "VKVideoPlayerCaptionSRT.h"
#import "ZHm3u8.h"
#import "DownLoadList.h"


@interface DemoVideoPlayerViewController ()
@property (nonatomic, strong) NSString *currentLanguageCode;
@end

@implementation DemoVideoPlayerViewController

- (void)downloadVideo
{
    
    

    if (self.downloadList.status != 0) {
        NSString *str = [NSString stringWithFormat:@"%@ 已经在下载了", self.downloadList.title];
        
        [[Message share] messageAlert:str];
//        [[Message share] messageAlert:str delegate:self];
//      提醒 已经下载
        
//        return;
    }


    ZHm3u8 *m3u = [[ZHm3u8 alloc] init];
    m3u.downloadList = self.downloadList;

    [m3u loadM3u8File];
    
    
    
    
}

- (void)viewDidLoad {
  [super viewDidLoad];
 
    
    
  self.player = [[VKVideoPlayer alloc] init];
  self.player.delegate = self;
  self.player.view.frame = self.view.bounds;
  [self.view addSubview:self.player.view];
  
  [self addDemoControl];
    

    
}





- (void)viewDidAppear:(BOOL)animated {
    
    

    [super viewDidAppear:YES];

   


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if ( [self.downloadList.status intValue] == 2 ) {
        
        [self playSampleClip2];
        souceType = SouceTypeLocal;
        
    }
    else {
        [self playSampleClip1];
        souceType = SouceTypeRemote;
    }
    
}


- (BOOL)prefersStatusBarHidden {
  return NO;
}

- (BOOL)shouldAutorotate {
  return YES;
}

- (void)playSampleClip1 {

    NSURL *url = [NSURL URLWithString:self.downloadList.url];

    [self playStream:url];
}
- (void)playSampleClip2 {

    NSString *str = [NSString stringWithFormat:@"http://localhost:12345/%@/m3u8.m3u", self.downloadList.identity];
    str = @"http://192.168.199.104:1314/leaked%20photos%20on%202014-09-01%20from%20iCloud/Jessica%20Brown%20Findlay/irb1NDIA_tyo.mov";
    [self playStream:[NSURL URLWithString: str ]];
    

}

- (void)loadSeek
{
    int seekToTime = [self.downloadList.playTime intValue];
    NSLog(@"loading  video success %i", seekToTime);
    
    
    [self.player seekToTimeInSecond:seekToTime userAction:NO completionHandler:^(BOOL finished) {
        
        
        if (finished) {
            [self.player playContent];
        }
        
    }];
    
}

- (void)playStream:(NSURL*)url {
  VKVideoPlayerTrack *track = [[VKVideoPlayerTrack alloc] initWithStreamURL:url];
  track.hasNext = YES;

    [track setTitle:self.downloadList.title];
    [self.player loadVideoWithTrack:track ];

    [self.player clearCaptions];

    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loadSeek) userInfo:nil repeats:NO];
    
    
}





- (VKVideoPlayerCaption*)testCaption:(NSString*)captionName {
  NSString *filePath = [[NSBundle mainBundle] pathForResource:captionName ofType:@"srt"];
  NSData *testData = [NSData dataWithContentsOfFile:filePath];
  NSString *rawString = [[NSString alloc] initWithData:testData encoding:NSUTF8StringEncoding];
  
  VKVideoPlayerCaption *caption = [[VKVideoPlayerCaptionSRT alloc] initWithRawString:rawString];
  return caption;
}

- (void)addDemoControl {
  
//  UIButton *playSample1Button = [UIButton buttonWithType:UIButtonTypeCustom];
//  playSample1Button.frame = CGRectMake(10,40,80,40);
//  [playSample1Button setTitle:@"remote" forState:UIControlStateNormal];
//  [playSample1Button addTarget:self action:@selector(playSampleClip1) forControlEvents:UIControlEventTouchUpInside];
//  [self.player.view addSubviewForControl:playSample1Button];
//
//  UIButton *playSample2Button = [UIButton buttonWithType:UIButtonTypeCustom];
//  playSample2Button.frame = CGRectMake(100,40,80,40);
//  [playSample2Button setTitle:@"local" forState:UIControlStateNormal];
//  [playSample2Button addTarget:self action:@selector(playSampleClip2) forControlEvents:UIControlEventTouchUpInside];
//  [self.player.view addSubviewForControl:playSample2Button];

//    UILabel *lable= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
//    lable.text = self.downloadList.title;
//    lable.textAlignment = NSTextAlignmentCenter;
//    [self.player.view addSubviewForControl:lable];
    

    
    
    UIButton *xiazaiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    xiazaiButton.frame = CGRectMake(screen_Height - 80,20,80,40);
    [xiazaiButton setTitle:@"下载" forState:UIControlStateNormal];
    [xiazaiButton addTarget:self action:@selector(downloadVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.player.view addSubviewForControl:xiazaiButton];


}

#pragma mark - VKVideoPlayerControllerDelegate
- (void)videoPlayer:(VKVideoPlayer*)videoPlayer didControlByEvent:(VKVideoPlayerControlEvent)event {
  NSLog(@"%s event:%d", __FUNCTION__, event);
  __weak __typeof(self) weakSelf = self;

  if (event == VKVideoPlayerControlEventTapDone) {
      NSLog(@"%f", self.player.currentTime );
      self.downloadList.playTime = [NSNumber numberWithDouble: self.player.currentTime];
      
      [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
      }];
    [self dismissViewControllerAnimated:YES completion:nil];
  }
  
  if (event == VKVideoPlayerControlEventTapCaption) {
    RUN_ON_UI_THREAD(^{
      VKPickerButton *button = self.player.view.captionButton;
      NSArray *subtitleList = @[@"JP", @"EN"];
      
      if (button.isPresented) {
        [button dismiss];
      } else {
        weakSelf.player.view.controlHideCountdown = -1;
        [button presentFromViewController:weakSelf title:NSLocalizedString(@"settings.captionSection.subtitleLanguageCell.text", nil) items:subtitleList formatCellBlock:^(UITableViewCell *cell, id item) {
          
          NSString* code = (NSString*)item;
          cell.textLabel.text = code;
          cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%%", @"50"];
        } isSelectedBlock:^BOOL(id item) {
          return [item isEqualToString:weakSelf.currentLanguageCode];
        } didSelectItemBlock:^(id item) {
          [weakSelf setLanguageCode:item];
          [button dismiss];
        } didDismissBlock:^{
          weakSelf.player.view.controlHideCountdown = kPlayerControlsAutoHideTime;
        }];
      }
    });
  }
}

- (void)setLanguageCode:(NSString*)code {
  self.currentLanguageCode = code;
  VKVideoPlayerCaption *caption = nil;
  if ([code isEqualToString:@"JP"]) {
    caption = [self testCaption:@"Japanese"];
  } else if ([code isEqualToString:@"EN"]) {
    caption = [self testCaption:@"English"];
  }
  if (caption) {
    [self.player setCaptionToBottom:caption];
    [self.player.view.captionButton setTitle:[code uppercaseString] forState:UIControlStateNormal];
  }
}



- (NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}


@end
