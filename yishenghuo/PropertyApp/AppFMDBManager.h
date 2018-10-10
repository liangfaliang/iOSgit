//
//  AppFMDBManager.h
//  shop
//
//  Created by 梁法亮 on 16/5/23.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuModel.h"
#import "SynthesizeSingleton.h" //快速声明和实现单例的

typedef void(^GetAllBlock)(NSMutableArray *modelArray);


@interface AppFMDBManager : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(AppFMDBManager);

/**
 *  缓存网络请求数据
 *
 *  @param dataArray 请求的网络数据（数组）
 *  @param dataType  数据类型（）
 */
-(void)saveDataArray:(NSArray *)dataArray dataType:(NSString *)dataType;


/**
 *  从沙盒获取数据
 *
 *  @param param 数据类型
 *
 *  @return 返回从沙盒获取的数据
 */
- (NSArray *)cachedDataWithDataType:(NSString *)dataType;

- (NSString *)timeDataWithDataType:(NSString *)dataType;
-(void)deleteDataWithDataType:(NSString *)dataType;//删除数据
@end
