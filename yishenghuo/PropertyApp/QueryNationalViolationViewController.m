//
//  NationalViolationViewController.m
//  shop
//
//  Created by 梁法亮 on 16/6/23.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "QueryNationalViolationViewController.h"
#import "PickerChoiceView.h"
#import "LFLUibutton.h"

#import "QueryResultViewController.h"
@interface QueryNationalViolationViewController ()<UITableViewDelegate,UITableViewDataSource,TFPickerDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)LFLUibutton *citybutton;
@property(nonatomic,strong)LFLUibutton *numbutton;
@property(nonatomic,strong)UITextField *tfnum;
@property(nonatomic,strong)UITextField *tfEngine;//发动机
@property(nonatomic,strong)UITextField *tfChassis;//车架



@property(nonatomic,strong)NSArray *typearr;
@property(nonatomic,strong) PickerChoiceView *picker;


@property(nonatomic,strong)NSMutableArray *cityArray;



@property(nonatomic,assign)int isEngine;
@property(nonatomic,assign)int isChassis;

@property(nonatomic,assign)CGFloat row;

@property(nonatomic,strong)NSString *citycode;

@end

@implementation QueryNationalViolationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.navigationBarTitle = @"违章查询";
    self.view.backgroundColor = [UIColor whiteColor];
    self.typearr = @[@"查询城市",@"车牌号码",@"发动机号",@"车身架号"];
    self.row = 4;
    self.isChassis = 1;
    self.isEngine = 1;
    [self createTableview];
    
    [self privinceAndCitydatacityDetail:nil];
}



-(NSMutableArray *)cityArray{
    
    
    if (_cityArray == nil) {
        _cityArray = [[NSMutableArray alloc]init];
    }
    
    return _cityArray;
}
-(UITextField *)tfEngine{
    if (_tfEngine == nil) {
        _tfEngine = [[UITextField alloc]init];
        _tfEngine.placeholder = @"请输入发动机号";
        _tfEngine.font = [UIFont systemFontOfSize:15];
        _tfEngine.textColor = JHmiddleColor;
    }
    return _tfEngine;
}

-(UITextField *)tfChassis{
    if (_tfChassis == nil) {
        _tfChassis = [[UITextField alloc]init];
        _tfChassis.placeholder = @"请输入车身机架号";
        _tfChassis.font = [UIFont systemFontOfSize:15];
        _tfChassis.textColor = JHmiddleColor;
    }
    return _tfChassis;

}

