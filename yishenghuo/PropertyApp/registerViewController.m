//
//  registerViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/9/14.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "registerViewController.h"
#import "NSString+YTString.h"
#import "SMSSDK.h"
#import "LoginViewController.h"
#import "projectTableViewController.h"
#import "SelectTableViewController.h"
#import "companyTableViewController.h"
@interface registerViewController ()
@property (nonatomic, retain) NSMutableArray * group;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *backview;

@property(nonatomic,assign)BOOL isNavibar;
@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.isAtt) {
        self.navigationBarTitle = @"注册&认证";
        [self submitClickreque];
    }else{
        self.navigationBarTitle = @"注册";
    }
    [self createUI];
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}
-(void)createUI{
    _backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height)];
    [self.view addSubview:_backview];
    _backview.backgroundColor = [UIColor clearColor];
    NSArray *namearr = [NSArray array];
    NSArray *imagearr = [NSArray array];
    if (self.isAtt) {
        namearr = @[@"请选择物业项目",@"请输入手机号",@"请输入验证码",@"请设置密码"];
        //        imagearr = @[@"wuyexiangmu_zhuce",@"zhanghu",@"yanzhengma",@"mima",@"mima"];
        imagearr = @[@"物业项目",@"手机号",@"验证码",@"设置密码"];
    }else{
        namearr = @[@"请输入手机号",@"请输入验证码",@"请设置密码"];
        //        imagearr = @[@"zhanghu",@"yanzhengma",@"mima",@"mima",@"mima_denglu"];
        imagearr = @[@"手机号",@"验证码",@"设置密码"];
    }
    CGFloat numi = 0;
    
    for (int i = 0; i < namearr.count; i ++) {
        UIImageView *view1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 114 + i *50, SCREEN.size.width - 30, 47)];
        view1.userInteractionEnabled = YES;
        view1.image = [UIImage imageNamed:@"shurukuang"];
        view1.contentMode =  UIViewContentModeScaleToFill;
        [_backview addSubview:view1];
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
        
        if (self.isAtt) {
            if (i == 0) {
                _sumbtn = [[LFLUibutton alloc]init];
                _sumbtn.titleLabel.textAlignment = NSTextAlignmentLeft;
                _sumbtn.titleLabel.font = [UIFont systemFontOfSize:14];
                _sumbtn.Ratio = 1;
                _sumbtn.titleLabel.adjustsFontSizeToFitWidth = YES;
                [_sumbtn setTitle:namearr[i] forState:UIControlStateNormal];
                [_sumbtn setTitleColor:JHColor(200, 200, 200) forState:UIControlStateNormal];
                [_sumbtn addTarget:self action:@selector(sumbtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [view1 addSubview:_sumbtn];
                [_sumbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(userimageView.mas_right).offset(10);
                    make.top.offset(0);
                    make.bottom.offset(0);
                    make.right.offset(0);
                    
                }];
                _rightImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gerenzhongxinjiantou"]];
                [_sumbtn addSubview:_rightImage];
                [_rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(_sumbtn.mas_centerY).offset(0);
                    make.right.offset(-5);
                    
                }];
                numi ++;
                continue;
            }
        }
        UITextField *tf = [[UITextField alloc]init];
        tf.tag = 500 + i - numi;
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        tf.font = [UIFont systemFontOfSize:14];
        tf.placeholder = namearr[i];
        //        tf.backgroundColor = [UIColor redColor];
        [view1 addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userimageView.mas_right).offset(10);
            make.top.offset(0);
            make.bottom.offset(0);
            if (i == (numi + 1)) {
                make.right.offset(-85);
            }else if(i == (numi + 2)){
                make.right.offset(-35);
            }else{
                make.right.offset(0);
            }
            
            
        }];
        if (i == (numi + 1)) {
            UIButton *setBtn = [[UIButton alloc]init];
            [setBtn setImage:[UIImage imageNamed:@"huoquyanzhengma"] forState:UIControlStateNormal];
            [setBtn setTitle:@"重新获取" forState:UIControlStateSelected];
            setBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
            [setBtn setTitleColor:JHMaincolor forState:UIControlStateSelected];
            [setBtn addTarget:self action:@selector(sendClick1:) forControlEvents:UIControlEventTouchUpInside];
            [view1 addSubview:setBtn];
            [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view1.mas_centerY);
                make.right.offset(-5);
                
                
            }];
            [view1 addSubview:setBtn];
        }
        if (i == (numi + 2)) {
            tf.secureTextEntry =YES;
            UIButton *eyeimageView = [[UIButton alloc]init];
            [eyeimageView setImage:[UIImage imageNamed:@"yanjing"] forState:UIControlStateNormal];
            [eyeimageView addTarget:self action:@selector(eyeimageViewClick:) forControlEvents:UIControlEventTouchUpInside];
            [view1 addSubview:eyeimageView];
            [eyeimageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view1.mas_centerY);
                make.right.offset(-5);
                
                
            }];
        }
        
        if (i == (numi + 2)) {
            tf.secureTextEntry =YES;
            
            UIButton *subbtn = [[UIButton alloc]init];
            if (self.isAtt) {
                [subbtn setImage:[UIImage imageNamed:@"zhucerenzheng"] forState:UIControlStateNormal];
            }else{
                [subbtn setImage:[UIImage imageNamed:@"zhuce"] forState:UIControlStateNormal];
            }
            [subbtn addTarget:self action:@selector(subbuttonclick:) forControlEvents:UIControlEventTouchUpInside];
            [_backview addSubview:subbtn];
            [subbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_backview.mas_centerX);
                make.top.equalTo(view1.mas_bottom).offset(50);
                
            }];
            
            
            
            UIButton *logonbtn = [[UIButton alloc]init];
            [logonbtn setTitle:@"已有账号？登陆" forState:UIControlStateNormal];
            [logonbtn setTitleColor:JHmiddleColor forState:UIControlStateNormal];
            [logonbtn addTarget:self action:@selector(backlogonbtnclick:) forControlEvents:UIControlEventTouchUpInside];
            logonbtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [_backview addSubview:logonbtn];
            [logonbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_backview.mas_centerX);
                make.top.equalTo(subbtn.mas_bottom).offset(5);
                
            }];
            
            
        }else{
            
            
        }
        
        
    }
    
    
    
}

