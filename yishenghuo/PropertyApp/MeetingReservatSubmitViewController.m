//
//  MeetingReservatSubmitViewController.m
//  shop
//
//  Created by 梁法亮 on 16/10/10.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "MeetingReservatSubmitViewController.h"
#import "HPGrowingTextView.h"
#import "LFLUibutton.h"
#import "PickerChoiceView.h"
#import "MHDatePicker.h"
@interface MeetingReservatSubmitViewController ()<UITableViewDelegate,UITableViewDataSource,TFPickerDelegate,MHSelectPickerViewDelegate>
@property (strong,nonatomic)HPGrowingTextView *tfvw;
@property(nonatomic,strong)UITableView *tableveiw;
@property(nonatomic,strong)NSArray *nameArr;
@property(nonatomic,strong)NSArray *keyArr;
@property(nonatomic,strong)UIView *footview;
@property (strong, nonatomic) MHDatePicker *selectTimePicker;
@property (strong, nonatomic)PickerChoiceView* picker;
@property(nonatomic,strong)NSString * AuditOver;
@property(nonatomic,strong)UIButton * meetButton;
@property(nonatomic,strong)UIButton * begainBtn;
@property(nonatomic,strong)UIButton * endBtn;
@property(nonatomic,strong)UIButton * unitBtn;
@property(nonatomic,strong)UITextField * tfmeetname;
@property(nonatomic,strong)UITextField * tfnumber;
@property(nonatomic,strong)UITextField * tftime;
@property(nonatomic,strong)UITextField * tfphone;
//时间戳
@property(nonatomic,strong)NSString * begainstr;
@property(nonatomic,strong)NSString * endstr;
@end

@implementation MeetingReservatSubmitViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationBarTitle = @"会议室预定详情";
    self.nameArr = @[@"会议室:",@"面积:",@"座位数:",@"投影仪:",@"电话会议:"];
    self.keyArr = @[@"po_name",@"size",@"seat",@"ep_isty",@"ep_istv",@""];
    LFLog(@"dataArray:%@",self.dataArray);
    
    self.AuditOver = @"end";
    [self createFootview];
    [self creatableveiw];
}

-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
}