-(void)createTableview{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    _tableView.separatorStyle = NO;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableHeaderView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    UIView *baveiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height - 200)];
    
    UIButton *submitButton = [[UIButton alloc]init];
    [submitButton addTarget:self action:@selector(subClick:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.backgroundColor =JHMaincolor;
    [submitButton setTitle:@"查询" forState:UIControlStateNormal];
    submitButton.layer.cornerRadius = 15;
    submitButton.layer.masksToBounds = YES;
    
    //    [submitButton setBackgroundImage:[UIImage imageNamed:@"weizhangchaxunanniu"] forState:UIControlStateNormal];
    [baveiw addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(40);
        make.top.offset(30);
        
        
    }];

   UILabel * desclb = [[UILabel alloc]init];
    desclb.font = [UIFont systemFontOfSize:14];
    desclb.numberOfLines = 0;
    desclb.textColor = JHmiddleColor;
    [baveiw addSubview:desclb];
    desclb.text = @"1.在输入的过程中请仔细区分D和0，Z和2，1、i和I等易混淆字符\n\n2.请注意区别车架号和发动机号";
    [desclb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(100);
        make.bottom.offset(0);
        make.right.offset(-15);
        
    }];

    self.tableView.tableFooterView = baveiw;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _row;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"querycell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"querycell"];
        if (indexPath.row < 2) {
            UIImageView *rightimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_arrows"]];
            [cell.contentView addSubview:rightimage];
            [rightimage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-10);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                
            }];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIButton * lb = [self.view viewWithTag:222 + indexPath.row];
    
    if (lb == nil ) {
        lb = [[UIButton alloc]init];
        lb.tag = 222 + indexPath.row;
        lb.titleLabel.font = [UIFont systemFontOfSize:15];
        [lb setTitleColor:JHdeepColor forState:UIControlStateNormal];
        [lb setImage:[UIImage imageNamed:@"diandian_weizhang"] forState:UIControlStateNormal];

    }
    [lb setTitle:[NSString stringWithFormat:@"  %@",self.typearr[indexPath.row]] forState:UIControlStateNormal];
    [cell.contentView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(0);
        make.bottom.offset(0);
        make.width.offset(100);
        
    }];

    
    if (indexPath.row == 0) {
      
        if (_citybutton == nil) {
            _citybutton = [[LFLUibutton alloc]init];
            [_citybutton setTitle:@"请选择" forState:UIControlStateNormal];
            _citybutton.Ratio = 0.9;
            _citybutton.titleLabel.font = [UIFont systemFontOfSize:15];
            _citybutton.titleLabel.textAlignment = NSTextAlignmentLeft;
            [_citybutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_citybutton addTarget:self action:@selector(citybuttonclick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_citybutton];
            [_citybutton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lb.mas_right).offset(15);
                make.top.offset(0);
                make.bottom.offset(0);
                make.right.offset(-30);
                
            }];
        }
        
   
       
        
    }else if (indexPath.row == 1){
        if (_numbutton == nil) {
            _numbutton = [[LFLUibutton alloc]init];
            [_numbutton setTitle:@"川" forState:UIControlStateNormal];
            _numbutton.Ratio = 1;
            [_numbutton setTitleColor:JHAssistColor forState:UIControlStateNormal];
            _numbutton.titleLabel.textAlignment = NSTextAlignmentCenter;
            _numbutton.titleLabel.font = [UIFont systemFontOfSize:15];
            UIImage * im = [UIImage imageNamed:@"diyukuang"];
            [_numbutton setBackgroundImage:im forState:UIControlStateNormal];
            [_numbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_numbutton addTarget:self action:@selector(numbuttonclick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_numbutton];
            [_numbutton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.left.equalTo(lb.mas_right).offset(15);
                make.height.offset(im.size.height);
                make.width.offset(im.size.width);
                
            }];
        }
        
       
        
        if (_tfnum == nil) {
             _tfnum = [[UITextField alloc]init];
            _tfnum.placeholder = @"请输入车牌号";
            _tfnum.font = [UIFont systemFontOfSize:15];
            _tfnum.textColor = JHmiddleColor;
            [cell.contentView addSubview:_tfnum];
            [_tfnum mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_numbutton.mas_right).offset(15);
                make.top.offset(0);
                make.bottom.offset(0);
                make.right.offset(-30);
            }];
        }
       
        
        
      }else if (_isEngine == 1 && _isChassis == 1){

          if (indexPath.row == 2) {
              LFLog(@"00000");
              [cell.contentView addSubview:self.tfEngine];
              [_tfEngine mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.left.equalTo(lb.mas_right).offset(15);
                  make.top.offset(0);
                  make.bottom.offset(0);
                  make.right.offset(-15);
              }];
              
          }else if (indexPath.row == 3){
              [cell.contentView addSubview:self.tfChassis];
              [_tfChassis mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.left.equalTo(lb.mas_right).offset(15);
                  make.top.offset(0);
                  make.bottom.offset(0);
                  make.right.offset(-15);
              }];
        
          
      }
    
    }else if (_isEngine == 1 && _isChassis == 0){
        [_tfChassis removeFromSuperview];
        if (indexPath.row == 2) {
             LFLog(@"11111");
            [cell.contentView addSubview:self.tfEngine];
            [_tfEngine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lb.mas_right).offset(15);
                make.top.offset(0);
                make.bottom.offset(0);
                make.right.offset(-15);
            }];
        }
    
    
    }else if (_isEngine == 0 && _isChassis == 1){
    
        [_tfEngine removeFromSuperview];
         LFLog(@"22222");
        if (indexPath.row == 2) {
            [cell.contentView addSubview:self.tfChassis];
            [_tfChassis mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lb.mas_right).offset(15);
                make.top.offset(0);
                make.bottom.offset(0);
                make.right.offset(-15);
            }];
            
        }
    
    }
    
    
    
    return cell;


}

//查询城市点击事件
-(void)citybuttonclick:(UIButton *)btn{
    [self.view endEditing:YES];
    _picker = nil;
    _picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
    _picker.inter =1;
    _picker.arrayType = GenderArray;
    _picker.delegate = self;
    _picker.titlestr = @"请选择";
    
    for (NSDictionary *dt in self.cityArray) {
        [_picker.provinceArr addObject:dt[@"province"]];
    }
    
    [self.view addSubview:_picker];
    
    
    
    
}

