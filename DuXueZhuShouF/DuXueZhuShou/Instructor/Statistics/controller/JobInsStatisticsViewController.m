//
//  JobInsStatisticsViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "JobInsStatisticsViewController.h"
#import "TBCycleView.h"
#import "InsSelectTimeView.h"
#import "SPPageMenu.h"
#import "LabelsTableViewCell.h"
#import "SelectTimeView.h"
#import "AttendanceDetailViewController.h"
#import "AttendSubmitModel.h"
@interface JobInsStatisticsViewController ()<SPPageMenuDelegate,UITableViewDataSource, UITableViewDelegate,TFPickerDelegate>
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) TBCycleView *cleView;
@property (nonatomic, strong) InsSelectTimeView *selectView;
@property (nonatomic, strong) SelectTimeView *STView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableArray *optionArray;
@property (nonatomic, copy) NSString *attenID;//考勤组ID
@end

@implementation JobInsStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self UpData];
    if (self.isKaoQin) {
        self.navigationBarTitle = @"考勤统计";
    }else{
        UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0  , screenW, 44)];
        self.navigationItem.titleView = view;
        //主线程列队一个block， 这样做 可以获取到autolayout布局后的frame，也就是titleview的frame。在viewDidLayoutSubviews中同样可以获取到布局后的坐标
        WEAKSELF;
        dispatch_async(dispatch_get_main_queue(), ^{
            //坐标系转换到titleview
            self.pageMenu.frame = [weakSelf.view.window convertRect:self.pageMenu.frame toView:weakSelf.navigationItem.titleView];
            //centerview添加到titleview
            [weakSelf.navigationItem.titleView addSubview:self.pageMenu];
        });
        
        [self.pageMenu setItems:self.dataArr selectedItemIndex:0];
    }


}
-(void)UpData{
    [super UpData];
    self.page = 1;
    self.more = 0;
    [self getDataSubject:nil];
//    [self getData:self.page];
}
-(NSMutableArray *)optionArray{
    if (!_optionArray) {
        _optionArray = [NSMutableArray array];
    }
    return _optionArray;
}
-(SelectTimeView *)STView{
    if (_STView == nil) {
        _STView  = [[NSBundle mainBundle]loadNibNamed:@"SelectTimeView" owner:nil options:nil].firstObject;
        _STView.frame = CGRectMake(0, 0, screenW, 115);
        WEAKSELF;
        _STView.clickBlock = ^(NSInteger tag) {
            if (tag < 4) {
                [weakSelf showPickerview:tag];
            }else{
                [weakSelf queryData];
            }
        };
    }
    return _STView;
}
-(InsSelectTimeView *)selectView{
    if (_selectView == nil) {
        _selectView  = [[NSBundle mainBundle]loadNibNamed:@"InsSelectTimeView" owner:nil options:nil].firstObject;
        _selectView.frame = CGRectMake(0, 20, screenW, 70);
        WEAKSELF;
        _selectView.clickBlock = ^(NSInteger tag) {
            if (tag < 3) {
                [weakSelf showPickerview:tag];
            }else{
                [weakSelf queryData];
            }
        };
    }
    return _selectView;
}
-(UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 270)];
        _headerView.backgroundColor = [UIColor whiteColor];
        CGFloat hh = 0;
        if (self.isKaoQin) {
            hh = self.STView.height_i;
            [_headerView addSubview:self.STView];
        }else{
            hh = self.selectView.height_i;
            [_headerView addSubview:self.selectView];
        }
        
        _cleView = [[TBCycleView alloc]initWithFrame:CGRectMake(0, 0, 170, 170)];
        _cleView.center = CGPointMake(screenW/2, hh + 85);
        _cleView.layer.cornerRadius = 85;
        _cleView.layer.masksToBounds = YES;
        //    cle.layer.borderColor = JHbgColor.CGColor;
        //    cle.layer.borderWidth = 10;
        _cleView.label.text = @"\n实到/应到";
        _headerView.height_i = 170 + hh;
        [_headerView addSubview:_cleView];
        
    }
    return _headerView;
}
- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        NSArray *arr = @[@{@"name":@"今日"},@{@"name":@"历史",@"badge":@1}];
        for (NSDictionary *temdt in arr) {
            SPitemModel *model = [SPitemModel mj_objectWithKeyValues:temdt];
            [_dataArr addObject:model];
        }
    }
    return _dataArr;
}
-(SPPageMenu *)pageMenu{
    if (!_pageMenu) {
        CGFloat width = 150;
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
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
        if (!self.isKaoQin) {
            _tableView.height_i = screenH - SAFE_NAV_HEIGHT;
        }
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"LabelsTableViewCell" bundle:nil] forCellReuseIdentifier:@"LabelsTableViewCell"];
//        WEAKSELF;
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [weakSelf UpData];
//        }];
        _tableView.tableHeaderView = self.headerView;

    }
    return _tableView;
}
-(void)showPickerview:(NSInteger )tag{
    PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
    picker.tag = tag;
    picker.inter =2;
    picker.delegate = self;
    if (tag < 3) {
        picker.arrayType = YMDWarray;
        if (tag == 2) {
            if ([(self.isKaoQin ? self.STView.leftTopView.titleLb.text : self.selectView.leftView.titleLb.text) isEqualToString:@"请选择"]) {
                [self presentLoadingTips:@"请选择开始时间"];
                return;
            }
            picker.minDate = [[UserUtils getTimeStrWithString:(self.isKaoQin ? self.STView.leftTopView.titleLb.text : self.selectView.leftView.titleLb.text) dateFormat:@"YYYY-MM-dd"] integerValue];
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

#pragma mark -------- TFPickerDelegate

- (void)PickerSelectorIndixString:(id)picker str:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    PickerChoiceView *pickerview  = (PickerChoiceView *)picker;
    LbRightImLeftView *view = self.isKaoQin ? [self.STView viewWithTag:pickerview.tag] : [self.selectView viewWithTag:pickerview.tag];
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
    if ([(self.isKaoQin ? self.STView.leftTopView.titleLb.text : self.selectView.leftView.titleLb.text) isEqualToString:@"请选择"]) {
        [self presentLoadingTips:@"请选择开始时间"];
    }else if ([(self.isKaoQin ? self.STView.rightTopView.titleLb.text : self.selectView.rightView.titleLb.text) isEqualToString:@"请选择"]){
        [self presentLoadingTips:@"请选择结束时间"];
    }else if (self.isKaoQin && [self.STView.leftBottomView.titleLb.text isEqualToString:@"请选择"]){
        [self presentLoadingTips:@"请选择考勤组"];
    }else{
        [self getData];
        if (!self.isKaoQin) [self getDataInsHistory];
    }
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LabelsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LabelsTableViewCell class]) forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (self.isKaoQin) {
            [cell setBackViewSubviews:@[@"       日期       ",@"正常签到",@"异常签到",@"未签到",@"出勤率"]];
        }else{
            [cell setBackViewSubviews:@[@"       日期       ",@"已完成",@"未完成",@"未打卡",@"完成率"]];
        }
        
    }else{
        NSDictionary *dt = self.dataArray[indexPath.row];
        if (self.isKaoQin) {
                    [cell setBackViewSubviews:@[dt[@"date"],lStringFor(dt[@"status_1"]),lStringFor(dt[@"status_2"]),lStringFor(dt[@"status_3"]),lStringFor(dt[@"rate"])]];
        }else{
                    [cell setBackViewSubviews:@[[UserUtils getShowDateWithTime:dt[@"start_time"] dateFormat:@"yyyy.MM.dd"],lStringFor(dt[@"student_completed_number"]),lStringFor(dt[@"student_uncompleted_number"]),lStringFor(dt[@"student_uncard_number"]),lStringFor(dt[@"rate"])]];;
        }

    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isKaoQin) {
        AttendanceDetailViewController *vc = [[AttendanceDetailViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.attenID) {
        [dt setObject:self.attenID forKey:@"id"];
    }
    if (self.isKaoQin) {
        [dt setObject:self.STView.leftTopView.titleLb.text forKey:@"start_date"];
        [dt setObject:self.STView.rightTopView.titleLb.text forKey:@"end_date"];
    }else{
        [dt setObject:[UserUtils getTimeStrWithString:self.selectView.leftView.titleLb.text dateFormat:@"yyyy-MM-dd"] forKey:@"start_time"];
        NSInteger end_time = [UserUtils getTimeStrWithString:self.selectView.rightView.titleLb.text dateFormat:@"yyyy-MM-dd"].integerValue + 86399;
        [dt setObject:lStringFormart(@"%ld",(long)end_time) forKey:@"end_time"];
    }
    [self presentLoadingTips];
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,self.isKaoQin ? AttendancStuStaUrl : OperationInsHistoryListUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *temDt in response[@"data"][@"list"]) {
                [self.dataArray addObject:temDt];
            }
            if (self.isKaoQin) {
                CGFloat status_1_total = [response[@"data"][@"status_1_total"] floatValue];
                CGFloat total = [response[@"data"][@"total"] floatValue];
                NSString *text = [NSString stringWithFormat:@"%@\n实到%.f/应到%.f",response[@"data"][@"rate"],status_1_total,total];
                _cleView.label.attributedText = [text AttributedString:response[@"data"][@"rate"] backColor:nil uicolor:JHMaincolor uifont:SYS_FONT(20)];
                [_cleView.label NSParagraphStyleAttributeName:10];
                [_cleView drawProgress:total > 0 ? status_1_total/total : 0];
            }

        }else{
            [self presentLoadingTips:response[@"msg"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - 获取学管历史总比
- (void)getDataInsHistory{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    [dt setObject:[UserUtils getTimeStrWithString:self.selectView.leftView.titleLb.text dateFormat:@"yyyy-MM-dd"] forKey:@"start_time"];
    [dt setObject:[UserUtils getTimeStrWithString:self.selectView.rightView.titleLb.text dateFormat:@"yyyy-MM-dd"] forKey:@"end_time"];
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,OperationInsHistoryUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取学管历史总比:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
            CGFloat status_1_total = [response[@"data"][@"student_completed_number"] floatValue];
            CGFloat total = [response[@"data"][@"student_number"] floatValue];
            NSString *text = [NSString stringWithFormat:@"%@\n实到%.f/应到%.f",response[@"data"][@"rate"],status_1_total,total];
            _cleView.label.attributedText = [text AttributedString:response[@"data"][@"rate"] backColor:nil uicolor:JHMaincolor uifont:SYS_FONT(20)];
            [_cleView.label NSParagraphStyleAttributeName:10];
            [_cleView drawProgress:total > 0 ? status_1_total/total : 0];
            
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
