//
//  ChangePWViewController.m
//  shop
//
//  Created by 梁法亮 on 16/8/3.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "ChangePWViewController.h"
#import "LoginViewController.h"
@interface ChangePWViewController ()
@property (nonatomic, retain) UIView *newview;
@property (nonatomic, retain) UITextField *newnumText;
@property (nonatomic, retain) UITextField *newauthcode;
@end

@implementation ChangePWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitle = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatNewView];
    
}
- (void)creatNewView
{


    
//    NSArray *namearr = @[@"请设置新密码",@"请确认新密码"];
//    NSArray *imagearr = @[@"mima",@"mima"];
//    NSArray *imagearr = @[@"设置新密码",@"确认新密码"];
//    UILabel *titlelb = [[UILabel alloc]initWithFrame:CGRectMake(15, 80, SCREEN.size.width - 30, 21)];
//    titlelb.text = @"设置密码后，可采用手机号+密码的形式登陆";
//    titlelb.textColor = [UIColor whiteColor];
//    titlelb.font = [UIFont systemFontOfSize:13];
//    [self.view addSubview:titlelb];
    
//    for (int i = 0; i < 2; i ++) {
//        UIImageView *view1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 114 + i *60, SCREEN.size.width - 30, 47)];
//        view1.userInteractionEnabled = YES;
//        view1.image = [UIImage imageNamed:@"shurukuang"];
//        view1.contentMode =  UIViewContentModeScaleToFill;
//        [self.view addSubview:view1];
//        UILabel *userimageView = [[UILabel alloc]init];
//        userimageView.text = imagearr[i];
//        userimageView.font = [UIFont systemFontOfSize:15];
//        userimageView.textColor = JHdeepColor;
//        //        userimageView.image = [UIImage imageNamed:imagearr[i]];
//        //        userimageView.contentMode =  UIViewContentModeCenter;
//        [view1 addSubview:userimageView];
//        [userimageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(view1.mas_centerY);
//            make.left.offset(5);
//            make.width.offset(90);
//            
//        }];
//        [view1 addSubview:userimageView];
//        //        UILabel *lb = [[UILabel alloc]init];
//        //        lb.text = namearr[i];
//        //        lb.textColor = [UIColor whiteColor];
//        //        lb.font = [UIFont systemFontOfSize:14];
//        //        [view1 addSubview:lb];
//        //        CGSize lbsize = [lb.text selfadaption:14];
//        //        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
//        //            make.left.equalTo(userimageView.mas_right).offset(5);
//        //            make.top.offset(0);
//        //            make.bottom.offset(0);
//        //            make.width.offset(lbsize.width + 5);
//        //
//        //        }];
//        UITextField *tf = [[UITextField alloc]init];
//        tf.tag = 500 + i;
//        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
//        tf.secureTextEntry =YES;
//        tf.font = [UIFont systemFontOfSize:14];
//        tf.placeholder = namearr[i];
//        //        tf.backgroundColor = [UIColor redColor];
//        [view1 addSubview:tf];
//        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(userimageView.mas_right).offset(10);
//            make.top.offset(0);
//            make.bottom.offset(0);
//            make.right.offset(0);
//            
//        }];
//        
//        if (i == 1) {
//            
//            self.newauthcode = tf;
//            
//            UIButton *subbtn = [[UIButton alloc]init];
//            [subbtn setImage:[UIImage imageNamed:@"queding"] forState:UIControlStateNormal];
//            [subbtn addTarget:self action:@selector(changebtnclick:) forControlEvents:UIControlEventTouchUpInside];
//            [self.view addSubview:subbtn];
//            [subbtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.equalTo(self.view.mas_centerX);
//                make.top.equalTo(view1.mas_bottom).offset(50);
//                
//            }];
//            
//            
//        }else{
//            
//            self.newnumText = tf;
//        }
//        
//        
//    }
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"恭喜，密码修改成功！";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = JHAssistColor;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.offset(264);
        
    }];
    UIButton *subbtn = [[UIButton alloc]init];
    [subbtn setImage:[UIImage imageNamed:@"queding"] forState:UIControlStateNormal];
    [subbtn addTarget:self action:@selector(changebtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:subbtn];
    [subbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.offset(264);
        
    }];
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}
-(void)changebtnclick:(UIButton *)btn{

    
    NSArray *vcarr = self.navigationController.viewControllers;
    for (UIViewController *vc in vcarr) {
        if ([vc isKindOfClass:[LoginViewController class]]) {
            LoginViewController *con = (LoginViewController *)vc;
            [con refresh];
            [self.navigationController popToViewController:con animated:YES];
        }
    }
    

//    if (self.newnumText.text.length == 0) {
//        [self presentLoadingTips:@"请输入新密码"];
//        [self.newnumText becomeFirstResponder];
//        return;
//    }
//
//    if (self.newnumText.text.length < 6 ||self.newnumText.text.length > 20 ) {
//        [self presentLoadingTips:@"请输入6-20新密码"];
//        return;
//    }
//    if (self.newauthcode.text.length == 0) {
//        [self presentLoadingTips:@"请再次输入新密码"];
//        [self.newauthcode becomeFirstResponder];
//        return;
//    }
//    if (![self.newnumText.text isEqualToString:self.newauthcode.text]) {
//        [self presentLoadingTips:@"两次输入的密码不一致"];
//        return;
//    }
//    [self.view endEditing:YES];
//    [self requestchangelData];
    
}

#pragma mark 修改密码请求数据
-(void)requestchangelData{
    LFLog(@"telphone:%@",self.telphone);
    NSDictionary *dt = @{@"mobile":self.telphone,@"password":self.newauthcode.text};
    [LFLHttpTool post:NSStringWithFormat(ZJguokaihangBaseUrl,@"30") params:dt success:^(id response) {
        LFLog(@"%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
   
     
            if ([str isEqualToString:@"0"]) {
                [UserDefault setObject:self.telphone forKey:@"nameuser"];
                [UserDefault setObject:self.newnumText.text forKey:@"namepass"];
                
                [self presentLoadingTips:@"修改成功"];
                
                [self performSelector:@selector(popToFirst) withObject:nil afterDelay:2.0];
            }else{
                
                [self presentLoadingTips:response[@"status"][@"error_desc"]];
            }
        
    } failure:^(NSError *error) {
        
    }];
    
}



-(void)popToFirst{

//    [self.stack popToFirstBoardAnimated:YES];
//    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    NSArray *vcarr = self.navigationController.viewControllers;
    for (UIViewController *vc in vcarr) {
        if ([vc isKindOfClass:[LoginViewController class]]) {
            LoginViewController *con = (LoginViewController *)vc;
            [con refresh];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];

}
//取消
-(void)returnclick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}



@end
