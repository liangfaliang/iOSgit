//
//  AttestViewController.m
//  shop
//
//  Created by 梁法亮 on 16/4/7.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//




#import "AttestViewController.h"
#import "SelectTableViewController.h"
#import "RepairsViewController.h"
#import "PayViewController.h"
#import "companyTableViewController.h"

#import "NSString+YTString.h"

#import "projectTableViewController.h"
#import "SMSSDK.h"
#import "LFLaccount.h"
#import "Records.h"
//#import "InformationViewController.h"


@interface AttestViewController ()<UINavigationControllerDelegate>
@property (retain, nonatomic) IBOutlet UIView *rootView;
@property (retain, nonatomic) IBOutlet UITextField *textPhone;

@property (retain, nonatomic) IBOutlet UITextField *textcode;


@property (retain, nonatomic) IBOutlet UIButton *buttonCode;
@property (retain, nonatomic) IBOutlet UIButton *SubmitButton;

@property(nonatomic,strong)UILabel *lb;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *userInfo;


@property(nonatomic,strong)NSArray *strArray;
@property(nonatomic,strong)NSArray *strArrayid;
@property(nonatomic,strong)UIView *submitView;

//数据请求对象
@property(nonatomic,strong)NSMutableArray *requestArr;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;//右滑手势
@end

@implementation AttestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.viewTop.constant = (kDevice_Is_iPhoneX ? 84 :64);
    self.view.backgroundColor = [UIColor whiteColor];
//      self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
//    self.automaticallyAdjustsScrollViewInsets = YES;
    self.lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.buttonCode.frame.size.width, self.buttonCode.frame.size.height)];
    _lb.textColor = JHMaincolor;
    _lb.text = @"获取验证码";
    _lb.font = [UIFont systemFontOfSize:12];
    [self.buttonCode addSubview:self.lb];
    [_lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
    }];
    
//    self.title = @"业主认证";
    self.navigationController.delegate = self;
    self.navigationBarTitle = @"业主认证";
    [self submitClickreque];
    [self creatSubmitView];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    [self presentLoadingTips];
    [Notification addObserver:self selector:@selector(USERInfoupdateState:)
                         name:USERInfo object:nil];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

//-(BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender
-(NSMutableArray *)dataArray{

    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }

    return _dataArray;
}

-(NSMutableString *)str{

    if (_str == nil) {
        _str = [[NSMutableString alloc]init];
    }

    return  _str;
}

- (NSMutableArray *)requestArr
{
    if (_requestArr == nil) {
        _requestArr = [[NSMutableArray alloc]init];
    }
    return _requestArr;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

-(void)showUserInfo{
    
    self.navigationBarTitle = @"业主信息";
    UIView *firstview = [[UIView alloc]initWithFrame:CGRectMake(0, (kDevice_Is_iPhoneX ? 84 :64), SCREEN.size.width, SCREEN.size.height )];
    firstview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstview];
    
    firstview.tag = 15;
    NSUserDefaults *defuat = [NSUserDefaults standardUserDefaults];
    
    NSString *locationstr = [NSString stringWithFormat:@"%@ %@ %@",[defuat objectForKey:@"Province"],[defuat objectForKey:@"City"],[defuat objectForKey:@"company"]];
    Records *recordView = [[NSBundle mainBundle]loadNibNamed:@"Records" owner:nil options:nil][0];
    recordView.username.text = [NSString stringWithFormat:@"业主姓名：%@",[defuat objectForKey:@"name"]];
    recordView.usercompany.text = [NSString stringWithFormat:@"物业公司：%@",[defuat objectForKey:@"company"]];
    recordView.userproject.text = [NSString stringWithFormat:@"物业项目：%@",[defuat objectForKey:@"le_name"]];
    recordView.location.text = [NSString stringWithFormat:@"位  置：%@",locationstr];
    NSInteger count = [[UserDefault objectForKey:@"PropertyCount"] integerValue];
    NSMutableString *roomstr = [NSMutableString string];
    for (int i = 0; i < count; i ++) {
        
        [roomstr appendFormat:@"%@",[UserDefault objectForKey:[NSString stringWithFormat:@"po_name_%d",i]]];
        if (i < count - 1) {
            [roomstr appendString:@"\n"];
        }
    }
    recordView.roomNme.text = roomstr;
    recordView.room.text = @"房    间:";
    //    recordView.room.text = [NSString stringWithFormat:@"房  间：%@",[defuat objectForKey:@"po_name_0"]];
    recordView.recordtime.text = [NSString stringWithFormat:@"认证时间：%@",[defuat objectForKey:@"time"]];
    NSLog(@"time:%@",recordView.recordtime.text);
    NSLog(@"rrr:%@",[defuat objectForKey:@"po_name"]);
    NSString *phonestr = [NSString stringWithFormat:@"认证手机：%@",[defuat objectForKey:@"mobile"]];
    
    [recordView.phoneButon setTitle:phonestr forState:UIControlStateNormal];
    
    recordView.frame = CGRectMake(0, 0, firstview.frame.size.width, 300);
    
    [firstview addSubview:recordView];
    NSArray *titlearray = [[NSArray alloc]initWithObjects:@"认证其他业主信息",@"重新认证", nil];
    
    //    for (int i = 0; i<2; i++) {
    UIButton * button= [[UIButton alloc]initWithFrame:CGRectMake(20, recordView.frame.size.height +10 , firstview.frame.size.width - 40, 40)];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:20.0];
    button.backgroundColor = JHMaincolor;
    [button setTitle:titlearray[1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(AttestbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 12;
    [firstview addSubview:button];
    //    }
    
    
    
}

- (void)creatSubmitView
{
    self.submitView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN.size.height/2, SCREEN.size.width, 40)];
    UIButton *submitBtn = [[UIButton alloc]init];
    submitBtn.frame = CGRectMake(10, 0, SCREEN.size.width-20, 40);
    [submitBtn.layer setMasksToBounds:YES];
    [submitBtn.layer setCornerRadius:20.0];
    [submitBtn setBackgroundColor:JHMaincolor];
    [submitBtn setTitle:@"提  交" forState:UIControlStateNormal];
    [submitBtn setTitle:@"提  交" forState:UIControlStateSelected];
    [submitBtn setTintColor:[UIColor whiteColor]];
    [submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.submitView addSubview:submitBtn];
    [self.view addSubview:self.submitView];
    
}

