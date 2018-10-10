//
//  validationNumViewController.m
//  shop
//
//  Created by 梁法亮 on 16/8/2.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
#import "validationNumViewController.h"
#import "SMSSDK.h"
#import "ChangePWViewController.h"
#import "NSString+YTString.h"
#import "LFLaccount.h"
@interface validationNumViewController ()<UITextFieldDelegate>
@property (nonatomic, retain) NSMutableArray * group;
@property (nonatomic, retain) UIView *newview;
@property (nonatomic, retain) UITextField *newnumText;
@property (nonatomic, retain) UITextField *newauthcode;
@property (nonatomic, retain) UITextField *newpassword;
@property (nonatomic, retain) UIButton *newsendBtn;

@property(nonatomic,strong)NSString *telnum;
@end

@implementation validationNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
   self.navigationBarTitle = @"找回密码";
    [self creatNewView];
}

- (void)creatNewView
{
    self.newview = [[UIView alloc]init];
    self.newview.frame = CGRectMake(0,0,SCREEN.size.width, SCREEN.size.height);

//    self.newview.backgroundImage = [UIImage imageNamed:@"beijingtu"];
//    [self.view addSubview:self.newview];
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(returnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(15);
        make.top.offset(30);
    }];
    
    NSArray *namearr = @[@"请输入手机号",@"请输入验证码",@"请设置新密码"];
//    NSArray *imagearr = @[@"zhanghu",@"yanzhengma"];
    NSArray *imagearr = @[@"手机号",@"验证码",@"设置新密码"];
//    UILabel *titlelb = [[UILabel alloc]initWithFrame:CGRectMake(15, 80, SCREEN.size.width - 30, 21)];
//    titlelb.text = @"请输入您注册的手机号";
//    titlelb.textColor = [UIColor whiteColor];
//    titlelb.font = [UIFont systemFontOfSize:15];
//    [self.view addSubview:titlelb];
    
    for (int i = 0; i < namearr.count; i ++) {
        UIImageView *view1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 114 + i *60, SCREEN.size.width - 30, 47)];
        view1.userInteractionEnabled = YES;
        view1.image = [UIImage imageNamed:@"shurukuang"];
        view1.contentMode =  UIViewContentModeScaleToFill;
        [self.view addSubview:view1];
        UILabel *userimageView = [[UILabel alloc]init];
        userimageView.text = imagearr[i];
        userimageView.textColor = JHdeepColor;
        userimageView.font = [UIFont systemFontOfSize:15];
//        userimageView.image = [UIImage imageNamed:imagearr[i]];
//        userimageView.contentMode =  UIViewContentModeCenter;
        [view1 addSubview:userimageView];
        [userimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view1.mas_centerY);
            make.left.offset(5);
            make.width.offset(90);
            
        }];
        [view1 addSubview:userimageView];
//        UILabel *lb = [[UILabel alloc]init];
//        lb.text = namearr[i];
//        lb.textColor = [UIColor whiteColor];
//        lb.font = [UIFont systemFontOfSize:14];
//        [view1 addSubview:lb];
//        CGSize lbsize = [lb.text selfadaption:14];
//        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(userimageView.mas_right).offset(5);
//            make.top.offset(0);
//            make.bottom.offset(0);
//            make.width.offset(lbsize.width + 5);
//            
//        }];
        UITextField *tf = [[UITextField alloc]init];
        tf.tag = 500 + i;
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        tf.font = [UIFont systemFontOfSize:14];
        tf.placeholder = namearr[i];
        //        tf.backgroundColor = [UIColor redColor];
        [view1 addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userimageView.mas_right).offset(10);
            make.top.offset(0);
            make.bottom.offset(0);
            if (i == 0) {
                make.right.offset(0);
            }else{
                
                make.right.offset(-85);
            }
            
        }];
        
        if (i == 1) {

            self.newauthcode = tf;
            UIButton *eyeimageView = [[UIButton alloc]init];
            //            [eyeimageView setImage:[UIImage imageNamed:@"huoquyanzhengma"] forState:UIControlStateNormal];
            [eyeimageView setTitleColor:JHMaincolor forState:UIControlStateNormal];
            [eyeimageView setTitle:@"发送验证码" forState:UIControlStateNormal];
            eyeimageView.titleLabel.font = [UIFont systemFontOfSize: 12.0];
            [eyeimageView addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
            [view1 addSubview:eyeimageView];
            [eyeimageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view1.mas_centerY);
                make.right.offset(-5);
                
                
            }];
            [view1 addSubview:eyeimageView];


            

        }else if(i == 0){
            tf.text = [UserDefault objectForKey:@"nameuser"];
            self.newnumText = tf;
        }else if(i == 2){
            self.newpassword = tf;
            self.newpassword.secureTextEntry =YES;
            UIButton *eyeimageView = [[UIButton alloc]init];
            [eyeimageView setImage:[UIImage imageNamed:@"yanjing"] forState:UIControlStateNormal];
            [eyeimageView addTarget:self action:@selector(eyeimageViewClick:) forControlEvents:UIControlEventTouchUpInside];
            [view1 addSubview:eyeimageView];
            [eyeimageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view1.mas_centerY);
                make.right.offset(-5);
                
                
            }];
            
            UIButton *subbtn = [[UIButton alloc]init];
            [subbtn setImage:[UIImage imageNamed:@"tijiao"] forState:UIControlStateNormal];
            [subbtn addTarget:self action:@selector(pwbtnclick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:subbtn];
            [subbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view.mas_centerX);
                make.top.equalTo(view1.mas_bottom).offset(50);
                
            }];
        }
        
        
    }
    


}

