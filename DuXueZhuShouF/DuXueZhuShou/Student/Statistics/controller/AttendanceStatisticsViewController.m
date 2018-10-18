//
//  AttendanceStatisticsViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/8.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AttendanceStatisticsViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "DuXueZhuShou-Bridging-Header.h"
#import "BarChartsHelper.h"
#import "SelectTimeView.h"
#import "SignInViewController.h"
#import "AttendSubmitModel.h"
@interface AttendanceStatisticsViewController ()<UITableViewDataSource, UITableViewDelegate,TFPickerDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIView *headerView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)SelectTimeView *timeView;
@property(nonatomic, strong)NSMutableArray *optionArray;
@property (nonatomic, weak) BarChartView *barChartView;
@property (nonatomic, strong) BarChartsHelper *helper;
@property (nonatomic, copy) NSString *attenID;

@end

@implementation AttendanceStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"考勤统计";
    [self.view addSubview:self.tableView];
    [self UpData];
}
-(void)UpData{
    [super UpData];
    self.page = 1;
    [self getDataSubject:nil];
}
-(NSMutableArray *)optionArray{
    if (!_optionArray) {
        _optionArray = [NSMutableArray array];
    }
    return _optionArray;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
//        NSArray *array = @[@{@"name":@"2018.08.09",@"text":@"全文",@"key":@"archive_no",@"textcolor":@"333333"},
//                           @{@"name":@"2018.08.09",@"key":@"archive_no",@"textcolor":@"333333"},
//                           @{@"name":@"2018.08.09",@"key":@"archive_no",@"textcolor":@"333333"},
//                           @{@"name":@"2018.08.09",@"key":@"archive_no",@"textcolor":@"333333"}];
//        for (NSDictionary *dt in array) {
//            TextFiledModel *model = [TextFiledModel mj_objectWithKeyValues:dt];
//            model.text = @"正常签到";
//            [_dataArray addObject:model];
//        }
    }
    return _dataArray;
}
-(UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, SAFE_NAV_HEIGHT, screenW, 9/24.0 * screenH + 135)];
        _headerView.backgroundColor = [UIColor whiteColor];
        _timeView = [SelectTimeView view];
        WEAKSELF;
        _timeView.clickBlock = ^(NSInteger tag) {
            if (tag < 4) {
                [weakSelf showPickerview:tag];
            }else{
                [weakSelf queryData];
            }
        };
        _timeView.frame = CGRectMake(0, 0, screenW, 115);
        [_headerView addSubview:_timeView];
        UILabel *lb = [UILabel initialization:CGRectMake(5, _timeView.height_i, screenW - 30, 20) font:[UIFont systemFontOfSize:14] textcolor:JHsimpleColor numberOfLines:0 textAlignment:0];
        lb.text = @"单位:次";
        [_headerView addSubview:lb];
        BarChartView *barChartView = [[BarChartView alloc] init];
        barChartView.noDataText = @"暂无数据";
        self.barChartView = barChartView;
        //    self.barChartView.delegate = self;//设置代理 可以设置X轴和Y轴的格式
        self.barChartView.frame = CGRectMake(0, _timeView.height_i + 20, self.view.frame.size.width, 9/24.0 * screenH);
        [_headerView addSubview:self.barChartView];
        
        _helper = [[BarChartsHelper alloc] init];
//        [_helper setBarChart:self.barChartView xValues:@[@"已完成",@"未完成",@"未打卡"] yValues:@[@"30",@"60",@"100"] barTitle:@"234de"];
    }
    return _headerView;
}
-(void)showPickerview:(NSInteger )tag{
    PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
    picker.tag = tag;
    picker.inter =2;
    picker.delegate = self;
    if (tag < 3) {
        picker.arrayType = YMDWarray;
        if (tag == 2) {
            if ([self.timeView.leftTopView.titleLb.text isEqualToString:@"请选择"]) {
                [self presentLoadingTips:@"请选择开始时间"];
                return;
            }
            picker.minDate = [[UserUtils getTimeStrWithString:self.timeView.leftTopView.titleLb.text dateFormat:@"YYYY-MM-dd"] integerValue];
        }
        picker.maxDate = [[NSDate date] timeIntervalSince1970];
        picker.selectDate = picker.maxDate;
    }else{
        if (!self.optionArray.count) {
            [self presentLoadingTips];
            WEAKSELF;
            [self getDataSubject:^(NSArray *arr) {
                if (arr.count) {
                     [weakSelf showPickerview:tag];
                }
            }];
            return;
        }
        picker.titlestr = @"";
        picker.arrayType = HeightArray;
        for (AttendStuModel *mo in self.optionArray) {
            [picker.typearr addObject:mo.name];
        }
    }
    [self.view addSubview:picker];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            STRONGSELF;
            [self UpData];
        }];
    }
    return _tableView;
}

