//
//  ChildAddInfoViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/23.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ChildAddInfoViewController.h"
#import "MHDatePicker.h"
#import "PickerChoiceView.h"
#import "ChildCareHomeViewController.h"
@interface ChildAddInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MHSelectPickerViewDelegate,TFPickerDelegate>

@property(nonatomic,strong)baseTableview *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (strong,nonatomic)NSMutableArray *subViewArray;
@property (strong,nonatomic)NSArray *nameArr0;
@property (strong,nonatomic)NSArray *nameArr1;
@property (strong,nonatomic)NSArray *placeholderArr;
@property (strong,nonatomic)NSString *dateTime;
@property (strong,nonatomic)NSString *relation;
@end

@implementation ChildAddInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"添加宝贝";
    self.nameArr0 = @[@"宝贝姓名",@"性      别",@"出生日期",@"出生体重"];
    self.nameArr1 = @[@"我与宝宝关系",@"我的姓名",@"联系电话"];
    self.placeholderArr = @[@"请输入宝贝姓名",@"",@"请选择生日",@"",@"请选择",@"请输入姓名",@"请输入电话号"];
    [self createUI];
    [self requestDataChildRelation:YES];
}
-(NSMutableArray *)subViewArray{
    if (_subViewArray == nil) {
        _subViewArray = [[NSMutableArray alloc]init];;
    }
    return _subViewArray;
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
-(void)createUI{
    
    for (int i = 0; i < self.nameArr0.count + self.nameArr1.count; i ++) {
        if (i == 1) {
            NSArray *nameArr = @[@"   男",@"   女"];
            NSMutableArray *btnArr = [NSMutableArray array];
            for (int i = 0 ; i < nameArr.count; i ++) {
                IndexBtn *btn = [[IndexBtn alloc]init];
                btn.index = i;
                [btn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
                [btn setTitle:nameArr[i] forState:UIControlStateNormal];
                [btn setTitle:nameArr[i] forState:UIControlStateSelected];
                [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
                [btn setTitleColor:JHdeepColor forState:UIControlStateSelected];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                btn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
                [btn addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                if (i == 0) {
                    btn.selected = YES;
                }
                [btnArr addObject:btn];
            }
            [self.subViewArray addObject:btnArr];
        }else if(i == 2 || i == 4){
            UILabel * lb = [[UILabel alloc]init];
            lb.text = self.placeholderArr[i];
            lb.textColor  = JHsimpleColor;
            lb.font = [UIFont systemFontOfSize:15];
            [self.subViewArray addObject:lb];
        }else{

            UITextField *tf = [[UITextField alloc]init];
            tf.placeholder = self.placeholderArr[i];
            //            tf.textAlignment = NSTextAlignmentRight;
            tf.font = [UIFont systemFontOfSize:15];
            tf.textColor = JHmiddleColor;
            if (i == 6) {
                tf.keyboardType = UIKeyboardTypeNumberPad;
            }
            if (i == 3) {
                UILabel *rightLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 50)];
                rightLb.text = @"kg";
                rightLb.textColor  = JHdeepColor;
                rightLb.font = [UIFont systemFontOfSize:15];
                tf.rightViewMode = UITextFieldViewModeAlways;
                tf.rightView = rightLb;
                UIView *vline = [[UIView alloc]init];
                vline.backgroundColor = JHBorderColor;
                [tf addSubview:vline];
                [vline mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(0);
                    make.right.offset(-20);
                    make.bottom.offset(0);
                    make.height.offset(1);
                }];
            }
            [self.subViewArray addObject:tf];
        }
        
    }
    LFLog(@"self.subViewArray:%@",self.subViewArray);
    self.tableview = [[baseTableview alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height - 50) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorColor = JHColor(222, 222, 222);
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"iscell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"ShopOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"othercell"];
    self.tableview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableview];
    
    UIView * foootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 300)];
    
    UIButton * submitBtn = [[UIButton alloc]init];
    [submitBtn setImage:[UIImage imageNamed:@"tijiaobuttun"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(employsubmitClick) forControlEvents:UIControlEventTouchUpInside];
    [foootview addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(70);
        make.centerX.equalTo(foootview.mas_centerX);
    }];
    self.tableview.tableFooterView = foootview;
}
#pragma mark 性别点击
-(void)sexBtnClick:(IndexBtn *)sender{
    sender.selected = YES;
    NSMutableArray *btnArr = self.subViewArray[1];
    for (IndexBtn *btn in btnArr) {
        if (btn != sender) {
            btn.selected = NO;
            return;
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.nameArr0.count;
    }
    return self.nameArr1.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"creditcell%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc]init];
        label.textColor = JHColor(53, 53, 53);
        label.font = [UIFont systemFontOfSize:15];
        if (indexPath.section == 0) {
            label.text = self.nameArr0[indexPath.row];
        }else{
            label.text = self.nameArr1[indexPath.row];
        }
        CGSize lbsize = [label.text selfadaption:15];
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.width.offset(lbsize.width + 5);
            
        }];
        NSInteger row = indexPath.row;
        if (indexPath.section == 1) {
            row += self.nameArr0.count;
        }
        if ([self.subViewArray[row] isKindOfClass:[NSArray class]]){
            NSMutableArray *btnArr = self.subViewArray[indexPath.row];
            int xx = lbsize.width + 30;
            for (IndexBtn *btn in btnArr) {
                btn.frame = CGRectMake( xx , 0, (SCREEN.size.width - lbsize.width -60)/2, 50);
                [cell.contentView addSubview:btn];
                xx += (SCREEN.size.width - lbsize.width -15)/2;
            }
        }else {
            UIView *tf = self.subViewArray[row];
            [cell.contentView addSubview:tf];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.left.equalTo(label.mas_right).offset(10);
                if (indexPath.section == 0 && indexPath.row == 3) {
                    make.width.offset(50);
                }else{
                    make.right.offset(-30);
                }
                
            }];
        }
    }
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 2) {
        [self timeClick];
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        PickerChoiceView * _picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
        _picker.titlestr = @"请选择";
        _picker.inter =2;
        _picker.delegate = self;
        _picker.arrayType = HeightArray;
        for (NSString *str in self.dataArray) {
            [_picker.typearr addObject:str];
        }
        [self.view addSubview:_picker];
        return;
    }
}
#pragma mark - 选择时间点击事件
- (void)timeClick
{
    MHDatePicker *_selectTimePicker = [[MHDatePicker alloc] init];
    _selectTimePicker.datePickerMode = UIDatePickerModeDate;
    _selectTimePicker.isBeforeTime = YES;
    _selectTimePicker.maxSelectDate = [NSDate date];
    _selectTimePicker.Displaystr = @"yyyy-MM-dd";
    _selectTimePicker.delegate = self;
}

