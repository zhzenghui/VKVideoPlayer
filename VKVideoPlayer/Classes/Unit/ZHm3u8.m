//
//  ZHm3u8.m
//  VKVideoPlayer
//
//  Created by bejoy on 14/9/2.
//  Copyright (c) 2014年 Viki Inc. All rights reserved.
//

#import "ZHm3u8.h"
#import "AFNetworking.h"
#import "DownloadList.h"

static ZHm3u8 *m3u8;

@interface ZHm3u8 ()
{
    NSMutableArray *urlArray;
    NSString *headerString;
}
@end

@implementation ZHm3u8

+ (ZHm3u8 *)share
{
    if ( ! m3u8) {
        m3u8 = [[ZHm3u8 alloc] init];
    }

    return m3u8;
    
}

- (id)init
{
    if (self == [super init])
    {

    }
    
    return self;
}



- (void)reBuildM3uExtinfDurationArray:(NSMutableArray *)extinfDurationArray  urlArray:(NSMutableArray *)urlArray
{
    NSMutableString *string = [NSMutableString string];
//    头部
//    [string appendString:@"#EXTM3U"];
//    [string appendString:@"\n"];
//    [string appendString:@"#EXT-X-TARGETDURATION:12"];
//    [string appendString:@"\n"];
//    [string appendString:@"#EXT-X-VERSION:2"];
//    [string appendString:@"\n"];

    //

    [string appendString:headerString];
    
    [string appendString:@"\n"];


    
    for (int i = 0; i < extinfDurationArray.count; i++) {
        
        [string appendFormat:@"#EXTINF:%@\n", extinfDurationArray[i]];
        
        NSString *s = [NSString stringWithFormat:@"%@", urlArray[i]];
        NSRange range = [s rangeOfString:@"#EXT-X-DISCONTINUITY"];
        if (range.length == 0) {
            [string appendFormat:@"%i.ts\n", i+1];
        }
        else {
            [string appendFormat:@"%i.ts\n", i+1];
            [string appendFormat:@"#EXT-X-DISCONTINUITY\n"];

        }

    }
    
    
    
//    尾部
    [string appendString:@"#EXT-X-ENDLIST"];
    
    
    
    

    
//    写入文件
    NSString *str = [NSString stringWithFormat:@"%@/m3u8.m3u", self.downloadList.identity];

    NSString *m3uPath = KCachesName(str);
    
    [string writeToFile:m3uPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
}


- (void)fileParsing:(NSString *)m3uString
{

    
//    清理m3u  数据
    
//    m3uString = [m3uString stringByReplacingOccurrencesOfString:@"#EXT-X-DISCONTINUITY" withString:@""];
    
    
    NSMutableArray *extinfArray = [NSMutableArray arrayWithArray:[m3uString componentsSeparatedByString:@"EXTINF:"]];
    

    
    
    headerString = [NSString stringWithFormat:@"%@",extinfArray[0]];

    //    去掉 头部 和 尾部
    [extinfArray removeObjectAtIndex:0];
    [extinfArray removeLastObject];
    

    //    保存音轨信息
    NSMutableArray *extinfDurationArray = [NSMutableArray array];
    //    url
    urlArray = [NSMutableArray array];
    
    for (NSString *str in extinfArray) {
        NSMutableArray *a = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"\n"]];
        NSString *str = nil;
        
        [a removeObject:@"\r"];
        [a removeObject:@"\n"];
        [a removeObject:@""];
        
        str = a[1];
        if ( a.count == 4  ) {
            if ([a[2] isEqualToString:@"#EXT-X-DISCONTINUITY"]) {
                str = [NSString stringWithFormat:@"%@\n%@", a[1], a[2]];
            }
        }

        [extinfDurationArray addObject:a[0]];
        [urlArray addObject:str];
    }
    
    
    
    self.downloadList.status = @1;
    self.downloadList.files = [NSNumber numberWithInt: extinfDurationArray.count];
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:nil];

    
    
    
    [self reBuildM3uExtinfDurationArray:extinfDurationArray urlArray:urlArray];
    
    
    [self loadNetWorkFilesForindex:[self.downloadList.currentIndex intValue]];

}

- (void)createDir
{
    
    NSString *str = [NSString stringWithFormat:@"%@/", self.downloadList.identity];
    NSString *path = KCachesName(str);
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    
    
    

    
    
    BOOL isDir = NO;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir])
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    else if (!isDir)
    {
        NSLog(@"Cannot proceed!");
        // Throw exception
    }
    
    
    
}

- (void)loadM3u8File
{
    
    
    
//   创建文件夹
    [self createDir];
    
    NSURL *URL = [NSURL URLWithString:self.downloadList.url];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request addValue:@"Mozilla/5.0(iPad; U; CPU iPhone OS 8_0 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B314 Safari/531.21.10" forHTTPHeaderField:@"User-Agent"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSString *m3uString = [NSString stringWithUTF8String:[data bytes]];
        if (m3uString.length != 0) {
            [self fileParsing:m3uString];
        }
        
    }];
    

    
    
    
}

- (void)loadNetWorkFilesForindex:(int)index
{
    

    
    if (_isStop) {
        return;
    }
    
    
    
    if ( index == urlArray.count ) {
        return;
    }
    
    NSString *urlString = urlArray[index];
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    index++;


    dispatch_queue_t queue = dispatch_queue_create("com.ple.queue", NULL);
    dispatch_async(queue, ^(void) {
        
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        
        NSString *str = [NSString stringWithFormat:@"%@/%i.ts", self.downloadList.identity, index];
        
        
        NSString *tsPath = KCachesName(str);
        
        
        

        
        if ( data ) {
            DLog(@"currentIndex  : %i", index);

//            更新下载索引
            self.downloadList.currentIndex = [NSNumber numberWithInt: index];
            
            if ([self.downloadList.currentIndex intValue] == [self.downloadList.files intValue]) {
                self.downloadList.status = [NSNumber numberWithInt: 2 ];
            }
            
            [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:nil];
            
            [data writeToFile:tsPath atomically:YES];
            

            
            dispatch_async(dispatch_get_main_queue(), ^{

                if ([self.delegate respondsToSelector:@selector(currentDownloadIndex:)]) {
                    [self.delegate currentDownloadIndex:self.downloadList];

                }
            });

            
        }
        else {
            DLog(@"error: %i ; %@", index, urlArray[index]);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadNetWorkFilesForindex:index];
            
        });
        
        
    });


}



- (void)startLoad
{
    _isStop = NO;
    self.downloadList.status = @1;

    [self loadM3u8File];

}
- (void)stopLoad
{
    
    self.downloadList.status = @3;

    _isStop = YES;
}


@end
