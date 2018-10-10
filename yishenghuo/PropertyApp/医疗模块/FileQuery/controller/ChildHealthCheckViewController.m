//
//  ChildHealthCheckViewController.m
//  PropertyApp
//
//  Created by admin on 2018/8/25.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ChildHealthCheckViewController.h"
#import "SPPageMenu.h"
#import "TextFiledLableTableViewCell.h"
@interface ChildHealthCheckViewController ()<SPPageMenuDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation ChildHealthCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = JHbgColor;
    self.navigationBarTitle = @"儿童健康检查记录表";
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
        [_pageMenu setItems:@[@"体格检查",@"发育评估",@"建议指导"] selectedItemIndex:0];
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
    if (self.bm_id) {
        [dt setObject:self.bm_id forKey:@"bm_id"];
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
    //体格检查
    NSArray *basicArr = @[
                          @{@"section":@"   体格检查",
                            @"image":@"yibanzhuangk",
                            @"key":@"jiating",
                            @"child":@[@{@"name":@"记录表状态",@"key":@"bv_name"},
                                       @{@"name":@"姓名",@"key":@"bm_name"},
                                       @{@"name":@"编号",@"key":@"hp_no"},
                                       @{@"name":@"月龄",@"key":@"bm_monthOld"},
                                       @{@"name":@"随访日期",@"key":@"bm_flup_date"},
                                       @{@"name":@"体重",@"key":@"bm_weight"},
                                       @{@"name":@"身高",@"key":@"bm_height"},
                                       @{@"name":@"体格发育评价",@"key":@"bm_Physical_development"}]
                            },
                          @{@"key":@"jiating",
                            @"child":@[@{@"name":@"视力",@"key":@"bm_eye"},
                                       @{@"name":@"听力",@"key":@"bm_Listening_ability"},
                                       @{@"name":@"牙数",@"key":@"bm_tooth1"},
                                       @{@"name":@"胸部",@"key":@"bm_Pectoralis"},
                                       @{@"name":@"腹部",@"key":@"bm_Abdomen"},
                                       @{@"name":@"血红蛋白值",@"key":@"bm_hemoglobin"},
                                       @{@"name":@"其他",@"key":@"bm_Physique_other"}]
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
    //发育评估
    NSArray *historyArr = @[@{@"section":@"   发育评估",
                              @"image":@"yibanzhuangk",
                              @"key":@"jiating",
                              @"child":@[]
                              },
                            @{@"section":@"   患病情况",
                              @"image":@"yibanzhuangk",
                              @"key":@"jiating",
                              @"child":@[@{@"name":@"",@"key":@"bm_growth"}]
                              },
                            @{@"key":@"xinshenger",
                              @"child":@[@{@"name":@"肺炎",@"key":@"xinshengerzhixi"},
                                         @{@"name":@"腹泻",@"key":@"jixing"},
                                         @{@"name":@"外伤",@"key":@"bv_unhs"},
                                         @{@"name":@"其他",@"key":@"bv_neonatal_screening"}]
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
    
    //建议指导
    NSArray *dirtyArr = @[@{@"section":@"   转诊建议",
                            @"image":@"yibanzhuangk",
                            @"key":@"jiating",
                            @"child":@[]
                            },
                          @{@"section":@"   指导",
                            @"image":@"yibanzhuangk",
                            @"key":@"jiating",
                            @"child":@[@{@"name":@"转诊原因",@"key":@"bv_temperature"},
                                       @{@"name":@"推荐机构",@"key":@"bv_heart_rate"},
                                       @{@"name":@"推荐科室",@"key":@"bv_breathing_rate"}]
                            },
                          @{@"key":@"chati",
                            @"child":@[@{@"name":@"",@"key":@"checkitem"}]
                            },
                          @{@"key":@"chati",
                            @"child":@[@{@"name":@"下次随访日期",@"key":@"checkitem"},
                                       @{@"name":@"随访医生",@"key":@"checkitem"}]
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
