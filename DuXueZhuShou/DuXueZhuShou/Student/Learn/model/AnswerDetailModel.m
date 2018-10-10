//
//  AnswerDetailModel.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AnswerDetailModel.h"
@implementation ReplyModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
+(NSDictionary *)mj_objectClassInArray{
    return @{@"children":@"ReplyModel"};
}
@end

@implementation AnswerDetailModel
+(NSDictionary *)mj_objectClassInArray{
    return @{@"answers":@"ReplyModel"};
}
@end
@implementation IgDetailModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
@end
