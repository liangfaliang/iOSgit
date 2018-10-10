//
//  Person.m
//  UILocalizedIndexedCollationDemo
//
//  Created by 吴珂 on 15/9/22.
//  Copyright © 2015年 MyCompany. All rights reserved.
//

#import "Person.h"

@implementation Person


- (instancetype)initWithName:(NSDictionary *)dt
{
    if (self = [super init]) {
        self.le_name = dt[@"le_name"];
        self.leid = dt[@"leid"];
        self.company = dt[@"company"];
        self.coid = dt[@"coid"];
        self.city = dt[@"city"];
        self.ciid = dt[@"ciid"];
        self.province = dt[@"province"];
        self.prid = dt[@"prid"];
    }
    
    return self;
}
@end
