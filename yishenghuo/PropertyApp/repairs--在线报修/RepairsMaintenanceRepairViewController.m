//
//  MaintenanceRepairViewController.m
//  shop
//
//  Created by 梁法亮 on 16/8/12.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "RepairsMaintenanceRepairViewController.h"
#import "LFLUibutton.h"
#import "MHDatePicker.h"
#import "PickerChoiceView.h"
@interface RepairsMaintenanceRepairViewController ()<UITableViewDelegate,UITableViewDataSource,MHSelectPickerViewDelegate,TFPickerDelegate,UITextViewDelegate>{
    
    BOOL _isnormal ;
    BOOL _isfinish ;
}
@property(nonatomic,strong)UITableView *tableveiw;

@property (strong, nonatomic) MHDatePicker *selectTimePicker;

@property(nonatomic,strong)NSArray *namekeysecon2;
@property(nonatomic,copy)NSString *closetime;


@property(nonatomic,copy)NSString *begantime;
@property(nonatomic,copy)NSString *endtime;
//数据请求对象
@property(nonatomic,strong)NSMutableArray *requestArr;

@end

@implementation RepairsMaintenanceRepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.navigationBarTitle = @"记录反馈";
    LFLog(@"namekey:%@",self.namekey);
    _isnormal = YES;
    _isfinish = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatableveiw];
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (NSMutableArray *)requestArr
{
    if (_requestArr == nil) {
        _requestArr = [[NSMutableArray alloc]init];
    }
    return _requestArr;
}
-(void)creatableveiw{
    
    self.tableveiw = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    self.tableveiw.delegate = self;
    self.tableveiw.dataSource = self;
    
    [self.tableveiw registerClass:[UITableViewCell class] forCellReuseIdentifier:@"employcell1"];
    [self.tableveiw registerClass:[UITableViewCell class] forCellReuseIdentifier:@"employcell2"];
    [self.view addSubview:self.tableveiw];
    
    
}

