//
//  VehicleServiceViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/6/20.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "VehicleServiceViewController.h"
#import "VehicleManagementViewController.h"//车辆管理
#import "QueryNationalViolationViewController.h"
#import "AttestViewController.h"
@interface VehicleServiceViewController ()

@end

@implementation VehicleServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationBarTitle = @"车辆服务";
    self.view.backgroundImage = [UIImage imageNamed:@"beijing_cheliang"];
}
- (IBAction)VehicleDetectClick:(id)sender {//车辆检测
    if (![UserModel Certification]) {
        AttestViewController *att = [[AttestViewController alloc]init];
        [self.navigationController pushViewController:att animated:YES];
        return;
    }
    VehicleManagementViewController *room= [[VehicleManagementViewController alloc]init];
    [self.navigationController pushViewController:room animated:YES];
}
- (IBAction)QueryResultClick:(id)sender {//违章查询
    QueryNationalViolationViewController *room= [[QueryNationalViolationViewController alloc]init];
    [self.navigationController pushViewController:room animated:YES];
}


@end
