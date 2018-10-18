//
//  GradeAnalysisViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/8.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "GradeAnalysisViewController.h"
#import "LbRightImLeftView.h"
#import "DuXueZhuShou-Bridging-Header.h"
#import "BarChartsHelper.h"
#import "LookStudentViewController.h"
#import "HallofFameViewController.h"//光荣榜
static NSString *const Grade_type = @"type";
static NSString *const subject_id = @"subject_id";
static NSString *const class_id = @"class_id";
static NSString *const ranking_type = @"ranking_type";

@interface GradeAnalysisViewController () <TFPickerDelegate>
@property (nonatomic, strong)  LineChartView *chartView;
@property (nonatomic, strong)  BarChartsHelper *helper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categorybtnTop;
@property (weak, nonatomic) IBOutlet LbRightImLeftView *categoryView;
@property (weak, nonatomic) IBOutlet LbRightImLeftView *classView;
@property (weak, nonatomic) IBOutlet LbRightImLeftView *subjectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backviewHeight;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *unitLb;
@property (weak, nonatomic) IBOutlet UIButton *GradeBtn;
@property (weak, nonatomic) IBOutlet UIButton *classBtn;
@property (weak, nonatomic) IBOutlet UIButton *CampusBtn;
@property (weak, nonatomic) IBOutlet UIButton *schoolBtn;
@property (strong,nonatomic)NSArray *BtnNameArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unitLbTop;

@property(nonatomic, strong)NSMutableArray *subjectArray;
@property(nonatomic, strong)NSMutableArray *GradeCgArray;
@property(nonatomic, strong)NSMutableArray *classArray;

@property(nonatomic, strong)NSMutableDictionary *dataDt;
@end

