//
//  AppFMDBTool.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/6.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SynthesizeSingleton.h" //快速声明和实现单例的

@interface AppFMDBTool : NSObject
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(AppFMDBTool);

-(void)saveDataArray:(NSArray *)dataArray dataType:(NSString *)dataType;

- (NSArray *)cachedDataWithDataType:(NSString *)dataType;

- (NSString *)timeDataWithDataType:(NSString *)dataType;

@end
