//
//  OperateListModel.m
//  DuXueZhuShou
//
//  Created by admin on 2018/9/14.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "OperateListModel.h"

@implementation OperateListModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"list" : @"OperateListModel"};
}
@end
