//
//  ZHm3u8.h
//  VKVideoPlayer
//
//  Created by bejoy on 14/9/2.
//  Copyright (c) 2014年 Viki Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DownloadList;
@interface ZHm3u8 : NSObject <UIWebViewDelegate>
{
    UIWebView *_webView;
}


@property (nonatomic, strong) DownloadList *downloadList;


- (void)loadM3u8File;



@end
