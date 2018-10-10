//
//  baseTableview.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/5/13.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "baseTableview.h"

@implementation baseTableview

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return self;
}
-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
