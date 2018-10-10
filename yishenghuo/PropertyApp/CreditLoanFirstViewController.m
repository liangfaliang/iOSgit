//
//  CreditLoanFirstViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/5/11.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "CreditLoanFirstViewController.h"
#import "SMSSDK.h"
#import "CreditLoanSecondViewController.h"
@interface CreditLoanFirstViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITextField *tf;
}
@property (nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSArray *nameArr1;
@property(nonatomic,strong)NSArray *nameArr2;
@property(nonatomic,strong)NSArray *keyArr2;
@end

@implementation CreditLoanFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"贷款申请";
    self.nameArr1 = @[@"业主姓名：",@"身份证号：",@"联系电话：",@"验证码："];
    self.nameArr2 = @[@"房屋地址：",@"建筑面积：",@"小区评估价：",@"房屋估值："];
    self.keyArr2 = @[@"em_name",@"sp_spua",@"sd_value",@"sd_suggest_value"];
    [self UploadDatadynamic];
    UILabel *rightLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    rightLb.font = [UIFont systemFontOfSize:15];
    rightLb.textColor = JHmiddleColor;
    rightLb.text = @"1/2步";
    UIBarButtonItem *rightItem= [[UIBarButtonItem alloc]initWithCustomView:rightLb];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(void)createUI{
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorColor = JHColor(222, 222, 222);
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"iscell"];
        self.tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.tableView];
        
        UIView *foootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 300)];
        
        UIButton *submitBtn = [[UIButton alloc]init];
        [submitBtn setImage:[UIImage imageNamed:@"xiayibu_xinyongdai"] forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(employsubmitClick:) forControlEvents:UIControlEventTouchUpInside];
        [foootview addSubview:submitBtn];
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(foootview.mas_centerY);
            make.centerX.equalTo(foootview.mas_centerX);
        }];
        self.tableView.tableFooterView = foootview;
    }

    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.nameArr1.count;
    }
    return self.nameArr2.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIImageView *view = [[UIImageView alloc]init];
    view.image = [UIImage imageNamed:@"fengexiantongyong"];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //        NSString *CellIdentifier = @"iscell";
    //        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSString *CellIdentifier = [NSString stringWithFormat:@"creditcell%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc]init];
        label.textColor = JHColor(53, 53, 53);
        label.font = [UIFont systemFontOfSize:15];
        if (indexPath.section == 0) {
            label.text = self.nameArr1[indexPath.row];
        }else{
            label.text = self.nameArr2[indexPath.row];
        }
        
        
        CGSize lbsize = [label.text selfadaption:15];
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(10);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.width.offset(lbsize.width + 5);
            
        }];
        
        if (indexPath.section == 0 && indexPath.row == 3) {
            UIButton *VerificationBtn = [[UIButton alloc]init];
            VerificationBtn.layer.borderColor = [JHColor(0, 169, 224) CGColor];
            VerificationBtn.layer.borderWidth = 1;
            VerificationBtn.layer.cornerRadius = 3;
            VerificationBtn.layer.masksToBounds = YES;
            VerificationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [VerificationBtn setTitleColor:JHColor(0, 169, 224) forState:UIControlStateNormal];
            [VerificationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [VerificationBtn addTarget:self action:@selector(VerificationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:VerificationBtn];
            [VerificationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.offset(-10);
                make.width.offset([VerificationBtn.titleLabel.text selfadap:15 weith:20].width + 20);
                make.height.offset(25);
            }];
            if (tf == nil) {
                tf = [[UITextField alloc]init];
                tf.textColor = JHmiddleColor;
                tf.font = [UIFont systemFontOfSize:15];
                tf.placeholder = @"请输入验证码";
                [cell.contentView addSubview:tf];
                [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(label.mas_right).offset(5);
                    make.top.offset(0);
                    make.bottom.offset(0);
                    make.right.equalTo(VerificationBtn.mas_left).offset(-10);
                }];
                
            }
            
            
            
        }else{
            
            UILabel *objclabel = [[UILabel alloc]init];
            objclabel.textColor = JHColor(102, 102, 102);
            objclabel.font = [UIFont systemFontOfSize:15];
            objclabel.numberOfLines = 0;
            if (indexPath.section == 0 && indexPath.row < 3) {
                objclabel.text = self.keyArr1[indexPath.row];
            }else if (indexPath.section == 1){
                LFLog(@"self.dataArray信息：%@",self.dataArray);
                if (self.dataArray.count) {
                    NSDictionary *dt = self.dataArray[0];
                    LFLog(@"信息：%ld",(long)indexPath.row);
                    if (dt[self.keyArr2[indexPath.row]]) {
                        objclabel.text =[NSString stringWithFormat:@"%@", dt[self.keyArr2[indexPath.row]]];
                    }
                }
                
                
            }
            [cell.contentView addSubview:objclabel];
            [objclabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(label.mas_right).offset(5);
                make.top.offset(0);
                make.bottom.offset(0);
                make.right.offset(-10);
                
            }];
            
        }

    }
    
        
    return cell;

    
}
//发送验证码
-(void)VerificationBtnClick:(UIButton *)sender{

    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"请检查您的网络状态~~"];
        
        return;
    }
    NSString *mobile = @"";
    if (self.keyArr1.count > 1) {
        mobile = self.keyArr1[2];
    }
    sender.userInteractionEnabled = NO;
    [self presentLoadingTips];
    [[SMSSDK sharedSMSSDK] getVerificationCodeByMethod:@"jrwf" phoneNumber:mobile zone:@"86" success:^(id response) {
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            NSLog(@"SUCCEED!");
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
            
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"请求失败！"];
        
    }] ;
