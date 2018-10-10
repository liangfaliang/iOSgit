//
//  InsSelectTimeView.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LbRightImLeftView.h"
@interface InsSelectTimeView : UIView
@property (weak, nonatomic) IBOutlet LbRightImLeftView *leftView;
@property (weak, nonatomic) IBOutlet LbRightImLeftView *rightView;
@property (copy, nonatomic) void (^clickBlock)(NSInteger tag);
@property (weak, nonatomic) IBOutlet UIButton *queryBtn;
@end