//是否显示密文
-(void)eyeimageViewClick:(UIButton *)btn{
    UIImage *im = [UIImage imageNamed:@"yanjing"];
    if ([btn.imageView.image isEqual:im]) {
        [btn setImage:[UIImage imageNamed:@"yanjingdakai"] forState:UIControlStateNormal];
        self.newpassword.secureTextEntry =NO;
    }else{
        [btn setImage:im forState:UIControlStateNormal];
        self.newpassword.secureTextEntry =YES;
    }
    
    
}
- (void)sendClick:(UIButton *)sender
{
    
    if (self.newnumText.text.length == 0) {
        [self presentLoadingTips:@"请输入手机号"];
        [self.newnumText becomeFirstResponder];
        return;
    }
    if (![self.newnumText.text isValidateMobile]){
        [self presentLoadingTips:@"请输入正确的手机号"];
        
        return;
        
    }
    self.telnum = self.newnumText.text;
    sender.userInteractionEnabled = NO;
    [self presentLoadingTips];
    [[SMSSDK sharedSMSSDK] getVerificationCodeByMethod:@"useredit" phoneNumber:self.newnumText.text zone:@"86" success:^(id response) {
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            NSLog(@"SUCCEED!");
            sender.userInteractionEnabled = YES;
            [self presentLoadingTips:@"验证码已发送~~"];
            UIButton *bt = (UIButton *)sender;
            __block int timeout=60; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        
                        [bt setTitle:@"获取验证码" forState:UIControlStateNormal];
                        [bt setTitleColor:JHMaincolor forState:UIControlStateNormal];
                        bt.userInteractionEnabled = YES;
                    });
                }else{
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:1];
                        [bt setTitle:[NSString stringWithFormat:@"%@秒重发",strTime] forState:UIControlStateNormal];
                        [bt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                        [UIView commitAnimations];
                        bt.userInteractionEnabled = NO;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
            
        } else {
            sender.userInteractionEnabled = YES;
            [sender setTitle:@"重新获取" forState:UIControlStateNormal];
             [self presentLoadingTips:response[@"status"][@"error_desc"]];
            return ;
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"请求失败！"];
        
    }] ;
//    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.newnumText.text zone:@"86"  result:^(NSError *error){
//        [self dismissTips];
//        if (!error)
//    }];
    
    
}

-(void)pwbtnclick:(UIButton *)btn{

    [self.view endEditing:YES];
//    ChangePWViewController *change = [[ChangePWViewController alloc]init];
//    change.telphone = self.newnumText.text;
//    [self.navigationController pushViewController:change animated:YES];
    if (![userDefaults objectForKey:NetworkReachability]) {
  
        return;
    }
    if (self.newnumText.text.length == 0) {
        [self presentLoadingTips:@"请输入手机号"];
        [self.newnumText becomeFirstResponder];
        return;
    }
    if (![self.newnumText.text isValidateMobile]){
        [self presentLoadingTips:@"请输入正确的手机号"];
        
        return;
        
    }
    if (self.newpassword.text.length == 0) {
        [self.newpassword becomeFirstResponder];
        [self presentLoadingTips:@"请输入新密码"];
        return;
    }
    if (self.newauthcode.text.length == 0) {
        [self.newauthcode becomeFirstResponder];
        [self presentLoadingTips:@"请输入验证码"];
        return;
    }
    self.telnum = self.newnumText.text;
    
#ifdef DEBUG //测试阶段
     [self requestchangelData];
//    ChangePWViewController *change = [[ChangePWViewController alloc]init];
//    change.telphone = self.telnum;
//    [self.navigationController pushViewController:change animated:YES];
#else
    [[SMSSDK sharedSMSSDK] commitVerificationCode:self.newauthcode.text
                                  phoneNumber:self.newnumText.text
                                         zone:@"86"
                                      success:^(id response) {
                                          [self dismissTips];
                                          NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
                                          if ([str isEqualToString:@"1"]) {
                                              NSLog(@"SUCCEED!");
                                              [self requestchangelData];
                                          }else {
                                              [self presentLoadingTips:response[@"status"][@"error_desc"]];
                                          }
                                      } failure:^(NSError *error) {
                                          
                                          
                                      }];
//    [SMSSDK commitVerificationCode:self.newauthcode.text phoneNumber:self.newnumText.text zone:@"86" result:^(NSError *error){
//        if (!error) {
//
//
//
//
////            ChangePWViewController *change = [[ChangePWViewController alloc]init];
////            change.telphone = self.telnum;
////            [self.navigationController pushViewController:change animated:YES];
//
//        }else {
//
//            [self presentLoadingTips:@"验证码错误"];
//
//        }
    
//    }];
#endif


}
#pragma mark 修改密码请求数据
-(void)requestchangelData{
    NSDictionary *dt = @{@"mobile":self.newnumText.text,@"password":self.newpassword.text};
    LFLog(@"修改密码dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJguokaihangBaseUrl,@"30") params:dt success:^(id response) {
        LFLog(@"%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        
        
        if ([str isEqualToString:@"0"]) {
            [UserDefault setObject:dt[@"mobile"] forKey:@"nameuser"];
            [UserDefault setObject:dt[@"password"] forKey:@"namepass"];
            
            [self presentLoadingTips:@"修改成功"];
            ChangePWViewController *change = [[ChangePWViewController alloc]init];
            change.telphone = dt[@"mobile"];
            [self.navigationController pushViewController:change animated:YES];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
//取消
-(void)returnclick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}



@end
