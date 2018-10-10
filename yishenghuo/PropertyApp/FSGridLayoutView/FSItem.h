//
//  FSItem.h
//  FSGridLayoutDemo
//
//  Created by 冯顺 on 2017/6/10.
//  Copyright © 2017年 冯顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSBaseModel.h"


@interface FSItem : NSObject
@property (nonatomic, strong) NSMutableArray *itemModels;
@property (nonatomic, copy) NSString *orientation;
@property (nonatomic, assign) double space;

+ (FSItem *)getItemWithModel:(FSBaseModel *)base;
@end