@implementation GradeAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBarTitle = self.TitleName ? self.TitleName : @"成绩分析";
    [self configData];
    [self UpData];
}
LazyLoadDict(dataDt)
LazyLoadArray(subjectArray)
LazyLoadArray(GradeCgArray)
LazyLoadArray(classArray)
-(void)UpData{
    if ([UserUtils getUserRole] == UserStyleStudent) {
    }else if ([UserUtils getUserRole] == UserStyleInstructor){
        [self getDataClass:nil];
    }
    [self getDataGradeCategory:nil];
    [self getDataSubjectresult:nil];
}
-(void)configData{
    if (self.student_id) {
        [self.dataDt setObject:self.student_id forKey:@"student_id"];
    }
    self.BtnNameArr = @[@"GradeBtn",@"classBtn",@"CampusBtn",@"schoolBtn"];
    self.categorybtnTop.constant = SAFE_NAV_HEIGHT + 30;
    self.categoryView.titleLb.text = @"测试类别";
    self.subjectView.titleLb.text = @"测试科目";
    self.classView.titleLb.text = @"请选择";
    int i = 0;
    for (NSString *name in self.BtnNameArr) {
        UIButton *btn = [self valueForKey:name];
        [btn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"checkl"] forState:UIControlStateSelected];
        [self.dataDt setObject:@"3" forKey:ranking_type];//班级排名
        if ([UserUtils getUserRole] == UserStyleInstructor){ //1=学校排名，2=校区排名，
            if (self.isClass ) {
                if (i < 2) btn.hidden = YES;;
                if (i == 3) btn.selected = YES;
                [self.dataDt setObject:@"1" forKey:ranking_type];//学校排名
            }else{
                if (i == 1) btn.selected = YES;
            }
        }else{
            if (i == 1) btn.selected = YES;
        }
        i ++;
    }
    _chartView = [[LineChartView alloc] init];
    _chartView.noDataText = @"暂无数据";//没有数据时的文字提示
    //    self.barChartView.delegate = self;//设置代理 可以设置X轴和Y轴的格式
    _chartView.frame = CGRectMake(0,0, screenW, 9/24.0 * screenH);
    [self.backView addSubview:_chartView];
    self.backviewHeight.constant = _chartView.height_i;
    _helper = [[BarChartsHelper alloc] init];
    
    
    if ([UserUtils getUserRole] == UserStyleInstructor){
        if (self.isClass) {
            self.classView.hidden = NO;
            self.unitLbTop.constant = 60;
            [self createBaritem];
        }
    }else if ([UserUtils getUserRole] == UserStyleStudent && !self.student_id){
        [self createBaritem];
    }
    
}
-(void)createBaritem{
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:[UserUtils getUserRole] == UserStyleInstructor ? @"查看学员":@"光荣榜" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    rightBar.tintColor = JHMaincolor;
    self.navigationItem.rightBarButtonItem = rightBar;
    
}
#pragma mark  公开问答
-(void)rightClick{

    
    if ([UserUtils getUserRole] == UserStyleStudent) {
        HallofFameViewController *record = [[HallofFameViewController alloc]init];
        [self.navigationController pushViewController:record animated:YES];
    }else if ([UserUtils getUserRole] == UserStyleInstructor){
        if (!self.dataDt[Grade_type]) {
            [self presentLoadingTips:@"请选择类别！"];
            return;
        }
        if (!self.dataDt[subject_id]) {
            [self presentLoadingTips:@"请选择科目！"];
            return;
        }
        LookStudentViewController *record = [[LookStudentViewController alloc]init];
        record.type_id = self.dataDt[Grade_type];
        record.subject_id = self.dataDt[subject_id];
        [self.navigationController pushViewController:record animated:YES];
    }

}
- (IBAction)selectTypeClick:(UITapGestureRecognizer *)tap {
    LFLog(@"%ld",tap.view.tag);
    if (tap.view.tag == 10 ) {//类别
        if (self.GradeCgArray.count) {
            [self showPickerview:self.GradeCgArray tag:tap.view.tag ];
        }else{
            [self presentLoadingTips];
            [self getDataGradeCategory:^(NSArray *arr) {
                [self showPickerview:arr tag:tap.view.tag ];
            }];
        }
        
    }else if (tap.view.tag == 11 ) {//科目
        if (self.subjectArray.count) {
            [self showPickerview:self.subjectArray tag:tap.view.tag ];
        }else{
            [self presentLoadingTips];
            [self getDataSubjectresult:^(NSArray *arr) {
                [self showPickerview:arr tag:tap.view.tag ];
            }];
        }
    }else if (tap.view.tag == 12 ) {//班级
        if (self.classArray.count) {
            [self showPickerview:self.classArray tag:tap.view.tag ];
        }else{
            [self presentLoadingTips];
            [self getDataClass:^(NSArray *arr) {
                [self showPickerview:arr tag:tap.view.tag ];
            }];
        }
    }
}
- (IBAction)selectBtnClick:(UIButton *)sender {

    self.unitLb.text = sender.tag == 1 ? @"单位:分" :@"单位:次";
    for (NSString *name in self.BtnNameArr) {
        UIButton *btn = [self valueForKey:name];
        if (sender == btn) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    if ([UserUtils getUserRole] == UserStyleInstructor && self.class){
        [self.dataDt setObject:sender.tag == 4 ? @"1" :@"2" forKey:ranking_type];//学校排名
    }else{
        [self.dataDt setObject:sender.tag == 4 ? @"1" :(sender.tag == 3 ? @"2" : @"3") forKey:ranking_type];//1=学校排名，2=校区排名，3=班级排名
    }
    [self getData];
}
-(void)showPickerview:(NSArray *)array tag:(NSInteger )tag{
    if (!array.count) {
        [self presentLoadingTips:@"暂无数据！"];
        return;
    }
    PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
    picker.tag = tag;
    picker.titlestr = @"";
    picker.inter =2;
    picker.delegate = self;
    picker.arrayType = HeightArray;
    for (int i = 0; i < array.count; i ++) {
        IDnameModel *mo = array[i];
        [picker.typearr addObject:mo.name];
    }
    [self.view addSubview:picker];
}
#pragma mark -------- TFPickerDelegate

- (void)PickerSelectorIndixString:(id)picker str:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    PickerChoiceView *pc = (PickerChoiceView *)picker;
    LFLog(@"%@",str);
    NSMutableArray *marr = pc.tag == 10 ? self.GradeCgArray : (pc.tag == 11 ? self.subjectArray : self.classArray) ;
    for (IDnameModel *mo in marr) {
        if ([mo.name isEqualToString:str]) {
            if (pc.tag == 10) {
                self.categoryView.titleLb.text = str;
                [self.dataDt setObject:mo.ID forKey:Grade_type];
            }else if (pc.tag == 11){
                self.subjectView.titleLb.text = str;
                [self.dataDt setObject:mo.ID forKey:subject_id];
            }else{
                self.classView.titleLb.text = str;
                [self.dataDt setObject:mo.ID forKey:class_id];
            }
        }
    }
    [self getData];

}
#pragma mark - 获取科目
-(void)getDataSubjectresult:(void (^)(NSArray *arr))result{
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP, AnswerSubjectsUrl  ) params:nil viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"获取科目:%@",response);
        NSNumber *code = @([response[@"code"] integerValue]);
        if (code.integerValue == 1) {
            [self.subjectArray removeAllObjects];
            for (NSDictionary *temDt in response[@"data"]) {
                IDnameModel *mo = [IDnameModel mj_objectWithKeyValues:temDt];
                [self.subjectArray addObject:mo];
            }
            if (result) {
                result(self.subjectArray);
            }
        }else{
            [AlertView showMsg:response[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [self dismissTips];
        LFLog(@"error：%@",error);
    }];
}

