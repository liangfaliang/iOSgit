//
//  btnFootView.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/16.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"
#import "LPLabel.h"
@interface btnFootView : UIView
@property (weak, nonatomic) IBOutlet YYLabel *priceYYlb;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (weak, nonatomic) IBOutlet LPLabel *lpLb;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lpLbWidth;
@property(nonatomic,copy)void(^block)();
-(void)setBlock:(void (^)())block;
@end
