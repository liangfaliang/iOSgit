//
//  SelectTimeView.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/8.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LbRightImLeftView.h"
@interface SelectTimeView : UIView
@property (weak, nonatomic) IBOutlet UILabel *zhiLb;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet LbRightImLeftView *leftTopView;
@property (weak, nonatomic) IBOutlet LbRightImLeftView *rightTopView;
@property (weak, nonatomic) IBOutlet LbRightImLeftView *leftBottomView;
@property (copy, nonatomic) void (^clickBlock)(NSInteger tag);
+ (SelectTimeView *)view;
@end
