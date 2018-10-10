//
//  ChildCareHomeview.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/21.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ChildCareHomeview.h"

@implementation ChildCareHomeview

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)addBtnClick:(id)sender {
    if (_addblock) {
        _addblock();
    }
}
-(void)setAddblock:(void (^)())addblock{
    _addblock = addblock;
}
- (IBAction)nabackclick:(id)sender {
    UIViewController *vc = [self viewController];
    [vc.navigationController popViewControllerAnimated:YES];
}

@end