//车牌号点击事件
-(void)numbuttonclick:(UIButton *)btn{
    [self.view endEditing:YES];

    _picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
    _picker.inter =2;
    _picker.delegate = self;
    _picker.titlestr = @"请选择";
    _picker.arrayType = HeightArray;
    for (NSDictionary *str in self.cityArray) {
        [_picker.typearr addObject:str[@"citys"][0][@"abbr"]];
    }
    
    [self.view addSubview:_picker];



}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.001;
}


#pragma mark 充值按钮
-(void)subClick:(UIButton *)btn{
    [self.view endEditing:YES];
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }

    if ([_citybutton.titleLabel.text isEqualToString:@"请选择"]) {
        
        [self presentLoadingTips:@"请选择所在城市"];
    }else if ([_numbutton.titleLabel.text isEqualToString:@""]){
    
    
    }else if (_tfnum.text.length == 0){
    
        [self presentLoadingTips:@"请输入车牌号"];
    
    }else if (self.isEngine == 1 && self.isChassis == 1){
    
        if (_tfEngine.text.length == 0) {
            [self presentLoadingTips:@"请输入发动机号"];
        }else if (_tfChassis.text.length == 0){
        [self presentLoadingTips:@"请输入车架号"];
        
        }else{
            NSLog(@"查询");
            
            [self querydatacityDetail];
        }

    
    
    }else if (self.isEngine == 0 && self.isChassis == 1){
    
         if (_tfChassis.text.length == 0){
            [self presentLoadingTips:@"请输入车架号"];
            
         }else{
             NSLog(@"查询");
             
             [self querydatacityDetail];
         }

    }else if (self.isEngine == 1 && self.isChassis == 0){
        
        if (_tfEngine.text.length == 0) {
            [self presentLoadingTips:@"请输入发动机号"];
        }else{
            NSLog(@"查询");
            
            [self presentLoadingTips:@"请稍等~~"];
            [self querydatacityDetail];
        }

    }
    
}


#pragma mark -------- TFPickerDelegate

- (void)PickerSelectorIndixString:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    
    NSLog(@"%@",str);
    
    if (isType == 0) {
      
        
        for (NSDictionary *dt in self.cityArray) {
            
            if ([dt[@"province"] isEqualToString:str]) {
                [_picker.cityArr removeAllObjects];
                
                for (NSDictionary *dict in dt[@"citys"]) {
//                    NSLog(@"==%@",dt[@"citys"]);
                    [_picker.cityArr addObject:dict[@"city_name"]];
                }
                [_picker reloadcomment:1];
            }

        }
        
    }else if (isType == 1){
        NSLog(@"%@",str);
        [_numbutton setTitle:str forState:UIControlStateNormal];
        
        
    }else if (isType == 2){
        
       
        
    }
    
}

-(void)provinceSelectorIndixString:(NSString *)pricent city:(NSString *)city{
    
    NSLog(@"%@==%@",pricent,city);
    [_citybutton setTitle:[NSString stringWithFormat:@"%@ %@",pricent,city] forState:UIControlStateNormal];
   self.typearr = @[@"查询城市",@"车牌号码",@"发动机号",@"车身架号"];
    for (NSDictionary *dt in self.cityArray) {
        
        if ([dt[@"province"] isEqualToString:pricent]) {
     
            for (NSDictionary *dict in dt[@"citys"]) {
                if ([dict[@"city_name"] isEqualToString:city]) {
                    
                    NSLog(@"3eq2ewdqwed；%@",dict);
                    [_numbutton setTitle:dict[@"abbr"] forState:UIControlStateNormal];
                    self.citycode = dict[@"city_code"];
                    if ([dict[@"engine"] isEqualToString:@"0"]) {
                        self.isEngine = 0;
                        self.row = 2;
                    }else{
                        self.isEngine = 1;
                        self.row = 3;
                        NSString *engineno = [NSString stringWithFormat:@"%@",dict[@"engineno"]];
                        if ([engineno isEqualToString:@"0"]) {
                            _tfEngine.placeholder = @"请输入发动机号";
                        }else{
                           _tfEngine.placeholder = [NSString stringWithFormat:@"请输入发动机号后%@位",dict[@"engineno"]];
                        }
                    
                    
                    }
                    
                    if ([dict[@"class"] isEqualToString:@"0"]) {
                        self.isChassis = 0;
                    }else{
                        self.row ++;
                     self.isChassis = 1;
                        NSString *classno = [NSString stringWithFormat:@"%@",dict[@"classno"]];
                        if ([classno isEqualToString:@"0"]) {
                            _tfChassis.placeholder = @"请输入车架号";
                        }else{
                            _tfChassis.placeholder = [NSString stringWithFormat:@"请输入车架号后%@位",dict[@"classno"]];
                        }
                        if (self.isEngine == 0) {
                            self.typearr = @[@"查询城市",@"车牌号码",@"车身架号",@"发动机号"];
                        }
                        
                    }
                    
                  [self.tableView reloadData];
                }
                
            }
        
        }
        
        
    }
   
    
}