#pragma mark 重新认证按钮
-(void)AttestbuttonClick:(UIButton *)btn{
    
    if (btn.tag == 12) {
        
        if (![userDefaults objectForKey:NetworkReachability]) {
            [self presentLoadingTips:@"网络貌似掉了~~"];
            return;
        }
        for (UIButton *sumview in self.submitView.subviews) {
            if ([sumview isKindOfClass:[UIButton class]]) {
                sumview.selected = YES;
            }
        }
        
        
//        [[UserModel shareUserModel] removeUserInfo];
//        self.navigationBarTitle = @"业主认证";
//        [self.view endEditing:YES];
//        for (UIView *view in self.view.subviews) {
//            if (view.tag == 15) {
//                [view setHidden:YES];
//            }
//        }

        UIAlertController *alertcontro = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要重新认证吗？确定后将清除之前的认证信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消了");
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            

            [self removeUserInfo];
        }];
        [alertcontro addAction:action];
        [alertcontro addAction:okAction];
        
        [self presentViewController:alertcontro animated:YES completion:nil];
        
        
        return;
    }
//    self.title = @"业主认证";
//    [self.view endEditing:YES];
//    for (UIView *view in self.view.subviews) {
//        if (view.tag == 15) {
//            [view setHidden:YES];
//        }
//    }
    
    
    
}


