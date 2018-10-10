//
//  HypertensionViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/8/28.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"

@interface HypertensionViewController : BaseViewController
@property(nonatomic,copy)NSString *archive_no;
@property(nonatomic,copy)NSString *tr_InterfaceID;
-(void)InitializationData:(NSDictionary *)dict;
@end
