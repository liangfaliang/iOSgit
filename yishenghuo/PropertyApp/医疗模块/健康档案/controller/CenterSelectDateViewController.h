//
//  CenterSelectDateViewController.h
//  PropertyApp
//
//  Created by admin on 2018/7/26.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"

@interface CenterSelectDateViewController : BaseViewController
@property (copy, nonatomic)void (^SelectBlock)(NSString *time ,NSString *timeS);
@end
