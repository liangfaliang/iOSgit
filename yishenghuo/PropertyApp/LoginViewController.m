//
//  LoginViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/6.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//17716138926   123456
//18781164678 123456
#import "LoginViewController.h"
#import "validationNumViewController.h"
#import "registerViewController.h"
#import "JPUSHService.h"
#import "UMMobClick/MobClick.h"//友盟统计
@interface LoginViewController ()
@property(nonatomic,assign)BOOL isNavibar;
@end

@implementation LoginViewController
SYNTHESIZE_SINGLETON_FOR_CLASS(LoginViewController);
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationAlpha = 0;
//    self.navigationBarTitle = @"登录";
//    UIImage *image = [UIImage imageNamed:@"beijingtu"];
//    self.view.layer.contents = (id) image.CGImage;
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijingtu"]];
//    self.navigationHidden = YES;
    [self creayeUI];
    //添加键盘通知
//    [Notification addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [Notification addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark 键盘将显示
-(void)kbWillShow:(NSNotification *)noti{
//        NSDictionary *dict = [noti userInfo];
//        CGRect keyboardRect = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.view.y = -100;
}


#pragma mark 键盘将隐藏
-(void)kbWillHide:(NSNotification *)noti{
    self.view.y = 0;
}
-(void)creayeUI{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"guanbibuttun"] style:UIBarButtonItemStylePlain target:self action:@selector(returnclick:)];
    self.navigationItem.leftBarButtonItem =rightItem;
//    UIButton *btn = [[UIButton alloc]init];
//    [btn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
//    
//    [btn addTarget:self action:@selector(returnclick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.offset(15);
//        make.top.offset(30);
//    }];
    
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(104);
        make.centerX.equalTo(self.view.mas_centerX);
        
    }];
    
    UIImage *im1 = [UIImage imageNamed:@"logo"];
    NSArray *namearr = @[@"手机号码",@"密码"];
    NSArray *imagearr = @[@"zhanghu",@"mima"];
    for (int i = 0; i < 2; i ++) {
        UIImageView *view1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, im1.size.height + 134 + i *60, SCREEN.size.width - 30, 47)];
        view1.userInteractionEnabled = YES;
        view1.image = [UIImage imageNamed:@"shurukuang"];
        view1.backgroundColor = [UIColor blueColor];
        view1.contentMode =  UIViewContentModeScaleToFill;
        [self.view addSubview:view1];
//        UIImageView *userimageView = [[UIImageView alloc]init];
//        userimageView.image = [UIImage imageNamed:imagearr[i]];
//        userimageView.contentMode =  UIViewContentModeCenter;
//        [view1 addSubview:userimageView];
//        [userimageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(view1.mas_centerY);
//            make.left.offset(5);
//            make.size.mas_equalTo(userimageView.image.size);
//            
//        }];

        UILabel *lb = [[UILabel alloc]init];
        lb.text = namearr[i];
        lb.textColor = JHdeepColor;
        lb.font = [UIFont systemFontOfSize:15];
        [view1 addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.offset(0);
            make.bottom.offset(0);
            make.width.offset(75);
            
        }];
        UITextField *tf = [[UITextField alloc]init];
        tf.tag = 500 + i;
        
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        tf.font = [UIFont systemFontOfSize:14];
        
        //        tf.backgroundColor = [UIColor redColor];
        [view1 addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lb.mas_right).offset(20);
            make.top.offset(0);
            make.bottom.offset(-2);
            if (i == 0) {
                make.right.offset(0);
            }else{
                
                make.right.offset(-35);
            }
            
        }];
        
        if (i == 1) {
            tf.secureTextEntry =YES;
            NSString *pass =  [UserDefault objectForKey:@"namepass"];
            LFLog(@"name:%@",pass);
            if (![pass isEqualToString:@"(null)"]) {
                tf.text = pass;
            }
            UIButton *eyeimageView = [[UIButton alloc]init];
            [eyeimageView setImage:[UIImage imageNamed:@"yanjing"] forState:UIControlStateNormal];
            [eyeimageView addTarget:self action:@selector(eyeimageViewClick:) forControlEvents:UIControlEventTouchUpInside];
            [view1 addSubview:eyeimageView];
            [eyeimageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view1.mas_centerY);
                make.right.offset(-5);
                
                
            }];
            
            
            UIButton *pawLb = [[UIButton alloc]init];
            pawLb.titleLabel.font = [UIFont systemFontOfSize:14];
            [pawLb setTitleColor:JHmiddleColor forState:UIControlStateNormal];
            [pawLb setTitle:@"忘记密码" forState:UIControlStateNormal];
            [pawLb addTarget:self action:@selector(forgetbtnclick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:pawLb];
            [pawLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view1.mas_bottom).offset(12);
                make.right.offset(-15);
            }];
