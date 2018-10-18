//
//  AttendanceListViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/1.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AttendanceListViewController.h"
#import "AttendanceListTableViewCell.h"
#import "RangePickerView.h"
#import "SignInViewController.h"
@interface AttendanceListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)RangePickerView *calendar;
@property(nonatomic, strong)NSString *dateStr;
@end

@implementation AttendanceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"考勤组";
    [self.view addSubview:self.tableView];
    [self createBaritem];
    [self UpData];
}
-(void)UpData{
    [super UpData];
    self.page = 1;
    [self getDataList:self.page];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)createBaritem{
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"rili"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = rightBar;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 60;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"AttendanceListTableViewCell" bundle:nil] forCellReuseIdentifier:@"AttendanceListTableViewCell"];
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf UpData];
        }];
    }
    return _tableView;
}
-(RangePickerView *)calendar{
    if (_calendar == nil) {
        _calendar = [[RangePickerView alloc]initWithFrame:CGRectMake(0, SAFE_NAV_HEIGHT, screenW, screenH - SAFE_NAV_HEIGHT)];
        [_calendar.calendar selectDate:[NSDate date]];
        WEAKSELF;
        _calendar.selectDateBlock = ^(NSArray<NSDate *> *dateArr) {
            if (dateArr.count) {
                NSDateFormatter *Formatter = [[NSDateFormatter alloc] init];
                Formatter.dateFormat = @"yyyy-MM-dd";
                weakSelf.dateStr = [Formatter stringFromDate:dateArr[0]];
                
                LFLog(@"%@",[Formatter stringFromDate:dateArr[0]]);
            }else{
                weakSelf.dateStr = nil;
            }
            [weakSelf UpData];
        };
    }
    return _calendar;
}


-(void)rightClick{
    if ([self.calendar isDescendantOfView:self.view]) {
        [self.calendar removeFromSuperview];
    }else{
        [self.view addSubview:self.calendar];
    }
}
#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.dataArray.count;
//    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AttendanceListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AttendanceListTableViewCell class]) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SignInViewController *vc =[[SignInViewController alloc]init];
    AttendStuModel *mo = self.dataArray[indexPath.row];
    vc.ID = mo.ID;
    vc.date = self.dateStr;
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - 获取列表
- (void)getDataList:(NSInteger )pageNum{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
//    [dt setObject:[NSString stringWithFormat:@"%ld",(long)pageNum] forKey:@"page"];
    if (self.dateStr) {
        [dt setObject:self.dateStr forKey:@"date"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,AttendanceListUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
//            if (pageNum == 1) {
                [self.dataArray removeAllObjects];
//            }
//            self.more = [response[@"data"][@"isEnd"] integerValue];
            for (NSDictionary *temDt in response[@"data"]) {
                AttendStuModel *model = [AttendStuModel mj_objectWithKeyValues:temDt];
                [self.dataArray addObject:model];
            }
        }else{
            [self presentLoadingTips:response[@"msg"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
@end
