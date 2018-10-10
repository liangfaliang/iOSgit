//
//  HSDTagModel.h
//  PropertyApp
//
//  Created by admin on 2018/8/14.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSDTagModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *content; //板块
@property (nonatomic, assign) NSInteger isSelect; //
//预约时间
@property (nonatomic, copy) NSString *rs_reserveDate;
@property (nonatomic, copy) NSString *avg_num_new; //板块
@property (nonatomic, copy) NSString *reserveDQ;
@property (nonatomic, copy) NSString *syrs; //板块
@end
