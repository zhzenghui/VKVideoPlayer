//
//  DownloadList.h
//  VKVideoPlayer
//
//  Created by bejoy on 14/9/5.
//  Copyright (c) 2014年 Viki Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DownloadList : NSManagedObject

@property (nonatomic, retain) NSNumber * currentIndex;
@property (nonatomic, retain) NSNumber * files;
@property (nonatomic, retain) NSNumber * identity;
@property (nonatomic, retain) NSNumber * playAndDownload;
@property (nonatomic, retain) NSNumber * playTime;
@property (nonatomic, retain) NSNumber * status; //0  1 下载中 2 完成
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * viewCount;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSDate * update;

@end
