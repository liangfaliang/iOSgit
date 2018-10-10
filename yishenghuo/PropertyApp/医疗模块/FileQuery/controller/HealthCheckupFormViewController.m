//
//  HealthCheckupFormViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/7/26.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "HealthCheckupFormViewController.h"
#import "SPPageMenu.h"
#import "TextFiledLableTableViewCell.h"
@interface HealthCheckupFormViewController ()<SPPageMenuDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation HealthCheckupFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = JHbgColor;
    self.navigationBarTitle = @"健康体检表";
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
        _pageMenu.permutationWay = SPPageMenuPermutationWayScrollAdaptContent;
        // 设置代理
        _pageMenu.selectedItemTitleColor = JHAssistColor;
        _pageMenu.unSelectedItemTitleColor = JHmiddleColor;
        _pageMenu.delegate = self;
        [_pageMenu setItems:@[@"症状",@"生活方式",@"脏器功能",@"查体",@"辅助检查",@"健康问题",@"治疗情况",@"用药情况",@"非免疫接种史",@"健康评价",@"健康指导"] selectedItemIndex:0];
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
    if (self.hfid) {
        [dt setObject:self.hfid forKey:@"hfid"];
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
    //症状
    NSArray *basicArr = @[@{@"key":@"zhengzhuang",
                            @"child":@[@{@"name":@"姓名",@"text":@"",@"key":@"hf_name"},
                                       @{@"name":@"编号",@"text":@"",@"key":@"hp_no"},
                                       @{@"name":@"体检日期",@"text":@"",@"key":@"hf_checkDate"},
                                       @{@"name":@"责任医生",@"text":@"",@"key":@"hf_ResponsibleDoctor"}]
                            },
                          @{@"section":@"   一般状况",
                            @"key":@"zhengzhuang",
                            @"image":@"yibanzhuangk",
                            @"child":@[@{@"name":@"症状",@"text":@"",@"key":@"hf_check_Symptom",@"textcolor":@"FF5050"}]
                            },
                          @{@"key":@"zhengzhuang",
                            @"child":@[@{@"name":@"体温",@"text":@"",@"key":@"hf_temperature"},
                                       @{@"name":@"脉率",@"text":@"",@"key":@"hf_pr",@"textcolor":@"FF5050"},
                                       @{@"name":@"呼吸频率",@"text":@"",@"key":@"hf_breathing_rate"},
                                       @{@"name":@"血压",@"text":@"",@"key":@"hf_blood_pressureL"},
                                       @{@"name":@"身高",@"text":@"",@"key":@"hf_height",@"textcolor":@"FF5050"},
                                       @{@"name":@"体重",@"text":@"",@"key":@"hf_weight"},
                                       @{@"name":@"腰围",@"text":@"",@"key":@"hf_waist"},
                                       @{@"name":@"体质指数(BMI)",@"text":@"",@"key":@"hf_bmi"},
                                       @{@"name":@"健康状态",@"text":@"",@"key":@"hf_Health_status",@"label":@"1"},
                                       @{@"name":@"生活自理能力",@"text":@"",@"key":@"hf_selfcare_ability",@"label":@"1"},
                                       @{@"name":@"认知功能",@"text":@"",@"key":@"hf_cognitive_function",@"label":@"1"},
                                       @{@"name":@"情感状态",@"text":@"",@"key":@"hf_older_affective",@"label":@"1"}]
                            }];
    NSMutableArray *mbasicarr = [NSMutableArray array];
    for (NSDictionary *dt in basicArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        for (TextFiledModel *cmo in model.child) {
            NSDictionary *temDt = dict;
            if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
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
        [mbasicarr addObject:model];
    }
    [self.dataArray addObject:mbasicarr];
    //生活方式
    NSArray *historyArr = @[@{@"section":@"   体育锻炼",
                              @"image":@"duanlian",
                              @"key":@"shenghuofangshi",
                              @"child":@[]
                              },
                            @{@"key":@"shenghuofangshi",
                              @"child":@[@{@"name":@"锻炼频率",@"text":@"",@"key":@"hf_check_anneal",@"label":@"1"},
                                         @{@"name":@"每次锻炼时间",@"text":@"",@"key":@"hf_Exercise_time",@"label":@"1"},
                                         @{@"name":@"坚持锻炼时间",@"text":@"",@"key":@"hf_Stick_Exercise_time",@"label":@"1"},
                                         @{@"name":@"锻炼方式",@"text":@"",@"key":@"hf_Exercise_way",@"label":@"1"}]
                              },
                            @{@"section":@"   吸烟情况",
                              @"image":@"xiyan",
                              @"key":@"shenghuofangshi",
                              @"child":@[@{@"name":@"饮食习惯",@"text":@"",@"key":@"hf_check_eating_habits",@"label":@"1"}]
                              },
                            @{@"section":@"   饮酒情况",
                              @"image":@"yinjiu",
                              @"key":@"shenghuofangshi",
                              @"child":@[@{@"name":@"吸烟状况",@"text":@"",@"key":@"hf_check_Smoking_status",@"label":@"1"},
                                         @{@"name":@"日吸烟量",@"text":@"",@"key":@"hf_day_smoking",@"label":@"1"},
                                         @{@"name":@"开始吸烟年龄",@"text":@"",@"key":@"hf_begin_smoking",@"label":@"1"},
                                         @{@"name":@"戒烟年龄",@"text":@"",@"key":@"hf_end_smoking",@"label":@"1"}]
                              },
                            @{@"section":@"   职业病危害因素接触史",
                              @"image":@"zhiyebing",
                              @"key":@"shenghuofangshi",
                              @"child":@[@{@"name":@"饮酒频率",@"text":@"",@"key":@"hf_check_Drinking",@"label":@"1"},
                                         @{@"name":@"日饮酒量",@"text":@"",@"key":@"hf_day_Drinking",@"label":@"1"},
                                         @{@"name":@"是否戒酒",@"text":@"",@"key":@"hf_check_Istemperance",@"label":@"1"},
                                         @{@"name":@"开始饮酒年龄",@"text":@"",@"key":@"hf_begin_Drinking",@"label":@"1"},
                                         @{@"name":@"近一年内是否曾醉酒",@"text":@"",@"key":@"hf_isDrunkenness",@"label":@"1"},
                                         @{@"name":@"饮酒种类",@"text":@"",@"key":@"hf_check_DrinkingType",@"label":@"1"}]
                              },
                            @{@"key":@"shenghuofangshi",
                              @"child":@[@{@"name":@"工种",@"text":@"",@"key":@"hf_workType",@"label":@"1"},
                                         @{@"name":@"工龄",@"text":@"",@"key":@"hf_Employment_time",@"label":@"1"},
                                         @{@"name":@"毒物种类",@"text":@"",@"key":@"duwuzhonglei",@"label":@"1"},
                                         @{@"name":@"防护措施",@"text":@"",@"key":@"fanghucuoshi",@"label":@"1"}]
                              }];
    NSMutableArray *mhistoryArr = [NSMutableArray array];
    for (NSDictionary *dt in historyArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        for (TextFiledModel *cmo in model.child) {
            NSDictionary *temDt = dict;
            if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                    cmo.text = temDt[cmo.key];
                }
            }
        }
        [mhistoryArr addObject:model];
    }
    [self.dataArray addObject:mhistoryArr];
    
    //脏器功能
    NSArray *dirtyArr = @[@{@"section":@"   口腔",
                              @"image":@"kouqiang",
                              @"key":@"ganzhang",
                              @"child":@[]
                              },
                            @{@"section":@"   视力",
                              @"image":@"shili",
                              @"key":@"ganzhang",
                              @"child":@[@{@"name":@"口唇",@"text":@"",@"key":@"hf_check_Lips",@"label":@"1"},
                                         @{@"name":@"齿列",@"text":@"",@"key":@"hf_check_Dentition",@"label":@"1",@"textcolor":@"FF5050"},
                                         @{@"name":@"咽部",@"text":@"",@"key":@"hf_check_Pharynx",@"label":@"1"}]
                              },
                          @{@"key":@"ganzhang",
                            @"child":@[@{@"name":@"左眼",@"text":@"",@"key":@"hf_left_eye",@"label":@"1"},
                                         @{@"name":@"右眼",@"text":@"",@"key":@"hf_right_eye",@"label":@"1",@"textcolor":@"FF5050"},
                                       @{@"name":@"左眼矫正视力",@"text":@"",@"key":@"hf_left_eye_correct",@"label":@"1"},
                                       @{@"name":@"右眼矫正视力",@"text":@"",@"key":@"hf_right_eye_correct",@"label":@"1"}]
                              },
                          @{@"key":@"ganzhang",
                            @"child":@[@{@"name":@"听力",@"text":@"",@"key":@"hf_check_Listen",@"label":@"1"},
                                       @{@"name":@"运动功能",@"text":@"",@"key":@"hf_check_motor_function",@"label":@"1",@"textcolor":@"FF5050"}]
                            }];
    NSMutableArray *mdirtyArr = [NSMutableArray array];
    for (NSDictionary *dt in dirtyArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        for (TextFiledModel *cmo in model.child) {
            NSDictionary *temDt = dict;
            if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                    cmo.text = temDt[cmo.key];
                }
            }
        }
        [mdirtyArr addObject:model];
    }
    [self.dataArray addObject:mdirtyArr];
    
    //查体
    NSArray *bodyArr = @[@{@"section":@"   肺",
                           @"image":@"fei",
                           @"key":@"查体",
                              @"child":@[@{@"name":@"眼底",@"text":@"",@"key":@"yandi",@"label":@"1"},
                                         @{@"name":@"皮肤",@"text":@"",@"key":@"pifu",@"label":@"1"},
                                         @{@"name":@"巩膜",@"text":@"",@"key":@"gongmo",@"label":@"1",@"textcolor":@"FF5050"},
                                         @{@"name":@"淋巴结",@"text":@"",@"key":@"linbajie",@"label":@"1"}]
                              },
                        @{@"section":@"   心脏",
                              @"image":@"xin",
                              @"key":@"肺",
                              @"child":@[@{@"name":@"桶状胸",@"text":@"",@"key":@"tongzhuangxiong",@"label":@"1"},
                                         @{@"name":@"呼吸音",@"text":@"",@"key":@"huxiyin",@"label":@"1"},
                                         @{@"name":@"啰音",@"text":@"",@"key":@"luoyin",@"label":@"1"}]
                              },
                         @{@"section":@"   腹部",
                              @"image":@"fubu",
                              @"key":@"心脏",
                              @"child":@[@{@"name":@"心率",@"text":@"",@"key":@"xinlv1",@"label":@"1"},
                                         @{@"name":@"心律",@"text":@"",@"key":@"xinlv2",@"label":@"1"},
                                         @{@"name":@"杂音",@"text":@"",@"key":@"zayin",@"label":@"1"}]
                              },

                         @{@"key":@"腹部",
                           @"child":@[@{@"name":@"压痛",@"text":@"",@"key":@"yatong",@"label":@"1"},
                                      @{@"name":@"包块",@"text":@"",@"key":@"baokuai",@"label":@"1"},
                                      @{@"name":@"肝大",@"text":@"",@"key":@"ganda",@"label":@"1"},
                                      @{@"name":@"脾大",@"text":@"",@"key":@"pida",@"label":@"1"},
                                      @{@"name":@"移动性浊音",@"text":@"",@"key":@"yidongxingzhuoying",@"label":@"1"}]
                           },

                         @{@"section":@"   妇科",
                           @"image":@"fuke",
                           @"key":@"腹部",
                              @"child":@[@{@"name":@"下肢水肿",@"text":@"",@"key":@"xiazhishuizhong",@"label":@"1",@"textcolor":@"FF5050"},
                                         @{@"name":@"足背动脉搏动",@"text":@"",@"key":@"zubeidongmaibodong",@"label":@"1"},
                                         @{@"name":@"肛门指诊",@"text":@"",@"key":@"gangmenzhizhen",@"label":@"1"},
                                         @{@"name":@"乳腺",@"text":@"",@"key":@"ruxian",@"label":@"1"}]
                           },
                         @{@"key":@"妇科",
                           @"child":@[@{@"name":@"外阴",@"text":@"",@"key":@"fukewaiyin",@"label":@"1"},
                                      @{@"name":@"阴道",@"text":@"",@"key":@"fukeyindao",@"label":@"1"},
                                      @{@"name":@"宫颈",@"text":@"",@"key":@"fukegongjing",@"label":@"1"},
                                      @{@"name":@"宫体",@"text":@"",@"key":@"fukegongti",@"label":@"1"},
                                      @{@"name":@"附件",@"text":@"",@"key":@"fukefujian",@"label":@"1",@"textcolor":@"FF5050"}]
                           },

                         @{@"key":@"妇科",
                           @"child":@[@{@"name":@"其他",@"text":@"",@"key":@"chatiqita",@"label":@"1"}]
                           }];
    
    
    NSMutableArray *mbodyArr = [NSMutableArray array];
    for (NSDictionary *dt in bodyArr) {
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
            for (NSDictionary *hdt in dict[@"checkitem"]) {
                if ([model.key isEqualToString:hdt[@"hc_type1"]]) {
                    for (TextFiledModel *cmo in model.child) {
                        if ([cmo.name isEqualToString:hdt[@"hc_type2"]]) {
                            if ([hdt[@"hc_name"] isKindOfClass:[NSString class]]) {
                                cmo.text = [NSString stringWithFormat:@"%@%@%@%@%@",hdt[@"hc_name"],hdt[@"hc_other"],hdt[@"hc_other2"],hdt[@"hc_other3"],hdt[@"hc_other4"]];
                            }
                            
                        }
                    }
                }
            }
        }
        [mbodyArr addObject:model];
    }
    [self.dataArray addObject:mbodyArr];

    //辅助检查
    NSArray *assistArr = @[@{@"section":@"   血常规",
                             @"image":@"xue",
                             @"key":@"dict",
                             @"child":@[]
                             },
                           @{@"section":@"   尿常规",
                             @"image":@"niaochangui",
                             @"key":@"dict",
                             @"child":@[@{@"name":@"血红蛋白",@"text":@"",@"key":@"hf_hemoglobin",@"label":@"1",@"textcolor":@"FF5050"},
                                        @{@"name":@"白细胞",@"text":@"",@"key":@"hf_leukocyte",@"label":@"1"},
                                        @{@"name":@"血小板",@"text":@"",@"key":@"hf_Platelet",@"label":@"1"},
                                        @{@"name":@"其他",@"text":@"",@"key":@"hf_routineBlood_other",@"label":@"1"}]
                             },

                         @{@"key":@"dict",
                           @"child":@[@{@"name":@"尿蛋白",@"text":@"",@"key":@"hf_Urine_protein",@"label":@"1",@"textcolor":@"FF5050"},
                                      @{@"name":@"尿糖",@"text":@"",@"key":@"hf_Urine_sugar",@"label":@"1",@"textcolor":@"FF5050"},
                                      @{@"name":@"尿酮体",@"text":@"",@"key":@"hf_Urine_ketone_body",@"label":@"1"},
                                      @{@"name":@"尿潜血",@"text":@"",@"key":@"hf_bld",@"label":@"1"},
                                      @{@"name":@"其他",@"text":@"",@"key":@"hf_Urine_routine_other",@"label":@"1"}]
                           },
                           @{@"section":@"   肝功能",
                             @"image":@"ganggongneng",
                             @"key":@"dict",
                           @"child":@[@{@"name":@"空腹血糖",@"text":@"",@"key":@"kongfuxuetang1",@"label":@"1"},
                                      @{@"name":@"心电图",@"text":@"",@"key":@"kongfuxuetang1",@"label":@"1"},
                                      @{@"name":@"尿微量白蛋白",@"text":@"",@"key":@"hf_AIB",@"label":@"1"},
                                      @{@"name":@"大便潜血",@"text":@"",@"key":@"hf_check_FOB",@"label":@"1"},
                                      @{@"name":@"糖化血红蛋白",@"text":@"",@"key":@"tanghuaxuehongdanbai",@"label":@"1"},
                                      @{@"name":@"乙型肝炎表面抗原",@"text":@"",@"key":@"hf_HBsAg",@"label":@"1"}
                                      ]
                           },
                           @{@"section":@"   肾功能",
                             @"image":@"sengongneng",
                             @"key":@"dict",
                           @"child":@[@{@"name":@"血清谷丙转氨酶",@"text":@"",@"key":@"hf_SGPT",@"label":@"1",@"textcolor":@"FF5050"},
                                      @{@"name":@"血清谷草转氨酶",@"text":@"",@"key":@"hf_SGOT",@"label":@"1",@"textcolor":@"FF5050"},
                                      @{@"name":@"白蛋白",@"text":@"",@"key":@"hf_ricim",@"label":@"1"},
                                      @{@"name":@"总胆红素",@"text":@"",@"key":@"hf_total_bilirubin",@"label":@"1"},
                                      @{@"name":@"结合胆红素",@"text":@"",@"key":@"hf_Conjugated_bilirubin",@"label":@"1"}]
                           },
                           @{@"section":@"   血脂",
                             @"image":@"xuezhi",
                             @"key":@"dict",
                             @"child":@[@{@"name":@"血清肌酐",@"text":@"",@"key":@"hf_scR",@"label":@"1",@"textcolor":@"FF5050"},
                                        @{@"name":@"血尿素",@"text":@"",@"key":@"hf_blood_urea",@"label":@"1",@"textcolor":@"FF5050"},
                                        @{@"name":@"血钾浓度",@"text":@"",@"key":@"hf_potassium_concentration",@"label":@"1"},
                                        @{@"name":@"血钠浓度",@"text":@"",@"key":@"hf_sodium_concentration",@"label":@"1"}]
                             },

                         @{@"key":@"dict",
                           @"child":@[@{@"name":@"总胆固醇",@"text":@"",@"key":@"hf_CT",@"label":@"1",@"textcolor":@"FF5050"},
                                      @{@"name":@"甘油三酯",@"text":@"",@"key":@"hf_triglyceride",@"label":@"1",@"textcolor":@"FF5050"},
                                      @{@"name":@"血清低密度脂蛋白胆固醇",@"text":@"",@"key":@"hf_Serum_low",@"label":@"1"},
                                      @{@"name":@"血清高密度脂蛋白胆固醇",@"text":@"",@"key":@"hf_Serum_high",@"label":@"1"}]
                           },
                           @{@"section":@"   B超",
                             @"image":@"bchao",
                             @"key":@"辅助检查",
                             @"child":@[@{@"name":@"胸部X线片",@"text":@"",@"key":@"xiongbuxxianpian",@"label":@"1"}]
                             },
                         @{@"key":@"B超",
                           @"child":@[@{@"name":@"腹部B超",@"text":@"",@"key":@"xiongbubchao",@"label":@"1"},
                                      @{@"name":@"其他",@"text":@"",@"key":@"bchaoqita",@"label":@"1"}]
                           },

                         @{@"key":@"辅助检查",
                           @"child":@[@{@"name":@"宫颈涂片",@"text":@"",@"key":@"gongjingtupian",@"label":@"1"},
                                      @{@"name":@"其他",@"text":@"",@"key":@"fuzhujianchaqita",@"label":@"1"}]
                           }];
    NSMutableArray *massistArr = [NSMutableArray array];
    for (NSDictionary *dt in assistArr) {
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
            for (NSDictionary *hdt in dict[@"checkitem"]) {
                if ([model.key isEqualToString:hdt[@"hc_type1"]]) {
                    for (TextFiledModel *cmo in model.child) {
                        if ([cmo.name isEqualToString:hdt[@"hc_type2"]]) {
                            if ([hdt[@"hc_name"] isKindOfClass:[NSString class]]) {
                                cmo.text = [NSString stringWithFormat:@"%@%@%@%@%@",hdt[@"hc_name"],hdt[@"hc_other"],hdt[@"hc_other2"],hdt[@"hc_other3"],hdt[@"hc_other4"]];
                            }
                            
                        }
                    }
                }
            }
        }
        [massistArr addObject:model];
    }
    [self.dataArray addObject:massistArr];
