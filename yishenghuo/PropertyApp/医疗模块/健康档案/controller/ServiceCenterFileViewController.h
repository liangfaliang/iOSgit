//
//  ServiceCenterFileViewController.h
//  PropertyApp
//
//  Created by admin on 2018/7/20.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"
#import "FileCenterModel.h"
@interface ServiceCenterFileViewController : BaseViewController
@property (retain, nonatomic) FileCenterModel *model;
@property (strong, nonatomic) UIImage *iconIm;
@property (assign, nonatomic) BOOL isYun;//是否孕妇建册
@end