-(void)eyeimageViewClick:(UIButton *)btn{
    
    UITextField *tfpass = [self.view viewWithTag:502];
    UIImage *im = [UIImage imageNamed:@"yanjing"];
    if ([btn.imageView.image isEqual:im]) {
        [btn setImage:[UIImage imageNamed:@"yanjingdakai"] forState:UIControlStateNormal];
        tfpass.secureTextEntry =NO;
    }else{
        [btn setImage:im forState:UIControlStateNormal];
        tfpass.secureTextEntry =YES;
    }
    
    
}
- (void)sendClick1:(UIButton *)sender
{
    UITextField *tfphone = [self.view viewWithTag:500];
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"请检查您的网络状态~~"];
        
        return;
    }
    
    
    
    if (tfphone.text.length == 0) {
        [self presentLoadingTips:@"请输入手机号"];
        return;
    }
    if (![tfphone.text isValidateMobile]){
        [self presentLoadingTips:@"请输入正确的手机号"];
        
        return;
        
    }
    
    sender.userInteractionEnabled = NO;
    [self presentLoadingTips];
    NSString *  purpose = @"";
    if (self.isAtt) {
        purpose = @"authentication+register";
    }else{
        purpose = @"register";
    }
    
    [[SMSSDK sharedSMSSDK] getVerificationCodeByMethod:purpose phoneNumber:tfphone.text zone:@"86" success:^(id response) {
        [self dismissTips];
        [sender setImage:nil forState:UIControlStateNormal];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            NSLog(@"SUCCEED!");
            UIButton *bt = (UIButton *)sender;
            
            __block int timeout=60; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                //隐藏图片
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [bt setImage:nil forState:UIControlStateNormal];
                        //设置界面的按钮显示 根据自己需求设置
                        
                        //                        [bt setTitle:@"发送验证码" forState:UIControlStateNormal];
                        //                        [bt setTitleColor:JHMaincolor forState:UIControlStateNormal];
                        bt.userInteractionEnabled = YES;
                        bt.selected = YES;
                    });
                }else{
                    
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        bt.selected = NO;
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
            
        }else {
            sender.selected = YES;
            sender.userInteractionEnabled = YES;
            [sender setTitle:@"重新获取" forState:UIControlStateSelected];
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        sender.userInteractionEnabled = YES;
        [self dismissTips];
        [self presentLoadingTips:@"请求失败！"];
        
    }] ;
    //    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:tfphone.text zone:@"86" result:^(NSError *error){
    //
    //        if (!error)
    //    }];
    
    
}
//登陆
-(void)subbuttonclick:(UIButton *)btn{
    
    [self doRegister];
    
}