#warning 未处理
    //健康问题
    NSArray *healthArr = @[@{@"key":@"jiankangwenti",
                             @"child":@[@{@"name":@"脑血管疾病",@"text":@"",@"key":@"naoxueguanjibing",@"label":@"1",@"textcolor":@"FF5050"},
                                        @{@"name":@"肾脏疾病",@"text":@"",@"key":@"shenzangjibing",@"label":@"1"},
                                        @{@"name":@"心脏疾病",@"text":@"",@"key":@"xinzangjibing",@"label":@"1"},
                                        @{@"name":@"血管疾病",@"text":@"",@"key":@"xueguanjibing",@"label":@"1"},
                                        @{@"name":@"眼部疾病",@"text":@"",@"key":@"yanbujibing",@"label":@"1"},
                                        @{@"name":@"神经系统疾病",@"text":@"",@"key":@"shenjingxitongjibing",@"label":@"1"},
                                        @{@"name":@"其他系统疾病",@"text":@"",@"key":@"qitaxitongjibing",@"label":@"1"}]
                             }];
    NSMutableArray *mhealthArr = [NSMutableArray array];
    for (NSDictionary *dt in healthArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        for (TextFiledModel *cmo in model.child) {
            NSDictionary *temDt = dict[model.key];
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
        [mhealthArr addObject:model];
    }
    [self.dataArray addObject:mhealthArr];
    
    
    //治疗情况
    NSArray *cureArr = @[@{@"section":@"   住院史",
                  @"image":@"zhuyuanshi",
                  @"key":@"dict",
                  @"child":@[]
                             },
                @{@"key":@"住院史",
                  @"child":@[@{@"name":@"入院日期",@"text":@"",@"key":@"hz_InDate",@"label":@"1"},
                             @{@"name":@"出院日期",@"text":@"",@"key":@"hz_OutDate",@"label":@"1"},
                             @{@"name":@"原因",@"text":@"",@"key":@"hz_reason",@"label":@"1"},
                             @{@"name":@"医疗机构名称",@"text":@"",@"key":@"hz_medical_name",@"label":@"1"},
                             @{@"name":@"病案号",@"text":@"",@"key":@"hz_medical_number",@"label":@"1"}]
                  },
                 @{@"section":@"   家庭病床史",
                   @"image":@"jiazhubingcs",
                   @"key":@"dict",
                   @"child":@[]
                   },
                @{@"key":@"家庭病床史",
                  @"child":@[@{@"name":@"建床日期",@"text":@"",@"key":@"hz_InDate",@"label":@"1"},
                             @{@"name":@"撤床日期",@"text":@"",@"key":@"hz_OutDate",@"label":@"1"},
                             @{@"name":@"原因",@"text":@"",@"key":@"hz_reason",@"label":@"1"},
                             @{@"name":@"医疗机构名称",@"text":@"",@"key":@"hz_medical_name",@"label":@"1"},
                             @{@"name":@"病案号",@"text":@"",@"key":@"hz_medical_number",@"label":@"1"}]
                  }];
    NSMutableArray *mcureArr = [NSMutableArray array];
    for (NSDictionary *dt in cureArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        if ([model.key isEqualToString:@"dict"]) {
            [mcureArr addObject:model];
        }else{
            for (NSDictionary *hdt in dict[@"hospitalization"]) {
                if ([model.key isEqualToString:hdt[@"hz_type"]]) {
                    TextSectionModel *mo = [TextSectionModel mj_objectWithKeyValues:dt];
                    for (TextFiledModel *cmo in mo.child) {
                        if ([hdt[cmo.key] isKindOfClass:[NSString class]]) {
                            cmo.text = hdt[cmo.key];
                        }
                    }
                    [mcureArr addObject:mo];
                }
            }
        }

    }
    [self.dataArray addObject:mcureArr];
    
    //用药情况
    NSArray * medicateArr = @[@{@"section":@"   药物名称1",
                  @"image":@"yaopin",
                  @"key":@"yongyaoqingkuang",
                  @"child":@[]
                  },
                @{@"image":@"yaopin",
                  @"key":@"shenghuofangshi",
                  @"child":@[@{@"name":@"用法",@"text":@"",@"key":@"hd_method",@"label":@"1"},
                             @{@"name":@"用量",@"text":@"",@"key":@"hd_Amount",@"label":@"1"},
                             @{@"name":@"用药时间",@"text":@"",@"key":@"hd_useDate",@"label":@"1"},
                             @{@"name":@"服药依从性",@"text":@"",@"key":@"hd_compliance",@"label":@"1"}]
                  }];
    NSMutableArray *mmedicateArr = [NSMutableArray array];
    NSArray *temArr = dict[@"Drug"];
    if (temArr.count) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:medicateArr[0]];
        model.section = [NSString stringWithFormat:@"   %@",temArr[0][@"hd_name"]];
        [mmedicateArr addObject:model];
    }
    for (int i = 0; i < temArr.count; i ++) {
        NSDictionary *temDt = temArr[i];
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:medicateArr[1]];

        for (TextFiledModel *cmo in model.child) {
            if (temDt) {
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
        if (i < temArr.count - 1) {
            model.section = [NSString stringWithFormat:@"   %@",temArr[i + 1][@"hd_name"]];
        }
        [mmedicateArr addObject:model];
    }

    [self.dataArray addObject:mmedicateArr];
    
    //非免疫接种史情况
    NSArray * nonimmuneArr = @[@{@"image":@"bingshi",
                                @"key":@"shenghuofangshi",
                                @"child":@[]
                                },
                              @{@"image":@"jiezhongzhengtou",
                                @"key":@"shenghuofangshi",
                                @"child":@[@{@"name":@"接种日期",@"text":@"",@"key":@"hn_Date",@"label":@"1"},
                                           @{@"name":@"接种机构",@"text":@"",@"key":@"hn_Inoculant",@"label":@"1"}]
                                }];

    NSMutableArray *mnonimmuneArr = [NSMutableArray array];
    NSArray *temnonimmuneArr = dict[@"immunizatio"];
    if (temnonimmuneArr.count) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:nonimmuneArr[0]];
        model.section = [NSString stringWithFormat:@"   %@",temnonimmuneArr[0][@"hn_name"]];
        [mnonimmuneArr addObject:model];
    }
    for (int i = 0; i < temnonimmuneArr.count; i ++) {
        NSDictionary *temDt = temnonimmuneArr[i];
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:nonimmuneArr[1]];
        for (TextFiledModel *cmo in model.child) {
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
        if (i < temnonimmuneArr.count - 1) {
            model.section = [NSString stringWithFormat:@"   %@",temnonimmuneArr[i + 1][@"hn_name"]];
        }
        [mnonimmuneArr addObject:model];
    }

    [self.dataArray addObject:mnonimmuneArr];
    
    //健康评价
    NSArray * abnormalArr = @[@{@"section":@"   有异常",
                                 @"image":@"yichang",
                                 @"key":@"shenghuofangshi",
                                 @"child":@[]
                                 },
                              @{@"key":@"shenghuofangshi",
                                 @"child":@[@{@"name":@"异常1",@"text":@"",@"key":@"jiwangshijibing",@"label":@"1"}]
                                 }];
    NSMutableArray *mabnormalArr = [NSMutableArray array];
    NSArray *temabnormalArr = dict[@"jiankangpingjia"];
    if (temabnormalArr.count) {
        TextSectionModel *model0 = [TextSectionModel mj_objectWithKeyValues:abnormalArr[0]];
        [mabnormalArr addObject:model0];
        
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:abnormalArr[1]];
        NSMutableArray *childArr = [NSMutableArray array];
        for (int i = 0; i < temabnormalArr.count; i ++) {
            NSString *temStr = temabnormalArr[i];
            TextFiledModel *cmo = [TextFiledModel mj_objectWithKeyValues:model.child[0]];
            cmo.name = [NSString stringWithFormat:@"异常%d",i + 1];
            cmo.text = temStr;
            [childArr addObject:cmo];
        }
        model.child = childArr;
        [mabnormalArr addObject:model];
    }
    [self.dataArray addObject:mabnormalArr];
    //健康指导
    NSArray * guideArr = @[@{@"section":@"   建议",
                                @"image":@"zhidao",
                                @"key":@"shenghuofangshi",
                                @"child":@[]
                                },
                              @{@"section":@"   危险因素控制",
                                @"image":@"yichang",
                                @"key":@"shenghuofangshi",
                                @"child":@[@{@"name":@" ",@"text":@"",@"key":@"jiwangshijibing",@"label":@"1"},//
                                           @{@"name":@" ",@"text":@"",@"key":@"jiwangshijibingshijian",@"label":@"1"},//
                                           @{@"name":@" ",@"text":@"",@"key":@"jiwangshijibing",@"label":@"1"}//
                                           ]
                                },
                              @{@"key":@"shenghuofangshi",
                                @"child":@[@{@"name":@" ",@"text":@"",@"key":@"jiwangshijibing",@"label":@"1"},
                                           @{@"name":@" ",@"text":@"",@"key":@"jiwangshijibingshijian",@"label":@"1"},
                                           @{@"name":@" ",@"text":@"",@"key":@"jiwangshijibing",@"label":@"1"},
                                           @{@"name":@" ",@"text":@"",@"key":@"jiwangshijibingshijian",@"label":@"1"}]
                                }];
    NSMutableArray *mguideArr = [NSMutableArray array];
    for (NSDictionary *dt in guideArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        for (TextFiledModel *cmo in model.child) {
            NSDictionary *temDt = dict[model.key];
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
        [mguideArr addObject:model];
    }
    [self.dataArray addObject:mguideArr];

    
    [self.tableView reloadData];
}
@end
