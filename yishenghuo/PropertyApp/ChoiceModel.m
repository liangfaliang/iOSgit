//
//  ChoiceModel.m
//  shop
//
//  Created by 梁法亮 on 16/8/18.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "ChoiceModel.h"

@implementation ChoiceModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

//+ (NSDictionary *)objectClassInArray{
//    return @{@"adDet":[OptionModel class]};
//}


@end
@implementation OptionModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}



@end