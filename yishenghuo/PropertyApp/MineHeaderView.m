//
//  MineHeaderView.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/25.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "MineHeaderView.h"
#import "ActivityViewController.h"
#import "PersonalCenterViewController.h"
@implementation MineHeaderView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.grayView.layer.cornerRadius = 8;
    self.grayView.layer.masksToBounds = YES;
    self.whiteView.layer.cornerRadius = 8;
    self.whiteView.layer.masksToBounds = YES;
    self.nameLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    self.backView.backgroundImage = [UIImage imageNamed:@"beijing_grzx"];
    self.activiBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    self.activiBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.activiBtn addSubview:self.activiBtn.titleLabel];
    [self.activiBtn.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.left.offset([UIImage imageNamed:@"wodehuodong_icon"].size.width);
    }];
    UITapGestureRecognizer *itemTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemTap)];
    [self.iconIm addGestureRecognizer:itemTap];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnclick:(id)sender {
    UIViewController *vc = [self viewController];
    
    if ([self.activity_info[@"ios"] isKindOfClass:[NSDictionary class]]) {
        [[UserModel shareUserModel] runtimePushviewController:self.activity_info[@"ios"] controller:vc];
        return;
    }
    
    ActivityViewController *active = [[ActivityViewController alloc]init];//参加的活动
    active.isJion =ActivityJionListUrl;
    [vc.navigationController pushViewController:active animated:YES];
}
- (void)itemTap{
    LFLog(@"头像点击");
    UIViewController *vc = [self viewController];
    PersonalCenterViewController *per = [[PersonalCenterViewController alloc]init];
    [vc.navigationController pushViewController:per animated:YES];
}
- (IBAction)iconClick:(id)sender {
    LFLog(@"头像点击");
    
}

@end