-(NSMutableAttributedString *)AttributedString:(NSString *)allstr attstring:(NSString *)attstring{
    NSMutableAttributedString* htinstr = [[NSMutableAttributedString alloc]initWithString:allstr];
    NSString *str = attstring;
    NSRange range =[[htinstr string]rangeOfString:str];
    [htinstr addAttribute:NSForegroundColorAttributeName value:JHColor(102, 102, 102) range:range];
    
    return htinstr;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    //    if (section == 1) {
    //        return 370 * self.asidcArr.count;
    //    }
    return 0.000001;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section == 1) {
        return 300;
    }
    return 0.000001;
    
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.namearr.count;
    }else{
        return 2;
        
    }
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"employcell1"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *or_servertime = self.namekey[indexPath.row];
        LFLog(@"or_servertime:%@",or_servertime);
        if (![or_servertime isKindOfClass:[NSNull class]]) {
            if (or_servertime.length == 0) {
                or_servertime = @"无";
            }else{
                
                if ([or_servertime rangeOfString:@"1900"].location == NSNotFound && [or_servertime rangeOfString:@"1970"].location == NSNotFound ) {
                } else {
                    or_servertime = @"无";
                    //                    NSLog(@"string 包含 martin");
                }
                
            }
    
        }else{
            or_servertime = @"无";
        }
        cell.textLabel.attributedText = [self AttributedString:[NSString stringWithFormat:@"%@ %@",self.namearr[indexPath.row],or_servertime] attstring:[NSString stringWithFormat:@"%@",or_servertime]];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        return cell;
       
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"employcell2"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *namelabel = [self.view viewWithTag:indexPath.row + 2000];
        if (namelabel == nil) {
            namelabel = [[UILabel alloc]init];
            namelabel.tag = indexPath.row + 2000;
        }
               //    namelabel.adjustsFontSizeToFitWidth = YES;
        //    namelabel.backgroundColor = [UIColor redColor];
        namelabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:namelabel]; 


            if (indexPath.row == 0) {
                UIImageView *rightimage = [[UIImageView alloc]init];
                rightimage.image = [UIImage imageNamed:@"gerenzhongxinjiantou"];
                namelabel.text = @"客户满意度：";
                UIButton *btnselect = [self.view viewWithTag: 1111];
                if (btnselect == nil) {
                    btnselect = [[UIButton alloc]init];
                    btnselect.tag = 1111;
                    [btnselect setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
                    [btnselect setTitle:@"特别满意" forState:UIControlStateNormal];
                }
                
                [cell.contentView addSubview:btnselect];
                [btnselect mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(namelabel.mas_right).offset(5);
                    make.top.offset(0);
                    make.bottom.offset(0);
                    make.right.offset(-10);
                    
                }];
                
                [btnselect addTarget:self action:@selector(clientbtnselectclick:) forControlEvents:UIControlEventTouchUpInside];
                btnselect.titleLabel.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:rightimage];
                [rightimage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(-10);
                    make.centerY.equalTo(cell.mas_centerY);
                    
                }];
            } else if (indexPath.row == 1){
                namelabel.text = @"回访意见：";
                UITextView *tfERPPassWd = [self.view viewWithTag:105];
                if (tfERPPassWd == nil) {
                    tfERPPassWd = [[UITextView alloc]init];
                    tfERPPassWd.tag = 105;
                    tfERPPassWd.textColor = JHColor(102, 102, 102);
                    tfERPPassWd.backgroundColor = JHColor(245, 245, 245);
                    tfERPPassWd.delegate = self;
                }
 
                [cell.contentView addSubview:tfERPPassWd];
                [tfERPPassWd mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(10);
                    make.top.equalTo(namelabel.mas_bottom).offset(5);
                    make.bottom.offset(-10);
                    make.right.offset(-10);
                    
                }];
                tfERPPassWd.layer.cornerRadius = 5;
                tfERPPassWd.layer.borderColor = [JHColor(225, 225, 225) CGColor];
                tfERPPassWd.layer.borderWidth = 1;
                tfERPPassWd.font = [UIFont systemFontOfSize:13];
                
                
            }

        CGSize size = [namelabel.text selfadap:15 weith:40];
        
        [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.offset(0);
            make.height.offset(44);
            make.width.offset(size.width +5);
        }];
        
      
        return cell;
        
    }
    
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        return 44;
    }else{
        if ( indexPath.row == 1) {
            return 120;
        }
    }
    
    
    return 44;
    
}
-(void)clientbtnselectclick:(UIButton *)btn{
    
    [self.view endEditing:YES];
   PickerChoiceView * _picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
    _picker.inter =2;
    _picker.titlestr = @"请选择";
    _picker.arrayType = HeightArray;
    _picker.delegate = self;
    NSArray *arr = @[@"特别满意",@"比较满意",@"满意",@"不满意"];
    for (NSString *dt in arr) {
        [_picker.typearr addObject:dt];
    }
    
    [self.view addSubview:_picker];
    
}
- (void)PickerSelectorIndixString:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    
    NSLog(@"%@",str);
    UIButton *btn = [self.view viewWithTag:1111];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];

    
}

//-(void)closebtnselectclick:(UIButton *)btn{
//    
//    [self.view endEditing:YES];
//    _selectTimePicker = [[MHDatePicker alloc] init];
//    _selectTimePicker.tag = 1000;
//    _selectTimePicker.delegate = self;
//    
//}
//-(void)beganbtnselectclick:(UIButton *)btn{
//    
//    [self.view endEditing:YES];
//    _selectTimePicker = [[MHDatePicker alloc] init];
//    _selectTimePicker.tag = 1001;
//    _selectTimePicker.delegate = self;
//    
//}
//
//-(void)endbtnselectclick:(UIButton *)btn{
//    
//    [self.view endEditing:YES];
//    _selectTimePicker = [[MHDatePicker alloc] init];
//    _selectTimePicker.tag = 1002;
//    _selectTimePicker.delegate = self;
//    
//}

