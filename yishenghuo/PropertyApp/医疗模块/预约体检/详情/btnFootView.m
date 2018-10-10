//
//  btnFootView.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/16.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "btnFootView.h"

@implementation btnFootView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnClick:(id)sender {
    if (_block) {
        _block();
    }
}
-(void)setBlock:(void (^)())block{
    _block = block;
}
@end
