//
//  SpecialDateViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/15.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "SpecialDateViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "RangePickerView.h"
@interface SpecialDateViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)RangePickerView *calendar;
@property(nonatomic, strong)NSArray<NSDate *> *dateArr;
@end

@implementation SpecialDateViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.calendar.calendar.selectedDates.count) {
        NSMutableArray *marr = [NSMutableArray array];
        NSDateFormatter *Formatter = [[NSDateFormatter alloc] init];
        Formatter.dateFormat = @"yyyy-MM-dd";
        for (NSDate *date in self.calendar.calendar.selectedDates) {
            [marr addObject:[Formatter stringFromDate:date]];
        }
        self.model.special_date = marr;
    }else{
        self.model.special_date = nil;
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle =  @"特殊日期"  ;
    self.isEmptyDelegate = NO;
    [self.view addSubview:self.tableView];
    [self createBaritem];
    [self UpData];
    
}
-(void)UpData{
    [super UpData];
    NSDateFormatter *Formatter = [[NSDateFormatter alloc] init];
    Formatter.dateFormat = @"yyyy-MM-dd";
    NSTimeInterval begain = [[UserUtils getTimeStrWithString:self.model.course.effective_date dateFormat:@"yyyy-MM-dd"] integerValue] + 8*60*60;
    NSTimeInterval end = [[UserUtils getTimeStrWithString:self.model.course.expiry_date dateFormat:@"yyyy-MM-dd"] integerValue] + 8*60*60;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSMutableArray *signArr = [NSMutableArray array];
    NSArray *weekArr = @[@"7",@"1",@"2",@"3",@"4",@"5",@"6"];
    while (begain <= end) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:begain];
        NSDateComponents *comp = [calendar components:NSCalendarUnitWeekday
                                             fromDate:date];
        // 得到几号
        NSInteger week = [comp weekday];
        for (ScheduleModel *scmo in self.model.course.timetable) {
            if ([weekArr[week - 1] isEqualToString:scmo.type]) {
                [signArr addObject:date];
                break;
            }
        }
        begain += 24*60*60;
    }
    self.calendar.SigndateArr = signArr;
    for (NSString *time in self.model.special_date) {
        NSDate *date = [Formatter dateFromString:time];
        [self.dataArray addObject:[self getTextModelFormDate:date Formatter:Formatter]];
        [self.calendar.calendar selectDate:date];
    }
    [self.calendar.calendar reloadData];
    [self.tableView reloadData];
}
-(void)createBaritem{
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"rili"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = rightBar;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH ) style:UITableViewStylePlain];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
    }
    return _tableView;
}
-(RangePickerView *)calendar{
    if (_calendar == nil) {
        _calendar = [[RangePickerView alloc]initWithFrame:CGRectMake(0, SAFE_NAV_HEIGHT, screenW, screenH - SAFE_NAV_HEIGHT)];
        _calendar.isMany = YES;
        WEAKSELF;
        _calendar.selectDateBlock = ^(NSArray<NSDate *> *dateArr) {
            NSDateFormatter *Formatter = [[NSDateFormatter alloc] init];
            Formatter.dateFormat = @"yyyy-MM-dd";
            weakSelf.dateArr = dateArr;
            [weakSelf.dataArray removeAllObjects];
            for (NSDate *date in dateArr) {
                [weakSelf.dataArray addObject:[weakSelf getTextModelFormDate:date Formatter:Formatter]];
            }
            [weakSelf.tableView reloadData];
        };
    }
    return _calendar;
}
-(TextFiledModel *)getTextModelFormDate:(NSDate *)date Formatter:(NSDateFormatter *)Formatter{
    TextFiledModel *model = [[TextFiledModel alloc]init];
    model.name = [Formatter stringFromDate:date];
    model.text = @"恢复签到";
    model.textcolor = @"3995FF";
    model.label = @"1";
    return model;
}
-(void)rightClick{
//    RangePickerView *calendar = [[RangePickerView alloc]initWithFrame:CGRectMake(0, SAFE_NAV_HEIGHT, screenW, screenH - SAFE_NAV_HEIGHT)];
    if ([self.calendar isDescendantOfView:self.view]) {
        [self.calendar removeFromSuperview];
    }else{
        [self.view addSubview:self.calendar];
    }
    
}
#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    TextFiledModel *cmo = self.dataArray[indexPath.row];
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    cell.nameBtn.userInteractionEnabled =NO;
    WEAKSELF;
    cell.contentLbBlock = ^{
        if (weakSelf.dateArr.count > indexPath.row) {
            [weakSelf.calendar refreshDate:weakSelf.dateArr[indexPath.row] date2:nil];
        }
        [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView reloadData];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    TextFiledLableTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //    TextSectionModel *smo = self.dataArray[indexPath.section];
    //    TextFiledModel *cmo = smo.child[indexPath.row];
    
    
}

@end




