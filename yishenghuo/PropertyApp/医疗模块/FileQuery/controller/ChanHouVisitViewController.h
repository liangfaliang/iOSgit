//
//  ChanHouVisitViewController.h
//  PropertyApp
//
//  Created by admin on 2018/8/28.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"

@interface ChanHouVisitViewController : BaseViewController
@property(nonatomic,copy)NSString *archive_no;
@property(nonatomic,copy)NSString *tr_InterfaceID;
-(void)InitializationData:(NSDictionary *)dict;
@end