//#pragma mark - 时间回传值
//- (void)timeString:(NSString *)timeString{
//    
//    UIButton *btn = [self.view viewWithTag:_selectTimePicker.tag - 900];
//    [btn setTitle:timeString forState:UIControlStateNormal];
//    
//    [btn setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
//    long time;
//    NSDateFormatter *format=[[NSDateFormatter alloc] init];
//    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *fromdate=[format dateFromString:timeString];
//    time= (long)[fromdate timeIntervalSince1970];
//    NSNumber *longNumber = [NSNumber numberWithLong:time];
//    if (_selectTimePicker.tag == 1000) {
//        
//        self.closetime = [longNumber stringValue];
//    }else if (_selectTimePicker.tag == 1001){
//        self.begantime = [longNumber stringValue];
//
//    }else{
//        
//        self.endtime = [longNumber stringValue];;
//        
//    }
//    
//}

-(void)keppClick:(UIButton *)btn{
    
    [self.view endEditing:YES];
    if (btn.tag == 120) {
        _isnormal = YES;
    }else{
        
        _isnormal = NO;
    }
    for (int i = 0; i < 2; i++) {
        UIButton *button = [self.view viewWithTag:120 + i];
        if (button.tag == btn.tag) {
            [button setImage:[UIImage imageNamed:@"gongdanxiangqingxuanzhong"] forState:UIControlStateNormal];
        }else{
            [button setImage:[UIImage imageNamed:@"gongdanxiangqingweixuanzhong"] forState:UIControlStateNormal];
        }
    }
    
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    
    
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *foootview = [[UIView alloc]init];
    
    if (section == 1) {
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
    }
    
    
    
    return foootview;
}

-(void)tapclick:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}
#pragma mark - textviewdeletelt
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    UIView *view = textView.superview;
    while (![view isKindOfClass:[UITableViewCell class]]) {
        view = [view superview];
    }
    
    UITableViewCell *cell = (UITableViewCell*)view;
    CGRect rect = [cell convertRect:cell.frame toView:self.view];
    if (rect.origin.y / 2 + rect.size.height>=SCREEN.size.height-216) {
        //        self.tableveiw.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        [self.tableveiw scrollToRowAtIndexPath:[self.tableveiw indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    return YES;
}
-(void)employsubmitClick:(UIButton *)btn{

    UITextView *tfERP = [self.view viewWithTag:105];

    
    UIButton *clientselect = [self.view viewWithTag:1111];
    

    if ([clientselect.titleLabel.text isEqualToString:@"请选择"]) {
        [tfERP becomeFirstResponder];
        [self presentLoadingTips:@"请选择客户意见"];
        return;
    }
//     if (tfERP.text.length == 0){
//        [tfERP becomeFirstResponder];
//        [self presentLoadingTips:@"请输入原因"];
//         return;
//        
//     }
    
        [self presentLoadingTips:@"请稍后~~"];
        
        [self UploadDatarepairreload];

    
}