-(void)createFootview{
    
    self.footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 300)];
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"tijiaoshenqing_kaoqin"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sumclickbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.footview addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.footview.mas_centerX);
        make.top.offset(50);
    }];
    
}
-(void)creatableveiw{
    
    self.tableveiw = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    self.tableveiw.delegate = self;
    self.tableveiw.dataSource = self;
    self.tableveiw.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.tableveiw.tableFooterView = self.footview;
    
    
    [self.view addSubview:self.tableveiw];
    
    [self.tableveiw registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MeetingsubmitViewController"];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (section == 0) {
        return self.nameArr.count;
    }
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        if (indexPath.row == 7) {
            return 70;
        }

    }
    return 44;
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetingsubmitViewController"];
        
        NSDictionary *dt = self.dataArray[indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView removeAllSubviews];
        CGSize lbsize = [self.nameArr[indexPath.row] selfadaption:15];
        UILabel *label = [[UILabel alloc]init];
        label.textColor = JHColor(53, 53, 53);
        label.font = [UIFont systemFontOfSize:15];
        label.text = self.nameArr[indexPath.row];
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(10);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.width.offset(lbsize.width + 5);
            
        }];
        UILabel *objclabel = [[UILabel alloc]init];
        objclabel.textColor = JHColor(102, 102, 102);
        objclabel.font = [UIFont systemFontOfSize:13];
        objclabel.numberOfLines = 0;
        if ([[dt objectForKey:self.keyArr[indexPath.row]] isKindOfClass:[NSString class]]) {
            objclabel.text = [dt objectForKey:self.keyArr[indexPath.row]];
        }else if ([[dt objectForKey:self.keyArr[indexPath.row]] isKindOfClass:[NSNumber class]]){
            NSNumber *num = [dt objectForKey:self.keyArr[indexPath.row]];
            objclabel.text = [NSString stringWithFormat:@"%@",num];
        }
        
        [cell.contentView addSubview:objclabel];
        [objclabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(label.mas_right).offset(5);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.offset(-10);
            
        }];
        
        LFLog(@"%ld",(long)indexPath.row);
        return cell;
        
        
    }else{
         NSString *Identifier = [NSString stringWithFormat:@"Identifier%ld",(long)indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *namelabel = [self.view viewWithTag:indexPath.row + 2000];
        if (namelabel == nil) {
            namelabel = [[UILabel alloc]init];
            namelabel.tag = indexPath.row + 2000;
        }
        namelabel.textColor = JHColor(53, 53, 53);
        namelabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:namelabel];
        UIImageView *rightimage  = [self.view viewWithTag:indexPath.row + 1000];
        if (rightimage == nil) {
            rightimage = [[UIImageView alloc]init];
            rightimage.tag = indexPath.row + 1000;
            rightimage.image = [UIImage imageNamed:@"gerenzhongxinjiantou"];
            [cell.contentView addSubview:rightimage];
            [rightimage mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.offset(-10);
                make.centerY.equalTo(cell.mas_centerY);
                
            }];
        }

        if (indexPath.row == 0) {
            namelabel.text = @"会议服务类型：";
            if (_meetButton == nil) {
                _meetButton = [[UIButton alloc]init];
                [_meetButton setTitle:@"普通会议" forState:UIControlStateNormal];
                _meetButton.titleLabel.font =[UIFont systemFontOfSize:13];
                [_meetButton setTitleColor:JHColor(102, 102, 102) forState:UIControlStateNormal];
                [cell.contentView addSubview:_meetButton];
                _meetButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                [_meetButton addTarget:self action:@selector(allbuttonclick:) forControlEvents:UIControlEventTouchUpInside];
            }
            [_meetButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(namelabel.mas_right).offset(5);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.offset(-30);
            }];
            
        }else if(indexPath.row == 1){
            rightimage.hidden = YES;
            namelabel.text = @"会议服务名称：";
            if (_tfmeetname == nil) {
                _tfmeetname = [[UITextField alloc]init];
                _tfmeetname.placeholder = @"请输入会议名称";
                _tfmeetname.textColor = JHColor(102, 102, 102);
                _tfmeetname.font = [UIFont systemFontOfSize:13];
                [cell.contentView addSubview:_tfmeetname];
            }
            [_tfmeetname mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(namelabel.mas_right).offset(5);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.offset(-10);
            }];
        }else if(indexPath.row == 2){
            rightimage.hidden = YES;
            namelabel.text = @"预定人数：";
            UILabel *numlabel = [cell viewWithTag:54];
            if (numlabel == nil) {
                numlabel = [[UILabel alloc]init];
                numlabel.tag = 54;
                NSArray * numarr = [self.dataArray[0][@"seat"] componentsSeparatedByString:@"--"];
                if (numarr.count > 1) {
                    numlabel.text = [NSString stringWithFormat:@"人 （最多%@人）",numarr[1]];
                }
                numlabel.font = [UIFont systemFontOfSize:13];
            }

            [cell.contentView addSubview: numlabel];
            CGSize numsize = [numlabel.text selfadaption:13];
            [numlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.offset(-10);
                make.width.offset(numsize.width + 5);
            }];
            if (_tfnumber == nil) {
                _tfnumber = [[UITextField alloc]init];
              _tfnumber.placeholder = @"请输入人数";
                _tfnumber.keyboardType = UIKeyboardTypeNumberPad;
                _tfnumber.font = [UIFont systemFontOfSize:13];
                [cell.contentView addSubview:_tfnumber];
            }
            [_tfnumber mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(namelabel.mas_right).offset(5);
                make.right.equalTo(numlabel.mas_left).offset(5);
                make.centerY.equalTo(cell.contentView.mas_centerY);
            }];
            
        }else if(indexPath.row == 3){
            
            namelabel.text = @"开始时间：";
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            long time= (long)[currentDate timeIntervalSince1970];
            self.begainstr = [NSString stringWithFormat:@"%ld",time];
            if (_begainBtn == nil) {
                _begainBtn = [[UIButton alloc]init];
                [_begainBtn setTitle:dateString forState:UIControlStateNormal];
                _begainBtn.titleLabel.font =[UIFont systemFontOfSize:13];
                [_begainBtn setTitleColor:JHColor(102, 102, 102) forState:UIControlStateNormal];
                [cell.contentView addSubview:_begainBtn];
                _begainBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                [_begainBtn addTarget:self action:@selector(allbuttonclick:) forControlEvents:UIControlEventTouchUpInside];
            }
            [_begainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(namelabel.mas_right).offset(5);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.offset(-30);
            }];
            
        }else if(indexPath.row == 4){
            
            namelabel.text = @"结束时间：";
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            long time= (long)[currentDate timeIntervalSince1970];
            self.endstr = [NSString stringWithFormat:@"%ld",time];
            if (_endBtn == nil) {
                _endBtn = [[UIButton alloc]init];
                [_endBtn setTitle:dateString forState:UIControlStateNormal];
                _endBtn.titleLabel.font =[UIFont systemFontOfSize:13];
                [_endBtn setTitleColor:JHColor(102, 102, 102) forState:UIControlStateNormal];
                [cell.contentView addSubview:_endBtn];
                _endBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                [_endBtn addTarget:self action:@selector(allbuttonclick:) forControlEvents:UIControlEventTouchUpInside];
            }
            [_endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(namelabel.mas_right).offset(5);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.offset(-30);
            }];
            
        }else if(indexPath.row == 5){

            namelabel.text = @"使用时间：";
            if (_unitBtn == nil) {
                _unitBtn = [[UIButton alloc]init];
                _unitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                [_unitBtn setTitle:@"小时" forState:UIControlStateNormal];
                [_unitBtn setTitleColor:JHColor(102, 102, 102) forState:UIControlStateNormal];
                [_unitBtn addTarget:self action:@selector(allbuttonclick:) forControlEvents:UIControlEventTouchUpInside];
            }
            [cell.contentView addSubview: _unitBtn];
            CGSize numsize = [_unitBtn.titleLabel.text selfadaption:13];
            [_unitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.offset(-30);
                make.width.offset(numsize.width + 5);
            }];
            if (_tftime == nil) {
                _tftime = [[UITextField alloc]init];
                _tftime.placeholder = @"请输入时间";
                _tftime.keyboardType = UIKeyboardTypeNumberPad;
                _tftime.font = [UIFont systemFontOfSize:13];
                [cell.contentView addSubview:_tftime];
            }
            [_tftime mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(namelabel.mas_right).offset(5);
                make.right.equalTo(_unitBtn.mas_left).offset(5);
                make.centerY.equalTo(cell.contentView.mas_centerY);
            }];
            
        }else if(indexPath.row == 6){
            rightimage.hidden = YES;
            namelabel.text = @"联系方式：";
            if (_tfphone == nil) {
                _tfphone = [[UITextField alloc]init];
                _tfphone.placeholder = @"请输入联系方式";
                _tfphone.font = [UIFont systemFontOfSize:13];
                _tfphone.keyboardType = UIKeyboardTypeNumberPad;
                [cell.contentView addSubview:_tfphone];
            }
            [_tfphone mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(namelabel.mas_right).offset(5);
                make.right.offset(-10);
                make.centerY.equalTo(cell.contentView.mas_centerY);
            }];
            
        }else if(indexPath.row == 7){
            rightimage.hidden = YES;
            namelabel.text = @"备注：";
            if (_tfvw == nil) {
                _tfvw = [[HPGrowingTextView alloc]init];
                _tfvw.layer.borderColor = [JHColor(229, 229, 229) CGColor];
                _tfvw.layer.borderWidth = 1;
                _tfvw.layer.cornerRadius = 3;
                _tfvw.placeholder = @"";
            }
            
            [cell.contentView addSubview:_tfvw];
            [_tfvw mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(namelabel.mas_right).offset(15);
                make.top.offset(10);
                make.bottom.offset(-10);
                make.right.offset(-15);
                
            }];
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

