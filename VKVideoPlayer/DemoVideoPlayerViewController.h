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
#import "DownloadList.h"
#import "AllBaseViewController.h"


@interface DemoVideoPlayerViewController : AllBaseViewController<UIAlertViewDelegate,
  VKVideoPlayerDelegate, UIWebViewDelegate
>
{
    
    SouceType souceType;
    
}



@property (nonatomic, strong) VKVideoPlayer* player;

@property (nonatomic, strong) DownloadList *downloadList;

@property (nonatomic, assign) BOOL isPlayLocal;

@end
