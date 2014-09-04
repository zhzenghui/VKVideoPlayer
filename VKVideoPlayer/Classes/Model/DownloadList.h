//
//  DownloadList.h
//  VKVideoPlayer
//
//  Created by bejoy on 14/9/4.
//  Copyright (c) 2014年 Viki Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DownloadList : NSManagedObject

@property (nonatomic, retain) NSNumber * identity;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * status;        // 0  最近播放  1 下载中  2 下载完成
@property (nonatomic, retain) NSNumber * currentIndex;  //  当前下载的  index
@property (nonatomic, retain) NSNumber * files;         //   m3u  有多少文件
@property (nonatomic, retain) NSNumber * playTime;      //  当前的播放进度
@property (nonatomic, retain) NSNumber * playAndDownload;  //  允许在播放的时候下载视频



@end
