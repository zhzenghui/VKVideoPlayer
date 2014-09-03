//
//  ZHm3u8.m
//  VKVideoPlayer
//
//  Created by bejoy on 14/9/2.
//  Copyright (c) 2014年 Viki Inc. All rights reserved.
//

#import "ZHm3u8.h"
#import "AFNetworking.h"

@interface ZHm3u8 ()
{
    NSMutableArray *urlArray;
}
@end

@implementation ZHm3u8

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
    [string appendString:@"#EXTM3U"];
    [string appendString:@"\n"];
    [string appendString:@"#EXT-X-TARGETDURATION:12"];
    [string appendString:@"\n"];
    [string appendString:@"#EXT-X-VERSION:2"];
    [string appendString:@"\n"];
//    段
    
    
    for (int i = 0; i < extinfDurationArray.count; i++) {
        [string appendFormat:@"#EXTINF:%@\n", extinfDurationArray[i]];
        [string appendFormat:@"%i.ts\n", i];
    }
    
    
    
//    尾部
    [string appendString:@"#EXT-X-ENDLIST"];
    
    
    
    

    
//    写入文件
    NSString *m3uPath = KCachesName(@"m3u8-1.m3u");
    
    [string writeToFile:m3uPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
}


- (void)fileParsing:(NSString *)m3uString
{

    
//    清理m3u  数据
    
    m3uString = [m3uString stringByReplacingOccurrencesOfString:@"#EXT-X-DISCONTINUITY" withString:@""];
    
    
    NSMutableArray *extinfArray = [NSMutableArray arrayWithArray:[m3uString componentsSeparatedByString:@"EXTINF:"]];
    
    //
    //    去掉 头部 和 尾部
    [extinfArray removeObjectAtIndex:0];
    [extinfArray removeLastObject];
    
    
    
    
    //    保存音轨信息
    NSMutableArray *extinfDurationArray = [NSMutableArray array];
    //    url
    urlArray = [NSMutableArray array];
    
    for (NSString *str in extinfArray) {
        NSMutableArray *a = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"\n"]];
        
        [a removeObject:@"\r"];
        [a removeObject:@"\n"];
        [a removeObject:@""];
        [extinfDurationArray addObject:a[0]];
        [urlArray addObject:a[1]];
    }
    
    
    
    
    [self reBuildM3uExtinfDurationArray:extinfDurationArray urlArray:urlArray];
    
    [self loadNetWorkFilesForindex:0];

}

- (void)loadM3u8File:(NSURL *)url
{
    __block NSString *m3uString;
    dispatch_queue_t queue = dispatch_queue_create("com.ple.queue", NULL);
    dispatch_async(queue, ^(void) {
        
        m3uString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (m3uString.length != 0) {
                [self fileParsing:m3uString];                
            }
        });
        
        
    });

    
    
    
}

- (void)loadNetWorkFilesForindex:(int)index
{
    


    if ( index == urlArray.count ) {
        
        return;
    }
    
    NSString *urlString = urlArray[index];
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    

    
    
    
    
    index ++;

 
    
  

    
    dispatch_queue_t queue = dispatch_queue_create("com.ple.queue", NULL);
    dispatch_async(queue, ^(void) {
        
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        
        NSString *str = [NSString stringWithFormat:@"%i.ts", index];
        NSString *tsPath = KCachesName(str);
        
        if ( data ) {
            DLog(@"%i", index);
            [data writeToFile:tsPath atomically:YES];
        }
        else {
            DLog(@"error: %i ; %@", index, urlArray[index]);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self loadNetWorkFilesForindex:index];
            
        });
        
        
    });


}

@end
