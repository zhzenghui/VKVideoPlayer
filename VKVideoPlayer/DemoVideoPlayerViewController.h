//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKVideoPlayer.h"

@class DownloadList;
@interface DemoVideoPlayerViewController : UIViewController<
  VKVideoPlayerDelegate, UIWebViewDelegate
>
{
}

@property (nonatomic, strong) VKVideoPlayer* player;

@property (nonatomic, strong) DownloadList *downloadList;



@end
