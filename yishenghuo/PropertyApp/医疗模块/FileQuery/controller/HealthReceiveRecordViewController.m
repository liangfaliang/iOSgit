//
//  HealthReceiveRecordViewController.m
//  PropertyApp
//
//  Created by admin on 2018/7/31.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

//
#import "HealthReceiveRecordViewController.h"
#import "TextFiledLableTableViewCell.h"
@interface HealthReceiveRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation HealthReceiveRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"接诊记录表";
    [self.view addSubview:self.tableView];
    [self UpData];
}

-(void)UpData{
    [super UpData];
//    [self getData];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH ) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.rowHeight = -1;
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
    TextSectionModel *smo = self.dataArray[section];
    return smo.section ? 40 : 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc]init];
    footer.backgroundColor = JHbgColor;
    TextSectionModel *smo = self.dataArray[section];
    if (smo.section) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, screenW - 30, 40)];
        [btn setTitle:smo.section forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
        if (smo.image) {
            [btn setImage:[UIImage imageNamed:smo.image] forState:UIControlStateNormal];
        }
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [footer addSubview:btn];
    }
    return footer;
}
#pragma mark - 数据
- (void)getData{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    NSString *uid = [UserDefault objectForKey:@"uid"];
    if (uid == nil) uid = @"";
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) coid = @"";
    coid = @"53";
    [dt setObject:coid forKey:@"coid"];
    [dt setObject:uid forKey:@"uid"];
    [dt setObject:@"1" forKey:@"iszb"];
    if (self.archive_no) {
        [dt setObject:self.archive_no forKey:@"hp_no"];
    }
    //
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,self.tr_InterfaceID) params:dt success:^(id response) {
        LFLog(@" 数据:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
                [self InitializationData:response[@"data"]];
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
-(void)InitializationData:(NSDictionary *)dict{
    //基本信息
    NSArray *basicArr = @[@{@"section":@"   就诊者主观资料",
                            @"image":@"yibanzhuangk",
                            @"key":@"zhengzhuang",
                            @"child":@[@{@"name":@"姓名",@"key":@"hp_name"},
                                       @{@"name":@"编号",@"key":@"hp_no"},
                                       @{@"name":@"签字医生",@"key":@"hr_Doctor"},
                                       @{@"name":@"接诊日期",@"key":@"hr_date"}]
                            },
                          @{@"section":@"   就诊者客观资料",
                            @"image":@"yibanzhuangk",
                            @"key":@"zhengzhuang",
                            @"child":@[@{@"name":@"",@"key":@"hr_SubjectiveData"}]
                            },
                          @{@"section":@"   评估",
                            @"image":@"yibanzhuangk",
                            @"key":@"zhengzhuang",
                            @"child":@[@{@"name":@"",@"key":@"hr_ObjectiveData"}]
                            },
                          @{@"section":@"   处置计划",
                            @"image":@"yibanzhuangk",
                            @"key":@"zhengzhuang",
                            @"child":@[@{@"name":@"",@"key":@"hr_Assessment"}]
                            },
                          @{@"key":@"zhengzhuang",
                            @"child":@[@{@"name":@"",@"key":@"hr_Plan"}]
                            }
                          ];
    
    for (NSDictionary *dt in basicArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        for (TextFiledModel *cmo in model.child) {
            cmo.label = @"1";
            cmo.text = @"";
            NSDictionary *temDt = dict;
            if (temDt) {
                if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                    cmo.text = temDt[cmo.key];
                }
            }
        }
        [self.dataArray addObject:model];
    }
    
    [self.tableView reloadData];
}
@end
