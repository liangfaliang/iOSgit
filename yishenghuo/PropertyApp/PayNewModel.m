//
//  PayNewModel.m
//  PropertyApp
//
//  Created by admin on 2018/8/13.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "PayNewModel.h"

@implementation PayNewModel
-(instancetype)init{
    if (self = [super init]) {
        _isSelect = 0;
    }
    return self;
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"dqfy":@"yjfy"};
}
@end
