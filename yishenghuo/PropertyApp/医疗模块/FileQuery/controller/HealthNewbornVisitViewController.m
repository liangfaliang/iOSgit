//
//  HealthNewbornVisitViewController.m
//  PropertyApp
//
//  Created by admin on 2018/7/31.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "HealthNewbornVisitViewController.h"
#import "SPPageMenu.h"
#import "TextFiledLableTableViewCell.h"
@interface HealthNewbornVisitViewController ()<SPPageMenuDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation HealthNewbornVisitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = JHbgColor;
    self.navigationBarTitle = @"新生儿家庭访视记录表";
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
        [_pageMenu setItems:@[@"家庭",@"新生儿",@"查体",@"建议"] selectedItemIndex:0];
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
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    if ([self.pageMenu selectedItemIndex] == 9) {
        return [UIImage imageNamed:@"tjianwuyic"];
    }
    return nil;
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if ([self.pageMenu selectedItemIndex] == 9) {
        return  nil;
    }
    return [super buttonTitleForEmptyDataSet:scrollView forState:state];
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
    //家庭
    NSArray *basicArr = @[@{@"key":@"jiating",
                            @"child":@[@{@"name":@"姓名",@"key":@"bv_name"},
                                       @{@"name":@"编号",@"key":@"hv_no"},
                                       @{@"name":@"性别",@"key":@"bv_sex"},
                                       @{@"name":@"出生日期",@"key":@"bv_birthday"}]
                            },
                          @{@"section":@"   父亲",
                            @"image":@"yibanzhuangk",
                            @"key":@"jiating",
                            @"child":@[@{@"name":@"身份证号",@"key":@"bv_idno"},
                                       @{@"name":@"家庭住址",@"key":@"bv_addr"}]
                            },
                          @{@"section":@"   母亲",
                            @"image":@"yibanzhuangk",
                            @"key":@"jiating",
                            @"child":@[@{@"name":@"姓名",@"key":@"bv_farther_name"},
                                       @{@"name":@"职业",@"key":@"bv_farther_work"},
                                       @{@"name":@"联系电话",@"key":@"bv_farther_tel"},
                                       @{@"name":@"出生日期",@"key":@"bv_farther_birthday"}]
                            },
                          @{@"key":@"jiating",
                            @"child":@[@{@"name":@"姓名",@"key":@"bv_mother_name"},
                                       @{@"name":@"职业",@"key":@"bv_mother_work"},
                                       @{@"name":@"联系电话",@"key":@"bv_mother_tel"},
                                       @{@"name":@"出生日期",@"key":@"bv_mother_birthday"}]
                            }];
    NSMutableArray *mbasicarr = [NSMutableArray array];
    for (NSDictionary *dt in basicArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        for (TextFiledModel *cmo in model.child) {
            if (!cmo.text) cmo.text = @"";
            cmo.label = @"1";
            NSDictionary *temDt = dict;
            if (temDt) {
                if (temDt[cmo.key]) {
                    if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                        cmo.text = temDt[cmo.key];
                    }else if(([temDt[cmo.key] isKindOfClass:[NSArray class]])){
                        NSArray *arr = temDt[cmo.key];
                        cmo.text = @"";
                        for (NSString *text in arr) {
                            cmo.text = [NSString stringWithFormat:@"%@ %@",cmo.text,text];
                        }
                    }
                }
            }
        }
        [mbasicarr addObject:model];
    }
    [self.dataArray addObject:mbasicarr];
    //新生儿
    NSArray *historyArr = @[@{@"key":@"xinshenger",
                              @"child":@[@{@"name":@"出生孕周",@"key":@"bv_born_week"},
                                         @{@"name":@"母亲妊娠期患病情况",@"key":@"bv_mother_sicken"},
                                         @{@"name":@"助产机构名称",@"key":@"bv_Midwifery"},
                                         @{@"name":@"出生情况",@"key":@"bv_Birth_condition"}]
                              },
                            @{@"key":@"xinshenger",
                              @"child":@[@{@"name":@"新生儿窒息",@"key":@"xinshengerzhixi"},
                                         @{@"name":@"畸形",@"key":@"jixing"},
                                         @{@"name":@"新生儿听力筛查",@"key":@"bv_unhs"},
                                         @{@"name":@"新生儿疾病筛查",@"key":@"bv_neonatal_screening",@"textcolor":@"FF5050"}]
                              },
                            @{@"key":@"xinshenger",
                              @"child":@[@{@"name":@"新生儿出生体重",@"key":@"bv_born_weight"},
                                         @{@"name":@"目前体重",@"key":@"bv_now_weight"},
                                         @{@"name":@"出生身长",@"key":@"bv_born_height"}]
                              },
                            @{@"key":@"xinshenger",
                              @"child":@[@{@"name":@"喂养方式",@"key":@"bv_feeding_patterns"},
                                         @{@"name":@"吃奶量",@"key":@"bv_Milk_volume"},
                                         @{@"name":@"吃奶次数",@"key":@"bv_Feeding_times"}]
                              },
                            @{@"key":@"checkitem",
                              @"child":@[@{@"name":@"呕吐",@"key":@"checkitem"},
                                         @{@"name":@"大便",@"key":@"bv_shitTimes"},
                                         @{@"name":@"大便次数",@"key":@"checkitem"}]
                              }];
    NSMutableArray *mhistoryArr = [NSMutableArray array];
    for (NSDictionary *dt in historyArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        for (TextFiledModel *cmo in model.child) {
            cmo.label = @"1";
            if ([cmo.key isEqualToString:@"checkitem"]) {
                for (NSDictionary *hdt in dict[@"checkitem"]) {
                    if ([cmo.name isEqualToString:hdt[@"hb_type1"]]) {
                        if ([hdt[@"hb_name"] isKindOfClass:[NSString class]]) {
                            cmo.text = [NSString stringWithFormat:@"%@%@%@",hdt[@"hb_name"],hdt[@"hb_other"],hdt[@"hb_other2"]];
                        }
                        
                    }
                }
            }else{
                NSDictionary *temDt = dict;
                if (temDt) {
                    if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                        cmo.text = temDt[cmo.key];
                    }
                }
            }

        }

        [mhistoryArr addObject:model];
    }
    [self.dataArray addObject:mhistoryArr];
    
    //查体
    NSArray *dirtyArr = @[@{@"key":@"chati",
                            @"child":@[@{@"name":@"体温",@"key":@"bv_temperature"},
                                       @{@"name":@"心率",@"key":@"bv_heart_rate"},
                                       @{@"name":@"呼吸频率",@"key":@"bv_breathing_rate"},
                                       @{@"name":@"面色",@"key":@"checkitem"},
                                       @{@"name":@"黄疸部位",@"key":@"checkitem"},
                                       @{@"name":@"前囟",@"key":@"bv_bregma1"}]
                            },
                          @{@"key":@"chati",
                            @"child":@[@{@"name":@"眼睛",@"key":@"checkitem"},
                                       @{@"name":@"四肢活动度",@"key":@"checkitem"},
                                       @{@"name":@"耳外观",@"key":@"checkitem"},
                                       @{@"name":@"颈部包块",@"key":@"checkitem"},
                                       @{@"name":@"鼻",@"key":@"checkitem"},
                                       @{@"name":@"皮肤",@"key":@"checkitem"},
                                       @{@"name":@"口腔",@"key":@"checkitem"}]
                            },
                          @{@"key":@"chati",
                            @"child":@[@{@"name":@"肛门",@"key":@"checkitem"},
                                       @{@"name":@"心肺听诊",@"key":@"checkitem"},
                                       @{@"name":@"胸部",@"key":@"checkitem"},
                                       @{@"name":@"腹部触诊",@"key":@"checkitem"},
                                       @{@"name":@"脊柱",@"key":@"checkitem"},
                                       @{@"name":@"外生殖器",@"key":@"checkitem"},
                                       @{@"name":@"脐带",@"key":@"checkitem",@"textcolor":@"FF5050"}]
                            }];
    NSMutableArray *mdirtyArr = [NSMutableArray array];
    for (NSDictionary *dt in dirtyArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        for (TextFiledModel *cmo in model.child) {
            cmo.label = @"1";
            if ([cmo.key isEqualToString:@"checkitem"]) {
                for (NSDictionary *hdt in dict[@"checkitem"]) {
                    if ([cmo.name isEqualToString:hdt[@"hb_type1"]]) {
                        if ([hdt[@"hb_name"] isKindOfClass:[NSString class]]) {
                            cmo.text = [NSString stringWithFormat:@"%@%@%@",hdt[@"hb_name"],hdt[@"hb_other"],hdt[@"hb_other2"]];
                        }
                        
                    }
                }
            }else{
                NSDictionary *temDt = dict;
                if (temDt) {
                    if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                        cmo.text = temDt[cmo.key];
                    }
                }
            }
            
        }

        [mdirtyArr addObject:model];
    }
    [self.dataArray addObject:mdirtyArr];
    
    //建议
    NSArray *bodyArr = @[@{@"key":@"jianyi",
                           @"child":@[@{@"name":@"转诊原因",@"key":@"checkitem"},
                                      @{@"name":@"机构及科室",@"key":@"checkitem"},
                                      @{@"name":@"转诊建议",@"key":@"checkitem"}]
                           },
                         @{@"key":@"jianyi",
                           @"child":@[@{@"name":@"指导",@"key":@"zhidao"}]
                           },
                         @{@"key":@"jianyi",
                           @"child":@[@{@"name":@"本次访视日期",@"key":@"bv_visit_date"},
                                      @{@"name":@"下次随访地点",@"key":@"bv_next_place"},
                                      @{@"name":@"下次随访日期",@"key":@"bv_next_date"},
                                      @{@"name":@"随访医生",@"key":@"bv_doctor_sign"}]
                           }];
    NSMutableArray *mbodyArr = [NSMutableArray array];
    for (NSDictionary *dt in bodyArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        for (TextFiledModel *cmo in model.child) {
            cmo.label = @"1";
            if ([cmo.key isEqualToString:@"checkitem"]) {
                for (NSDictionary *hdt in dict[@"checkitem"]) {
                    if ([cmo.name isEqualToString:hdt[@"hb_type1"]]) {
                        if ([hdt[@"hb_name"] isKindOfClass:[NSString class]]) {
                            cmo.text = [NSString stringWithFormat:@"%@%@%@",hdt[@"hb_name"],hdt[@"hb_other"],hdt[@"hb_other2"]];
                        }
                        
                    }
                }
            }else{
                NSDictionary *temDt = dict;
                if (temDt) {
                    if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                        cmo.text = temDt[cmo.key];
                    }
                }
            }
            
        }
        [mbodyArr addObject:model];
    }
    [self.dataArray addObject:mbodyArr];
    
    [self.tableView reloadData];
}
@end
