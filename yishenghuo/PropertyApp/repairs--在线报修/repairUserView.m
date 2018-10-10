//
//  repairUserView.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/1/11.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "repairUserView.h"

@implementation repairUserView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)callClick:(id)sender {
    if (self.callBlock) {
        self.callBlock();
    }
}

@end
