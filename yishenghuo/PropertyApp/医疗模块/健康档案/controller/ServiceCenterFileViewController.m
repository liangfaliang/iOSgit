//
//  ServiceCenterFileViewController.m
//  PropertyApp
//
//  Created by admin on 2018/7/20.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ServiceCenterFileViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "TextFiledModel.h"
#import "CenterSelectDateViewController.h"
#import "UIView+TYAlertView.h"
#import "MyAppointmentViewController.h"
#import "MChooseBanKuaiViewController.h"
#import "PickerChoiceView.h"
#import "PersonalFileSubmitViewController.h"
@interface ServiceCenterFileViewController ()<UITableViewDataSource, UITableViewDelegate,TFPickerDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIView *leftBtnView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableArray *adressArray;
@end

@implementation ServiceCenterFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isYun) {
        self.navigationBarTitle = @"孕妇建册";
    }else{
        self.navigationBarTitle = @"服务中心建档";
    }
    
    [self setupUI];
    self.isEmptyDelegate = NO;
    UIButton *footview = [[UIButton alloc]initWithFrame:CGRectMake(0, screenH -  50, screenW,  50)];
    footview.backgroundColor = JHMedicalColor;;
    [footview setTitle:@"提交预约" forState:UIControlStateNormal];
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
#pragma  mark 立即预约
-(void)submitClick{
    

    
    for (TextFiledModel *tmodel in self.dataArray) {
        if (!tmodel.value && tmodel.prompt) {
            [self presentLoadingTips:tmodel.prompt];
            return;
        }else if (tmodel.value){
            [self.model setValue:tmodel.value forKey:tmodel.key];
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

    //prompt：必填提示语
    NSArray * array = nil;
    if (self.isYun) {
        array = @[@{@"name":@"性别",@"text":self.model.gr_name ? self.model.gr_name :@"",@"value":self.model.gr_name ? self.model.gr_name :@"",@"placeholder":@"请输入姓名",@"key":@"hr_name",@"enable":@"1",@"prompt":@"请输入姓名"},
                  @{@"name":@"身份证号",@"text":@"",@"placeholder":@"请填写",@"key":@"gr_idno",@"enable":@"1",@"prompt":@"请输入身份证号"},
                  @{@"name":@"联系电话",@"text":@"",@"placeholder":@"请填写您的电话",@"key":@"gr_telp",@"enable":@"1",@"prompt":@"联系电话"},
                  @{@"name":@"户籍地址",@"text":@"",@"placeholder":@"请填写",@"key":@"gr_domicileP",@"enable":@"1",@"prompt":@"请输入户籍地址"},
                  @{@"name":@"现住地址",@"text":@"",@"key":@"gr_addr",@"rightim":@"1",@"prompt":@"请选择现住地址"},
                  @{@"name":@"建档机构",@"text":@"",@"key":@""},
                  @{@"name":@"村(居)委会名称",@"text":@"",@"key":@""},
                  @{@"name":@"预约时间",@"text":@"",@"key":@"gr_reserveDate",@"rightim":@"1",@"prompt":@"请选择预约时间"}
                  ];
    }else{
        array = @[@{@"name":@"姓名",@"text":self.model.hr_name ? self.model.hr_name :@"",@"value":self.model.hr_name ? self.model.hr_name :@"",@"placeholder":@"请输入姓名",@"key":@"hr_name"},
                  @{@"name":@"联系电话",@"text":@"",@"placeholder":@"请填写您的电话",@"key":@"hr_telp",@"enable":@"1",@"prompt":@"联系电话"},
                  @{@"name":@"户籍地址",@"text":@"",@"placeholder":@"请填写",@"key":@"hr_domicileP",@"enable":@"1",@"prompt":@"请输入户籍地址"},
                  @{@"name":@"现住地址",@"text":@"",@"key":@"hr_addr",@"rightim":@"1",@"prompt":@"请选择现住地址"},
                  @{@"name":@"建档机构",@"text":@"",@"key":@""},
                  @{@"name":@"村(居)委会名称",@"text":@"",@"key":@""},
                  @{@"name":@"预约时间",@"text":@"",@"key":@"hr_reserveDate",@"rightim":@"1",@"prompt":@"请选择预约时间"}
                  ];
    }
    
    for (NSDictionary *arr in array) {
        TextFiledModel *model = [TextFiledModel mj_objectWithKeyValues:arr];
        [self.dataArray addObject:model];
    }
    [self initTableView];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextFiledLableTableViewCell class]) forIndexPath:indexPath];
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    TextFiledModel *model = self.dataArray[indexPath.section];
    cell.model = model;
    