//            UIButton *btn = [[UIButton alloc]init];
//            btn.tag = 300;
//            [btn addTarget:self action:@selector(onOffClick:) forControlEvents:UIControlEventTouchUpInside];
//            UIImage *image = [UIImage imageNamed:@"on"];
//            [btn setImage:image forState:UIControlStateNormal];
            
//            [self.view addSubview:btn];
//            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(pawLb.mas_centerY);
//                make.right.equalTo(pawLb.mas_left).offset(-5);
//                make.size.mas_equalTo(image.size);
//            }];
            UIButton *subbtn = [[UIButton alloc]init];
            [subbtn setBackgroundImage:[UIImage imageNamed:@"denglukuang"] forState:UIControlStateNormal];
            [subbtn setTitle:@"登录" forState:UIControlStateNormal];
            [subbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            subbtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [subbtn addTarget:self action:@selector(subbuttonclick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:subbtn];
            [subbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view.mas_centerX);
                make.top.equalTo(view1.mas_bottom).offset(50);
                
            }];
            
            
            
            UIButton *logonbtn = [[UIButton alloc]init];
            logonbtn.tag = 220;
            [logonbtn setTitle:@"|注册&认证" forState:UIControlStateNormal];
            [logonbtn setTitleColor:JHmiddleColor forState:UIControlStateNormal];
            [logonbtn addTarget:self action:@selector(logonbtnclick:) forControlEvents:UIControlEventTouchUpInside];
            logonbtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:logonbtn];
            [logonbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(SCREEN.size.width/2);
                make.top.equalTo(subbtn.mas_bottom).offset(5);
                
            }];
            
            UIButton *forgetbtn = [[UIButton alloc]init];
            forgetbtn.tag = 221;
            [forgetbtn setTitleColor:JHmiddleColor forState:UIControlStateNormal];
            [forgetbtn setTitle:@"立即注册？" forState:UIControlStateNormal];
            [forgetbtn addTarget:self action:@selector(logonbtnclick:) forControlEvents:UIControlEventTouchUpInside];
            forgetbtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:forgetbtn];
            [forgetbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(logonbtn.mas_centerY);
                make.right.equalTo(logonbtn.mas_left);
                
            }];
            
        }else{
            
            NSString *name =  [UserDefault objectForKey:@"nameuser"];
            LFLog(@"name:%@",name);
            if (![name isEqualToString:@"(null)"]) {
                tf.text = name;
            }
        }
        
        
    }



}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];

}
//取消
-(void)returnclick:(UIButton *)btn{
    
//    [[AppBoard_iPhone sharedInstance] hideLogin];
    [self.navigationController popViewControllerAnimated:YES];
}

//登陆
-(void)subbuttonclick:(UIButton *)btn{
   
    [self doLogin];
}

