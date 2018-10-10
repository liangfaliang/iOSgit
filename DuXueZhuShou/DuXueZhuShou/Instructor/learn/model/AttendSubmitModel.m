//
//  AttendSubmitModel.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/29.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AttendSubmitModel.h"


@implementation placeModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"place" : @"id"};
}
@end

@implementation courseModel
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"timetable" : @"ScheduleModel"};
}
@end

@implementation AttendSubmitModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
-(instancetype)init{
    if (self = [super init]) {
        _mode = 1;
        _photoProof = 0;
    }
    return self;
}
+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"course" : @"courseModel",
             @"place" : @"placeModel"
             };
}
@end

@implementation AttendStuModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"course" : @"courseModel",
             @"place" : @"placeModel"
             };
}
@end