#pragma mark - 获取考试类别
-(void)getDataGradeCategory:(void (^)(NSArray *arr))result{
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP, GradeCategoryUrl  ) params:nil viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"获取科目:%@",response);
        NSNumber *code = @([response[@"code"] integerValue]);
        if (code.integerValue == 1) {
            [self.GradeCgArray removeAllObjects];
            for (NSDictionary *temDt in response[@"data"]) {
                IDnameModel *mo = [IDnameModel mj_objectWithKeyValues:temDt];
                [self.GradeCgArray addObject:mo];
            }
            if ( result) {
                result(self.GradeCgArray);
            }
        }else{
            [AlertView showMsg:response[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [self dismissTips];
        LFLog(@"error：%@",error);
    }];
}
#pragma mark - 获取班级
-(void)getDataClass:(void (^)(NSArray *arr))result{
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP, InsClassListUrl  ) params:nil viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"获取科目:%@",response);
        NSNumber *code = @([response[@"code"] integerValue]);
        if (code.integerValue == 1) {
            [self.classArray removeAllObjects];
            for (NSDictionary *temDt in response[@"data"]) {
                IDnameModel *mo = [IDnameModel mj_objectWithKeyValues:temDt];
                [self.classArray addObject:mo];
            }
            if (result) {
                result(self.classArray);
            }
        }else{
            [AlertView showMsg:response[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [self dismissTips];
        LFLog(@"error：%@",error);
    }];
}

#pragma mark - 获取详情
-(void)getData{
    if (self.dataDt.count < (([UserUtils getUserRole] == UserStyleStudent && !self.student_id) ? 3: 4) ) {
        return;
    }
    if ([UserUtils getUserRole] == UserStyleStudent) {
    }else if ([UserUtils getUserRole] == UserStyleInstructor){
    }
    
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP, [UserUtils getUserRole] == UserStyleInstructor ? (self.class ? GradeInsStatisUrl : GradeInsLookStuStatisUrl) : GradeInsStatisUrl) params:self.dataDt viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"获取详情:%@",response);
        NSNumber *code = @([response[@"code"] integerValue]);
        if (code.integerValue == 1) {
            NSMutableArray *marr = [NSMutableArray array];
             NSMutableArray *xArr = [NSMutableArray array];
            for (NSDictionary *temdt in response[@"data"]) {
                NSString * score = lStringFor(temdt[@"score_avg"] ? temdt[@"score_avg"] : temdt[@"score"]);
                if ((([UserUtils getUserRole] == UserStyleInstructor && !self.class) || ([UserUtils getUserRole] == UserStyleStudent)) && self.GradeBtn.isSelected){
                    [marr addObject:@{Cyvalue:score,Ccolor:@"3396FB",Cpercent:lStringFormart(@"%@分, %@名",score,temdt[@"ranking"])}];
                }else{
                    
                    [marr addObject:@{Cyvalue:lStringFor(temdt[@"ranking"]),Ccolor:@"3396FB",Cpercent:lStringFormart(@"%@分, %@名",score,temdt[@"ranking"])}];
                }
                NSArray *dateArr = [temdt[@"date"] componentsSeparatedByString:@"-"];
                [xArr addObject:dateArr.count > 2 ? lStringFormart(@"%ld.%ld",(long)[dateArr[1] integerValue],(long)[dateArr[2] integerValue]) : @""];
            }
            
            [_helper setLineChart:_chartView xValues:xArr yValues:marr barTitle:@""];
        }else{
            [AlertView showMsg:response[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [self dismissTips];
        LFLog(@"error：%@",error);
    }];
}


@end
