//
//  JWCacheManager.h
//  ImageScrollView
//
//  Created by 黄金卫 on 16/4/8.
//  Copyright © 2016年 黄金卫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JWCacheManager : NSObject


+(CGFloat)getCacheSizeAtPath:(NSString *)path;


+(BOOL)clearCacheAtPath:(NSString *)path;



@end
