//
//  PregnantHeaderView.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/24.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PregnantHeaderView : UIView
@property (strong, nonatomic)CAShapeLayer *border;
@property (weak, nonatomic) IBOutlet UILabel *timeTypeLb;
@property (weak, nonatomic) IBOutlet UIButton *iconAddbtn;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UILabel *laveLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeTypeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeTypeRight;
@property(nonatomic,copy)void(^addblock)();
-(void)setAddblock:(void (^)())addblock;
-(void)nameBtnBoderIshide:(BOOL)hide;
@end
