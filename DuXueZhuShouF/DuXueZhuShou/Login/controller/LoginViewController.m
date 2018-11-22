//
//  LoginViewController.m
//  AppProject
//
//  Created by admin on 2018/5/21.
//  Copyright © 2018年 admin. All rights reserved.
//学生账号  ypxs1   ypxs1123456
//学管员xgs1  xgs1123456
#import "LoginViewController.h"
#import "JPUSHService.h"
#import <UMAnalytics/MobClick.h>//友盟统计
//#import "SMSSDK.h"
//#import "TencentLogin.h"
//#import "WXApiRequestHandler.h"
//#import "WXApiManager.h"
#import "AppDelegate.h"
#import "YYText.h"
#import "UIViewController+BackButtonHandler.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
SYNTHESIZE_SINGLETON_FOR_CLASS(LoginViewController);
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self creayeUI];
    
}

-(void)creayeUI{

    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.image = [UIImage imageNamed:@"logologin"];
    [self.view addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(104);
        make.centerX.equalTo(self.view.mas_centerX);
        
    }];
    UIImage *im1 = imageview.image;
    NSArray *namearr = @[@"请输入用户名",@"请输入密码"];
    for (int i = 0; i < 2; i ++) {
        UIImageView *view1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, im1.size.height + 134 + i *60, screenW - 30, 47)];
        view1.userInteractionEnabled = YES;
        view1.image = [UIImage imageNamed:@"shurukuang"];
        view1.backgroundColor = [UIColor blueColor];
        view1.contentMode =  UIViewContentModeScaleToFill;
        [self.view addSubview:view1];
        UITextField *tf = [[UITextField alloc]init];
        tf.tag = 500 + i;
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        tf.font = [UIFont systemFontOfSize:14];
        tf.placeholder = namearr[i];
//        tf.keyboardType = UIKeyboardTypeNumberPad;
        [view1 addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.offset(0);
            make.bottom.offset(-2);
            make.right.offset(0);
        }];
        if (i == 1) {
            tf.secureTextEntry = YES;
            tf.text =  [UserDefault objectForKey:@"namepass"];
            UIButton *subbtn = [[UIButton alloc]init];
            subbtn.backgroundColor = JHMaincolor;
            [subbtn setTitle:@"登录" forState:UIControlStateNormal];
            subbtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [subbtn addTarget:self action:@selector(subbuttonclick:) forControlEvents:UIControlEventTouchUpInside];
            subbtn.layer.cornerRadius = 20;
            subbtn.layer.masksToBounds = YES;
            [self.view addSubview:subbtn];
            [subbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(40);
                make.right.offset(-40);
                make.height.offset(40);
                make.top.equalTo(view1.mas_bottom).offset(50);
                
            }];
        }else{
            NSString *name =  [UserDefault objectForKey:@"nameuser"];
            LFLog(@"name:%@",name);
            if (name) {
                tf.text = name;
            }
        }
    }

}


//登陆
-(void)subbuttonclick:(UIButton *)btn{
    
//    [self jumpOver];
//    return;
    
    UITextField *tfphone = [self.view viewWithTag:500];
    UITextField *tfcode = [self.view viewWithTag:501];

    if (![UserDefault objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"请检查您的网络状态~~"];
        return;
    }

    if (tfphone.text.length == 0) {
        [self presentLoadingTips:@"请输入用户名"];
        return;
    }
//    if (tfphone.text.length < 4){
//        [self presentLoadingTips:@"请输入正确的用户名"];
//        return;
//    }
    if (tfcode.text.length == 0) {
        [self presentLoadingTips:@"请输入密码"];
        return;
    }
    [self doLogin];
    
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
#pragma mark 手机号登陆
-(void)doLogin{
    [self presentLoadingTips:@"请稍后~~~"];
    UITextField *tfuser = [self.view viewWithTag:500];
    UITextField *tfpass = [self.view viewWithTag:501];
    NSDictionary *dt = @{@"username":tfuser.text,@"password":tfpass.text};
    LFLog(@"name:%@password:%@",tfuser.text,tfpass.text);
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,LoginUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"用户信息:%@",response);
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            NSDictionary *dict = response[@"data"];
            [self LoginSuccess:dict code:code];
        }
        [self presentLoadingTips:response[@"msg"]];
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

-(void)LoginSuccess:(NSDictionary *)dict code:(NSInteger )code{
    if (dict) {
        [UserUtils saveUserInfo:dict];//保存用户数据
        [UserUtils postGetUserInfo:nil success:nil failure:nil];//获取用户基本信息
    }
    [self SavePassword];
    NSString *tagstr = dict[@"userId"];//设备tag
    if (tagstr && tagstr.length) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //推送设置推送tag
            __autoreleasing NSMutableSet *tags = [[NSMutableSet alloc]init];
            [self setTags:&tags addTag:tagstr];
            __autoreleasing NSString *alias = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",dict[@"userId"]]];//别名
            [JPUSHService setTags:tags alias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        });
    }
    //友盟统计
    if ([dict[@"userId"] length]) {
        [MobClick profileSignInWithPUID:dict[@"userId"]];
    }

    if (self.loginResultBlock) {
        self.loginResultBlock(code);//回调
    }
    [self jumpOver];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refresh];
    //    self.navigationHidden = YES;
}

-(void)dismiss{
    if (self.presentingViewController) {
        UIViewController *vc =self.presentingViewController;
        while (vc.presentingViewController) {
            vc = vc.presentingViewController;
        }
        if ([vc isKindOfClass:[LFLTabBarViewController class]]) {
            UINavigationController *na = ((LFLTabBarViewController *)vc).selectedViewController;
            vc = na.topViewController;
//            bord.isPresent = NO;
        }else if ([vc isKindOfClass:[UIViewController class]]){
//            vc.isPresent = NO;
        }
        [vc dismissViewControllerAnimated:YES completion:^{
            vc.isPresent = NO;
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.isPresent = NO;
}
-(void)jumpOver{
    if (self.loginResultBlock) {
        self.loginResultBlock(-2);//回调
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.type = [UserUtils getUserRole];
    [self dismiss];
//    if (appDelegate.tabbar) {
//
//        if ([UIApplication sharedApplication].keyWindow.rootViewController == appDelegate.tabbar) {
//            [self dismiss];
//        }else{
//            [UIApplication sharedApplication].keyWindow.rootViewController = appDelegate.tabbar;
//        }
//    }else{
//        LFLTabBarViewController *tabbar = [[LFLTabBarViewController alloc]init];
//        tabbar.type = [UserUtils getUserRole];
//        appDelegate.tabbar = tabbar;
//        [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
//    }
}
@end
