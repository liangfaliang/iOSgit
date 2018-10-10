//
//  PersonalFileSubmitViewController.m
//  PropertyApp
//
//  Created by admin on 2018/8/25.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "PersonalFileSubmitViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "TextFiledModel.h"
#import "UIView+TYAlertView.h"
#import "MyAppointmentViewController.h"
#import "MChooseBanKuaiViewController.h"
#import "PickerChoiceView.h"
@interface PersonalFileSubmitViewController ()<UITableViewDataSource, UITableViewDelegate,TFPickerDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIView *leftBtnView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableArray *adressArray;

@end

@implementation PersonalFileSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"个人建档";
    [self setupUI];
    [self initTableView];
    self.isEmptyDelegate = NO;
    UIButton *footview = [[UIButton alloc]initWithFrame:CGRectMake(0, screenH -  50, screenW,  50)];
    footview.backgroundColor = JHMedicalColor;
    [footview setTitle:self.isSecond ? @"提交预约":@"下一步" forState:UIControlStateNormal];
    footview.titleLabel.font = [UIFont systemFontOfSize:15];
    [footview addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footview];
    [self UpData];
}
-(void)UpData{
    [self getDataAdress:nil];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)adressArray{
    if (!_adressArray) {
        _adressArray = [NSMutableArray array];
    }
    return _adressArray;
}
-(FileBasicModel *)model{
    if (_model == nil) {
        _model = [[FileBasicModel alloc]init];
    }
    return _model;
}
#pragma  mark 立即预约
-(void)submitClick{
    if (!self.isSecond) {
        PersonalFileSubmitViewController *vc = [[PersonalFileSubmitViewController alloc]init];
        vc.isSecond = YES;
        NSMutableDictionary *mdt = [self.model mj_keyValues];
        vc.model = [FileBasicModel mj_objectWithKeyValues:mdt];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    for (TextSectionModel *tmodel in self.dataArray) {
        for (TextFiledModel *cmo in tmodel.child) {
            if (!cmo.value && cmo.prompt) {
                [self presentLoadingTips:cmo.prompt];
                return;
            }else if (cmo.value && cmo.key.length){
                [self.model setValue:cmo.value forKey:cmo.key];
            }
        }
    }

    

    NSMutableDictionary *dt = [self.model mj_keyValues];
    NSString *uid = [UserDefault objectForKey:@"uid"];
    if (uid == nil) uid = @"";
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) coid = @"";
    coid = @"53";
    [dt setObject:coid forKey:@"coid"];
    [dt setObject:uid forKey:@"uid"];
    [dt setObject:@"1" forKey:@"iszb"];
    [self SubmitData:dt];
}

