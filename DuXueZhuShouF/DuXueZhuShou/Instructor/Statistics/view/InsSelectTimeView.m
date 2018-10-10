//
//  InsSelectTimeView.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "InsSelectTimeView.h"

@implementation InsSelectTimeView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.leftView.titleLb.text = @"请选择";
    self.rightView.titleLb.text = @"请选择";

}
- (IBAction)queryClick:(UIButton *)sender {//tag= 3
    if (self.clickBlock) {
        self.clickBlock(sender.tag);
    }
}
- (IBAction)tapClick:(UITapGestureRecognizer*)tap {
    LFLog(@"%ld",tap.view.tag);
    if (self.clickBlock) {
        self.clickBlock(tap.view.tag);
    }
}


@end
