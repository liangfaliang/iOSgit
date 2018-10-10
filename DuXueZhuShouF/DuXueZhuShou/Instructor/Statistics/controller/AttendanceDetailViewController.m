//
//  AttendanceDetailViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AttendanceDetailViewController.h"
#import "SPPageMenu.h"
#import "TextFiledLableTableViewCell.h"
@interface AttendanceDetailViewController ()<SPPageMenuDelegate,UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation AttendanceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self UpData];
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0  , screenW, 44)];
    self.navigationItem.titleView = view;
    WEAKSELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        //坐标系转换到titleview
        self.pageMenu.frame = [weakSelf.view.window convertRect:self.pageMenu.frame toView:weakSelf.navigationItem.titleView];
        //centerview添加到titleview
        [weakSelf.navigationItem.titleView addSubview:self.pageMenu];
    });
    
    [self.pageMenu setItems:self.dataArr selectedItemIndex:0];
    
}
-(void)UpData{
    [super UpData];
    self.page = 1;
    [self getDataList:self.page];
}


- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        NSArray *arr = @[@{@"name":@"正常签到"},@{@"name":@"异常签到"},@{@"name":@"未签到"}];
        for (NSDictionary *temdt in arr) {
            SPitemModel *model = [SPitemModel mj_objectWithKeyValues:temdt];
            [_dataArr addObject:model];
        }
    }
    return _dataArr;
}
-(SPPageMenu *)pageMenu{
    if (!_pageMenu) {
        CGFloat width = 250;
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake((screenW - width)/2, SAFE_NAV_HEIGHT - 44, width, 44) trackerStyle:SPPageMenuTrackerStyleLine];
        _pageMenu.itemPadding = 10;
        _pageMenu.tracker.backgroundColor = JHAssistColor;
        _pageMenu.SPPageMenuLineColor = [UIColor clearColor];
        _pageMenu.backgroundColor = [UIColor clearColor];
        // 传递数组，默认选中第1个
        // 可滑动的自适应内容排列
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        // 设置代理
        _pageMenu.selectedItemTitleColor = JHAssistColor;
        _pageMenu.unSelectedItemTitleColor = JHmiddleColor;
        _pageMenu.delegate = self;
        
    }
    return _pageMenu;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray *array = @[@{@"tfmodel":@{@"name":@"科目",@"leftim":@"enter",@"key":@"status"},
                             @"child":@[@{@"name":@"接受学生组",@"text":@"",@"key":@"",@"rightim":@"1"},
                                        @{@"name":@"作业下发时间",@"text":@"",@"key":@"",@"rightim":@"1"},
                                        @{@"name":@"最晚打卡时间",@"text":@"",@"key":@"",@"rightim":@"1"},
                                        @{@"name":@"未打卡提醒时间",@"text":@"",@"key":@"",@"rightim":@"1"},
                                        @{@"name":@"接受学生组",@"text":@"",@"key":@"",@"rightim":@"1"},
                                        @{@"name":@"作业下发时间",@"text":@"",@"key":@"",@"rightim":@"1"},
                                        @{@"name":@"最晚打卡时间",@"text":@"",@"key":@"",@"rightim":@"1"},
                                        @{@"name":@"未打卡提醒时间",@"text":@"",@"key":@"",@"rightim":@"1"}]
                             },
                           @{@"tfmodel":@{@"name":@"科目",@"leftim":@"enter",@"key":@"status"},
                             @"child":@[@{@"name":@"接受学生组",@"text":@"",@"key":@"",@"rightim":@"1"},
                                        @{@"name":@"作业下发时间",@"text":@"",@"key":@"",@"rightim":@"1"},
                                        @{@"name":@"最晚打卡时间",@"text":@"",@"key":@"",@"rightim":@"1"},
                                        @{@"name":@"未打卡提醒时间",@"text":@"",@"key":@"",@"rightim":@"1"},
                                        @{@"name":@"接受学生组",@"text":@"",@"key":@"",@"rightim":@"1"},
                                        @{@"name":@"作业下发时间",@"text":@"",@"key":@"",@"rightim":@"1"},
                                        @{@"name":@"最晚打卡时间",@"text":@"",@"key":@"",@"rightim":@"1"},
                                        @{@"name":@"未打卡提醒时间",@"text":@"",@"key":@"",@"rightim":@"1"}]
                             }];
        for (NSDictionary *dt in array) {
            TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
            [_dataArray addObject:model];
        }
        
    }
    return _dataArray;
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.estimatedSectionHeaderHeight = 70;
        _tableView.rowHeight = -1;
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"herader"];
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf UpData];
        }];

    }
    return _tableView;
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    TextSectionModel *smo = self.dataArray[section];
    return smo.isSelect ? smo.child.count :0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    cell.NameTfSpace.constant = 50;
    cell.nameBtn.titleLabel.numberOfLines = 1;
    __block   TextSectionModel *smo = self.dataArray[indexPath.section];
    __block  TextFiledModel *cmo = smo.child[indexPath.row];
    if (cmo.isSelect) {
        cmo.image = @"choosed";
    }else{
        cmo.image = @"choose";
    }
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    cell.nameBtn.userInteractionEnabled =NO;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return -1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TextFiledLableTableViewCell *header = [tableView dequeueReusableCellWithIdentifier:@"herader"];
    header.nameBtn.titleLabel.numberOfLines = 1;
    header.backgroundColor = [UIColor whiteColor];
    header.tag = section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerClick:)];
    [header addGestureRecognizer:tap];
    __block TextSectionModel *smo = self.dataArray[section];
    TextFiledModel *cmo = smo.tfmodel;
    header.model = cmo;
    header.textfiled.textAlignment = NSTextAlignmentRight;
    header.nameBtn.userInteractionEnabled = NO;

    return header;
}
-(void)headerClick:(UITapGestureRecognizer *)tap{
    TextFiledLableTableViewCell *header = (TextFiledLableTableViewCell *)tap.view;
    TextSectionModel *smo = self.dataArray[header.tag];
    smo.isSelect = smo.isSelect ? 0 : 1;
    [self.tableView reloadData];
    //    header.model = cmo;
}

#pragma mark - 获取列表
- (void)getDataList:(NSInteger )pageNum{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pageNum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
//    if (pageNum == 1) {
//        [self.dataArray removeAllObjects];
//        [_tableView reloadData];
//    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,@"") params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            if (pageNum == 1) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *temDt in response[@"data"]) {
            }
            
        }else{
            
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
@end
