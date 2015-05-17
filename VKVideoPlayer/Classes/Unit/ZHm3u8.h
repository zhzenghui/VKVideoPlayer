//
//  ZHm3u8.h
//  VKVideoPlayer
//
//  Created by bejoy on 14/9/2.
//  Copyright (c) 2014年 Viki Inc. All rights reserved.
//

#import <Foundation/Foundation.h>





@class DownloadList;

@protocol ZHm3u8Delegate <NSObject>

- (void)currentDownloadIndex:(DownloadList *)downloadList;
- (void)downLoadStart:(DownloadList *)downloadList;
- (void)downLoadFinish:(DownloadList *)downloadList;

@end

@interface ZHm3u8 : NSObject <UIWebViewDelegate>
{
    UIWebView *_webView;

   ;
}

@property (nonatomic, assign)  __block  BOOL isStop;

@property (nonatomic, strong) DownloadList *downloadList;
@property (nonatomic, assign) id<ZHm3u8Delegate> delegate;

+ (ZHm3u8 *)share;

- (void)loadM3u8File;


- (void)startLoad;
- (void)stopLoad;


@end
