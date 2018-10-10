//
//  repairUserView.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/1/11.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XX_image.h"
@interface repairUserView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet XX_image *xxIm;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property(copy,nonatomic) void(^callBlock)();
@end