#pragma mark - 工单报修
-(void)UploadDatarepairreload{
    UITextView *tfERP = [self.view viewWithTag:105];
    NSString *leid = [UserDefault objectForKey:@"leid"];
    if (leid == nil) {
        leid = @"";
    }
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) {
        coid = @"";
    }

    NSMutableDictionary *dt = [NSMutableDictionary dictionaryWithObjectsAndKeys:leid,@"leid",coid,@"coid",self.dataArray[0][@"orid"],@"orid", nil];
    if (tfERP.text.length > 0) {
        [dt setObject:tfERP.text forKey:@"sea_idea"];
    }
    if (self.tag == 111) {
        UIButton *btn = [self.view viewWithTag:1111];
        NSString *grade = [NSString string];
        if ([btn.titleLabel.text isEqualToString:@"特别满意"]) {
            grade = @"100";
        }else if ([btn.titleLabel.text isEqualToString:@"比较满意"]){
            grade = @"90";
        }else if ([btn.titleLabel.text isEqualToString:@"满意"]){
            grade = @"70";
        }else if ([btn.titleLabel.text isEqualToString:@"不满意"]){
            grade = @"40";
        }

        [dt setObject:grade forKey:@"sea_quic"];
    }
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    [dt setObject:dateString forKey:@"sea_date"];
    
    if (![self.namekey[1] isKindOfClass:[NSNull class]]) {
        [dt setObject:self.namekey[1] forKey:@"mobile"];
    }
    
//    [self alertController:@"提示" prompt:[self dictionaryToJson:dt] sure:@"确定" cancel:nil success:^{
//        [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,@"em_ReturnAnswer") params:dt success:^(id response) {
//            [self.tableveiw.mj_header endRefreshing];
//            [self.tableveiw.mj_footer endRefreshing];
////            UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
////            pastboard.string = [self dictionaryToJson:response];
//            [self alertController:@"提示返回信息" prompt:[self dictionaryToJson:response] sure:@"确定" cancel:nil success:^{
//                [self performSelector:@selector(popclick) withObject:nil afterDelay:2.0];
//            } failure:^{
//                
//            }];
//            LFLog(@"response：%@",response);
//            NSString *str = [NSString stringWithFormat:@"%@",response[@"error"]];
//            [self dismissTips];
//            if ([str isEqualToString:@"0"]) {
//                
//                [self presentLoadingTips:@"提交成功"];
//                //            if (self.gobackBlock) {
//                //                self.gobackBlock();
//                //            }
//                            [self performSelector:@selector(popclick) withObject:nil afterDelay:2.0];
//            }else{
//                [self presentLoadingTips:response[@"date"]];
//                
//            }
//            
//        } failure:^(NSError *error) {
//            [self alertController:@"提示错误信息" prompt:[self dictionaryToJson:error.userInfo] sure:@"确定" cancel:nil success:^{
//                [self performSelector:@selector(popclick) withObject:nil afterDelay:2.0];
//            } failure:^{
//                
//            }];
//            [self.tableveiw.mj_header endRefreshing];
//            [self.tableveiw.mj_footer endRefreshing];
//        }];
//
//    } failure:^{
//        
//    }];
    LFLog(@"提交：%@",dt);
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,@"em_ReturnAnswer") params:dt success:^(id response) {
        [self.tableveiw.mj_header endRefreshing];
        [self.tableveiw.mj_footer endRefreshing];
//        UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
//        pastboard.string = [self dictionaryToJson:response];
        LFLog(@"response：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"error"]];
        [self dismissTips];
        if ([str isEqualToString:@"0"]) {
    
            [self presentLoadingTips:@"提交成功"];
//            if (self.gobackBlock) {
//                self.gobackBlock();
//            }
            [self performSelector:@selector(popclick) withObject:nil afterDelay:2.0];
        }else{
            
            [self presentLoadingTips:response[@"date"]];
          
        }
        
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"服务器连接失败"];
        [self.tableveiw.mj_header endRefreshing];
        [self.tableveiw.mj_footer endRefreshing];
    }];

}

//字典转json格式字符串：
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(void)popclick{
//    NSArray *vcArr = self.navigationController.viewControllers;
//    for (UIViewController *vc in vcArr) {
//        if ([vc isKindOfClass:[MaintenanceRecordViewController class]]) {
//        
//            NSLog(@"自控制器：%@",[vc class]);
//            
//            MaintenanceRecordViewController *att = (MaintenanceRecordViewController *)vc;
// 
//            [att UploadDataload];
//            [self.navigationController popToViewController:att animated:YES];
//        }
//    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end

