//
//  ChangePasswordViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/10.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UIViewController+BackButtonHandler.h"

@interface ChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTop;
@property (weak, nonatomic) IBOutlet UITextField *tfold;
@property (weak, nonatomic) IBOutlet UITextField *tfNew;
@property (weak, nonatomic) IBOutlet UITextField *tfconfirm;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.viewTop.constant = SAFE_NAV_HEIGHT;
    self.navigationBarTitle =@"修改密码";
}
- (IBAction)submitClick:(id)sender {
    if (!self.tfold.text.length) {
        [self presentLoadingTips:@"请输入原密码！"];
        [self.tfold becomeFirstResponder];
        return;
    }
    if (!self.tfNew.text.length) {
        [self presentLoadingTips:@"请输入新密码！"];
        [self.tfNew becomeFirstResponder];
        return;
    }
    if (!self.tfconfirm.text.length) {
        [self presentLoadingTips:@"请再次输入新密码！"];
        [self.tfconfirm becomeFirstResponder];
        return;
    }
    if (![self.tfconfirm.text isEqualToString:self.tfNew.text]) {
        [self presentLoadingTips:@"两次输入的密码不一致！"];
        return;
    }
    [self UpdateLoad];
}
#pragma mark 提交
-(void)UpdateLoad{
    NSMutableDictionary *mdt = [NSMutableDictionary dictionary];
    [mdt setObject:self.tfNew.text forKey:@"password"];
    [mdt setObject:self.tfold.text forKey:@"oldPassword"];
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,ChangePasswordUrl) params:mdt viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"tijaio:%@",response);
        NSNumber *code = @([response[@"code"] integerValue]);
        if (code.integerValue == 1) {
            NSLog(@"注册成功");

            [self performSelector:@selector(dismissView) withObject:nil afterDelay:2.];
        }
        [AlertView showMsg:response[@"msg"]];
        
    } failure:^(NSError *error) {
        [self dismissTips];
        LFLog(@"error：%@",error);
    }];
}
-(void)dismissView{
    [self.navigationController popViewControllerAnimated:YES];
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
