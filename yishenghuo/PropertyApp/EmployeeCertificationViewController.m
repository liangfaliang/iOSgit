//
//  EmployeeCertificationViewController.m
//  shop
//
//  Created by 梁法亮 on 16/8/3.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "EmployeeCertificationViewController.h"
#import "projectTableViewController.h"
#import "SMSSDK.h"
#import "NSString+YTString.h"
#import "SelectTableViewController.h"
@interface EmployeeCertificationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)UITableView *tableveiw;
//数据请求对象
@property(nonatomic,strong)NSMutableArray *requestArr;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *infoArray;
@property(nonatomic,strong)UIView *infoview;
@end

@implementation EmployeeCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.navigationBarTitle = @"员工认证";
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:248/255.0 alpha:1.0];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
    [self employInforequest];
    [self submitClickrequest];
}
- (NSMutableArray *)requestArr
{
    if (_requestArr == nil) {
        _requestArr = [[NSMutableArray alloc]init];
    }
    return _requestArr;
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}
-(NSMutableArray *)infoArray{
    
    if (_infoArray == nil) {
        _infoArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _infoArray;
}
-(void)createemployInfo{

    self.infoview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, SCREEN.size.height)];
    [self.view addSubview:self.infoview];
    NSDictionary *dt = self.infoArray[0];
    NSArray *namearr = @[@"公司名称:",@"部门和项目:",@"ERP账号:",@"认证手机:",@"认证时间:",@""];
    NSString *company = [NSString stringWithFormat:@"大庆高新"];
    NSString *department = [NSString stringWithFormat:@"%@%@",dt[@"le_name"],dt[@"company"]];
     NSString *ERPname = [NSString stringWithFormat:@"%@",dt[@"name"]];
    NSString *ERPphone = [NSString stringWithFormat:@"%@",dt[@"mobile"]];
    NSString *ERPtime = [NSString stringWithFormat:@"%@",dt[@"time"]];
    NSArray *infoarray = @[company,department,ERPname,ERPphone,ERPtime];
    for (int i = 0; i < 5; i ++) {
        
        UIView *itemveiw = [[UIView alloc]initWithFrame:CGRectMake(0, 35 * i, SCREEN.size.width, 34)];
        
        [self.infoview addSubview:itemveiw];
        UILabel *namelabel = [[UILabel alloc]init];
        namelabel.text = namearr[i];
        namelabel.textColor = JHColor(53, 53, 53);
        namelabel.font = [UIFont systemFontOfSize:15];
        
        [itemveiw addSubview:namelabel];
        [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.offset(15);
            make.top.offset(0);
            make.bottom.offset(0);
            make.width.offset(100);
            
        }];
        
        UILabel *conlabel = [[UILabel alloc]init];
        conlabel.text = infoarray[i];
        conlabel.textColor = JHColor(53, 53, 53);
        conlabel.font = [UIFont systemFontOfSize:15];
        
        [itemveiw addSubview:conlabel];
        [conlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(namelabel.mas_right).offset(10);
            make.top.offset(0);
            make.bottom.offset(0);
            make.right.offset(-10);
            
        }];
        
    }
    
    UIButton *afreshBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    afreshBtn.frame = CGRectMake(10, 175 + 44, SCREEN.size.width-20, 40);
    [afreshBtn.layer setMasksToBounds:YES];
    [afreshBtn.layer setCornerRadius:5.0];
    [afreshBtn setBackgroundColor:JHMaincolor];
    [afreshBtn setTitle:@"重新认证" forState:UIControlStateNormal];
    [afreshBtn setTintColor:[UIColor whiteColor]];
    [afreshBtn addTarget:self action:@selector(employafreshBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.infoview addSubview:afreshBtn];

    

}
#pragma mark 重新认证
-(void)employafreshBtnClick:(UIButton *)btn{

    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }
    UIAlertController *alertcontro = [UIAlertController alertControllerWithTitle:@"提示" message:@"清空已经认证的员工信息" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消了");
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentLoadingTips:@"请稍后~~"];
    [self clearemployInforequest];
        
    }];
    [alertcontro addAction:action];
    [alertcontro addAction:okAction];
    
    [self presentViewController:alertcontro animated:YES completion:nil];
    

    

}
-(void)creatableveiw{

    self.tableveiw = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    self.tableveiw.delegate = self;
    self.tableveiw.dataSource = self;
    self.tableveiw.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableveiw registerClass:[UITableViewCell class] forCellReuseIdentifier:@"employcell"];
    [self.view addSubview:self.tableveiw];
    


}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"employcell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *namelabel = [self.view viewWithTag:indexPath.row + 200];
    if (namelabel == nil) {
        namelabel = [[UILabel alloc]init];
        namelabel.tag = indexPath.row + 200;
    }
    
