//
//  TwoWayINViewController.m
//  PropertyApp
//
//  Created by admin on 2018/8/25.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "TwoWayINViewController.h"
#import "SPPageMenu.h"
#import "TextFiledLableTableViewCell.h"
@interface TwoWayINViewController ()<SPPageMenuDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation TwoWayINViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = JHbgColor;
    if ([self.tr_InterfaceID isEqualToString:@"97"]) {
        self.navigationBarTitle = @"双向转诊(转出)单";
    }else{
        self.navigationBarTitle = @"双向转诊(转回)单";
    }
    
//    [self.view addSubview:self.pageMenu];
    [self.view addSubview:self.tableView];
//    [self UpData];
}
-(SPPageMenu *)pageMenu{
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, NaviH, screenW, pageMenuH) trackerStyle:SPPageMenuTrackerStyleLine];
        _pageMenu.tracker.backgroundColor = JHAssistColor;
        // 传递数组，默认选中第1个
        // 可滑动的自适应内容排列
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        // 设置代理
        _pageMenu.selectedItemTitleColor = JHAssistColor;
        _pageMenu.unSelectedItemTitleColor = JHmiddleColor;
        _pageMenu.delegate = self;
        [_pageMenu setItems:@[@"存根",[self.tr_InterfaceID isEqualToString:@"97"] ? @"转出单" :@"回转单"] selectedItemIndex:0];
    }
    return _pageMenu;
}
#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    NSLog(@"%zd",index);
    [self.tableView reloadData];
}
-(void)UpData{
    [super UpData];
    [self getData];
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
        _tableView.rowHeight = UITableViewAutomaticDimension;
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
//    if (self.dataArray.count) {
//        NSMutableArray *marr = self.dataArray[self.pageMenu.selectedItemIndex];
//        return marr.count;
//    }
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSMutableArray *marr = self.dataArray[self.pageMenu.selectedItemIndex];
    TextSectionModel *smo = self.dataArray[section];
    return smo.child.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
//    NSMutableArray *marr = self.dataArray[self.pageMenu.selectedItemIndex];
    TextSectionModel *smo = self.dataArray[indexPath.section];
    TextFiledModel *cmo = smo.child[indexPath.row];
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    NSMutableArray *marr = self.dataArray[self.pageMenu.selectedItemIndex];
    if (self.dataArray.count - 1 > section) {
        TextSectionModel *model =  self.dataArray[section +1];
        return model.section ? 0.001 : 10;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    NSMutableArray *marr = self.dataArray[self.pageMenu.selectedItemIndex];
    TextSectionModel *model =  self.dataArray[section];
    return model.section ? 40 : 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    NSMutableArray *marr = self.dataArray[self.pageMenu.selectedItemIndex];
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
    if ([self.tr_InterfaceID isEqualToString:@"97"]) {
        //基本信息
//        NSArray *basicArr = @[@{@"key":@"healthy",
//                                @"child":@[
//                                        @{@"name":@"患者姓名",@"text":@"",@"key":@"hp_name"},
//                                        @{@"name":@"性别",@"text":@"",@"key":@"ht_sex"},
//                                        @{@"name":@"年龄",@"text":@"",@"key":@"ht_age"},
//                                        @{@"name":@"档案编号",@"text": @"",@"key":@"hp_no"},
//                                        @{@"name":@"家庭住址",@"text":@"",@"key":@""}]
//                                },
//                              @{@"key":@"healthy",
//                                @"child":@[@{@"name":@"病情日期",@"text":@"",@"key":@""},
//                                           @{@"name":@"转入单位",@"text":@"",@"key":@""},
//                                           @{@"name":@"转入科室",@"text":@"",@"key":@""},
//                                           @{@"name":@"接诊医生",@"text":@"",@"key":@""}]
//                                },
//                              @{@"key":@"healthy",
//                                @"child":@[@{@"name":@"转诊医生",@"text":@"",@"key":@"ht_Doctor"},
//                                           @{@"name":@"转诊日期",@"text":@"",@"key":@"ht_date"}]
//                                }];
//
        //病史
        NSArray *historyArr = @[@{@"key":@"contact",
                                  @"child":@[@{@"name":@"转入机构名称",@"key":@"ht_mechanism"},
                                             @{@"name":@"患者",@"key":@"hp_name"},
                                             @{@"name":@"性别",@"key":@"ht_sex"},
                                             @{@"name":@"年龄",@"key":@"ht_age"}]
                                  },
                                @{@"section":@"   初步印象",
                                  @"image":@"yibanzhuangk",
                                  @"key":@"contact",
                                  @"child":@[@{@"name":@"",@"text":@"",@"key":@"ht_Preliminary"}]
                                  },
                                @{@"section":@"   主要现病史(转出原因)",
                                  @"image":@"yibanzhuangk",
                                  @"key":@"contact",
                                  @"child":@[@{@"name":@"",@"text":@"",@"key":@"ht_Reason"}]
                                  },
                                @{@"section":@"   主要既往史",
                                  @"image":@"yibanzhuangk",
                                  @"key":@"contact",
                                  @"child":@[@{@"name":@"",@"text":@"",@"key":@"ht_PastHistory"}]
                                  },
                                @{@"section":@"   治疗经过",
                                  @"image":@"yibanzhuangk",
                                  @"key":@"contact",
                                  @"child":@[@{@"name":@"",@"text":@"",@"key":@"ht_After"}]
                                  }
//                                ,
//                                @{@"key":@"contact",
//                                  @"child":@[@{@"name":@"转诊医生",@"text":@"",@"key":@"hp_doctor"},
//                                             @{@"name":@"联系电话",@"text":@"",@"key":@"hp_doctor_tel"},
//                                             @{@"name":@"转诊机构名称",@"text":@"",@"key":@"hp_doctor"},
//                                             @{@"name":@"转诊日期",@"text":@"",@"key":@"hp_doctor_tel"}]
//                                  }
                                ];
        
        
//        NSMutableArray *mbasicarr = [NSMutableArray array];
//        for (NSDictionary *dt in basicArr) {
//            TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
//            for (TextFiledModel *cmo in model.child) {
//                NSDictionary *temDt = dict;
//                if (temDt) {
//                    if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
//                        cmo.text = temDt[cmo.key];
//                    }
//                }
//            }
//            [mbasicarr addObject:model];
//        }
//        NSMutableArray *mhistoryArr = [NSMutableArray array];
        for (NSDictionary *dt in historyArr) {
            TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
            for (TextFiledModel *cmo in model.child) {
                cmo.label = @"1";
                NSDictionary *temDt = dict;
                if (temDt) {
                    if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                        cmo.text = temDt[cmo.key];
                    }
                }
            }
            [self.dataArray addObject:model];
        }
        
//        [self.dataArray addObjectsFromArray:@[mbasicarr,mhistoryArr]];
    }else{
        //基本信息
//        NSArray *basicArr = @[@{@"key":@"healthy",
//                                @"child":@[
//                                        @{@"name":@"患者姓名",@"text":@"",@"key":@"hp_name"},
//                                        @{@"name":@"性别",@"text":@"",@"key":@""},
//                                        @{@"name":@"年龄",@"text":@"",@"key":@""},
//                                        @{@"name":@"档案编号",@"text": @"",@"key":@"hp_no"},
//                                        @{@"name":@"家庭住址",@"text":@"",@"key":@""}]
//                                },
//                              @{@"key":@"healthy",
//                                @"child":@[@{@"name":@"病情日期",@"text":@"",@"key":@""},
//                                           @{@"name":@"转入单位",@"text":@"",@"key":@""},
//                                           @{@"name":@"转入科室",@"text":@"",@"key":@""},
//                                           @{@"name":@"接诊医生",@"text":@"",@"key":@""}]
//                                },
//                              @{@"key":@"healthy",
//                                @"child":@[@{@"name":@"转诊医生",@"text":@"",@"key":@"ht_Doctor"},
//                                           @{@"name":@"转诊日期",@"text":@"",@"key":@"ht_date"}]
//                                }];
//
        //病史
        NSArray *historyArr = @[@{@"key":@"contact",
                                  @"child":@[@{@"name":@"转入机构名称",@"text":@"",@"key":@"hb_mechanism"},
                                             @{@"name":@"患者",@"text":@"",@"key":@"hp_name"},
                                             @{@"name":@"诊断结果",@"text":@"",@"key":@"hb_DiagnosticResults"},
                                             @{@"name":@"住院病案号",@"text":@"",@"key":@"hb_CaseNumber"}]
                                  },
                                @{@"section":@"   主要检查结果",
                                  @"image":@"yibanzhuangk",
                                  @"key":@"contact",
                                  @"child":@[@{@"name":@"",@"text":@"",@"key":@"hb_ExaminationResults"}]
                                  },
                                @{@"section":@"   诊疗方案及康复建议",
                                  @"image":@"yibanzhuangk",
                                  @"key":@"contact",
                                  @"child":@[@{@"name":@"",@"text":@"",@"key":@"hb_Proposal"}]
                                  }
//                                ,
//                                @{@"key":@"contact",
//                                  @"child":@[@{@"name":@"转诊医生",@"text":@"",@"key":@"hp_doctor"},
//                                             @{@"name":@"联系电话",@"text":@"",@"key":@"hp_doctor_tel"},
//                                             @{@"name":@"转诊机构名称",@"text":@"",@"key":@"hp_doctor"},
//                                             @{@"name":@"转诊日期",@"text":@"",@"key":@"hp_doctor_tel"}]
//                                  }
                                ];
        
        
//        NSMutableArray *mbasicarr = [NSMutableArray array];
//        for (NSDictionary *dt in basicArr) {
//            TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
//            for (TextFiledModel *cmo in model.child) {
//                NSDictionary *temDt = dict;
//                if (temDt) {
//                    if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
//                        cmo.text = temDt[cmo.key];
//                    }
//                }
//            }
//            [mbasicarr addObject:model];
//        }
//        NSMutableArray *mhistoryArr = [NSMutableArray array];
        for (NSDictionary *dt in historyArr) {
            TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
            for (TextFiledModel *cmo in model.child) {
                cmo.label = @"1";
                NSDictionary *temDt = dict;
                if (temDt) {
                    if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                        cmo.text = temDt[cmo.key];
                    }
                }
            }
            [self.dataArray addObject:model];
        }
        
//        [self.dataArray addObjectsFromArray:@[mbasicarr,mhistoryArr]];
    }

    [self.tableView reloadData];
}
@end
