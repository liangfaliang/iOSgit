//
//  HealthReceiveRecordViewController.h
//  PropertyApp
//
//  Created by admin on 2018/7/31.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"

@interface HealthReceiveRecordViewController : BaseViewController
@property(nonatomic,copy)NSString *archive_no;
@property(nonatomic,copy)NSString *tr_InterfaceID;
-(void)InitializationData:(NSDictionary *)dict;
@end