//    namelabel.adjustsFontSizeToFitWidth = YES;
//    namelabel.backgroundColor = [UIColor redColor];
    namelabel.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:namelabel];
    if (indexPath.row == 0) {
        namelabel.text = @"所属公司:";
        UIButton *btnselect = [self.view viewWithTag:indexPath.row + 100];
        if (btnselect == nil) {
            btnselect = [[UIButton alloc]init];
            btnselect.tag = indexPath.row + 100;
            [btnselect setTitleColor:JHMaincolor forState:UIControlStateNormal];
            [btnselect setTitle:@"请选择" forState:UIControlStateNormal];
        }

        [cell.contentView addSubview:btnselect];
        [btnselect mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(namelabel.mas_right).offset(5);
            make.top.offset(0);
            make.bottom.offset(0);
            make.right.offset(-10);
            
        }];

        btnselect.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnselect addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if (indexPath.row == 1){
    namelabel.text = @"ERP账号:";
        UITextField *tfERP = [self.view viewWithTag:indexPath.row + 100];
        if (tfERP == nil) {
            tfERP = [[UITextField alloc]init];
            tfERP.tag = indexPath.row + 100;
        }
        

        [cell.contentView addSubview:tfERP];
        [tfERP mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(namelabel.mas_right).offset(5);
            make.top.offset(0);
            make.bottom.offset(0);
            make.right.offset(-10);
            
        }];
        tfERP.placeholder = @"ERP账号";
        tfERP.font = [UIFont systemFontOfSize:14];
        tfERP.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        
    
    }else if (indexPath.row == 2){
        namelabel.text = @"ERP密码:";
        UITextField *tfERPPassWd = [self.view viewWithTag:indexPath.row + 100];
        if (tfERPPassWd == nil) {
            tfERPPassWd = [[UITextField alloc]init];
            tfERPPassWd.tag = indexPath.row + 100;
        }
        

        
        [cell.contentView addSubview:tfERPPassWd];
        [tfERPPassWd mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(namelabel.mas_right).offset(5);
            make.top.offset(0);
            make.bottom.offset(0);
            make.right.offset(-10);
            
        }];
        tfERPPassWd.placeholder = @"ERP密码";
        tfERPPassWd.secureTextEntry = YES;
        tfERPPassWd.font = [UIFont systemFontOfSize:14];
        tfERPPassWd.clearButtonMode = UITextFieldViewModeWhileEditing;
        
    }else if (indexPath.row == 3){
        namelabel.text = @"手机号:";
        UITextField *tfphone = [self.view viewWithTag:indexPath.row + 100];
        if (tfphone == nil) {
            tfphone = [[UITextField alloc]init];
            tfphone.tag = indexPath.row + 100;
        }

        
        [cell.contentView addSubview:tfphone];
        [tfphone mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(namelabel.mas_right).offset(5);
            make.top.offset(0);
            make.bottom.offset(0);
            
            
        }];
        tfphone.placeholder = @"请输入手机号";
        tfphone.font = [UIFont systemFontOfSize:14];
        tfphone.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIButton *btncode = [self.view viewWithTag:indexPath.row + 50];
        if (btncode == nil) {
            btncode = [[UIButton alloc]init];
            btncode.tag = indexPath.row + 50;
        }

        [cell.contentView addSubview:btncode];
        [btncode mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(tfphone.mas_right).offset(5);
            make.top.offset(0);
            make.bottom.offset(0);
            make.right.offset(-10);
            make.width.offset(90);
            
        }];
        [btncode setTitleColor:JHMaincolor forState:UIControlStateNormal];
        [btncode setTitle:@"获取验证码" forState:UIControlStateNormal];
        btncode.titleLabel.font = [UIFont systemFontOfSize:15];
        [btncode addTarget:self action:@selector(btncodeClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }else if (indexPath.row == 4){
        namelabel.text = @"手机验证码:";

        UITextField *tfcode = [self.view viewWithTag:indexPath.row + 100];
        if (tfcode == nil) {
            tfcode = [[UITextField alloc]init];
            tfcode.tag = indexPath.row + 100;
        }
        [cell.contentView addSubview:tfcode];
        [tfcode mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(namelabel.mas_right).offset(5);
            make.top.offset(0);
            make.bottom.offset(0);
            make.right.offset(-10);
            
        }];
        tfcode.placeholder = @"请输入验证码";
        tfcode.font = [UIFont systemFontOfSize:14];
        tfcode.clearButtonMode = UITextFieldViewModeWhileEditing;
        
    }else if (indexPath.row == 5){
        namelabel.text = @"ERP账号:";
        
    }
    
    CGSize size = [namelabel.text selfadap:15 weith:40];

    [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(0);
        make.bottom.offset(0);
        make.width.offset(size.width +5);
    }];

    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.view endEditing:YES];

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *foootview = [[UIView alloc]init];

    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitBtn.frame = CGRectMake(10, 30, SCREEN.size.width-20, 40);
    [submitBtn.layer setMasksToBounds:YES];
    [submitBtn.layer setCornerRadius:5.0];
    [submitBtn setBackgroundColor:JHMaincolor];
    [submitBtn setTitle:@"提  交" forState:UIControlStateNormal];
    [submitBtn setTintColor:[UIColor whiteColor]];
    [submitBtn addTarget:self action:@selector(employsubmitClick:) forControlEvents:UIControlEventTouchUpInside];
    [foootview addSubview:submitBtn];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapclick:)];
    [foootview addGestureRecognizer:tap];
    return foootview;
}

