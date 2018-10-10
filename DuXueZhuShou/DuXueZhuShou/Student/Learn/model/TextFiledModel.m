//
//  TextFiledModel.m
//  PropertyApp
//
//  Created by admin on 2018/7/20.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "TextFiledModel.h"

@implementation TextFiledModel
-(instancetype)init{
    if (self = [super init]) {
        _isSelect = 0;
    }
    return self;
}
@end
@implementation TextSectionModel
-(instancetype)init{
    if (self = [super init]) {
        _isSelect = 0;
    }
    return self;
}
+(NSDictionary *)mj_objectClassInArray{
    return @{@"child":@"TextFiledModel"};
}
@end
@implementation IDnameModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
@end
