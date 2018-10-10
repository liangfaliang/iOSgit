//
//  StuSignInModel.m
//  DuXueZhuShou
//
//  Created by admin on 2018/9/5.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "StuSignInModel.h"
@implementation SignModel
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"place" : @"placeModel"};
}
@end

@implementation StuSignInModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"place" : @"placeModel",
             @"sign_in" : @"SignModel",
             @"sign_out" : @"SignModel"
             };
}
@end
