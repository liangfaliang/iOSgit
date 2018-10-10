//
//  OperationFooterView.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/10.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "OperationFooterView.h"

@implementation OperationFooterView
-(void)awakeFromNib{
    [super awakeFromNib];
    NSArray *arr = @[@"btn1",@"btn2",@"btn3"];
    for (NSString *name in arr) {
        UIButton *btn = [self valueForKey:name];
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        if (![name isEqualToString:@"btn3"]) {
            [btn setViewBorderColor:JHBorderColor borderWidth:1];
        }
    }
}

- (IBAction)btnClick:(UIButton *)sender {
    if (self.btnClickBlcok) {
        self.btnClickBlcok(sender.tag);
    }
}

@end