-(NSMutableAttributedString *)AttributedString:(NSString *)allstr attstring:(NSString *)attstring{
    NSMutableAttributedString* htinstr = [[NSMutableAttributedString alloc]initWithString:allstr];
    NSString *str = attstring;
    NSRange range =[[htinstr string]rangeOfString:str];
    [htinstr addAttribute:NSForegroundColorAttributeName value:JHColor(102, 102, 102) range:range];
    [htinstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    return htinstr;
    
}

-(void)allbuttonclick:(UIButton *)btn{

    [self.view endEditing:YES];
    if ([btn isEqual:_meetButton]) {
        _picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
        _picker.titlestr = @"请选择";
        _picker.inter =2;
        _picker.delegate = self;
        _picker.tag = 200;
        _picker.arrayType = HeightArray;
        [_picker.typearr addObject:@"普通会议"];
        [_picker.typearr addObject:@"重要会议"];
        [_picker.typearr addObject:@"培训会议"];
        [_picker.typearr addObject:@"接待会议"];
        [self.view addSubview:_picker];
    }else if ([btn isEqual:_unitBtn]){
        _picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
        _picker.inter =2;
        _picker.titlestr = @"请选择";
        _picker.delegate = self;
        _picker.tag = 201;
        _picker.arrayType = HeightArray;

        [_picker.typearr addObject:@"天"];
        [_picker.typearr addObject:@"小时"];
        [_picker.typearr addObject:@"分钟"];
        [self.view addSubview:_picker];
        
    }else if ([btn isEqual:_begainBtn]){
        _selectTimePicker = [[MHDatePicker alloc] init];
        _selectTimePicker.tag = 300;
        _selectTimePicker.delegate = self;
    
    }else{
        _selectTimePicker = [[MHDatePicker alloc] init];
        _selectTimePicker.tag = 301;
        _selectTimePicker.delegate = self;
    
    }

}

#pragma mark - 时间回传值
- (void)timeString:(NSString *)timeString
{
    long time;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:timeString];
    time= (long)[fromdate timeIntervalSince1970];
    NSNumber *longNumber = [NSNumber numberWithLong:time];
    if (_selectTimePicker.tag == 300) {
        [self.begainBtn setTitle:timeString forState:UIControlStateNormal];
        self.begainstr = [longNumber stringValue];
    }else{
        [self.endBtn setTitle:timeString forState:UIControlStateNormal];
        self.endstr = [longNumber stringValue];

    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    DetailsPageViewController *dtail = [[DetailsPageViewController alloc]init];
    //    dtail.dataArray = self.dataArray[indexPath.section];
    //    [self.stack pushBoard:dtail animated:YES];
    
}
#pragma mark 数据提交按钮

-(void)sumclickbtn:(UIButton *)btn{
    
    
    [self.view endEditing:YES];
    if (_tfmeetname.text.length == 0) {
        [_tfmeetname becomeFirstResponder];
        [self presentLoadingTips:@"请输入会议名称"];
    }else if (self.tfnumber.text.length == 0) {
        [self.tfnumber becomeFirstResponder];
        [self presentLoadingTips:@"请输入预定人数"];
    }else if (self.tftime.text.length == 0) {
        [self.tftime becomeFirstResponder];
        [self presentLoadingTips:@"请输入使用时间"];
    }else if (self.tfphone.text.length == 0) {
        [self.tfphone becomeFirstResponder];
        [self presentLoadingTips:@"请输入联系方式"];
    }else if (self.tfvw.text.length == 0) {
        [self.tfvw becomeFirstResponder];
        [self presentLoadingTips:@"请输入备注内容"];
    }else{
        [self subtimeData];
        
    }
    
}
#pragma mark -------- TFPickerDelegate

- (void)PickerSelectorIndixString:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    
    NSLog(@"%@",str);
    if (_picker.tag == 200) {
        [_meetButton setTitle:str forState:UIControlStateNormal];
    }else{
    [_unitBtn setTitle:str forState:UIControlStateNormal];
    }
    

}

