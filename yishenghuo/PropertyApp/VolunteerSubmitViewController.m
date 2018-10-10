//
//  VolunteerSubmitViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/6.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "VolunteerSubmitViewController.h"
#import "VolunteerServiceViewController.h"
@interface VolunteerSubmitViewController ()

@end

@implementation VolunteerSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"志愿者申请确认";
    UILabel *lb = [[UILabel alloc]init];
    lb.textColor = JHdeepColor;
    lb.font = [UIFont systemFontOfSize:15];
    lb.numberOfLines = 0;
    lb.text = @"    我志愿成为一名华宇爱心公益志愿者，自觉坚持华宇爱心公益志愿服务管理条例，尽己所能，不计报酬，为帮助他人和服务社会而工作";
    [self.view addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(74);
        make.right.offset(-10);
        make.height.offset([lb.text selfadap:15 weith:20].height + 10);
        
    }];
    
    
    UIButton *subbtn = [[UIButton alloc]init];
    [subbtn setImage:[UIImage imageNamed:@"querenshenqing"] forState:UIControlStateNormal];
    [subbtn addTarget:self action:@selector(skipnextsubmitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:subbtn];
    [subbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    
}

//确认
-(void)skipnextsubmitClick:(UIButton *)btn{
    [self volunteersSaveInformation];
    
}
#pragma mark 志愿者信息提交
-(void)volunteersSaveInformation{

    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,volunteersConfirmUrl) params:self.dict success:^(id response) {
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"志愿者信息提交：%@",response);
        if ([str isEqualToString:@"1"]) {
           
            [self presentLoadingTips:@"申请成功"];
            [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.0];
        }else{
            
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                }];
            }
                [self presentLoadingTips:response[@"status"][@"error_desc"]];
                
            
            
        }
        
        
    } failure:^(NSError *error) {
        [self dismissTips];
    }];
    
    
}

-(void)popViewController{
    NSArray *vcarr = self.navigationController.viewControllers;
    for (UIViewController *vc in vcarr) {
        if ([vc isKindOfClass:[VolunteerServiceViewController class]]) {
            VolunteerServiceViewController *ser = (VolunteerServiceViewController *)vc;
            [self.navigationController popToViewController:ser animated:YES];
        }
    }
    
}

@end