//    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:mobile zone:@"86" result:^(NSError *error){
//        [self dismissTips];
//        if (!error)
//            NSLog(@"错误信息:%@",error.userInfo[@"getVerificationCode"]);
//            [self presentLoadingTips:error.userInfo[@"getVerificationCode"]];
//            return ;
//        }
//    }];

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *imagevw = [[UIImageView alloc]init];
    imagevw.image = [UIImage imageNamed:@"biaotikuang_xinyongdai"];
    UILabel *lb = [[UILabel alloc]init];
    lb.font = [UIFont systemFontOfSize:14];
    lb.textColor = JHsimpleColor;
    if (section == 0) {
        lb.text = @"贷款人基本信息";
    }else{
        lb.text = @"贷款人房产信息";
    }
    [imagevw addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(0);
        make.bottom.offset(0);
        make.right.offset(-10);
    }];
    return imagevw;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

#pragma mark 下一步
-(void)employsubmitClick:(UIButton *)btn{


    
    
    NSString *mobile = @"";
    if (self.keyArr1.count > 1) {
        mobile = self.keyArr1[2];
    }else{
        [self presentLoadingTips:@"您的手机号码为空"];
    }
#ifdef DEBUG //测试阶段
    CreditLoanSecondViewController *second = [[CreditLoanSecondViewController alloc]init];
    second.dataDt = self.dataDt;
    if (self.dataArray.count) {
        second.PropertyDt = self.dataArray[0];
    }
    second.keyArr1 = self.keyArr1;
    [self.navigationController pushViewController:second animated:YES];
#else
    if (tf.text.length) {
        [self presentLoadingTips];
        [[SMSSDK sharedSMSSDK] commitVerificationCode:tf.text
                                      phoneNumber:mobile
                                             zone:@"86"
                                          success:^(id response) {
                                              [self dismissTips];
                                              NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
                                              if ([str isEqualToString:@"1"]) {
                                                  
                                                  NSLog(@"SUCCEED!");
                                                  CreditLoanSecondViewController *second = [[CreditLoanSecondViewController alloc]init];
                                                  second.dataDt = self.dataDt;
                                                  if (self.dataArray.count) {
                                                      second.PropertyDt = self.dataArray[0];
                                                  }
                                                  second.keyArr1 = self.keyArr1;
                                                  [self.navigationController pushViewController:second animated:YES];
                                              }else {
                                                  [self presentLoadingTips:response[@"status"][@"error_desc"]];
                                              }
                                          } failure:^(NSError *error) {
                                              [self dismissTips];
                                              
                                          }];
//        [SMSSDK commitVerificationCode:tf.text phoneNumber:mobile zone:@"86" result:^(NSError *error){
//            if (!error) {
//
//
//
//
//            }else {
//
//                [self presentLoadingTips:@"验证码错误"];
//
//            }
//
//        }];
        
    }else{
        [self dismissTips];
        [self presentLoadingTips:@"请您输入验证码"];
    }
#endif


    
}
#pragma mark - *************房产信息*************
-(void)UploadDatadynamic{
    [self presentLoadingTips];
    NSString *leid = [UserDefault objectForKey:@"leid"];
    if (leid == nil) {
        leid = @"";
    }
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) {
        coid = @"";
    }
    NSString *mobile = [UserDefault objectForKey:@"mobile"];
    if (mobile == nil) {
        mobile = @"";
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:leid,@"leid",coid,@"coid",mobile,@"mobile", nil];
    //    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    //    NSDictionary *pagination = @{@"count":@"5",@"page":page};
    //    [dt setObject:pagination forKey:@"pagination"];
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,@"102") params:dt success:^(id response) {
        LFLog(@"房产信息:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"error"]];
        if ([str isEqualToString:@"0"]) {
            
            [self.dataArray removeAllObjects];
//            if ([response[@"note"] isKindOfClass:[NSDictionary class]]) {
                [self.dataArray addObject:response[@"note"][0]];
//            }
            [self createUI];
            [self.tableView reloadData];
            
        }else{

            [self presentLoadingTips:response[@"date"]];
            
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];

}
@end
