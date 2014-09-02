//
//  ZHFileCache.m
//  Dyrs
//
//  Created by mbp  on 13-8-15.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//





#define KDirMaxNum 500





#import "ZHFileCache.h"


ZHFileCache *instance;

@implementation ZHFileCache


#pragma mark SDImageCache (class methods)

+ (ZHFileCache *)share
{
    if (instance == nil)
    {
        instance = [[ZHFileCache alloc] init];
    }
    
    return instance;
}


- (NSString *)md5
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%f", interval];
    
    return [timeSp md5];
}

- (void)createDirectory:(NSString *)diskPath
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:diskPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
}


- (NSString *)checkFilesPath
{
    
//    NSFileManager* fm=[NSFileManager defaultManager];
//    NSArray *paths = [fm contentsOfDirectoryAtPath:diskCachePath error:nil];
//    
//    if ([paths count] == 0) {
//        
//        NSString *currentPath = [diskCachePath stringByAppendingPathComponent:[self md5]];
//        
//        [self createDirectory:currentPath];
//        return currentPath;
//    }
//    
//    
//    
//    NSString *lastPathName = [paths objectAtIndex:([paths count] -1)];
//    NSString *lastPath = [diskCachePath stringByAppendingPathComponent:lastPathName];
    

//    /files  下的dir  个数

//    目录中的 file 个数
//    NSArray *filesPath = [fm subpathsAtPath:lastPath];

//    >1  创建新文件夹
//    if ([filesPath count] >= KDirMaxNum) {
//        
//        
//
//                
//        NSString *str = [NSString stringWithFormat:@"/%@", [self md5]];
//        
//        
//        
//        [self createDirectory:[diskCachePath stringByAppendingPathComponent:str]];
//        
//        return [diskCachePath stringByAppendingPathComponent:str];
//    }
//    else {
    
        return diskCachePath;
//    }


}


- (void)saveFile:(NSData *)data filePath:(NSString *)filePath
{

    //    save  文件
    NSError *error = nil;
    
    [data writeToFile:filePath options:NSDataWritingAtomic error:&error];
    
//    #quenstion#
    if (error ==nil) {
        DLog(@"保存成功，name:%@", filePath);
    }
    else {
        DLog(@"保存失败，name:%@", filePath);
    }
}


/*
 *  保存文件
 *
 *  建立文件树系统，每个文件夹放500张图片，
 *  超过500， 创建新文件夹
 */
- (void)saveFile:(NSData *)data image:(NSDictionary *)dict
{
    
//      file name
    NSArray *splitArray = [[dict objectForKey:@"id"] componentsSeparatedByString:@"/"];
    NSString *fileName = [splitArray objectAtIndex:[splitArray count] -1] ;

//    检查 文件是否超过五百

    NSString *savePath = [self checkFilesPath];

//    
    NSString *saveAllPath  = [savePath stringByAppendingPathComponent:fileName];
    [self saveFile:data filePath:saveAllPath];

}


- (void)saveFile:(NSData *)data fileName:(NSString *)fileName
{    
    //    检查 文件是否超过五百
    
    NSString *savePath = [self checkFilesPath];
    
    //
    NSString *saveAllPath  = [savePath stringByAppendingPathComponent:fileName];
    [self saveFile:data filePath:saveAllPath];
    
}



- (NSData *)file:(NSString *)fileName
{
    
//    所有/files子目录

    
    
    NSString *filePath = KCachesName(fileName);
    NSData *data = [NSData dataWithContentsOfFile:filePath];
        
    if (data) {
        return data;
    }
    

    return nil;
}

- (void)delFile:(NSString *)fileName 
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@", diskCachePath, @"files", fileName];
    
    if ( [[NSFileManager defaultManager] removeItemAtPath:fileName error:nil]) {
        DLog(@"del sucess %@", filePath);
    }
    else {
        DLog(@"del faild %@", filePath);
    }
    
}


#define k
- (id)init
{
    if ((self = [super init]))
    {
        // Init the disk cache
        diskCachePath = [KDocumentDirectory stringByAppendingPathComponent:@"/files"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
    }
    
    return self;
}


@end
