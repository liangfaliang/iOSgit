//
//  MineHeaderNewView.h
//  PropertyApp
//
//  Created by admin on 2018/10/11.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineHeaderNewView : UIView
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *adressLb;
@property (weak, nonatomic) IBOutlet UIButton *hiuyuanBtn;
+ (MineHeaderNewView *)view;
@end
