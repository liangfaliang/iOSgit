//
//  ActivateFileViewController.m
//  PropertyApp
//
//  Created by admin on 2018/7/27.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ActivateFileViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "InputTextViewViewController.h"
#import "SelectillViewController.h"
#import "UIView+TYAlertView.h"
@interface ActivateFileViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property (strong, nonatomic)  NSMutableArray *illNameArr;//慢性疾病
@property (strong, nonatomic)  NSString *illtext;//慢性疾病
@end

@implementation ActivateFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"档案认证";
    [self.view addSubview:self.tableView];
    UIButton * footer = [[UIButton alloc]initWithFrame:CGRectMake(0, screenH - 50, screenW, 50)];
    footer.backgroundColor = JHMedicalColor;
    [footer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footer addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footer];
    if (self.isSecond) {
        [footer setTitle:@"提交档案" forState:UIControlStateNormal];
    }else{
        self.illtext = @"";
        [footer setTitle:@"下一步" forState:UIControlStateNormal];
    }
    
    [self InitializationData];
}

-(NSMutableArray *)illNameArr{
    if (!_illNameArr) {
        _illNameArr = [NSMutableArray array];
    }
    return _illNameArr;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH - 50) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = JHbgColor;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
        //        WEAKSELF;
        //        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //            [weakSelf getData];
        //        }];
    }
    return _tableView;
}
#pragma mark - 下一步
- (void)nextClick{
    if (self.isSecond) {
        for (TextSectionModel *tmodel in self.dataArray) {
            for (TextFiledModel *cmo in tmodel.child) {
                if (cmo.text) {
                    [self.acmodel setValue:cmo.value forKey:cmo.key];
                }
            }
        }
        NSMutableDictionary *mdt = [self.acmodel mj_keyValues];
        NSDictionary * session =[userDefaults objectForKey:@"session"];
        if (session == nil) {
            session = @{};
        }
        [mdt setObject:session forKey:@"session"];
        [self SubmitData:mdt];
    }else{
        ActivateFileViewController *vc = [[ActivateFileViewController alloc]init];
        vc.acmodel = self.acmodel;
        vc.isSecond = @"isSecond";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TextSectionModel *smo = self.dataArray[section];
    return smo.child.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    TextSectionModel *smo = self.dataArray[indexPath.section];
    TextFiledModel *cmo = smo.child[indexPath.row];
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return  10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc]init];
    footer.backgroundColor = JHbgColor;
    return footer;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TextSectionModel *smo = self.dataArray[indexPath.section];
    TextFiledModel *cmo = smo.child[indexPath.row];
    if (self.isSecond) {
        if (indexPath.section == 4 && indexPath.row == 0) {
            InputTextViewViewController*vc = [[InputTextViewViewController alloc]init];
            vc.titleStr = @"其他说明";
            vc.textviewtext = cmo.text;
            WEAKSELF;
            vc.selectBlock = ^(NSString *text) {
                cmo.text = text;
                cmo.value = text;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
    }else{
        if (indexPath.section == 2 && indexPath.row == 2) {
            SelectillViewController*vc = [[SelectillViewController alloc]init];
            vc.selectNameArr = self.illNameArr;
            vc.illtext = self.illtext;
            WEAKSELF;
            vc.selectBlock = ^(NSString *text) {
                cmo.text = text;
                cmo.value = text;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        if (indexPath.section == 2 && indexPath.row == 3) {
            InputTextViewViewController*vc = [[InputTextViewViewController alloc]init];
            vc.titleStr = @"过敏史";
            vc.textviewtext = cmo.text;
            WEAKSELF;
            vc.selectBlock = ^(NSString *text) {
                cmo.text = text;
                cmo.value = text;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
    }
}
#pragma mark - 数据
- (void)getData{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,MyFileHealthCoveUrl) params:dt success:^(id response) {
        LFLog(@" 数据:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
-(void)InitializationData{
    //基本信息
    NSArray *basicArr = nil;
    if (self.isSecond) {
        basicArr = @[@{@"key":@"",
                       @"child":@[@{@"name":@"家庭住址",@"text":@"",@"key":@"address",@"enable":@"1",@"textcolor":@"#999999"},
                                  @{@"name":@"家庭电话",@"text":@"",@"key":@"tel",@"enable":@"1",@"textcolor":@"#999999"}]
                       },
                     @{@"key":@"",
                       @"child":@[@{@"name":@"紧急情况联系人",@"text":@"",@"key":@"contact",@"enable":@"1",@"textcolor":@"#999999"},
                                  @{@"name":@"联系人电话",@"text":@"",@"key":@"contact_tel",@"enable":@"1",@"textcolor":@"#999999"}]
                       },
                     @{@"key":@"",
                       @"child":@[@{@"name":@"建档机构名称",@"text":@"",@"key":@"organ_name"},
                                  @{@"name":@"联系电话",@"text":@"",@"key":@"organ_tel"}]
                       },
                     @{@"key":@"",
                       @"child":@[@{@"name":@"责任医生或护士",@"text":@"",@"key":@"doctor_nurse_name"},
                                  @{@"name":@"联系电话",@"text":@"",@"key":@"doctor_nurse_tel"}]
                       },
                     
                     @{@"key":@"",
                       @"child":@[@{@"name":@"其他说明",@"text":@"",@"key":@"comment",@"rightim":@"1"}]
                       }];
        
    }else{
        basicArr = @[@{@"key":@"",
                       @"child":@[@{@"name":@"建档时间",@"text":@"",@"key":@"add_time"}]
                       },
                     @{@"key":@"",
                       @"child":@[@{@"name":@"姓名",@"text":@"",@"key":@"name"},
                                  @{@"name":@"性别",@"text":@"",@"key":@"sex"},
                                  @{@"name":@"出生日期",@"text":@"",@"key":@"birthday"},
                                  @{@"name":@"健康档案编号",@"text":@"",@"key":@"archive_no"}]
                       },
                     @{@"key":@"",
                       @"child":@[@{@"name":@"ABO血型",@"text":@"",@"key":@"abo_blood_type"},
                                  @{@"name":@"RH血型",@"text":@"",@"key":@"rh_blood_type"},
                                  @{@"name":@"慢性病患病情况",@"text":@"",@"key":@"chronic_disease",@"rightim":@"1",@"textcolor":@"999999"},
                                  @{@"name":@"过敏史",@"text":@"",@"key":@"allergies",@"rightim":@"1",@"textcolor":@"999999"}]
                       }];
    }
    for (NSDictionary *dt in basicArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        for (TextFiledModel *cmo in model.child) {
            NSString *temDt = [self.acmodel valueForKey:cmo.key];
            if (temDt) {
                cmo.text = temDt;
                cmo.value = temDt;
            }
        }
        [self.dataArray addObject:model];
    }
    
    [self.tableView reloadData];
}

#pragma mark - 数据提交
- (void)SubmitData:(NSMutableDictionary *)dt{
    [self presentLoadingTips];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ActivateSubmitUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@" 数据提交:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"" message:@"激活成功"];
            alertView.titleLable.textColor = JHmiddleColor;
            alertView.messageLabel.textColor = JHmiddleColor;
            alertView.buttonCancelBgColor = [UIColor whiteColor];
            alertView.buttonDestructiveBgColor = [UIColor whiteColor];
            alertView.buttonTextColor = JHMedicalColor;
            alertView.backgroundColor = [UIColor whiteColor];
            WEAKSELF;
            [alertView addAction:[TYAlertAction actionWithTitle:@"查看详情" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
//                [weakSelf.navigationController pushViewController:[[MyAppointmentViewController alloc]init] animated:YES];
            }]];
            
            [alertView addAction:[TYAlertAction actionWithTitle:@"确认" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }]];
            
            [alertView showInWindowWithOriginY:0 backgoundTapDismissEnable:NO];
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self dismissTips];
    }];
    
}
@end
