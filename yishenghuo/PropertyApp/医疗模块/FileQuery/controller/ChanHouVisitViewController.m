//
//  ChanHouVisitViewController.m
//  PropertyApp
//
//  Created by admin on 2018/8/28.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ChanHouVisitViewController.h"
#import "SPPageMenu.h"
#import "TextFiledLableTableViewCell.h"
@interface ChanHouVisitViewController ()<SPPageMenuDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation ChanHouVisitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = JHbgColor;
    self.navigationBarTitle = @"产后访视记录表";
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
        [_pageMenu setItems:@[@"检查信息",@"建议指导"] selectedItemIndex:0];
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
    NSArray *basicArr = @[@{@"key":@"jiating",
                            @"child":@[@{@"name":@"姓名",@"key":@"hp_name"},
                                       @{@"name":@"编号",@"key":@"hp_no"},
                                       @{@"name":@"随访日期",@"key":@"hg_FollowUpDate"},
                                       @{@"name":@"分娩日期",@"key":@"hg_ChildbirthDate"},
                                       @{@"name":@"出院日期",@"key":@"hg_LeaveHospitalDate"},
                                       @{@"name":@"体温",@"key":@"hg_Temperature"}]
                            },
                          @{@"key":@"jiating",
                            @"child":@[@{@"name":@"一般健康状况",@"key":@"hg_HealthySituation"},
                                       @{@"name":@"一般心理状况",@"key":@"hg_PsychologySituation"}]
                            },
                          @{@"key":@"jiating",
                            @"child":@[@{@"name":@"血压",@"key":@"hg_BloodPressure"},
                                       @{@"name":@"乳房",@"key":@"hg_Breast"},
                                       @{@"name":@"恶露",@"key":@"hg_Lochia"},
                                       @{@"name":@"子宫",@"key":@"hg_uterus"},
                                       @{@"name":@"伤口",@"key":@"hg_Wound"},
                                       @{@"name":@"其他",@"key":@"hg_Other"},
                                       @{@"name":@"分类",@"key":@"hg_Classification"}]
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
    
    
    //建议指导
    NSArray *dirtyArr = @[@{@"section":@"   指导",
                            @"image":@"yibanzhuangk",
                            @"key":@"chati",
                            @"child":@[]
                            },
                          @{@"section":@"   转诊",
                            @"image":@"yibanzhuangk",
                            @"key":@"jiating",
                            @"child":@[@{@"name":@"",@"key":@"hg_Guidance"}]
                            },
                          @{@"key":@"checkitem",
                            @"child":@[@{@"name":@"转诊原因",@"key":@"hc_Referral2"},
                                       @{@"name":@"机构及科室",@"key":@"hc_Referral3"}]
                            },
                          @{@"key":@"chati",
                            @"child":@[@{@"name":@"下次随访日期",@"key":@"hg_NextFollowUpDate"},
                                       @{@"name":@"随访医生",@"key":@"hg_FollowUpDoctor"}]
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