#pragma mark -------- TFPickerDelegate

- (void)PickerSelectorIndixString:(id)picker str:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    PickerChoiceView *pickerview  = (PickerChoiceView *)picker;
    LbRightImLeftView *view = [self.timeView viewWithTag:pickerview.tag];
    view.titleLb.text = pickerview.tag < 3 ? [UserUtils getShowDateWithTime:str dateFormat:@"YYYY-MM-dd"] : str;
    if (pickerview.tag == 3) {
        for (AttendStuModel *smo in self.optionArray) {
            if ([smo.name isEqualToString:str]) {
                self.attenID = smo.ID;
                return;
            }
        }
    }

}
#pragma mark -------- 查询
-(void)queryData{
    if ([self.timeView.leftTopView.titleLb.text isEqualToString:@"请选择"]) {
        [self presentLoadingTips:@"请选择开始时间"];
    }else if ([self.timeView.rightTopView.titleLb.text isEqualToString:@"请选择"]){
        [self presentLoadingTips:@"请选择结束时间"];
    }else if ([self.timeView.leftBottomView.titleLb.text isEqualToString:@"请选择"]){
        [self presentLoadingTips:@"请选择考勤组"];
    }else{
        [self getData];
    }
}
#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.dataArray.count;
//    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    TextFiledModel *cmo = self.dataArray[indexPath.row];
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.headerView.height_i;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SignInViewController *vc =[[SignInViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 获取考勤组
-(void)getDataSubject:(void (^)(NSArray *arr))result{
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,AttendanceAllListUrl) params:nil viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"获取考勤组:%@",response);
        NSNumber *code = @([response[@"code"] integerValue]);
        if (code.integerValue == 1) {
            [self.optionArray removeAllObjects];
            for (NSDictionary *temDt in response[@"data"]) {
                AttendStuModel *model  = [AttendStuModel mj_objectWithKeyValues:temDt];
                [self.optionArray addObject:model];
            }
            if (result ) {
                if (self.optionArray.count) {
                    result(self.optionArray);
                }else{
                    [AlertView showMsg:@"暂无数据！"];
                }
            }
        }else{
            [AlertView showMsg:response[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        LFLog(@"error：%@",error);
    }];
}

#pragma mark - 获取列表
- (void)getData{
    [self presentLoadingTips];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.attenID) {
        [dt setObject:self.attenID forKey:@"id"];
    }
    [dt setObject:self.timeView.leftTopView.titleLb.text forKey:@"start_date"];
    [dt setObject:self.timeView.rightTopView.titleLb.text forKey:@"end_date"];
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,AttendancStuStaUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"]) {
            [TextFiledModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{Tname : @"date",Tvalue : @"status"};
            }];
            [self.dataArray removeAllObjects];
            for (NSDictionary *temDt in response[@"data"][@"list"]) {
                TextFiledModel *cmo = [TextFiledModel mj_objectWithKeyValues:temDt];
                
                if (cmo.value.integerValue == 1){
                    cmo.text = @"正常签到";
                    cmo.textcolor = @"00C5A2";
                }else{
                    cmo.textcolor = @"F81000";
                    if (cmo.value.integerValue == 2) cmo.text = @"异常签到";
                    if (cmo.value.integerValue == 3) cmo.text = @"未签到";
                }

                [self.dataArray addObject:cmo];
            }
            [TextFiledModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return nil;
            }];
            NSArray *yValueArr = @[@{@"yvalue":[NSString stringWithFormat:@"%@",response[@"data"][@"status_1"]],@"color":@"3396FB"},
                                   @{@"yvalue":[NSString stringWithFormat:@"%@",response[@"data"][@"status_2"]],@"color":@"FB6250"},
                                   @{@"yvalue":[NSString stringWithFormat:@"%@",response[@"data"][@"status_3"]],@"color":@"FFB20A"}];
            [_helper setBarChart:self.barChartView xValues:@[@"正常签到",@"异常签到",@"未签到"] yValues:yValueArr barTitle:@"234de"];
        }else{
            
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
@end