#pragma mark 选择项目接口
- (IBAction)buttonClick:(id)sender {
    
    if (!self.dataArray.count) {
        [self submitClickreque];
        return;
    }
//    SelectTableViewController *select = [[SelectTableViewController alloc]init];
//    if (self.dataArray) {
//        
//        for (NSDictionary *dict in self.dataArray) {
//            
////            if ([dict[@"Province"] isEqualToString:@"四川省"]) {
//                [select.selectArray addObject:dict];
////            }
//            
//        }
//    }
    
//   NSLog(@"物业项目：%@",select.selectArray );
//    [self.navigationController pushViewController:select animated:YES];
    
    companyTableViewController *company = [[companyTableViewController alloc]init];
    company.is_Sort = @"Att";
    for (NSDictionary *dt in self.dataArray) {
        [company.companyArray addObject:dt];
    }
//    NSString *prid = @"1";
//    NSString *ciid = @"1";
//    if (self.dataArray.count > 0) {
//            for (NSDictionary *dict in self.dataArray) {
//                if ([dict[@"Province"] isEqualToString:@"四川省"]) {
//                    prid = dict[@"prid"];
//                }
//
//                for (NSDictionary *arrprovince in dict[@"note"]) {
//
//                    if (([arrprovince[@"city"] isEqualToString:@"绵阳市"])) {
//                        ciid = arrprovince[@"ciid"];
//                        for (NSDictionary *dt in arrprovince[@"le_arr"]) {
//
//                            //                        if ([dt[@"company"] isEqualToString:@"绵阳市"]) {
////                            for (NSDictionary *lastdt in dt[@"note"]) {
//                                [company.companyArray addObject:dt];
////                            }
//                            //                        }
//                        }
//                    }
//
//
//                }
//        }
//
//
//    }
//    company.str = [NSMutableString stringWithFormat:@"四川省 绵阳市"];
//    company.strid = [NSMutableString stringWithFormat:@"%@,%@",prid,ciid];
  
    [self.navigationController pushViewController:company animated:YES];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 提交接口
- (void)submitClick:(UIButton *)sender {
    
    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }

    
    //判断是否登录
    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {
        }];
        return;
    }
    [self submit];

    
}
-(void)submit{
    //    if (self.textID.text.length == 0) {
    //        [MBProgressHUD showError:@"身份证号码不能为空"];
    //        return;
    //
    //    }else if (self.textID.text.length <10 || self.textID.text.length > 18) {
    //
    //        [MBProgressHUD showError:@"请输入正确的身份证号"];
    //        return;
    //
    //
    //    }else{
    
    if ([self.proButton.titleLabel.text isEqualToString:@"请选择"]) {
        [self presentLoadingTips:@"请选择项目"];
        return;
    }
    if (self.textPhone.text.length == 0) {
        [self presentLoadingTips:@"请输入手机号"];
        
        return;
    }else if (![self.textPhone.text isValidateMobile]){
        [self presentLoadingTips:@"请输入正确的手机号"];
        
        return;
        
    }else{
        
        
        if (self.textcode.text.length == 0) {
            [self presentLoadingTips:@"请输入验证码"];
            
        }else{
#ifdef DEBUG //测试阶段
            [self registerData];
            
#else
            [[SMSSDK sharedSMSSDK] commitVerificationCode:self.textcode.text
                                          phoneNumber:self.textPhone.text
                                                 zone:@"86"
                                              success:^(id response) {
                                                  [self dismissTips];
                                                  NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
                                                  if ([str isEqualToString:@"1"]) {
                                                      NSLog(@"SUCCEED!");
                                                      [self registerData];
                                                  }else {
                                                      [self presentLoadingTips:response[@"status"][@"error_desc"]];
                                                  }
                                              } failure:^(NSError *error) {
                                                  
                                                  
                                              }];
//            [SMSSDK commitVerificationCode:self.textcode.text phoneNumber:self.textPhone.text zone:@"86" result:^(NSError *error){
//                if (!error) {
//                    NSLog(@"SUCCEED!");
//                    [self registerData];
//                } else {
//
//                    [self presentLoadingTips:@"验证码错误"];
//
//                }
//            }];
            
#endif
            
        }
        
        
    }
    //    }

}

#pragma mark 发送验证码接口
- (IBAction)codeButtonclick:(id)sender {
    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }
    if (self.textPhone.text.length == 0) {
        [self presentLoadingTips:@"请输入手机号"];
        return;
    }
    UIButton *bt = (UIButton *)sender;
    bt.userInteractionEnabled = NO;
    [self presentLoadingTips];
    [[SMSSDK sharedSMSSDK] getVerificationCodeByMethod:@"authentication" phoneNumber:self.textPhone.text zone:@"86" success:^(id response) {
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            NSLog(@"SUCCEED!");
            __block int timeout=60; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        //[bt setTitle:@"发送验证码" forState:UIControlStateNormal];
                        _lb.text = @"获取验证码";
                        _lb.textColor = JHMaincolor;
                        bt.userInteractionEnabled = YES;
                    });
                }else{
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:1];
                        
                        _lb.text = [NSString stringWithFormat:@"%@秒重发",strTime];
                        
                        _lb.textColor = [UIColor grayColor];
                        //[bt setTitle:[NSString stringWithFormat:@"%@秒重发",strTime] forState:UIControlStateNormal];
                        [UIView commitAnimations];
                        bt.userInteractionEnabled = NO;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
            
        } else {
            //            [bt setTitle:@"重新获取" forState:UIControlStateNormal];
            _lb.text = @"获取验证码";
            bt.userInteractionEnabled = YES;
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            return ;
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"请求失败！"];
        
    }] ;
//    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.textPhone.text zone:@"86"  result:^(NSError *error){
//        [self dismissTips];
//    }];
    
    
    
}