//    WEAKSELF;
//    cell.TextChangeBlock = ^(NSString *text) {
//        LFLog(@"row:%ld",(long)indexPath.row);
//        NSMutableDictionary *mdt = weakSelf.dataArray[indexPath.row];
//        [mdt setObject:text ? text :@"" forKey:@"value"];
//
//    } ;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 55;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
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
    TextFiledModel *wmodel = self.dataArray[indexPath.section];
    int row = 3;
    if (self.isYun) {
        row = 4;
    }
    if (indexPath.section == self.dataArray.count - 1 && indexPath.row == 0) {
        TextFiledModel *admodel = self.dataArray[row];
        if (!admodel.value) {
            [self presentLoadingTips:@"请先选择现住地址！"];
            return;
        }
        MChooseBanKuaiViewController *vc = [[MChooseBanKuaiViewController alloc] init];
        vc.type = SelectReserveTime;
        vc.codeid = admodel.value;
        vc.rs_type = self.isYun ? @"可预约建册时间" : @"可预约建档时间";
        __weak typeof(self) weakSelf = self;
        vc.doneBlock = ^(HSDTagModel *model,id dict){
            wmodel.value = [NSString stringWithFormat:@"%@ %@ (剩余%@人)",model.rs_reserveDate,model.reserveDQ,model.avg_num_new];
            wmodel.text = wmodel.value;
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSDictionary *temdt = (NSDictionary *)dict;
                if (weakSelf.isYun) {
                    weakSelf.model.gr_deid = temdt[@"deid"];
                    weakSelf.model.gr_comno = temdt[@"com_no"];
                }else{
                    weakSelf.model.hr_deid = temdt[@"deid"];
                    weakSelf.model.hr_comno = temdt[@"com_no"];
                }
                
                TextFiledModel *tmo4 = weakSelf.dataArray[self.dataArray.count - 3];
                tmo4.text =  temdt[@"de_name"];
                TextFiledModel *tmo5 = weakSelf.dataArray[self.dataArray.count - 2];
                tmo5.text =  temdt[@"com_name"];
            }
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == row && indexPath.row == 0) {
        PickerChoiceView *_picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
        _picker.inter =1;
        _picker.titlestr = @"请选择";
        _picker.arrayType = GenderArray;
        _picker.delegate = self;
        [_picker.provinceArr addObject:@"太原市"];

        [self.view addSubview:_picker];

    }
}
#pragma mark -------- TFPickerDelegate
-(void)PickerSelectorIndixString:(id)picker str:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    PickerChoiceView *_picker = (PickerChoiceView *)picker;
    [_picker.cityArr removeAllObjects];
    if (self.adressArray.count) {
        for (NSString *dt in self.adressArray) {
            [_picker.cityArr addObject:dt];
        }
        [_picker reloadcomment:1];
    }else{
        [self getDataAdress:^(NSArray *arr) {
            for (NSString *dt in arr) {
                [_picker.cityArr addObject:dt];
            }
            [_picker reloadcomment:1];
        }];
    }
}


-(void)provinceSelectorIndixString:(NSString *)pricent city:(NSString *)city{
    NSLog(@"%@==%@",pricent,city);
    TextFiledModel *wmodel = self.dataArray[self.isYun ? 4 : 3];
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
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,self.isYun ? ERPYunSubmitUrl :ERPFileCenterSubmitUrl) params:dt  success:^(id response) {
        [self dismissTips];
        LFLog(@" 数据提交:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
//            [AlertView showMsg:@"预约成功！"];
            TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"预约提醒" message:response[@"data"][@"message"]];
            alertView.titleLable.textColor = JHmiddleColor;
            alertView.messageLabel.textColor = JHmiddleColor;
            alertView.buttonCancelBgColor = [UIColor whiteColor];
            alertView.buttonDestructiveBgColor = [UIColor whiteColor];
            alertView.buttonTextColor = JHMedicalColor;
            alertView.backgroundColor = [UIColor whiteColor];
            WEAKSELF;
            if (!self.isYun) {
                [alertView addAction:[TYAlertAction actionWithTitle:@"去建档" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
                    PersonalFileSubmitViewController *vc = [[PersonalFileSubmitViewController alloc]init];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    
                    //                [weakSelf.navigationController pushViewController:[[MyAppointmentViewController alloc]init] animated:YES];
                }]];
            }
            [alertView addAction:[TYAlertAction actionWithTitle:self.isYun ? @"确定" : @"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }]];
            TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
            alertController.backgroundColor =JHColoralpha(0, 0, 0, 0.3);
            //alertController.alertViewOriginY = 60;
            [self presentViewController:alertController animated:YES completion:nil];
//            [alertView showInWindowWithOriginY:0 backgoundTapDismissEnable:NO];
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self dismissTips];
    }];
    
}

@end
