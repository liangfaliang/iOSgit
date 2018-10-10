//
//  HypertensionViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/8/28.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "HypertensionViewController.h"
#import "SPPageMenu.h"
#import "TextFiledLableTableViewCell.h"
@interface HypertensionViewController ()<SPPageMenuDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation HypertensionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = JHbgColor;
    self.navigationBarTitle = @"高血压患者随访服务记录表";
    [self.view addSubview:self.pageMenu];
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
        [_pageMenu setItems:@[@"症状体征",@"生活指导",@"用药情况",@"建议指导"] selectedItemIndex:0];
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
    if (marr.count - 1 > section) {
        TextSectionModel *model =  marr[section +1];
        return model.section ? 0.001 : 10;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSMutableArray *marr = self.dataArray[self.pageMenu.selectedItemIndex];
    TextSectionModel *model =  marr[section];
    return model.section ? 40 : 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSMutableArray *marr = self.dataArray[self.pageMenu.selectedItemIndex];
    TextSectionModel *model =  marr[section];
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
    //    症状体征
    NSArray *basicArr = @[@{@"key":@"jiating",
                            @"child":@[@{@"name":@"姓名",@"key":@"hp_name"},
                                       @{@"name":@"编号",@"key":@"hp_no"},
                                       @{@"name":@"随访日期",@"key":@"hd_FollowUpDate"},
                                       @{@"name":@"随访方式",@"key":@"hd_FollowUpMode"}]
                            },
                          @{@"section":@"   症状",
                            @"image":@"yibanzhuangk",
                            @"key":@"jiating",
                            @"child":@[@{@"name":@"常见症状",@"key":@"hd_Symptom"},
                                       @{@"name":@"其他症状",@"key":@"hd_Symptom_other"}]
                            },
                          @{@"section":@"   体征",
                            @"image":@"yibanzhuangk",
                            @"key":@"jiating",
                            @"child":@[@{@"name":@"血压",@"key":@"hd_BloodPressure"},
                                       @{@"name":@"体重",@"key":@"hd_Weight1"},
                                       @{@"name":@"体质指数(BIM)",@"key":@"hd_Constitution1"},
                                       @{@"name":@"心率",@"key":@"hh_FetalHeartRate"},
                                       @{@"name":@"其他",@"key":@"hd_Other"}]
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
    
    //生活指导
    NSArray *lifeArr = @[@{@"key":@"jiating",
                           @"child":@[@{@"name":@"日吸烟量",@"key":@"hh_DaySmoke1"},
                                      @{@"name":@"日饮酒量",@"key":@"hd_DayDrink1"},
                                      @{@"name":@"运动",@"key":@"hd_Motion1"},
                                      @{@"name":@"摄盐情况(咸淡)",@"key":@"hh_SaltUptake1"},
                                      @{@"name":@"心理调整",@"key":@"hh_MentalAdjustment"},
                                      @{@"name":@"遵医行为",@"key":@"hd_Compliance"}]
                           },
                         @{@"key":@"jiating",
                           @"child":@[@{@"name":@"辅助检查",@"key":@"hh_Auxiliary"}]
                           }];
    NSMutableArray *mlifeArr = [NSMutableArray array];
    for (NSDictionary *dt in lifeArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        for (TextFiledModel *cmo in model.child) {
            if (!cmo.text) cmo.text = @"";
            cmo.label = @"1";
            NSDictionary *temDt = dict;
            if (temDt) {
                if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                    cmo.text = temDt[cmo.key];
                }
            }
        }
        [mlifeArr addObject:model];
    }
    
    [self.dataArray addObject:mlifeArr];
    
    //用药情况
    NSArray *useArr = @[@{@"key":@"hd_DrugName1",
                          @"child":@[@{@"name":@"服药依从性",@"key":@"hd_DrugCompliance"},
                                     @{@"name":@"药物不良反应",@"key":@"hd_AdverseDrugReaction"},
                                     @{@"name":@"此次随访分类",@"key":@"hh_FollowUpClassification"}]
                          }];
    NSMutableArray *museArr = [NSMutableArray array];
    for (NSDictionary *dt in useArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        for (TextFiledModel *cmo in model.child) {
            if (!cmo.text) cmo.text = @"";
            cmo.label = @"1";
            NSDictionary *temDt = dict;
            if (temDt) {
                if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                    cmo.text = temDt[cmo.key];
                }
            }
        }
        [museArr addObject:model];
    }
    for (int i = 0; i < 5; i ++) {
        NSString *hd_DrugName = [NSString stringWithFormat:@"hh_DrugName%d",i+1];
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:@{@"child":@[@{@"name":@"用法"},@{@"name":@"用量"}]
                                                                             }];
        model.section = dict[hd_DrugName];
        int j = 0;
        BOOL isAdd = NO;
        for (TextFiledModel *cmo in model.child) {
            cmo.label = @"1";
            if ([cmo.name isEqualToString:@"用法"]) cmo.key = [NSString stringWithFormat:@"hd_UsageDosageNum%d",i+1];
            if ([cmo.name isEqualToString:@"用量"]) cmo.key = [NSString stringWithFormat:@"hd_UsageDosageAmount%d",i+1];
            NSDictionary *temDt = dict;
            if (temDt) {
                if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                    cmo.text = temDt[cmo.key];
                    if (cmo.text.length) isAdd = YES;
                }else{
                    break;
                }
            }
            j ++;
        }
        if (isAdd) [museArr addObject:model];
    }
    [self.dataArray addObject:museArr];
    
    
    //建议指导
    NSArray *dirtyArr = @[@{@"section":@"   转诊",
                            @"image":@"yibanzhuangk",
                            @"key":@"checkitem",
                            @"child":@[@{@"name":@"转诊原因",@"key":@"hd_Reason"},
                                       @{@"name":@"机构及科室",@"key":@"hd_Mechanism"}]
                            },
                          @{@"key":@"chati",
                            @"child":@[@{@"name":@"下次随访日期",@"key":@"hd_NextFollowUpDate"},
                                       @{@"name":@"随访医生",@"key":@"hd_FollowUpDoctor"}]
                            }];
    NSMutableArray *mdirtyArr = [NSMutableArray array];
    for (NSDictionary *dt in dirtyArr) {
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
        
        [mdirtyArr addObject:model];
    }
    [self.dataArray addObject:mdirtyArr];
    
    
    [self.tableView reloadData];
}
@end
