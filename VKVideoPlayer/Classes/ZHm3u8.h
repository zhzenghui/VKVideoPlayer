//
//  ZHm3u8.h
//  VKVideoPlayer
//
//  Created by bejoy on 14/9/2.
//  Copyright (c) 2014年 Viki Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHm3u8 : NSObject <UIWebViewDelegate>
{
    UIWebView *_webView;
}


- (void)loadM3u8File:(NSURL *)url;



@end
