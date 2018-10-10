//
//  AddSignInViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/14.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AddSignInViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "AddSignInTableViewCell.h"
#import "SetClassScheduleViewController.h"
#import "SpecialDateViewController.h"
#import "SignInMapViewController.h"
#import "SelectStudentViewController.h"

@interface AddSignInViewController ()<UITableViewDataSource, UITableViewDelegate,TFPickerDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableArray *subjectArray;

@end

@implementation AddSignInViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.isEdit)  [self reloadUI];
}
-(void)reloadUI{
    TextSectionModel *smo = self.dataArray[2];
    for (int i = 0; i < smo.child.count ; i ++) {
        TextFiledModel *cmo = smo.child[i];
        if (i == 0 ) cmo.text = self.model.course ? @"已设置" : @"";
        if (i == 1 ) cmo.text = self.model.student.count ? @"已选择" : @"";
    }
    [self updateAdress];
    [self.tableView reloadData];
}
-(void)updateAdress{
    TextSectionModel *smo3 = self.dataArray[3];
    NSMutableArray *temArr = [NSMutableArray arrayWithObject:smo3.child.firstObject];
    for (placeModel *pmo in self.model.place) {
        TextFiledModel *cmo = [TextFiledModel mj_objectWithKeyValues:@{Tkey:@"",Trightim:@"1",Timage:@"delete",Tunedit:@"1",Tenable:@"1"}];
        cmo.name = pmo.address;
        [temArr addObject:cmo];
    }
    [temArr addObject:smo3.child.lastObject];
    smo3.child = temArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = self.isEdit ? @"编辑考勤组" :@"新建考勤组" ;
    if (!self.isEdit) {
        self.model = [[AttendSubmitModel alloc]init];
    }
    self.isEmptyDelegate = NO;
    [self.view addSubview:self.tableView];
    [self createFootview];
    [self UpData];
}