-(void)tapclick:(UIGestureRecognizer *)tap{

    [self.view endEditing:YES];
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return SCREEN.size.height - 100;
}
-(void)employsubmitClick:(UIButton *)btn{

     UIButton *btnselect = [self.view viewWithTag:100];
     UITextField *tfERP = [self.view viewWithTag:101];
    UITextField *tfERPpasswd = [self.view viewWithTag:102];
    UITextField *tfphone = [self.view viewWithTag:103];
    UITextField *tfcode = [self.view viewWithTag:104];
    
    if ([btnselect.titleLabel.text isEqualToString:@"请选择"]) {
        [self presentLoadingTips:@"请选择所属公司"];
    }else if (tfERP.text.length == 0){
        [tfERP becomeFirstResponder];
    [self presentLoadingTips:@"请输入ERP账号"];
    
    }else if (tfERPpasswd.text.length == 0){
        [tfERPpasswd becomeFirstResponder];
        [self presentLoadingTips:@"请输入ERP密码"];
        
    }else if (tfphone.text.length == 0){
        [tfphone becomeFirstResponder];
        [self presentLoadingTips:@"请输入手机号"];
        
    }else if (![tfphone.text isValidateMobile]){
        [tfphone becomeFirstResponder];
        [self presentLoadingTips:@"请输入正确的手机号"];
        
    }else if (tfcode.text.length == 0){
        [tfcode becomeFirstResponder];
        [self presentLoadingTips:@"请输入验证码"];
        
    }else {
        [self presentLoadingTips:@"请稍后~~"];
        [self registerData:tfERP.text uspass:tfERPpasswd.text mobile:tfphone.text];

//        [SMSSDK commitVerificationCode:tfcode.text phoneNumber:tfphone.text zone:@"86" result:^(NSError *error){
//            if (!error) {
//                [self dismissTips];
//             NSLog(@"SUCCEED!");
//         [self registerData:tfERP.text uspass:tfERPpasswd.text mobile:tfphone.text];
//
//                
//            }else {
//                
//                [self presentFailureTips:@"验证码错误"];
//                
//            }
//            
//        }];
        
    }

}
#pragma mark 选择按钮
-(void)selectClick:(UIButton *)btn{

//    projectTableViewController *project = [[projectTableViewController alloc]init];
//    
//    if (self.dataArray.count > 0) {
//        
//        for (NSDictionary *dict in self.dataArray) {
//            
//            for (NSDictionary *arrprovince in dict[@"note"]) {
//                
//                for (NSDictionary *dt in arrprovince[@"le_arr"]) {
//                    
//                    if ([dt[@"company"] isEqualToString:@"大庆高新"]) {
//                        for (NSDictionary *lastdt in dt[@"note"]) {
//                            [project.projectArray addObject:lastdt];
//                        }
//                    }
//                }
//                
//            }
//        }
//        
//        
//    }
//    
//    
//    [self.navigationController pushViewController:project animated:YES];
    SelectTableViewController *select = [[SelectTableViewController alloc]init];
    if (self.dataArray) {
        
        for (NSDictionary *dict in self.dataArray) {
            
            [select.selectArray addObject:dict];
        }
    }
    
    //   NSLog(@"物业项目：%@",select.selectArray );
    [self.navigationController pushViewController:select animated:YES];
    
}