-(void)provinceSelectorIndixString:(NSString *)pricent city:(NSString *)city{
    
    NSLog(@"%@==%@",pricent,city);

    
}

#pragma mark 数据提交
- (void)subtimeData
{
    
    NSString * utf=[_tfvw.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * divan_content=[_tfmeetname.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * divan_number=[_tfnumber.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * op_num=[_tftime.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * tel=[_tfphone.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * op_unit=[_unitBtn.titleLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * Divan_class=[self.meetButton.titleLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * poid=[[self.dataArray[0] objectForKey:@"poid"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * fee_sv=[[self.dataArray[0] objectForKey:@"fee_sv"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * fee=[[self.dataArray[0] objectForKey:@"fee"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSString *requestTime = [NSString stringWithFormat:@"%f",[currentDate timeIntervalSince1970]];
    NSString *leid = [UserDefault objectForKey:@"leid"];
   
    NSString *mobile = [UserDefault objectForKey:@"mobile"];
    NSArray *valueArr = [NSArray arrayWithObjects:requestTime,self.begainstr,self.endstr,poid,leid,op_num,fee_sv,fee,op_unit,divan_number,utf,divan_content,Divan_class,mobile,tel,nil];
    NSArray *keyArr = [NSArray arrayWithObjects:@"requestTime",@"divan_day",@"divan_eday",@"divan_poid",@"leid",@"op_num",@"op_priceSV",@"op_price",@"op_unit",@"divan_number",@"note",@"divan_content",@"Divan_class",@"mobile",@"tel", nil];
    LFLog(@"%lu=%lu",(unsigned long)valueArr.count,(unsigned long)keyArr.count);
    NSMutableString *parmastring = [NSMutableString string];
    for (int i = 0; i < valueArr.count; i ++) {
        
        [parmastring appendFormat:@"%@=%@",keyArr[i],valueArr[i]];
        if (i<valueArr.count-1) {
            [parmastring appendString:@"&"];
        }
        
    }
    NSString *urlid = NSStringWithFormat(ZJERPIDBaseUrl,@"hyyd");
    NSString *urlstr = [NSString stringWithFormat:@"%@&%@",urlid,parmastring];

    
    [LFLHttpTool get:urlstr params:nil success:^(id response) {
        [self.tableveiw.mj_header endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"error"]];
        LFLog(@"会议室预定：%@",response);
        if ([str isEqualToString:@"0"]) {
            [self presentLoadingTips:@"提交成功"];
            [self performSelector:@selector(perform) withObject:nil afterDelay:2.0];
            
        }else{
            
            
        }
        

        
    } failure:^(NSError *error) {
        [self.tableveiw.mj_header endRefreshing];
    }];
}


-(void)perform{
    
    [self.navigationController popViewControllerAnimated:YES];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