#pragma mark 业主信息认证
-(void)registerData{
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSArray *arrid = [self.strID componentsSeparatedByString:@","];
    NSArray *arrname = [self.str componentsSeparatedByString:@" "];
    NSDictionary *dt = [NSDictionary dictionary];
    if (arrid.count > 3) {
        dt = @{@"userid":uid,@"mobile":self.textPhone.text,@"province":arrname[0],@"city":arrname[1],@"company":arrname[2],@"companyid":arrid[2],@"lename":arrname[3],@"leid":arrid[3]};
    }
    LFLog(@"dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJguokaihangBaseUrl,@"2") params:dt success:^(id response) {
        
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            
            NSLog(@"认证成功");
            [self presentLoadingTips:@"认证成功"];            
            [[UserModel shareUserModel] sendTobox];
            
        }else if ([str isEqualToString:@"2"]){
            
            [[UserModel shareUserModel] sendTobox];
            [self showUserInfo];
            UIAlertController *alertcontro = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已认证过了" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            
            [alertcontro addAction:okAction];
            
            [self presentViewController:alertcontro animated:YES completion:nil];
            
        }else{
            NSLog(@"认证失败:%@",response[@"err_msg"]);
            [self presentLoadingTips:response[@"err_msg"]];
            
            
        }

        
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark 通知刷新
-(void)USERInfoupdateState:(NSNotification*)notify{
    LFLog(@"notify:%@",notify);
    [self dismissTips];
    if ([[notify.userInfo objectForKey:@"login"]isEqualToString:@"succeed"]) {
        [self showUserInfo];
    }else{
        self.navigationBarTitle = @"业主认证";
        [self.view endEditing:YES];
        for (UIView *view in self.view.subviews) {
            if (view.tag == 15) {
                [view setHidden:YES];
            }
        }
    }
    
}
#pragma mark 清除业主信息
-(void)removeUserInfo{
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSDictionary *dt = @{@"userid":uid};
    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"4") params:dt success:^(id response) {
        
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        
        if ([str isEqualToString:@"0"]) {
            
            [[UserModel shareUserModel] removeUserInfo];
   
             [self presentLoadingTips:@"已清除"];
            self.navigationBarTitle = @"业主认证";
            [self.view endEditing:YES];
            for (UIView *view in self.view.subviews) {
                if (view.tag == 15) {
                    [view setHidden:YES];
                }
            }
            

            
            
        }else{
            //            [self presentFailureTips:array[@"err_msg"]];
            
            
            
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
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

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }
    
    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {
        }];
        return;
    }
    
    if (![self.isSenbox isEqualToString:@"projectTableViewController"]) {
        if ( NO == [UserModel online] )
        {
            [self showLogin:^(id response) {
            }];
            
            return;
        }
        
      [[UserModel shareUserModel] sendTobox];
//         [self isqwertt];
        
    }
    
    

   
    if (self.str) {
//        self.strArray = [self.str componentsSeparatedByString:@" "];
        LFLog(@"%@",self.str);
        LFLog(@"%@",self.strID);
//        self.strArrayid = [self.strID componentsSeparatedByString:@" "];
    }

}

-(void)isqwertt{
    NSUserDefaults *defuat = [NSUserDefaults standardUserDefaults];
    NSString *str = [NSString stringWithFormat:@"%@",[defuat objectForKey:@"name"]];
    NSLog(@"3232:%@",str);
    if ([str isEqualToString: @"(null)"]) {
        
        [[UserModel shareUserModel] sendTobox];
       
//        if ([[LFLaccount shareaccount].returnMessage isEqualToString:@"0"]) {
//            [self showUserInfo];
//        }
        
    }else{
        
        [self showUserInfo];
        
    }

    



}

-(void)poprootviewcontroler{

    [self.navigationController popViewControllerAnimated:YES];


}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    self.isSenbox = nil;
    
    
     NSArray *vcArr = self.navigationController.viewControllers;
    for (UIViewController *vc in vcArr) {
        if ([vc isKindOfClass:[RepairsViewController class]]) {
            RepairsViewController *att = (RepairsViewController *)vc;
            att.isPop = @"pop";
        }else if ([vc isKindOfClass:[PayViewController class]]){
        
            PayViewController *pay = (PayViewController *)vc;
            
            pay.isPop = @"pop";
        
        
//        }else if ([vc isKindOfClass:[InformationViewController class]]){
//            
//            InformationViewController *info = (InformationViewController *)vc;
//            
//            info.isPop = @"pop";
//            
//            
        }

    }

}
-(void)dealloc{
    [Notification removeObserver:self];
    
}




@end