-(void)btncodeClick:(UIButton *)bt{
    
    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }
    
    UITextField *tfphone = [self.view viewWithTag: 103];
    UITextField *tfcode = [self.view viewWithTag: 104];
    if (tfphone.text.length == 0) {
        [self presentLoadingTips:@"请输入手机号"];
        [tfphone becomeFirstResponder];
        return;
    }
    if (![tfphone.text isValidateMobile]){
        [self presentLoadingTips:@"请输入正确的手机号"];
        
        return;
        
    }
    bt.userInteractionEnabled = NO;
    [self presentLoadingTips];

//    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:tfphone.text zone:@"86" result:^(NSError *error) {
//        [self dismissTips];
//        if (!error) {
//            NSLog(@"SUCCEED!");
//            [self presentLoadingTips:@"验证码已发送~~"];
//            [tfcode becomeFirstResponder];
//            __block int timeout=60; //倒计时时间
//            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//            dispatch_source_set_event_handler(_timer, ^{
//
//                if(timeout<=0){ //倒计时结束，关闭
//                    dispatch_source_cancel(_timer);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //设置界面的按钮显示 根据自己需求设置
//
//                        [bt setTitle:@"获取验证码" forState:UIControlStateNormal];
//                        [bt setTitleColor:JHMaincolor forState:UIControlStateNormal];
//                        bt.userInteractionEnabled = YES;
//                    });
//                }else{
//                    int seconds = timeout % 60;
//                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //设置界面的按钮显示 根据自己需求设置
//                        [UIView beginAnimations:nil context:nil];
//                        [UIView setAnimationDuration:1];
//                        [bt setTitle:[NSString stringWithFormat:@"%@秒重发",strTime] forState:UIControlStateNormal];
//                        [bt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//                        [UIView commitAnimations];
//                        bt.userInteractionEnabled = NO;
//                    });
//                    timeout--;
//                }
//            });
//            dispatch_resume(_timer);
//
//        } else {
//            bt.userInteractionEnabled = YES;
//            [bt setTitle:@"重新获取" forState:UIControlStateNormal];
//            NSLog(@"错误信息:%@",error.userInfo[@"getVerificationCode"]);
//            [self presentLoadingTips:error.userInfo[@"getVerificationCode"]];
//            return ;
//        }
//    }];
//
    
}