//返回登陆页
-(void)backlogonbtnclick:(UIButton *)btn{
    
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
//取消
-(void)returnclick:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
    //     [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)doRegister
{
    
    UITextField *tfphone = [self.view viewWithTag:500];
    UITextField *tfcode = [self.view viewWithTag:501];
    UITextField *tfpass = [self.view viewWithTag:502];
    UITextField *tfpass1 = [self.view viewWithTag:503];
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"请检查您的网络状态~~"];
        
        return;
    }
    if (self.isAtt) {
        if (!(self.str && self.strID)) {
            [self presentLoadingTips:@"请选择物业项目"];
            return;
        }
    }
    
    
    if (tfphone.text.length == 0) {
        [self presentLoadingTips:@"请输入手机号"];
        return;
    }
    if (![tfphone.text isValidateMobile]){
        [self presentLoadingTips:@"请输入正确的手机号"];
        
        return;
        
    }
    if (tfcode.text.length == 0) {
        [self presentLoadingTips:@"请输入验证码"];
        return;
    }
    
    if (tfpass.text.length == 0) {
        [self presentLoadingTips:@"请输入密码"];
        
        return;
    }
    if (tfpass.text.length  < 6  || tfpass.text.length  >20 ) {
        [self presentLoadingTips:@"请输入6-20位密码"];
        
        return;
    }
//    if (tfpass1.text.length == 0){
//        [self presentLoadingTips:@"请输入确认密码"];
//
//        return;
//
//    }
//    if (![tfpass.text isEqualToString:tfpass1.text]){
//        [self presentLoadingTips:@"密码不一致"];
//
//        return;
//
//    }
    if (tfcode.text.length == 0) {
        [self presentLoadingTips:@"请输入验证码"];
        
    }else {
#ifdef DEBUG //测试阶段
        if (self.isAtt) {
            [self RegisterAttestation:tfphone.text pass:tfpass.text];
        }else{
            [self Register:tfphone.text pass:tfpass.text];
        }
#else
        // 获取服务器返回的信息判断验证码是否正确
        [self presentLoadingTips];
        [[SMSSDK sharedSMSSDK] commitVerificationCode:tfcode.text
                                          phoneNumber:tfphone.text
                                                 zone:@"86"
                                              success:^(id response) {
                                                  [self dismissTips];
                                                  NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
                                                  if ([str isEqualToString:@"1"]) {
                                                      [self presentLoadingTips];
                                                      if (self.isAtt) {
                                                          [self RegisterAttestation:tfphone.text pass:tfpass.text];
                                                      }else{
                                                          [self Register:tfphone.text pass:tfpass.text];
                                                      }
                                                  }else {
                                                      [self presentLoadingTips:response[@"status"][@"error_desc"]];
                                                  }
                                              } failure:^(NSError *error) {
                                                  [self presentLoadingTips:@"请求失败！"];
                                                  
                                                  
                                              }];
        //            [SMSSDK commitVerificationCode:tfcode.text phoneNumber:tfphone.text zone:@"86" result:^(NSError *error){
        //                if (!error) {
        //
        //                    NSLog(@"SUCCEED!");
        //
        //                    if (self.isAtt) {
        //                        [self RegisterAttestation:tfphone.text pass:tfpass.text];
        //                    }else{
        //                        [self Register:tfphone.text pass:tfpass.text];
        //                    }
        //
        //
        //                }else {
        //
        //                    [self presentLoadingTips:@"验证码错误"];
        //
        //                }
        //
        //            }];
#endif
        
        
        
        
    }
    
}
#pragma mark 注册
-(void)Register:(NSString *)phone pass:(NSString *)pass{
    NSDictionary *dt = @{@"name":phone,@"password":pass,@"email":[NSString stringWithFormat:@"%@@shequyun.cc",phone]};
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,RegisterUrl) params:dt success:^(id response) {
        LFLog(@"%@",response);
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [UserDefault setObject:phone forKey:@"nameuser"];
            [UserDefault setObject:pass forKey:@"namepass"];
            [UserDefault synchronize];
            
            [self presentLoadingTips:@"注册成功"];
            [self performSelector:@selector(popToFirst) withObject:nil afterDelay:2.0];
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        
        
    } failure:^(NSError *error) {
        LFLog(@"error：%@",error);
        
    }];
    
    
}
#pragma mark 注册+认证
-(void)RegisterAttestation:(NSString *)phone pass:(NSString *)pass{
    NSArray *arrid = [self.strID componentsSeparatedByString:@","];
    NSArray *arrname = [self.str componentsSeparatedByString:@" "];
    NSDictionary *dt = [NSDictionary dictionary];
    if (arrid.count > 3) {
        dt = @{@"password":pass,@"mobile":phone,@"province":arrname[0],@"city":arrname[1],@"company":arrname[2],@"companyid":arrid[2],@"lename":arrname[3],@"leid":arrid[3]};
    }
    //    NSDictionary *dt = @{@"password":pass,@"mobile":phone,@"province":@"浙江省",@"city":@"杭州市",@"company":@"梅苑酒店",@"companyid":@"29",@"lename":self.str,@"leid":self.strID};
    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"101") params:dt success:^(id response) {
        LFLog(@"认证%@",response);
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            [UserDefault setObject:phone forKey:@"nameuser"];
            [UserDefault setObject:pass forKey:@"namepass"];
            
            [UserDefault synchronize];
            
            [self presentLoadingTips:@"注册成功"];
            [self performSelector:@selector(popToFirst) withObject:nil afterDelay:2.0];
            [[UserModel shareUserModel] sendTobox];
            
            
        }else if ([str isEqualToString:@"2"]){
            
            [[UserModel shareUserModel] sendTobox];
            
            UIAlertController *alertcontro = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已认证过了" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            
            [alertcontro addAction:okAction];
            
            [self presentViewController:alertcontro animated:YES completion:nil];
            
        }else{
            NSLog(@"认证失败");
            [self presentLoadingTips:response[@"err_msg"]];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}