//记住密码
-(void)onOffClick:(UIButton *)btn{
    
    UIImage *im = [UIImage imageNamed:@"on"];
    if ([btn.imageView.image isEqual:im]) {
        [btn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    }else{
        [btn setImage:im forState:UIControlStateNormal];
        
    }
    
}
//是否显示密文
-(void)eyeimageViewClick:(UIButton *)btn{
    
    UITextField *tfpass = [self.view viewWithTag:501];
    UIImage *im = [UIImage imageNamed:@"yanjing"];
    if ([btn.imageView.image isEqual:im]) {
        [btn setImage:[UIImage imageNamed:@"yanjingdakai"] forState:UIControlStateNormal];
        tfpass.secureTextEntry =NO;
    }else{
        [btn setImage:im forState:UIControlStateNormal];
        tfpass.secureTextEntry =YES;
    }
    
    
}
//注册
-(void)logonbtnclick:(UIButton *)btn{
    
    _isNavibar = NO;
    registerViewController *regis = [[registerViewController alloc]init];
    if (btn.tag == 220) {
       regis.isAtt = YES;
    }else{
    regis.isAtt = NO;
    }
    
    [self.navigationController pushViewController:regis animated:YES];
//    [self presentViewController:[[registerViewController alloc]init] animated:YES completion:nil];
//    [self.stack pushBoard:[A1_SignupBoard_iPhone board] animated:YES];
    
}

//忘记密码
-(void)forgetbtnclick:(UIButton *)btn{
    _isNavibar = NO;
    validationNumViewController *board = [[validationNumViewController alloc]init];
    board.titlename = @"找回密码";
    [self.navigationController pushViewController:board animated:YES];
//    [self presentViewController:board animated:YES completion:nil];
 
}

//保存密码
-(void)SavePassword{
    
    UITextField *tfuser = [self.view viewWithTag:500];
    UITextField *tfpass = [self.view viewWithTag:501];
    [UserDefault setObject:tfuser.text forKey:@"nameuser"];
    [UserDefault setObject:tfpass.text forKey:@"namepass"];
    [UserDefault synchronize];
    
}

//刷新
-(void)refresh{
    UITextField *tfuser = [self.view viewWithTag:500];
    UITextField *tfpass = [self.view viewWithTag:501];
    tfuser.text = [UserDefault objectForKey:@"nameuser"];
    tfpass.text = [UserDefault objectForKey:@"namepass"];

}

#pragma mark 登陆
-(void)doLogin{
    [self presentLoadingTips:@"请稍后~~~"];
    UITextField *tfuser = [self.view viewWithTag:500];
    UITextField *tfpass = [self.view viewWithTag:501];
    NSDictionary *dt = @{@"name":tfuser.text,@"password":tfpass.text};
    LFLog(@"name:%@password:%@",tfuser.text,tfpass.text);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,LoginUrl) params:dt success:^(id response) {
        [self dismissTips];
        LFLog(@"用户信息:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [[UserModel shareUserModel] removeAllUserInfo];
            NSString *timestamp = [NSString stringWithFormat:@"%d",(int)[[NSDate date] timeIntervalSince1970]];
            [UserDefault setObject:timestamp forKey:@"appisLogin"];//存储当前时间
            NSDictionary *dict = response[@"data"];
            [UserDefault setObject:dict[@"session"] forKey:@"session"];
            [UserDefault setObject:dict[@"session"][@"uid"] forKey:@"useruid"];
            [UserModel saveUserInfo:dict[@"user"]];
            [UserModel shareUserModel].login =  YES;
            [[UserModel shareUserModel] sendTobox];
            [[UserModel shareUserModel] infosendTobox];
            if ([dict[@"user"][@"proinfo"] isKindOfClass:[NSDictionary class]]) {
                [[UserModel shareUserModel] SaveOwnerInfo:dict[@"proinfo"]];
            }
            [self SavePassword];
            if (self.loginResultBlock) {
                self.loginResultBlock(str);//回调
            }
            NSString *tagstr = tfuser.text;//设备tag
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //推送设置推送tag
                __autoreleasing NSMutableSet *tags = [[NSMutableSet alloc]init];
                [self setTags:&tags addTag:tagstr];
                __autoreleasing NSString *alias = [NSString stringWithFormat:@"%@",dict[@"session"][@"uid"]];//别名
                LFLog(@"tags:%@ \nalias:%@",tags,alias);
                [JPUSHService setTags:tags alias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
                

                
            });
            //友盟统计
            if (tfuser.text.length) {
                [MobClick profileSignInWithPUID:tfuser.text];
            }
            [self popToFirst];
            [Notification postNotificationName:USERNotifiLogin object:nil userInfo:dict[@"user"]];
//            [self performSelector:@selector(popToFirst) withObject:nil afterDelay:2.0];
        }else{
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        
        
    } failure:^(NSError *error) {
        [self dismissTips];
        LFLog(@"error：%@",error);

    }];
}
- (void)setTags:(NSMutableSet **)tags addTag:(NSString *)tag {
    //  if ([tag isEqualToString:@""]) {
    // }
    LFLog(@"tag:%@",tag);
    [*tags addObject:tag];
}
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,tags, alias];
    NSLog(@"TagsAlias回调:%@", callbackString);
}
-(void)popToFirst{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   [self.navigationController setNavigationAlpha:0 animated:YES];
    [self refresh];
//    self.navigationHidden = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self.navigationController setNavigationAlpha:1.0 animated:YES];
//    self.navigationHidden = NO;
}



@end
