//
//  HealthFileInfoViewController.m
//  PropertyApp
//
//  Created by admin on 2018/7/26.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "HealthFileInfoViewController.h"
#import "SPPageMenu.h"
#import "TextFiledLableTableViewCell.h"
@interface HealthFileInfoViewController ()<SPPageMenuDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation HealthFileInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = JHbgColor;
    self.navigationBarTitle = @"健康档案信息卡";
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
        [_pageMenu setItems:@[@"健康信息",@"联系方式"] selectedItemIndex:0];
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
    NSArray *basicArr = @[@{@"key":@"healthy",
                            @"child":@[
                                       @{@"name":@"姓名",@"text":@"",@"key":@"hp_name"},
                                       @{@"name":@"性别",@"text":@"",@"key":@"hp_sex"},
                                       @{@"name":@"出生日期",@"text":@"",@"key":@"hp_birthday"},
                                       @{@"name":@"健康档案编号",@"text":self.archive_no ? self.archive_no : @"",@"key":@"hp_no"},]
                            },
                          @{@"key":@"healthy",
                            @"child":@[@{@"name":@"ABO血型",@"text":@"",@"key":@"hp_bloodTypeABO"},
                                       @{@"name":@"RH血型",@"text":@"",@"key":@"hp_bloodTypeRH"},
                                       @{@"name":@"慢性病患病情况",@"text":@"",@"key":@"hp_disease",@"textcolor":@"FF5050",@"label":@"1"},
                                       @{@"name":@"过敏史",@"text":@"",@"key":@"hp_drugAllergy",@"textcolor":@"FF5050",@"label":@"1"}]
                            }];
    
    //病史
    NSArray *historyArr = @[@{@"key":@"contact",
                              @"child":@[@{@"name":@"家庭住址",@"text":@"",@"key":@"hp_addr"},
                                         @{@"name":@"家庭电话",@"text":@"",@"key":@"hp_telp"}]
                              },
                            @{@"key":@"contact",
                              @"child":@[@{@"name":@"紧急情况联系人",@"text":@"",@"key":@"hp_linkman"},
                                         @{@"name":@"联系人电话",@"text":@"",@"key":@"hp_linktelp"}]
                              },
                            @{@"key":@"contact",
                              @"child":@[@{@"name":@"建档机构名称",@"text":@"",@"key":@"hp_Archiving_unit"},
                                         @{@"name":@"联系电话",@"text":@"",@"key":@"hp_Archiving_unittel"}]
                              },
                            @{@"key":@"contact",
                              @"child":@[@{@"name":@"责任医生或护士",@"text":@"",@"key":@"hp_doctor"},
                                         @{@"name":@"联系电话",@"text":@"",@"key":@"hp_doctor_tel"}]
                              },
                            @{@"key":@"contact",
                              @"child":@[@{@"name":@"其他说明",@"text":@"",@"key":@"hp_othernote",@"label":@"1"}]
                              }];
    
    
    NSMutableArray *mbasicarr = [NSMutableArray array];
    for (NSDictionary *dt in basicArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        for (TextFiledModel *cmo in model.child) {
            NSDictionary *temDt = dict;
            if (temDt) {
                if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                    if ([cmo.key isEqualToString:@"aboxuexing"]) {
                        cmo.text = [NSString stringWithFormat:@"%@ %@",temDt[cmo.key],temDt[@"rhxuexing"]];
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
        for (TextFiledModel *cmo in model.child) {
            NSDictionary *temDt = dict;
            if (temDt) {
                if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                    cmo.text = temDt[cmo.key];
                }
            }
        }
        [mhistoryArr addObject:model];
    }

    [self.dataArray addObjectsFromArray:@[mbasicarr,mhistoryArr]];
    [self.tableView reloadData];
}
@end
