//
//  FilePersonalFormViewController.m
//  PropertyApp
//
//  Created by admin on 2018/7/24.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "FilePersonalFormViewController.h"
#import "SPPageMenu.h"
#import "TextFiledLableTableViewCell.h"
@interface FilePersonalFormViewController ()<SPPageMenuDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation FilePersonalFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = JHbgColor;
    self.navigationBarTitle = @"个人信息基本表";
    [self.view addSubview:self.pageMenu];
    [self.view addSubview:self.tableView];
    [self UpData];
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
        [_pageMenu setItems:@[@"基本信息",@"病史",@"生活环境"] selectedItemIndex:0];
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NaviH + pageMenuH, screenW, screenH - NaviH - pageMenuH) style:UITableViewStylePlain];
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
    if (self.dataArray.count) {
        NSMutableArray *marr = self.dataArray[self.pageMenu.selectedItemIndex];
        return marr.count;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *marr = self.dataArray[self.pageMenu.selectedItemIndex];
    TextSectionModel *smo = marr[section];
    return smo.child.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    NSMutableArray *marr = self.dataArray[self.pageMenu.selectedItemIndex];
    TextSectionModel *smo = marr[indexPath.section];
    TextFiledModel *cmo = smo.child[indexPath.row];
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSMutableArray *marr = self.dataArray[self.pageMenu.selectedItemIndex];
    TextSectionModel *smo = marr[section];
    return smo.section ? 40 : 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc]init];
    footer.backgroundColor = JHbgColor;
    NSMutableArray *marr = self.dataArray[self.pageMenu.selectedItemIndex];
    TextSectionModel *smo = marr[section];
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
    NSArray *basicArr = @[@{@"key":@"basic",
                            @"child":@[@{@"name":@"状态",@"text":@"",@"key":@"status",@"rightim":@"1",@"textcolor":@"FF5050"},
                                       @{@"name":@"姓名",@"text":@"",@"key":@"hp_name"},
                                       @{@"name":@"编号",@"text":@"",@"key":@"hp_no"},
                                       @{@"name":@"性别",@"text":@"",@"key":@"hp_sex"},
                                       @{@"name":@"出生日期",@"text":@"",@"key":@"hp_birthday"}]
                            },
                          @{@"key":@"basic",
                            @"child":@[@{@"name":@"身份证号",@"text":@"",@"key":@"hp_idno"},
                                       @{@"name":@"工作单位",@"text":@"",@"key":@"hp_workCompany"},
                                       @{@"name":@"本人电话",@"text":@"",@"key":@"hp_telp",@"textcolor":@"FF5050"},
                                       @{@"name":@"联系人姓名",@"text":@"",@"key":@"hp_linkman"},
                                       @{@"name":@"联系人电话",@"text":@"",@"key":@"hp_linktelp",@"textcolor":@"FF5050"}]
                            },
                          
                          @{@"key":@"basic",
                            @"child":@[@{@"name":@"常住类型",@"text":@"",@"key":@"hp_PermanentType"},
                                       @{@"name":@"民族",@"text":@"",@"key":@"hp_nation"},
                                       @{@"name":@"ABO血型/RH血型",@"text":@"",@"key":@"hp_bloodType"},
                                       @{@"name":@"文化程度",@"text":@"",@"key":@"hp_education"},
                                       @{@"name":@"职业",@"text":@"",@"key":@"hp_profession",@"label":@"1"},
                                       @{@"name":@"婚姻状况",@"text":@"",@"key":@"hp_marital"},
                                       @{@"name":@"医疗费支付方式",@"text":@"",@"key":@"hp_medicalExpense"}]
                            }];
    //病史
    NSArray *historyArr = @[@{@"section":@"   既往史",
                              @"key":@"dict",
                              @"image":@"bingshi",
                            @"child":@[@{@"name":@"药物过敏史",@"text":@"",@"key":@"hp_drugAllergy"},
                                       @{@"name":@"暴露史",@"text":@"",@"key":@"hp_exposure"}]
                            },
                          @{@"key":@"既往史",
                            @"child":@[@{@"name":@"疾病",@"text":@"",@"key":@"jiwangshijibing"},
                                       @{@"name":@"确诊时间",@"text":@"",@"key":@"jiwangshijibingshijian"}]
                            },
                            @{@"key":@"既往史",
                              @"child":@[@{@"name":@"手术",@"text":@"",@"key":@"jiwangshishoushu"},
                                         @{@"name":@"时间",@"text":@"",@"key":@"jiwangshishoushushijian"}]
                              },
                            @{@"key":@"既往史",
                              @"child":@[@{@"name":@"外伤",@"text":@"",@"key":@"jiwangshiwaishang"},
                                         @{@"name":@"时间",@"text":@"",@"key":@"jiwangshiwaishangshijian"}]
                              },
                            @{@"section":@"   家族史",
                              @"image":@"",
                              @"key":@"家族史",
                              @"child":@[@{@"name":@"输血",@"text":@"",@"key":@"jiwangshishuxue"},
                                         @{@"name":@"原因",@"text":@"",@"key":@"jiwangshishuxueyuanyin"},
                                         @{@"name":@"时间",@"text":@"",@"key":@"jiwangshishuxueshijian"}]
                              },
                          
                          @{@"key":@"家族史",
                            @"child":@[@{@"name":@"父亲",@"text":@"",@"key":@"father"},
                                       @{@"name":@"母亲",@"text":@"",@"key":@"mother"},
                                       @{@"name":@"兄弟姐妹",@"text":@"",@"key":@"brother"},
                                       @{@"name":@"子女",@"text":@"",@"key":@"children"}]
                            },
                            @{@"key":@"家族史",
                              @"child":@[@{@"name":@"遗传病史",@"text":@"",@"key":@"hereditary"},
                                         @{@"name":@"残疾情况",@"text":@"",@"key":@"disability"}]
                              }];
    
    //生活环境
    NSArray *liveArr = @[@{@"key":@"life",
                            @"child":@[@{@"name":@"厨房排风设施",@"text":@"",@"key":@"kitchen"},
                                       @{@"name":@"燃料类型",@"text":@"",@"key":@"fuel"},
                                       @{@"name":@"饮水",@"text":@"",@"key":@"water"},
                                       @{@"name":@"厕所",@"text":@"",@"key":@"wc"},
                                       @{@"name":@"禽畜栏",@"text":@"",@"key":@"livestock"}]
                            }];

    NSMutableArray *mbasicarr = [NSMutableArray array];
    for (NSDictionary *dt in basicArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        for (TextFiledModel *cmo in model.child) {
            NSDictionary *temDt = dict;
            if (temDt) {
                if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                    if ([cmo.key isEqualToString:@"hp_bloodType"]) {
                        cmo.text = [NSString stringWithFormat:@"%@ %@",temDt[cmo.key],temDt[@"hp_bloodRH"]];
                    }else{
                        cmo.text = temDt[cmo.key];
                    }
                }
            }
        }
        [mbasicarr addObject:model];
    }
    NSMutableArray *mhistoryArr = [NSMutableArray array];
    for (NSDictionary *dt in historyArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        if ([model.key isEqualToString:@"dict"]) {
            for (TextFiledModel *cmo in model.child) {
                NSDictionary *temDt = dict;
                if (temDt) {
                    if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                        cmo.text = temDt[cmo.key];
                    }
                }
            }
        }else{
            for (NSDictionary *hdt in dict[@"history"]) {
                if ([model.key isEqualToString:hdt[@"hh_type1"]]) {
                    for (TextFiledModel *cmo in model.child) {
                        if ([cmo.name isEqualToString:hdt[@"hh_type2"]]) {
                            if ([hdt[@"hh_name"] isKindOfClass:[NSString class]]) {
                                cmo.text = hdt[@"hh_name"];
                            }
                            
                        }
                    }
                }
            }
        }

        [mhistoryArr addObject:model];
    }
    NSMutableArray *mliveArr = [NSMutableArray array];
//    for (NSDictionary *dt in liveArr) {
//        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
//        for (TextFiledModel *cmo in model.child) {
//            NSDictionary *temDt = dict[model.key];
//            if (temDt) {
//                if (temDt[cmo.key]) {
//                    cmo.text = temDt[cmo.key];
//                }
//            }
//        }
//        [mliveArr addObject:model];
//    }

    for (NSDictionary *dt in liveArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        for (NSDictionary *hdt in dict[@"Environment"]) {
            for (TextFiledModel *cmo in model.child) {
                if ([cmo.name isEqualToString:hdt[@"he_type"]]) {
                    cmo.text = [NSString stringWithFormat:@"%@ %@",hdt[@"he_name"],hdt[@"he_other"]];
                }
            }
        }
        [mliveArr addObject:model];
    }
    [self.dataArray addObjectsFromArray:@[mbasicarr,mhistoryArr,mliveArr]];
    [self.tableView reloadData];
}
@end
