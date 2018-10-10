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
+(NSDictionary *)mj_objectClassInArray{
    return @{@"child":@"TextFiledModel"};
}
@end
