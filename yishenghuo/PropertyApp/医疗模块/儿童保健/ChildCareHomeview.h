//
//  ChildCareHomeview.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/21.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"
@interface ChildCareHomeview : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTop;
@property (weak, nonatomic) IBOutlet UIButton *navibackbtn;
@property (weak, nonatomic) IBOutlet UIView *iconView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet YYLabel *nameLb;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLbWidth;
@property(nonatomic,copy)void(^addblock)();
-(void)setAddblock:(void (^)())addblock;
@end
