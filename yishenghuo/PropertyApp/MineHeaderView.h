//
//  MineHeaderView.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/25.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIView *grayView;
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UIImageView *iconIm;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *adressLb;
@property (weak, nonatomic) IBOutlet UIButton *activiBtn;
@property (strong, nonatomic) NSDictionary *activity_info;
@property (weak, nonatomic) IBOutlet UIView *btnView;

@end