#pragma mark 选择物业项目
-(void)sumbtnClick:(UIButton *)btn{
    
    //    companyTableViewController *company = [[companyTableViewController alloc]init];
    //    company.is_Sort = @"Att";
    //    NSString *prid = @"1";
    //    NSString *ciid = @"1";
    //    if (self.dataArray.count > 0) {
    //
    //        for (NSDictionary *dict in self.dataArray) {
    //            if ([dict[@"Province"] isEqualToString:@"四川省"]) {
    //                prid = dict[@"prid"];
    //            }
    //
    //            for (NSDictionary *arrprovince in dict[@"note"]) {
    //
    //                if (([arrprovince[@"city"] isEqualToString:@"绵阳市"])) {
    //                    ciid = arrprovince[@"ciid"];
    //                    for (NSDictionary *dt in arrprovince[@"le_arr"]) {
    //
    //                        //                        if ([dt[@"company"] isEqualToString:@"绵阳市"]) {
    //                        //                            for (NSDictionary *lastdt in dt[@"note"]) {
    //                        [company.companyArray addObject:dt];
    //                        //                            }
    //                        //                        }
    //                    }
    //                }
    //
    //
    //            }
    //        }
    //
    //
    //    }
    //    company.str = [NSMutableString stringWithFormat:@"四川省 绵阳市"];
    //    company.strid = [NSMutableString stringWithFormat:@"%@,%@",prid,ciid];
    //
    //    [self.navigationController pushViewController:company animated:YES];
    
    companyTableViewController *company = [[companyTableViewController alloc]init];
    company.is_Sort = @"Att";
    for (NSDictionary *dt in self.dataArray) {
        [company.companyArray addObject:dt];
    }
    
    [self.navigationController pushViewController:company animated:YES];
}
#pragma mark 物业项目
-(void)submitClickreque{
    [self presentLoadingTips];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    LFLog(@"物业项目dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PropertyProjectUrl) params:dt success:^(id response) {
        [self dismissTips];
        LFLog(@"物业项目:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *subDic in response[@"data"]) {
                [self.dataArray addObject:subDic];
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    [self submitClickreque];
                }];
            }
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"数据请求失败！"];
    }];
    
}
-(void)popToFirst{
    
    
    //    LoginViewController *vc = (LoginViewController *)self.presentedViewController;
    //    [vc refresh];
    //
    //    [self dismissViewControllerAnimated:YES completion:nil];
    NSArray *vcarr = self.navigationController.viewControllers;
    for (UIViewController *vc in vcarr) {
        if ([vc isKindOfClass:[LoginViewController class]]) {
            LoginViewController *con = (LoginViewController *)vc;
            [con refresh];
            [con doLogin];//注册完自动登录
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationHidden = NO;
}


@end

