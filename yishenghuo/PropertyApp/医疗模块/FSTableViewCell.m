//
//  FSTableViewCell.m
//  FSGridLayoutDemo
//
//  Created by 冯顺 on 2017/6/10.
//  Copyright © 2017年 冯顺. All rights reserved.
//

#import "FSTableViewCell.h"
@implementation FSTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layoutView.delegate = self;
    }
    return self;
}
- (void)setJson:(id )json
{
    
    [self.layoutView removeFromSuperview];
    self.layoutView = [[FSGridLayoutView alloc]init];
    self.layoutView.json = json;
    [self addSubview:self.layoutView];
    [self.layoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo([FSGridLayoutView GridViewHeightWithJsonStr:json]);
    }];
}

@end