#pragma mark  数据请求
-(void)privinceAndCitydatacityDetail:(NSString *)type{

    [LFLHttpTool get:NSStringWithFormat(ZJnationalViolationBaseUrl,NationalViolationCityurl) params:nil success:^(id response) {

        LFLog(@"response:%@",response);
        NSString *code = [NSString stringWithFormat:@"%@",response[@"error_code"]];

            if ([code isEqualToString:@"0"]) {
 
                [response[@"result"] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    NSLog(@"%@",obj);
                    [self.cityArray addObject:obj];
                    
                }];
                //设置默认值
                [self provinceSelectorIndixString:@"四川" city:@"绵阳"];
            }
        
    } failure:^(NSError *error) {

    }];
    
    
}

-(void)querydatacityDetail{
//    NSString *hphm = @"苏L50A11";
//    self.citycode = @"SH";
//    self.tfEngine.text = @"123456";
    NSString *hphm = [NSString  stringWithFormat:@"%@%@",_numbutton.titleLabel.text,_tfnum.text];
    NSMutableDictionary *dt = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.citycode,@"city",@"02",@"hpzl",hphm,@"hphm", nil];
    if (self.isEngine == 1 && self.isChassis == 1){
        [dt setObject:_tfEngine.text  forKey:@"engineno"];
         [dt setObject:_tfChassis.text  forKey:@"classno"];
        
    }else if (self.isEngine == 0 && self.isChassis == 1){
        [dt setObject:_tfChassis.text  forKey:@"classno"];
        
    }else if (self.isEngine == 1 && self.isChassis == 0){
        [dt setObject:_tfEngine.text  forKey:@"engineno"];
    }

    
    [LFLHttpTool get:NSStringWithFormat(ZJnationalViolationBaseUrl,NationalViolationQuery) params:dt success:^(id response) {
        [self dismissTips];
        LFLog(@"response:%@",response);
         NSString *code = [NSString stringWithFormat:@"%@",response[@"error_code"]];
        if ([code isEqualToString:@"0"]) {
             [UserModel OperationToSendPoints:@"wzcx"];
            NSArray *privincecity = [_citybutton.titleLabel.text componentsSeparatedByString:@" "];
            NSString *hphm = [NSString  stringWithFormat:@"%@%@",_numbutton.titleLabel.text,_tfnum.text];
            QueryResultViewController *nation = [[QueryResultViewController alloc]init];
            nation.privincestr = privincecity[0];
            nation.citystr = privincecity[1];
            nation.numstr = hphm;
//            NSDictionary *testDt = @{
//                                     @"province":@"HB",
//                                     @"city":@"HB_HD",
//                                     @"hphm":@"冀DHL327",
//                                     @"hpzl":@"02",
//                                     @"lists":@[
//                                              @{@"date":@"2013-12-29 11:57:29",
//                                                  @"area":@"316省道53KM+200M",
//                                                  @"act":@"16362 : 驾驶中型以上载客载货汽车、校车、危险物品运输车辆以外的其他机动车在高速公路以外的道路上行驶超过规定时速20%以上未达50%的",
//                                                  @"code":@"",
//                                                  @"fen":@"6",
//                                                  @"money":@"100",
//                                                  @"handled":@"0"
//                                              }
//                                              ]
//                                     };
//            [nation.dataArray addObject:testDt];
            [nation.dataArray addObject:response[@"result"]];
            
                if (self.isEngine == 1 ){
                    nation.numengine = [NSString stringWithFormat:@"发动机号：%@",_tfEngine.text];
                }else if (self.isChassis == 1){
                    nation.numengine = [NSString stringWithFormat:@"车身架号：%@",_tfChassis.text];
            
            
                }else {
                    nation.numengine = @"";
                }
            [self.navigationController pushViewController:nation animated:YES];
        }else{
            [self presentLoadingTips:response[@"reason"]];
        }

        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}


@end
