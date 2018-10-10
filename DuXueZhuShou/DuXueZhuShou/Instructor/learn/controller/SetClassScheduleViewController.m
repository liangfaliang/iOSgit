//
//  SetClassScheduleViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/15.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "SetClassScheduleViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "ClassScheduleTableViewCell.h"
@interface SetClassScheduleViewController ()<UITableViewDataSource, UITableViewDelegate,TFPickerDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableArray *weekArray;
@end

@implementation SetClassScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle =  @"设置课程表"  ;
    self.isEmptyDelegate = NO;
    [self.view addSubview:self.tableView];
    [self createFootview];
    [self UpData];
    
}
-(void)UpData{
    [super UpData];
}
-(void)createFootview{
    UIButton *footview = [[UIButton alloc]initWithFrame:CGRectMake(15, screenH -  60, screenW -  30,  50)];
    footview.backgroundColor = JHMaincolor;
    [footview setTitle:@"确定" forState:UIControlStateNormal];
    footview.titleLabel.font = [UIFont systemFontOfSize:15];
    [footview addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footview];
}
-(NSMutableArray *)weekArray{
    if (_weekArray == nil) {
        _weekArray = [NSMutableArray array];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"];
        formatter.locale = locale;
        for (int i = 1 ; i < 8; i ++) {
            ScheduleModel * mo = [[ScheduleModel alloc]init];
            NSString *string = [formatter stringFromNumber:[NSNumber numberWithInt:i]];
            NSString *type = [NSString stringWithFormat:@"%d",i];
            if (self.model.course) {
                for (ScheduleModel *scmo in self.model.course.timetable) {
                    if ([scmo.type isEqualToString:type]) {
                        mo = scmo;
                    }
                    
                }
            }
            mo.week = [NSString stringWithFormat:@"周%@",string];
            mo.type = type;
            [_weekArray addObject:mo];
        }
    }
    return _weekArray;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray *array = @[@{Schild:@[@{Tname:@"课表生效时间",Ttext:self.model.course ? self.model.course.effective_date: @"",Tkey:@"effective_date",Trightim:@"1",Tprompt:@"请选择课表生效时间"},
                                        @{Tname:@"课表失效时间",Ttext:self.model.course ? self.model.course.expiry_date: @"",Tkey:@"expiry_date",Trightim:@"1",Tprompt:@"请选择课表失效时间"}]
                             }];
        for (NSDictionary *dt in array) {
            TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
            for (TextFiledModel *cmo in model.child) {
                if (cmo.text.length) {
                    cmo.value = [UserUtils getTimeStrWithString:cmo.text dateFormat:@"yyyy-MM-dd"];
                    cmo.text = [cmo.text stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                    
                }
            }
            [_dataArray addObject:model];
        }
        
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH -60) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"ClassScheduleTableViewCell" bundle:nil] forCellReuseIdentifier:@"ClassScheduleTableViewCell"];
    }
    return _tableView;
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.weekArray.count + self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section < self.weekArray.count) {
        return 1;
    }
    TextSectionModel *smo = self.dataArray[0];
    return smo.child.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.weekArray.count) {
        ClassScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassScheduleTableViewCell" forIndexPath:indexPath];
        cell.model = self.weekArray[indexPath.section];
        return cell;
    }
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    cell.nameBtn.titleLabel.numberOfLines = 1;
    TextSectionModel *smo = self.dataArray[0];
    TextFiledModel *cmo = smo.child[indexPath.row];
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    cell.nameBtn.userInteractionEnabled =NO;
    return cell;
}
-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.weekArray.count) {
        TextSectionModel *smo = self.dataArray[0];
        TextFiledModel *coldmo = smo.child[0];
        if (indexPath.row > 0 && !coldmo.value) {
            [self presentLoadingTips:@"请先选择课表生效时间"];
            return;
        }
        PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
        picker.tag = indexPath.row;
        picker.inter =2;
        picker.arrayType = YMDWarray;
        if (indexPath.row == 0) {
            picker.minDate = [[NSDate date] timeIntervalSince1970];
        }else{
            picker.minDate = coldmo.value.integerValue + 24*60*60;
        }
        picker.selectDate = picker.minDate;
        picker.delegate = self;
        [self.view addSubview:picker];
    }

}
#pragma mark -------- TFPickerDelegate

- (void)PickerSelectorIndixString:(id)picker str:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    PickerChoiceView *pickerview  = (PickerChoiceView *)picker;
    TextSectionModel *smo = self.dataArray[0];
    TextFiledModel *cmo = smo.child[pickerview.tag];
    cmo.value = str;
    cmo.text = [UserUtils getShowDateWithTime:str dateFormat:@"yyyy.MM.dd"];
    [self.tableView reloadData];
}
#pragma mark - 确定
-(void)submitClick{
    courseModel *couMo = [[courseModel alloc]init];
    NSMutableArray *marr = [NSMutableArray array];
    int i = 0;
    for (ScheduleModel *scmo in self.weekArray) {
        if (scmo.lesson_start_time.length) {
            if (self.model.mode == 2 && !scmo.minimum_time.length) {
                [self presentLoadingTips:@"请设置自由考勤时最低学习时长"];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                return;
            }
            if (!scmo.lesson_end_time.length && scmo.sign_out == 1) {
                [self presentLoadingTips:@"请选择下课时间"];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                return;
            }
            [marr addObject:scmo];
        }
        i ++;
    }
    if (!marr.count) {
        [self presentLoadingTips:@"至少设置一天"];
        return;
    }
    couMo.timetable = marr;

    TextSectionModel *smo = self.dataArray[0];
    for (TextFiledModel *cmo in smo.child) {
        if (!cmo.value.length && cmo.prompt) {
            [self presentLoadingTips:cmo.prompt];
            return;
        }else{
            if (cmo.value.length) {
                [couMo setValue:[UserUtils getShowDateWithTime:cmo.value dateFormat:@"yyyy-MM-dd"] forKey:cmo.key];
            }

        }
    }
    for (ScheduleModel *scmo in couMo.timetable) {
        scmo.week = nil;
    }
    self.model.course = couMo;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
