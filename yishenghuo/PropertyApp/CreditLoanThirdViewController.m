
//
//  CreditLoanThirdViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/5/12.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "CreditLoanThirdViewController.h"
#import "CreditLoanRecordDetailsController.h"
#import "CreditLoanViewController.h"
@interface CreditLoanThirdViewController ()

@end

@implementation CreditLoanThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"提交完成";
    UILabel *objclabel = [[UILabel alloc]init];
    objclabel.textColor = JHColor(51, 51, 51);
    objclabel.font = [UIFont systemFontOfSize:15];
    objclabel.numberOfLines = 0;
    objclabel.textAlignment = NSTextAlignmentCenter;
    objclabel.text = @"您的贷款申请已经提交成功！\n稍后会有工作人员与您联系……";
    [self.view addSubview:objclabel];
    [objclabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(150);
        make.top.offset(50);
        make.left.offset(10);
        make.right.offset(-10);
        
    }];
    
    UIButton *submitBtn = [[UIButton alloc]init];
    [submitBtn setImage:[UIImage imageNamed:@"queren_xinyongdai"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(employsubmitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(objclabel.mas_bottom).offset(50);
    }];
}
-(void)employsubmitClick:(UIButton *)btn{
    if (self.sdid) {
        CreditLoanRecordDetailsController *detail = [[CreditLoanRecordDetailsController alloc]init];
        detail.sdid = self.sdid;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        NSArray *vcarr = self.navigationController.viewControllers;
        for (UIViewController *vc in vcarr) {
            if ([vc isKindOfClass:[CreditLoanViewController class]]) {

                CreditLoanViewController *att = (CreditLoanViewController *)vc;
                [self.navigationController popToViewController:att animated:YES];
            }
        }
        
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
