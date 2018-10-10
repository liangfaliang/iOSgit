//
//  Person.h
//  UILocalizedIndexedCollationDemo
//
//  Created by 吴珂 on 15/9/22.
//  Copyright © 2015年 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

- (instancetype) initWithName:(NSDictionary *)dt;

@property (nonatomic, copy) NSString *coid;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *le_name;
@property (nonatomic, copy) NSString *leid;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *ciid;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *prid;

@end
