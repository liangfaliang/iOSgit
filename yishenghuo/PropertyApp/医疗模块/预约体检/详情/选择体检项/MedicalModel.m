//
//  MedicalModel.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/16.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "MedicalModel.h"

@implementation MedicalModel
-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    if (self = [super initWithDictionary:dict error:err]) {
        if (!self.Allselect) {
            self.Allselect = @"0";
        }
    }
    return self;
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
@implementation ItemModel
-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    if (self = [super initWithDictionary:dict error:err]) {
        if (!self.select) {
            self.select = @"0";
        }
    }
    return self;
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