-(void)UpData{
    [super UpData];
    [self getDataSubject:nil];
}
-(void)createFootview{
    UIButton *footview = [[UIButton alloc]initWithFrame:CGRectMake(15, screenH -  60, screenW -  30,  50)];
    footview.backgroundColor = JHMaincolor;
    [footview setTitle:@"确定" forState:UIControlStateNormal];
    footview.titleLabel.font = [UIFont systemFontOfSize:15];
    [footview addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footview];
}
-(NSMutableArray *)subjectArray{
    if (!_subjectArray) {
        _subjectArray = [NSMutableArray array];
    }
    return _subjectArray;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray *array = @[@{@"child":@[@{@"name":@"签到组名称",@"text":self.isEdit ? self.model.name : @"",@"value":self.isEdit ? self.model.name : @"",@"key":@"name",@"enable":@"1",@"placeholder":@"请输入",@"prompt":@"请输入名字"},
                                        @{@"name":@"签到类别",@"key":@"type",@"rightim":@"1",@"prompt":@"请选择类别"}]
                             },
                           @{@"child":@[@{@"name":@"",@"key":@""}]
                             },
                           @{@"child":@[@{@"name":@"设置课程表",@"text":@"",@"key":@"",@"rightim":@"1"},
                                        @{@"name":@"选择学生",@"text":@"",@"key":@"",@"rightim":@"1"}]
                             },
                           @{@"child":@[@{@"name":@"考勤地点",@"text":@"",@"key":@"",@"rightim":@"1",@"enable":@"1",@"unedit":@"1",@"image":@"tj"},
                                        @{@"name":@"需要拍照",@"text":@"",@"key":@"",@"leftim":@"choose"}]
                             },
                           @{@"child":@[@{@"name":@"特殊日期不签到",@"text":@"",@"key":@"",@"rightim":@"1"}]
                             }];
        for (NSDictionary *dt in array) {
            TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
            [_dataArray addObject:model];
        }
        if (self.isEdit) {
            [self updateAdress];
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
        [_tableView registerNib:[UINib nibWithNibName:@"AddSignInTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddSignInTableViewCell"];
    }
    return _tableView;
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TextSectionModel *smo = self.dataArray[section];
    return smo.child.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        AddSignInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddSignInTableViewCell" forIndexPath:indexPath];
        cell.model = self.model;
        WEAKSELF;
        cell.btnclickBlock = ^(NSInteger idx) {
            [weakSelf.tableView reloadData];
        };
        return cell;
    }
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    cell.NameTfSpace.constant = 50;
    cell.nameBtn.titleLabel.numberOfLines = 0;
    TextSectionModel *smo = self.dataArray[indexPath.section];
    TextFiledModel *cmo = smo.child[indexPath.row];
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    if (indexPath.section == 3 && indexPath.row == smo.child.count - 1) {
        cell.nameBtn.userInteractionEnabled = YES;
    }else{
        cell.nameBtn.userInteractionEnabled = NO;
    }
    WEAKSELF;
    cell.nameBtnBlock = ^{
        if (indexPath.section == 3 && indexPath.row == smo.child.count - 1) {
            cmo.isSelect = !cmo.isSelect;
            cmo.leftim = cmo.isSelect ?  @"choosed" : @"choose" ;
            self.model.photoProof = cmo.isSelect;
            [weakSelf.tableView reloadData];
        }
    };
    cell.rightViewBlock = ^{
        if (indexPath.section == 3 ) {
            if (indexPath.row == 0) {
                SignInMapViewController *vc = [[SignInMapViewController alloc]init];
                vc.isSetAdress =YES;
                vc.model = weakSelf.model;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                for (placeModel *pmo in weakSelf.model.place) {
                    if ([cmo.name isEqualToString:pmo.address]) {
                        self.model.place = [weakSelf arrayRemove:weakSelf.model.place index: 1 object:pmo];
                        break;
                    }
                }
                smo.child = [weakSelf arrayRemove:smo.child index:indexPath.row object:nil];
                [weakSelf.tableView reloadData];
            }

        }
    };
    return cell;
}
-(NSArray *)arrayRemove:(NSArray *)arr index:(NSInteger )index object:(id)object {
    NSMutableArray *temarr = [NSMutableArray arrayWithArray:arr];
    if (temarr.count > index && index >= 0) {
        [temarr removeObjectAtIndex:index];
    }
    if (object) {
        [temarr removeObject:object];
    }
    return temarr;
}
-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        if (self.subjectArray.count) {
            [self showPickerview:self.subjectArray tag:indexPath.row ];
        }else{
            [self presentLoadingTips];
            [self getDataSubject:^(NSArray *arr) {
                [self showPickerview:arr tag:indexPath.row ];
            }];
        }
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        [self pushClassSchedule];
    }else if (indexPath.section == 2 && indexPath.row == 1) {
        SelectStudentViewController *vc = [[SelectStudentViewController alloc]init];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 4 && indexPath.row == 0) {
        if (!self.model.course) {
            [self presentLoadingTips:@"请设置课程表信息！"];
            return;
        }
        SpecialDateViewController *vc = [[SpecialDateViewController alloc]init];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
//    TextSectionModel *smo = self.dataArray[indexPath.section];
//    TextFiledModel *cmo = smo.child[indexPath.row];

    
}
-(void)pushClassSchedule{
    SetClassScheduleViewController *vc = [[SetClassScheduleViewController alloc]init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)showPickerview:(NSArray *)array tag:(NSInteger )tag{
    PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
    picker.tag = tag;
    picker.titlestr = @"";
    picker.inter =2;
    picker.delegate = self;
    picker.arrayType = HeightArray;
    for (int i = 0; i < array.count; i ++) {
        [picker.typearr addObject:array[i][@"name"]];
    }
    [self.view addSubview:picker];
}
#pragma mark -------- TFPickerDelegate

- (void)PickerSelectorIndixString:(id)picker str:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    LFLog(@"%@",str);
    TextSectionModel *smo = self.dataArray[0];
    TextFiledModel *cmo = smo.child[1];
    for (NSDictionary *dt in self.subjectArray) {
        if ([dt[@"name"] isEqualToString:str]) {
            cmo.text = str;
            cmo.value = [NSString stringWithFormat:@"%@",dt[@"id"]];
            [self.tableView reloadData];
            return;
        }
    }
}
#pragma mark - 确定
-(void)submitClick{
    TextSectionModel *smo = self.dataArray[0];
    for (TextFiledModel *cmo in smo.child) {
        if (!cmo.value.length && cmo.prompt) {
            [self presentLoadingTips:cmo.prompt];
            return;
        }else{
            if (cmo.value) [self.model setValue:cmo.value forKey:cmo.key];
        }
    }
    if (self.model.mode == 1) {
        if (!self.model.allowTimeBeforeSignIn.length) {
            [self presentLoadingTips:@"请设置有效签到时间！"];
            return;
        }
        if (!self.model.allowTimeAfterSignOut.length) {
            [self presentLoadingTips:@"请设置有效签退时间！"];
            return;
        }
    }

    if (!self.model.course) {
        [self presentLoadingTips:@"请设置课程表信息！"];
        return;
    }
    
    for (ScheduleModel *scmo in self.model.course.timetable) {
        if (scmo.lesson_start_time.length) {
            if (self.model.mode == 2 && !scmo.minimum_time.length) {
                [AlertView showMsg:@"请设置课程表自由考勤时最低学习时长!"];
                [self pushClassSchedule];
                return;
            }
        }

    }
    if (!self.model.student.count) {
        [self presentLoadingTips:@"请选择学生！"];
        return;
    }
    if (!self.model.place.count) {
        [self presentLoadingTips:@"请设置可签到地点！"];
        return;
    }


    [self UpdateLoad];
}
#pragma mark - 获取科目
-(void)getDataSubject:(void (^)(NSArray *arr))result{
    [self.subjectArray removeAllObjects];
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,AnswerSubjectsUrl  ) params:nil viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"获取科目:%@",response);
        NSNumber *code = @([response[@"code"] integerValue]);
        if (code.integerValue == 1) {

            [self.subjectArray removeAllObjects];
            [self.subjectArray addObject:@{@"name":@"早自习",@"id":@"-1"}];
            [self.subjectArray addObject:@{@"name":@"晚自习",@"id":@"-2"}];
            for (NSDictionary *temDt in response[@"data"]) {
                [self.subjectArray addObject:temDt];
            }
            if (self.isEdit && self.model && self.model.type ) {
                for (NSDictionary *tdt in self.subjectArray) {
                    if ([self.model.type isEqualToString:tdt[@"id"]]) {
                        TextSectionModel *smo = self.dataArray[0];
                        TextFiledModel *cmo = smo.child[1];
                        cmo.text = tdt[@"name"];
                        cmo.value =tdt[@"id"];
                        [self.tableView reloadData];
                        break;
                    }
                }
                
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
#pragma mark 提交
-(void)UpdateLoad{
    NSMutableDictionary *mdt = [self.model mj_keyValues];

    [LFLHttpTool post:NSStringWithFormat(SERVER_IP, self.isEdit ? AttendancEditUrl :  AttendanceAddUrl) params:mdt viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"tijaio:%@",response);
        NSNumber *code = @([response[@"code"] integerValue]);
        if (code.integerValue == 1) {
            NSLog(@"注册成功");
            if (self.successBlock) {
                self.successBlock();
            }
            [self performSelector:@selector(dismissView) withObject:nil afterDelay:2.];
        }
        [AlertView showMsg:response[@"msg"]];
        
    } failure:^(NSError *error) {
        [self dismissTips];
        LFLog(@"error：%@",error);
    }];
}
-(void)dismissView{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