#pragma  mark 房屋选择
- (void)setupUI{
    
    if (!self.isSecond) {
        //prompt：必填提示语
        NSArray * array = @[@{@"key":@"basic",
                              @"child":@[@{@"name":@"联系人电话",@"enable":@"1",@"key":@"hp_linktelp",@"placeholder":@"请输入"}]
                              },
                            @{@"key":@"basic",
                              @"child":@[@{@"name":@"常住类型",@"text":@"",@"key":@"hp_PermanentType"},
                                         @{@"name":@"民族",@"text":@"",@"key":@"hp_nation"},
                                         @{@"name":@"ABO血型",@"text":@"",@"key":@"hp_bloodType"},
                                         @{@"name":@"RH血型",@"text":@"",@"key":@"hp_bloodRH"},
                                         @{@"name":@"文化程度",@"text":@"",@"key":@"hp_education"},
                                         @{@"name":@"职业",@"text":@"",@"key":@"hp_profession"},
                                         @{@"name":@"婚姻状况",@"text":@"",@"key":@"hp_marital"},
                                         @{@"name":@"医疗费支付方式",@"text":@"",@"key":@"hp_medicalExpense"}]
                              }];
        int i =0;
        for (NSDictionary *arr in array) {
            TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:arr];
            if (i > 0) {
                for (TextFiledModel *cmo in model.child) {
                    cmo.rightim = @"1";
                    cmo.placeholder = @"请选择";
                }
            }

            [self.dataArray addObject:model];
            i ++;
        }
    }else{
        NSArray *historyArr = @[@{@"section":@"   既往史",
                                  @"key":@"selectBtn",
                                  @"child":@[@{@"name":@"疾病",@"text":@"",@"key":@"",@"rightim":@"1",@"selectBtn":@"1"},
                                             @{@"name":@"添加疾病",@"placeholder":@"请选择",@"key":@"hp_historyDisease",@"rightim":@"1"}]
                                  },
                                @{@"key":@"selectBtn",
                                  @"child":@[@{@"name":@"手术",@"text":@"",@"key":@"health_operation_ishave",@"rightim":@"1",@"selectBtn":@"1"},
                                             @{@"name":@"手术名称①",@"placeholder":@"请输入",@"key":@"health_operation_1_name",@"enable":@"1"},
                                             @{@"name":@"时间",@"placeholder":@"请选择",@"key":@"health_operation_1_date",@"rightim":@"1"},
                                             @{@"name":@"手术名称②",@"placeholder":@"请输入",@"key":@"health_operation_2_name",@"enable":@"1"},
                                             @{@"name":@"时间",@"placeholder":@"请选择",@"key":@"health_operation_2_date",@"rightim":@"1"}]
                                  },
                                @{@"key":@"selectBtn",
                                  @"child":@[@{@"name":@"外伤",@"text":@"",@"key":@"health_trauma_ishave",@"rightim":@"1",@"selectBtn":@"1"},
                                             @{@"name":@"外伤名称①",@"placeholder":@"请输入",@"key":@"health_trauma_1_name",@"enable":@"1"},
                                             @{@"name":@"时间",@"placeholder":@"请选择",@"key":@"health_trauma_1_date",@"rightim":@"1"},
                                             @{@"name":@"外伤名称②",@"placeholder":@"请输入",@"key":@"health_trauma_2_name",@"enable":@"1"},
                                             @{@"name":@"时间",@"placeholder":@"请选择",@"key":@"health_trauma_2_date",@"rightim":@"1"}]
                                  },
                                @{@"key":@"selectBtn",
                                  @"child":@[@{@"name":@"输血",@"text":@"",@"key":@"health_transfusion_ishave",@"rightim":@"1",@"selectBtn":@"1"},
                                             @{@"name":@"输血原因①",@"placeholder":@"请输入",@"key":@"health_transfusion_1_name",@"enable":@"1"},
                                             @{@"name":@"时间",@"placeholder":@"请选择",@"key":@"health_transfusion_1_date",@"rightim":@"1"},
                                             @{@"name":@"输血原因②",@"placeholder":@"请输入",@"key":@"health_transfusion_2_name",@"enable":@"1"},
                                             @{@"name":@"时间",@"placeholder":@"请选择",@"key":@"health_transfusion_2_date",@"rightim":@"1"}]
                                  },
                                @{@"section":@"   家族史",
                                  @"image":@"",
                                  @"key":@"",
                                  @"child":@[@{@"name":@"父亲",@"text":@"",@"key":@"familyDisease_father",@"rightim":@"1"},
                                             @{@"name":@"母亲",@"text":@"",@"key":@"familyDisease_mather",@"rightim":@"1"},
                                             @{@"name":@"兄弟姐妹",@"text":@"",@"key":@"familyDisease_sister",@"rightim":@"1"},
                                             @{@"name":@"子女",@"text":@"",@"key":@"familyDisease_son",@"rightim":@"1"}]
                                  },
                                @{@"key":@"家族史",
                                  @"child":@[@{@"name":@"遗传病史",@"text":@"",@"key":@"heredopathia_name",@"rightim":@"1"},
                                             @{@"name":@"残疾情况",@"text":@"",@"key":@"hp_Disability",@"rightim":@"1"}]
                                  },
                                @{@"section":@"   生活环境",
                                  @"image":@"",
                                  @"key":@"",
                                  @"child":@[@{@"name":@"厨房排风设施",@"text":@"",@"key":@"Kitchenexhaus",@"rightim":@"1"},
                                             @{@"name":@"燃料类型",@"text":@"",@"key":@"FuelType",@"rightim":@"1"},
                                             @{@"name":@"饮水",@"text":@"",@"key":@"water",@"rightim":@"1"},
                                             @{@"name":@"厕所",@"text":@"",@"key":@"Toilet",@"rightim":@"1"},
                                             @{@"name":@"禽畜栏",@"text":@"",@"key":@"corral",@"rightim":@"1"}]
                                  }];
        for (NSDictionary *arr in historyArr) {
            TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:arr];
            for (TextFiledModel *cmo in model.child) {
                if (cmo.selectBtn) {
                    cmo.rightim = @"1";
                    cmo.enable = @"1";
                }
            }
            [self.dataArray addObject:model];

        }
    }
    
    [self.tableView reloadData];
}


