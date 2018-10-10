//
//  JWCacheManager.m
//  ImageScrollView
//
//  Created by 黄金卫 on 16/4/8.
//  Copyright © 2016年 黄金卫. All rights reserved.
//

#import "JWCacheManager.h"

@implementation JWCacheManager

//1
+(CGFloat)getCacheSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        CGFloat size = 0;
        NSArray *childFolder = [fileManager subpathsAtPath:path];
        for (NSString *name in childFolder)
        {
            NSString *subPath = [path stringByAppendingPathComponent:name];
            size += [JWCacheManager sizeOfSubPath:subPath];
        }
        return size;
    }
    return 0;
}
+(CGFloat)sizeOfSubPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        CGFloat size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size /1024.0/1024.0;
    }
    return 0;
}



//2
+(BOOL)clearCacheAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        
        NSArray *childFolders = [fileManager subpathsAtPath:path];
        for (NSString *folderName in childFolders)
        {
            NSString *subPath = [path stringByAppendingPathComponent:folderName];
            [fileManager removeItemAtPath:subPath error:nil];
        }
    }
    return YES;
}




@end
