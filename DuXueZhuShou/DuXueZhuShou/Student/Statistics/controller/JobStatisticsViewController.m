//
//  JobStatisticsViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/8.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "JobStatisticsViewController.h"
#import "DuXueZhuShou-Bridging-Header.h"
#import "BarChartsHelper.h"
#import "PunchOperationListViewController.h"
#import "SelectTimeView.h"
@interface JobStatisticsViewController ()<TFPickerDelegate>
@property (nonatomic, weak) BarChartView *barChartView;
@property(nonatomic, strong)SelectTimeView *timeView;
@property (nonatomic, strong) BarChartsHelper *helper;
@end

@implementation JobStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"作业统计";
//    NSArray *yValueArr = @[@{Cyvalue:@"3",Ccolor:@"3396FB",Cpercent:@"55"},
//                           @{Cyvalue:@"5",Ccolor:@"FB6250",Cpercent:@"33"},
//                           @{Cyvalue:@"9",Ccolor:@"FFB20A",Cpercent:@"11"}];
    [self createSingleBarChartView];
    [self createBaritem];

}
-(void)createBaritem{
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"查看详情" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    rightBar.tintColor = JHMaincolor;
    self.navigationItem.rightBarButtonItem = rightBar;
}
#pragma mark  查看详情
-(void)rightClick{
    PunchOperationListViewController * vc= [[PunchOperationListViewController alloc]init];
    vc.isHomework = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//单柱图
- (void)createSingleBarChartView
{
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, SAFE_NAV_HEIGHT, screenW, 13/24.0 * screenH)];
    backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backview];
    
    _timeView = [SelectTimeView view];
    _timeView.zhiLb.hidden = YES;
    _timeView.leftTopView.hidden = YES;
    _timeView.leftBottomView.hidden = YES;
    _timeView.sureBtn.hidden = YES;
    _timeView.frame = CGRectMake(0, 0, screenW, 60);
    WEAKSELF;
    _timeView.clickBlock = ^(NSInteger tag) {
        [weakSelf showPickerview:tag];
    };
    [backview addSubview:_timeView];
    UILabel *lb = [UILabel initialization:CGRectMake(5, _timeView.height_i, screenW - 30, 20) font:[UIFont systemFontOfSize:14] textcolor:JHsimpleColor numberOfLines:0 textAlignment:0];
    lb.text = @"单位:%";
    [backview addSubview:lb];
    BarChartView *barChartView = [[BarChartView alloc] init];
    barChartView.noDataText = @"暂无数据";
    self.barChartView = barChartView;
    //    self.barChartView.delegate = self;//设置代理 可以设置X轴和Y轴的格式
    self.barChartView.frame = CGRectMake(0, _timeView.height_i + 20, self.view.frame.size.width, 9/24.0 * screenH);
    [backview addSubview:self.barChartView];
    _helper = [[BarChartsHelper alloc] init];
    
}
-(void)showPickerview:(NSInteger )tag{
    PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
    picker.tag = tag;
    picker.inter = 2;
    picker.delegate = self;
    picker.arrayType = YMDWarray;
    picker.maxDate = [[NSDate date] timeIntervalSince1970];
    picker.selectDate = picker.maxDate;
    [self.view addSubview:picker];
}
#pragma mark -------- TFPickerDelegate

- (void)PickerSelectorIndixString:(id)picker str:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    LFLog(@"str:%@",str);
    PickerChoiceView *pickerview  = (PickerChoiceView *)picker;
    LbRightImLeftView *view = [self.timeView viewWithTag:pickerview.tag];
    view.titleLb.text = [UserUtils getShowDateWithTime:str dateFormat:@"YYYY-MM-dd"];
    [self getData:str];
}

#pragma mark - 获取列表
- (void)getData:(NSString *)start_time{
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,OperationStatisticsUrl) params:start_time ? @{@"start_time":start_time} :nil viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"]) {
            NSInteger total = [response[@"data"][@"total"] integerValue];
            NSInteger type1 = [response[@"data"][@"type1"] integerValue];
            NSInteger type2 = [response[@"data"][@"type2"] integerValue];
            NSInteger type3 = [response[@"data"][@"type3"] integerValue];
            if (total) {
                NSArray *yValueArr = @[@{Cyvalue:[NSString stringWithFormat:@"%ld",(type1 * 100)/total ],Ccolor:@"3396FB",Cpercent:[NSString stringWithFormat:@"%ld",type1]},
                                       @{Cyvalue:[NSString stringWithFormat:@"%ld",(type2 * 100)/total ],Ccolor:@"FB6250",Cpercent:[NSString stringWithFormat:@"%ld",type2]},
                                       @{Cyvalue:[NSString stringWithFormat:@"%ld",(type3 * 100)/total ],Ccolor:@"FFB20A",Cpercent:[NSString stringWithFormat:@"%ld",type3]}];
                [_helper setBarChart:self.barChartView xValues:@[@"已完成",@"未完成",@"未打卡"] yValues:yValueArr barTitle:@""];
            }else{
                [_helper setBarChart:self.barChartView xValues:@[@"已完成",@"未完成",@"未打卡"] yValues:nil barTitle:@""];
            }

        }else{
            [self presentLoadingTips:response[@"msg"]];
        }

    } failure:^(NSError *error) {

    }];
    
}
@end