#pragma mark - 时间回传值
- (void)timeString:(NSString *)timeString
{
    
    UILabel *lb = self.subViewArray[2];
    lb.text = timeString;
    long time;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromdate=[format dateFromString:timeString];
    time= (long)[fromdate timeIntervalSince1970];
    NSNumber *longNumber = [NSNumber numberWithLong:time];
    self.dateTime = [longNumber stringValue];

}
- (void)PickerSelectorIndixString:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    NSLog(@"%@",str);
    self.relation = str;
    UILabel *lb = self.subViewArray[4];
    lb.text = str;
    
}
#pragma mark - 提交
-(void)employsubmitClick{
    [self upDateInfo];
}
#pragma mark - *************宝宝关系*************
-(void)requestDataChildRelation:(BOOL )isFirst{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ChildRelationUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"预约体检列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            for (NSString *str in response[@"data"]) {
                [self.dataArray addObject:str];
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                      
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"%@",error);
        [self presentLoadingTips:@"请求失败！"];
    }];
    
}
-(void)upDateInfo{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSArray *parameterArr = @[@"child_name",@"child_sex",@"child_birthday",@"child_weight",@"relationship",@"user_name",@"mobile"];
    for (int i = 0 ; i < self.subViewArray.count; i ++) {
        if ([self.subViewArray[i] isKindOfClass:[UITextField class]]) {
            UITextField *tf = self.subViewArray[i];
            if (!tf.text.length) {
                [self presentLoadingTips:self.placeholderArr[i]];
                [tf becomeFirstResponder];
                return;
            }else{
                if (i == 6 && tf.text.length != 11) {
                    [self presentLoadingTips:@"请输入正确的手机号！"];
                    return;
                }
                [dt setObject:tf.text forKey:parameterArr[i]];
            }
        }else if ([self.subViewArray[i] isKindOfClass:[NSArray class]]){
            NSMutableArray *btnArr = self.subViewArray[i];
            for (IndexBtn *btn in btnArr) {
                if (btn.selected) {
                    [dt setObject:[NSString stringWithFormat:@"%ld",(long)btn.index] forKey:parameterArr[i]];
                }
            }
        }else if ([self.subViewArray[i] isKindOfClass:[UILabel class]]){
            if (i == 2) {
                if (self.dateTime) {
                    [dt setObject:self.dateTime forKey:parameterArr[i]];
                }else{
                    [self presentLoadingTips:self.placeholderArr[i]];
                }
            }
            if (i == 4) {
                if (self.relation) {
                    [dt setObject:self.relation forKey:parameterArr[i]];
                }else{
                    [self presentLoadingTips:@"请选择与宝宝关系"];
                }
            }
        }
    }
    [self presentLoadingTips];
    
    LFLog(@"宝宝提交dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ChildRelationSumbitUrl) params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"宝宝提交：%@",response);
        [self dismissTips];
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"提交成功"];
            [self performSelector:@selector(successClick) withObject:nil afterDelay:.2];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"提交失败，网络错误！"];
    }];
}
-(void)successClick{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ChildCareHomeViewController class]]) {
            [((ChildCareHomeViewController*)vc) refeshData];
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