#pragma mark 物业项目数据请求
-(void)submitClickrequest{

    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"1") params:nil success:^(id response) {
        for (NSDictionary *dt in response) {
            
            [self.dataArray addObject:dt];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark 员工信息认证
-(void)registerData:(NSString *)usname uspass:(NSString *)uspass mobile:(NSString *)mobile{

    [self presentLoadingTips:@"请稍后~~"];
//    NSDictionary *dt = @{@"userid":uid,@"mobile":mobile,@"province":@"黑龙江省",@"city":@"大庆市",@"dename":@"大庆高新",@"company":@"27",@"lename":self.str,@"leid":self.strid,@"usname":usname,@"uspass":uspass};
    
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSArray *arrid = [self.strid componentsSeparatedByString:@","];
    NSArray *arrname = [self.str componentsSeparatedByString:@" "];
    NSDictionary *dt = [NSDictionary dictionary];
    if (arrid.count > 3) {
        dt = @{@"userid":uid,@"mobile":mobile,@"province":arrname[0],@"city":arrname[1],@"company":arrname[2],@"companyid":arrid[2],@"lename":arrname[3],@"leid":arrid[3],@"usname":usname,@"uspass":uspass};
    }

    
    [LFLHttpTool post:NSStringWithFormat(ZJguokaihangBaseUrl,@"31") params:dt success:^(id response) {

        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        [self dismissTips];
        if ([str isEqualToString:@"0"]) {
            
            NSLog(@"认证成功");
            
            [self presentLoadingTips:@"认证成功"];
            [self performSelector:@selector(performrefrch) withObject:nil afterDelay:1.0];
            
            
        }else{
            NSLog(@"认证失败");
            [self presentLoadingTips:response[@"err_msg"]];
            
            
        }
        

    } failure:^(NSError *error) {
        
    }];
    
}


#pragma mark 员工个人信息数据请求
-(void)employInforequest{
    NSString *uid = [UserDefault objectForKey:@"useruid"];

    if (uid == nil) {
        uid = @"";
    }
    NSDictionary *dt = @{@"userid":uid};
    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"32") params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        LFLog(@"个人信息：%@",response);
        if ([str isEqualToString:@"0"]) {
            
            NSArray *ar = response[@"note"];
            if (ar.count == 0) {
                [self creatableveiw];
                self.navigationBarTitle = @"员工认证";
            }else{
                [self.infoArray addObject:response[@"note"]];
                
                NSDictionary *dt = response[@"note"];
                [UserDefault setObject:dt[@"Province"] forKey:@"workerProvince"];
                [UserDefault setObject:dt[@"City"] forKey:@"workerCity"];
                [UserDefault setObject:dt[@"le_name"] forKey:@"workerle_name"];
                [UserDefault setObject:dt[@"leid"] forKey:@"workerleid"];
                [UserDefault setObject:dt[@"name"] forKey:@"workername"];
                [UserDefault setObject:dt[@"company"] forKey:@"workercompany"];
                [UserDefault setObject:dt[@"coid"] forKey:@"workercoid"];
                [UserDefault setObject:dt[@"usid"] forKey:@"workerusid"];
                [UserDefault setObject:dt[@"user_name"] forKey:@"workeruser_name"];
                [UserDefault setObject:dt[@"mobile"] forKey:@"workermobile"];
                [UserDefault setObject:dt[@"us_db"] forKey:@"workerus_db"];
                [UserDefault synchronize];
                [self createemployInfo];
                self.navigationBarTitle = @"员工信息";
            }
            
        }else{
            
            self.navigationBarTitle = @"员工认证";
            [self creatableveiw];
            
            
        }

    } failure:^(NSError *error) {
        self.navigationBarTitle = @"员工认证";
        [self creatableveiw];
    }];
    
}

#pragma mark 清除员工个人信息数据请求
-(void)clearemployInforequest{
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    
    if (uid == nil) {
        uid = @"";
    }
    NSDictionary *dt = @{@"userid":uid};
    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"34") params:dt success:^(id response) {
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        
        if ([str isEqualToString:@"0"]) {
            [[UserModel shareUserModel] removeWorkUserInfo];
            LFLog(@"清除个人信息：%@",response);
            [self.infoview removeAllSubviews];
            [self.infoview removeFromSuperview];
            [self creatableveiw];
            
        }else{
            
            
            [self creatableveiw];
            [self submitClickrequest];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}



-(void)performrefrch{

    self.navigationBarTitle = @"员工信息";
    [self.tableveiw removeFromSuperview];
    [self employInforequest];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.str) {
        UIButton *btn = [self.view viewWithTag:100];
        [btn setTitle:self.str forState:UIControlStateNormal];
        [btn setTitleColor:JHColor(102, 102, 102) forState:UIControlStateNormal];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.str = nil;
    self.strid = nil;
    

}





@end
