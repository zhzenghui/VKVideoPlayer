//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//



typedef NS_ENUM(NSInteger, SouceType) {
    
    SouceTypeLocal,
    SouceTypeRemote
    
};

#import <UIKit/UIKit.h>
#import "VKVideoPlayer.h"

@class DownloadList;
@interface DemoVideoPlayerViewController : UIViewController<
  VKVideoPlayerDelegate, UIWebViewDelegate
>
{
    
    SouceType souceType;
    
}



@property (nonatomic, strong) VKVideoPlayer* player;

@property (nonatomic, strong) DownloadList *downloadList;



@end
