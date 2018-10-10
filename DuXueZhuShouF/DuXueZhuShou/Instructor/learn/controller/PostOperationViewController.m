//
//  PostOperationViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/10.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "PostOperationViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "OperationHeaderView.h"
#import "OperationFooterView.h"
#import "LookOperationViewController.h"
#import "StudentGroupViewController.h"
#import "MHDatePicker.h"

@interface PostOperationViewController ()<UITableViewDataSource, UITableViewDelegate,TFPickerDelegate,MHSelectPickerViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableArray *subjectArray;
@property(nonatomic,strong)NSMutableArray  *imageArray;
@property(nonatomic,strong)UIImage *picture;
@property(nonatomic, strong)OperationHeaderView *operationView;
@property(nonatomic, strong)OperationFooterView *footerView;
@property(nonatomic, strong)OperateSubmitModel *model;
@end

@implementation PostOperationViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.model = [[OperateSubmitModel alloc]init];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    [self UpData];
    self.navigationBarTitle = @"发布作业";
    
}
-(void)UpData{
    [super UpData];
    [self getDataSubjectresult:nil];
}
-(OperationFooterView *)footerView{
    if (_footerView == nil) {
        _footerView = [[NSBundle mainBundle]loadNibNamed:@"OperationFooterView" owner:nil options:nil].firstObject;
        _footerView.frame = CGRectMake(0, screenH - 60, screenW, 60);
        WEAKSELF;
        _footerView.btnClickBlcok = ^(NSInteger tag) {
            if (tag == 2) {
                [weakSelf submitClick:nil];
            }else{
                [weakSelf submitClick:tag == 1 ? @"2" :@"1"];
            }
        };
    }
    return _footerView;
}
-(void)submitClick:(NSString *)type{
    for (TextSectionModel *smo in self.dataArray) {
        for (TextFiledModel *cmo in smo.child) {
            if (!cmo.value.length && cmo.prompt) {
                [self presentLoadingTips:cmo.prompt];
                return;
            }else{
                if (cmo.value) [self.model setValue:cmo.value forKey:cmo.key];
                if (!type) {//预览
                    if ([cmo.key isEqualToString:@"subject_id"]) self.model.subject = [IDnameModel mj_objectWithKeyValues:@{@"id":cmo.value,@"name":cmo.text}];
                    if ([cmo.key isEqualToString:@"group_id"]) self.model.group = [IDnameModel mj_objectWithKeyValues:@{@"id":cmo.value,@"name":cmo.text}];
                }
            }
        }
    }
    if (!self.model.content.length) {
        [self presentLoadingTips:@"请输入作业内容"];
        return;
    }
    self.model.images = nil;
    NSMutableArray *marr = [NSMutableArray arrayWithArray:self.imageArray];
    [marr removeObject:self.picture];
    if (type) {//发布 保存
        self.model.imageArr =  nil;
        [self presentLoadingTips];
        if (marr.count) {
            [UploadManager uploadImagesWith:marr uploadFinish:^(NSArray *imFailArr){
                if (imFailArr.count) {
                    [self alertController:@"提示" prompt:[NSString stringWithFormat:@"您有%lu张图片上传失败！，是否继续",(unsigned long)marr.count] sure:@"是" cancel:@"否" success:^{
                        [self UpdateLoad:type];
                    } failure:^{
                        [self dismissTips];
                    }];
                }else{
                    [self UpdateLoad:type];
                }
                
            } success:^(NSDictionary *imgDic, int idx) {
                NSInteger code = [imgDic[@"code"] integerValue];
                if (code == 1) {
                    self.model.images = [imgDic[@"data"][@"url"] SeparatorStr:self.model.images];
                }else{
                    [AlertView showMsg:imgDic[@"msg"]];
                }
            } failure:^(NSError *error, int idx) {
                
            }];
        }else{
            [self UpdateLoad:type];
        }
    }else{//预览
        self.model.imageArr = marr;
        LookOperationViewController *vc = [[LookOperationViewController alloc]init];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
-(OperationHeaderView *)operationView{
    if (_operationView == nil) {
        _operationView = [[NSBundle mainBundle]loadNibNamed:@"OperationHeaderView" owner:nil options:nil].firstObject;
        _operationView.textview.placeholder = @"请输入作业内容...";
        _operationView.model = self.model;
        self.picture = _operationView.picture;
        self.imageArray = _operationView.imageArray;
    }
    return _operationView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray *array = @[@{@"child":@[@{@"name":@"科目",@"placeholder":@"请选择",@"key":@"subject_id",@"rightim":@"1",Tprompt:@"请选择科目"}]
                             },
                           @{@"child":@[@{@"name":@"接受学生组",@"text":@"",@"key":@"group_id",@"rightim":@"1",Tprompt:@"请选择学生组"},
                                        @{@"name":@"作业下发时间",@"text":@"",@"key":@"start_time",@"rightim":@"1",Tprompt:@"请选择作业下发时间"},
                                        @{@"name":@"最晚打卡时间",@"text":@"",@"key":@"end_time",@"rightim":@"1",Tprompt:@"请选择晚打卡时间"},
                                        @{@"name":@"未打卡提醒时间",@"text":@"",@"key":@"clock_time",@"rightim":@"1",Tprompt:@"请选择未打卡提醒时间"}]
                             }];
        for (NSDictionary *dt in array) {
            TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}
-(NSMutableArray *)subjectArray{
    if (!_subjectArray) {
        _subjectArray = [NSMutableArray array];
    }
    return _subjectArray;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH - 60) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
//        _tableView.tableFooterView = self.footerView;
    }
    return _tableView;
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TextSectionModel *smo = self.dataArray[section];
    return smo.child.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    TextSectionModel *smo = self.dataArray[indexPath.section];
    TextFiledModel *cmo = smo.child[indexPath.row];
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 245 + (screenW - 60)/3;
    }
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return self.operationView;
    }
    return [[UIView alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.subjectArray.count) {
            [self showPickerview:self.subjectArray tag:indexPath.row ];
        }else{
            [self presentLoadingTips];
            [self getDataSubjectresult:^(NSArray *arr) {
                [self showPickerview:arr tag:indexPath.row ];
            }];
        }
    }else if (indexPath.section == 1 && indexPath.row ==0 ) {
        TextSectionModel *smo = self.dataArray[indexPath.section];
        TextFiledModel *coldmo = smo.child[indexPath.row];
        StudentGroupViewController *vc = [[StudentGroupViewController alloc]init];
        vc.model = coldmo;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSDate *minDate = [NSDate date];
        NSDate *maxDate = nil;
        if (indexPath.row > 1) {
            TextSectionModel *smo = self.dataArray[1];
            TextFiledModel *coldmo = smo.child[1];
            if (!coldmo.value) {
                [self presentLoadingTips:@"请先选择作业下发时间"];
                return;
            }
            TextFiledModel *coldmo1 = smo.child[2];
            if (indexPath.row == 3 && !coldmo1.value) {
                [self presentLoadingTips:@"请先选择最晚打卡时间"];
                return;
            }
            minDate = [NSDate dateWithTimeIntervalSince1970:[coldmo.value doubleValue]];
            if (indexPath.row == 3) {
                maxDate = [NSDate dateWithTimeIntervalSince1970:[coldmo1.value doubleValue]];
            }
        }
        
        MHDatePicker *date = [[MHDatePicker alloc]init];
        date.tag = indexPath.row;
        date.delegate = self;
        date.isBeforeTime = NO;
        date.datePickerMode = UIDatePickerModeDateAndTime;
        date.minSelectDate = minDate;
        if (maxDate) {
            date.maxSelectDate = maxDate;
        }
        date.Displaystr = @"yyyy-MM-dd HH:mm";
        date.selectDate = date.minSelectDate;
    }

}
-(void)showPickerview:(NSArray *)array tag:(NSInteger )tag{
    PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
    picker.tag = tag;
    picker.delegate = self;
    picker.inter =2;
    picker.titlestr = @"";
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
    if (pc.tag == 0) {//科目
        TextSectionModel *smo = self.dataArray[0];
        TextFiledModel *cmo = smo.child[0];
        for (IDnameModel *mo in self.subjectArray) {
            if ([mo.name isEqualToString:str]) {
                cmo.text = str;
                cmo.value = [NSString stringWithFormat:@"%@",mo.ID];
            }
        }
    }else{
        TextSectionModel *smo1 = self.dataArray[1];
        TextFiledModel *cmo = smo1.child[pc.tag];
        cmo.value = str;
        cmo.text = [UserUtils getShowDateWithTime:str dateFormat:@"yyyy.MM.dd HH:mm"];
    }
   [self.tableView reloadData];
}
#pragma mark - 时间回传值
- (void)timeString:(MHDatePicker *)datePicker timeString:(NSString *)timeString date:(NSDate *)date
{
    TextSectionModel *smo1 = self.dataArray[1];
    TextFiledModel *cmo = smo1.child[datePicker.tag];
    LFLog(@"%@",timeString);
    cmo.value = [NSString stringWithFormat:@"%.f",[date timeIntervalSince1970]];
    cmo.text = timeString;
    [self.tableView reloadData];
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
            if (self.subjectArray.count && result) {
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
-(void)UpdateLoad:(NSString *)type{//1发布，2保存
    NSMutableDictionary *mdt = [self.model mj_keyValues];
    [mdt setObject:type forKey:@"type"];
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP, OperationSubmitUrl) params:mdt viewcontrllerEmpty:self success:^(id response) {
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