#pragma mark - tableView
- (void)initTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH - 50) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //    _tableView.estimatedRowHeight = 60;
    _tableView.rowHeight = 75;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TextFiledLableTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TextFiledLableTableViewCell class])];
    
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TextSectionModel *model =  self.dataArray[section];
    if ([model.key isEqualToString:@"selectBtn"] && model.child.count) {
        TextFiledModel *cmo = model.child[0];
        return [cmo.value isEqualToString:@"有"] ? model.child.count : 1;
    }
    return model.child.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextFiledLableTableViewCell class]) forIndexPath:indexPath];
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    __weak typeof(self) weakSelf = self;
    cell.selectBtnBlock = ^(NSInteger index) {
        [weakSelf.tableView reloadData];
    };
   TextSectionModel *model = self.dataArray[indexPath.section];
    TextFiledModel *cmo = model.child[indexPath.row];
    cell.model = cmo;

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.dataArray.count - 1 > section) {
        TextSectionModel *model =  self.dataArray[section +1];
        return model.section ? 0.001 : 10;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    TextSectionModel *model =  self.dataArray[section];
    return model.section ? 40 : 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TextSectionModel *model =  self.dataArray[section];
    if (model.section) {
        UIView *header = [[UIView alloc]init];
        header.backgroundColor = JHbgColor;
        if (model.section) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, screenW - 30, 40)];
            [btn setTitle:model.section forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
            if (model.image) {
                [btn setImage:[UIImage imageNamed:model.image] forState:UIControlStateNormal];
            }
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [header addSubview:btn];
        }
        return header;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSMutableArray *marr = self.dataArray[indexPath.section];
    //    TextFiledModel *model = marr[indexPath.row];
    //    CenterSelectDateViewController *select = [[CenterSelectDateViewController alloc]init];
    //    WEAKSELF;
    //    select.SelectBlock = ^(NSString *time ,NSString *timeS) {
    //        model.value = timeS;
    //        model.text = time;
    //        [weakSelf.tableView reloadData];
    //    };
    //    [self.navigationController pushViewController:select animated:YES];
    TextSectionModel *model = self.dataArray[indexPath.section];
    TextFiledModel *wmodel = model.child[indexPath.row];
    if (self.isSecond) {
        if (indexPath.section > 0 && indexPath.section < 4 && indexPath.row > 0 && indexPath.row%2 == 0) {
            PickerChoiceView *_picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
            _picker.tag = indexPath.section * 10 + indexPath.row;
            _picker.inter =2;
            _picker.titlestr = @"请选择";
            _picker.arrayType = DeteArray;
            _picker.delegate = self;
            [self.view addSubview:_picker];
        }else {
            NSString * option_key = nil;
            if (indexPath.section == 0  && indexPath.row == 1){
                option_key =@"health_historyDisease";
            }else if (indexPath.section == 5  && indexPath.row == 1){
                option_key =@"health_Disability";
            }else if (indexPath.section == 4  || (indexPath.section == 5  && indexPath.row == 0)){
                option_key =@"health_familyDisease";
            }else if (indexPath.section == 6  ){
                NSArray *arrType = @[@"health_Kitchenexhaus",@"health_FuelType",@"health_water",@"health_Toilet",@"corral",@"",@"",@""];
                option_key =arrType[indexPath.row];
            }else{
                return;
            }
            MChooseBanKuaiViewController *vc = [[MChooseBanKuaiViewController alloc] init];
            if (indexPath.section != 6  )vc.isMultiple = YES;
            vc.type = SelectFileStandard;
            vc.option_key = option_key;
            __weak typeof(self) weakSelf = self;
            vc.doneBlock = ^(HSDTagModel *model,id dict){
                
                NSMutableString *mstr = [NSMutableString string];
                if (!model) {
                    if ([dict isKindOfClass:[NSArray class]]) {
                        for (HSDTagModel *hmo in dict) {
                            if (mstr.length) {
                                [mstr appendFormat:@",%@",hmo.content];
                            }else{
                                [mstr appendString:hmo.content];
                            }
                        }
                    }
                    if ([mstr containsString:@"其他"]) {
                        wmodel.enable = @"1";
                    }else{
                        wmodel.enable = nil;
                    }
                }else{
                    [mstr appendString:model.content];
                }

                wmodel.value = mstr;
                wmodel.text = mstr;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }

    }else{
        if (indexPath.section > 0) {
            MChooseBanKuaiViewController *vc = [[MChooseBanKuaiViewController alloc] init];
            vc.type = SelectFileStandard;
            NSArray *arrType = @[@"health_PermanentType",@"health_nation",@"health_bloodABO",@"health_bloodRH",@"health_education",@"health_profession",@"health_marital",@"health_medicalExpense"];
            vc.option_key =arrType[indexPath.row];
            __weak typeof(self) weakSelf = self;
            vc.doneBlock = ^(HSDTagModel *model,id dict){
                wmodel.value = model.content;
                wmodel.text = model.content;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

}
#pragma mark -------- TFPickerDelegate
-(void)PickerSelectorIndixString:(id)picker str:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    LFLog(@"%@",str);
    
    PickerChoiceView *_picker = (PickerChoiceView *)picker;
    TextSectionModel *model = self.dataArray[_picker.tag/10];
    TextFiledModel *cmo = model.child[_picker.tag%10];
    cmo.text = str;
    cmo.value = str;
    [self.tableView reloadData];
    
}


-(void)provinceSelectorIndixString:(NSString *)pricent city:(NSString *)city{
    NSLog(@"%@==%@",pricent,city);
    TextFiledModel *wmodel = self.dataArray[3];
    wmodel.text = [NSString stringWithFormat:@"%@%@",pricent,city];
    wmodel.value = wmodel.text;
    [self.tableView reloadData];
}
#pragma mark - 数据
- (void)getDataAdress:(void (^)(NSArray *arr))result{
    
    NSString *uid = [UserDefault objectForKey:@"uid"];
    if (uid == nil) uid = @"";
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) coid = @"";
    coid = @"53";
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    [dt setObject:coid forKey:@"coid"];
    [dt setObject:uid forKey:@"uid"];
    [dt setObject:@"1" forKey:@"iszb"];
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,@"109") params:dt success:^(id response) {
        LFLog(@" 数据提交:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            NSString *addr = [response objectForKey:@"data"][@"addr"];
            NSArray *arr = [addr componentsSeparatedByString:@","];
            if (result) {
                result(arr);
            }
            [self.adressArray removeAllObjects];
            for (NSString *dic in arr) {
                [self.adressArray addObject:dic];
            }
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - 数据提交
- (void)SubmitData:(NSMutableDictionary *)dt{
    [self presentLoadingTips];
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,ERPFileBasicSetupUrl) params:dt  success:^(id response) {
        [self dismissTips];
        LFLog(@" 数据提交:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"建档成功"];
            [self performSelector:@selector(dissview) withObject:nil afterDelay:2.0];
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self dismissTips];
    }];
    
}
-(void)dissview{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
