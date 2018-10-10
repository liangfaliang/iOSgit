//
//  ChanQianRecordViewController.m
//  PropertyApp
//
//  Created by admin on 2018/8/25.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ChanQianRecordViewController.h"
#import "SPPageMenu.h"
#import "TextFiledLableTableViewCell.h"
@interface ChanQianRecordViewController ()<SPPageMenuDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation ChanQianRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = JHbgColor;
    self.navigationBarTitle = @"产前检查服务记录表";
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
        [_pageMenu setItems:@[@"基本信息",@"辅助检查",@"建议指导"] selectedItemIndex:0];
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
    //基本信息
    NSArray *basicArr = @[@{@"section":@"   丈夫",
                            @"image":@"yibanzhuangk",
                            @"key":@"jiating",
                            @"child":@[@{@"name":@"姓名",@"key":@"hgf_name"},
                                       @{@"name":@"编号",@"key":@"hp_no"},
                                       @{@"name":@"填表日期",@"key":@"hgf_date"},
                                       @{@"name":@"孕周",@"key":@"hgf_gestational_weeks"},
                                       @{@"name":@"孕妇年龄",@"key":@"hgf_age"}]
                            },
                          @{@"section":@"   孕史",
                            @"image":@"yibanzhuangk",
                            @"key":@"jiating",
                            @"child":@[@{@"name":@"姓名",@"key":@"hgf_Husband_name"},
                                       @{@"name":@"年龄",@"key":@"hgf_Husband_age"},
                                       @{@"name":@"电话",@"key":@"hgf_Husband_tel"}]
                            },
                          @{@"section":@"   病史",
                            @"image":@"yibanzhuangk",
                            @"key":@"jiating",
                            @"child":@[@{@"name":@"孕次",@"key":@"hgf_gravidity"},
                                       @{@"name":@"阴道分娩",@"key":@"hgf_normal_childbirth_times"},
                                       @{@"name":@"剖宫产",@"key":@"hgf_Cesarean_section_times"},
                                       @{@"name":@"末次月经",@"key":@"hgf_LMP"},
                                       @{@"name":@"预产期",@"key":@"hgf_expected_date"}]
                            },
                          @{@"key":@"jiating",
                            @"child":@[@{@"name":@"既往史",@"key":@"checkitem"},
                                       @{@"name":@"家族史",@"key":@"checkitem"},
                                       @{@"name":@"个人史",@"key":@"checkitem"},
                                       @{@"name":@"妇产科手术史",@"key":@"checkitem"},
                                       @{@"name":@"孕产史",@"key":@"checkitem"}]
                            },
                          @{@"section":@"   听诊",
                            @"image":@"yibanzhuangk",
                            @"key":@"jiating",
                            @"child":@[@{@"name":@"身高",@"key":@"hgf_height"},
                                       @{@"name":@"体重",@"key":@"hgf_weight"},
                                       @{@"name":@"体质指数(BMI)",@"key":@"hgf_BMI"},
                                       @{@"name":@"血压1",@"key":@"hgf_blood_pressureS"},
                                       @{@"name":@"血压2",@"key":@"hgf_blood_pressureM"}]
                            },
                          @{@"section":@"   妇科检查",
                            @"image":@"yibanzhuangk",
                            @"key":@"jiating",
                            @"child":@[@{@"name":@"心脏",@"key":@"checkitem"},
                                       @{@"name":@"肺部",@"key":@"checkitem"}]
                            },
                          @{@"key":@"jiating",
                            @"child":@[@{@"name":@"外阴",@"key":@"checkitem"},
                                       @{@"name":@"阴道",@"key":@"checkitem"},
                                       @{@"name":@"宫颈",@"key":@"checkitem"},
                                       @{@"name":@"子宫",@"key":@"checkitem"},
                                       @{@"name":@"孕妇年龄",@"key":@"checkitem"},
                                       @{@"name":@"附件",@"key":@"checkitem"}]
                            }];
    NSMutableArray *mbasicarr = [NSMutableArray array];
    for (NSDictionary *dt in basicArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        for (TextFiledModel *cmo in model.child) {
            if (!cmo.text) cmo.text = @"";
            cmo.label = @"1";
            if ([cmo.key isEqualToString:@"checkitem"]) {
                for (NSDictionary *hdt in dict[@"checkitem"]) {
                    if ([cmo.name isEqualToString:hdt[@"hb_type1"]]) {
                        if ([hdt[@"hb_name"] isKindOfClass:[NSString class]]) {
                            cmo.text = [NSString stringWithFormat:@"%@%@%@%@%@%@",hdt[@"hg_name"],hdt[@"hb_other"],hdt[@"hg_other3"],hdt[@"hg_other4"],hdt[@"hb_other5"],hdt[@"hb_other6"]];
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
        [mbasicarr addObject:model];
    }
    [self.dataArray addObject:mbasicarr];
    //辅助检查
    NSArray *historyArr = @[@{@"section":@"   血常规",
                              @"image":@"yibanzhuangk",
                              @"key":@"jiating",
                              @"child":@[]
                              },
                            @{@"section":@"   尿常规",
                              @"image":@"yibanzhuangk",
                              @"key":@"jiating",
                              @"child":@[@{@"name":@"血红蛋白值",@"key":@"hgf_Hemoglobin"},
                                         @{@"name":@"白细胞计数值",@"key":@"hgf_leucocyte_count"},
                                         @{@"name":@"血小板计数值",@"key":@"hgf_Platelet_count"},
                                         @{@"name":@"其他",@"key":@"hgf_Routine_blood_Other"}]
                              },
                            @{@"key":@"xinshenger",
                              @"child":@[@{@"name":@"尿蛋白",@"key":@"hgf_Urine_protein"},
                                         @{@"name":@"尿糖",@"key":@"hgf_Urine_sugar"},
                                         @{@"name":@"尿酮体",@"key":@"hgf_Urine_ketone_body"},
                                         @{@"name":@"尿潜血",@"key":@"hgf_bld"},
                                         @{@"name":@"其他",@"key":@"hgf_Urine_routine_other"}]
                              },
                            @{@"section":@"   肝功能",
                              @"image":@"yibanzhuangk",
                              @"key":@"jiating",
                              @"child":@[@{@"name":@"ABO",@"key":@"hgf_abo"},
                                         @{@"name":@"RH",@"key":@"hgf_RH"},
                                         @{@"name":@"血糖",@"key":@"hgf_blood_sugar"}]
                              },
                            @{@"section":@"   肾功能",
                              @"image":@"yibanzhuangk",
                              @"key":@"xinshenger",
                              @"child":@[@{@"name":@"血清谷丙转氨酶",@"key":@"hgf_SGPT"},
                                         @{@"name":@"血清谷草转氨酶",@"key":@"hgf_SGOT"},
                                         @{@"name":@"白蛋白",@"key":@"hgf_ricim"},
                                         @{@"name":@"总胆红素",@"key":@"hgf_total_bilirubin"},
                                         @{@"name":@"结合胆红素",@"key":@"hgf_Conjugated_bilirubin"}]
                              },
                            @{@"section":@"   阴道分泌物",
                              @"image":@"yibanzhuangk",
                              @"key":@"xinshenger",
                              @"child":@[@{@"name":@"血清肌酐",@"key":@"hgf_scR"},
                                         @{@"name":@"血尿素",@"key":@"hgf_blood_urea"}]
                              },
                            @{@"section":@"   乙型肝炎",
                              @"image":@"yibanzhuangk",
                              @"key":@"xinshenger",
                              @"child":@[@{@"name":@"分泌物",@"key":@""},
                                         @{@"name":@"清洁度",@"key":@"hgf_Vaginal_cleanliness"}]
                              },
                            @{@"key":@"xinshenger",
                              @"child":@[@{@"name":@"乙型肝炎表面抗原",@"key":@""},
                                         @{@"name":@"乙型肝炎表面抗体",@"key":@""},
                                         @{@"name":@"乙型肝炎e抗原",@"key":@""},
                                         @{@"name":@"乙型肝炎e抗体",@"key":@""},
                                         @{@"name":@"乙型肝炎核心抗体",@"key":@""}]
                              },
                            @{@"key":@"xinshenger",
                              @"child":@[@{@"name":@"梅毒血清学试验",@"key":@"hgf_Cantanitest"},
                                         @{@"name":@"HIV抗体检测",@"key":@"hgf_hiv"},
                                         @{@"name":@"B超",@"key":@"hgf_B_mode"},
                                         @{@"name":@"其他",@"key":@"hgf_fz_Scheck_other"}]
                              }
                            ];
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
    
    //建议指导
    NSArray *dirtyArr = @[@{@"section":@"   保健指导",
                            @"image":@"yibanzhuangk",
                            @"key":@"chati",
                            @"child":@[@{@"name":@"总体评估",@"key":@"checkitem"}]
                            },
                          @{@"section":@"   转诊",
                            @"image":@"yibanzhuangk",
                            @"key":@"jiating",
                            @"child":@[@{@"name":@"",@"key":@"checkitem"}]
                            },
                          @{@"key":@"checkitem",
                            @"child":@[@{@"name":@"转诊原因",@"key":@"bv_temperature"},
                                       @{@"name":@"推荐机构",@"key":@"bv_heart_rate"},
                                       @{@"name":@"推荐科室",@"key":@"bv_breathing_rate"}]
                            },
                          @{@"key":@"chati",
                            @"child":@[@{@"name":@"下次随访日期",@"key":@"hgf_follow_up_Date"},
                                       @{@"name":@"随访医生",@"key":@"hgf_doctor"}]
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
    
    
    [self.tableView reloadData];
}
@end
