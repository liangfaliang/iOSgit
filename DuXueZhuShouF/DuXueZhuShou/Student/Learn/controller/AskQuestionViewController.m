//
//  AskQuestionViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AskQuestionViewController.h"
#import "AskQuestionTableViewCell.h"
#import "TextFiledLableTableViewCell.h"
#import "TextFiledModel.h"
#import "PlayVoiceTableViewCell.h"
#import "RecordManage.h"
#import "UploadManager.h"


@interface AskQuestionViewController ()<UITableViewDataSource, UITableViewDelegate,TFPickerDelegate>
@property(nonatomic, strong)RecordManage *recoreM;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableArray *subjectArray;
@property(nonatomic, strong)NSMutableArray *teacherArray;
@property(nonatomic,strong)NSMutableArray  *imageArray;
@property(nonatomic,strong)UIImage  *picture;
@property(nonatomic, assign)BOOL isRecording;//是否正在录音
@property(nonatomic,strong)AnswerModel  *model;
@property (nonatomic, strong) UIView *selectTimeView;
@end

@implementation AskQuestionViewController
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.recoreM removeTimer];
    [self.recoreM stopPlay];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([UserUtils getUserRole] == UserStyleStudent) {
        self.navigationBarTitle  =@"提问";
    }else if ([UserUtils getUserRole] == UserStyleTeacher){
        self.navigationBarTitle  =@"回复";
    }
    
    self.model = [[AnswerModel alloc]init];
    self.isRecording = YES;
    [self.recoreM DeleteFile];
    NSArray *array = @[@{@"name":@"科目",@"key":@"archive_no",@"rightim":@"1"},
                       @{@"name":@"@",@"key":@"archive_no",@"rightim":@"1"},
                       @{@"name":@"@",@"key":@"archive_no",@"rightim":@"1"},
                       @{@"name":@"@",@"key":@"archive_no",@"rightim":@"1"}];
    for (NSDictionary *dt in array) {
        TextFiledModel *model = [TextFiledModel mj_objectWithKeyValues:dt];
        [self.dataArray addObject:model];
    }
    [self.view addSubview:self.tableView];
    [self createFootview];
    [self UpData];
    
}
-(void)UpData{
    [super UpData];
    self.page = 1;
    [self getDataSubject:nil result:nil];
}
-(NSMutableArray *)teacherArray{
    if (!_teacherArray) {
        _teacherArray = [NSMutableArray array];
    }
    return _teacherArray;
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
    }
    return _dataArray;
}
-(UIView *)selectTimeView{
    if (!_selectTimeView) {
        
        _selectTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW - 30 , 40)];
        for (int i = 0; i < 2; i ++) {
            ImTopBtn *btn = [[ImTopBtn alloc]initWithFrame:CGRectMake(i * 100, 0, 100, _selectTimeView.height_i)];
            btn.index = i;
            [btn addTarget:self action:@selector(SelectTimeClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"choosed"] forState:UIControlStateSelected];
            [btn setTitleColor:JHdeepColor forState:UIControlStateSelected];
            [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"   %@",i ? @"公开" : @"普通"] forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"   %@",i ? @"公开" : @"普通"] forState:UIControlStateSelected];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            if (i == 0) {
                btn.selected = YES;
                self.model.is_open = @"0";
            }
            [_selectTimeView addSubview:btn];
        }
    }
    return _selectTimeView;
}
-(void)SelectTimeClick:(ImTopBtn *)btn{
    btn.selected = YES;
    for (UIButton *sender in self.selectTimeView.subviews) {
        if (btn != sender) {
            sender.selected = NO;
        }
    }
    self.model.is_open = btn.index ? @"1" : @"0";
}
-(RecordManage *)recoreM{
    if (_recoreM == nil) {
        _recoreM = [[RecordManage alloc]initCofig];
        WEAKSELF;
        _recoreM.RecordResultBlock = ^(BOOL success) {
            if (success) {//成功
                [weakSelf.tableView reloadData];
            }else{
                
            }
        };
    }
    return _recoreM;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH -60) style:UITableViewStylePlain];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"AskQuestionTableViewCell" bundle:nil] forCellReuseIdentifier:@"AskQuestionTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PlayVoiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"PlayVoiceTableViewCell"];
        
    }
    return _tableView;
}
-(void)createFootview{
    UIButton *footview = [[UIButton alloc]initWithFrame:CGRectMake(15, screenH -  60, screenW -  30,  50)];
    footview.backgroundColor = JHMaincolor;
    [footview setTitle:@"确定" forState:UIControlStateNormal];
    footview.titleLabel.font = [UIFont systemFontOfSize:15];
    [footview addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footview];
}
#pragma mark - 确定
-(void)submitClick{
    if ([UserUtils getUserRole] == UserStyleStudent && !self.answer_type) {
        self.model.teachers_id  = nil;
        for (int i = 0; i < self.dataArray.count; i ++) {
            if (i > 0) {
                TextFiledModel *cmo = self.dataArray[i];
                if (cmo.value) {
                    self.model.teachers_id = [cmo.value SeparatorStr:self.model.teachers_id];
                }
            }
        }
        if (!self.model.title) {
            [self presentLoadingTips:@"请输入标题!"];
            return;
        }
        if (!self.model.subject_id) {
            [self presentLoadingTips:@"请选择科目!"];
            return;
        }
        if (!self.model.teachers_id) {
            [self presentLoadingTips:@"请选择老师!"];
            return;
        }
    }

    
    NSMutableArray *marr = [NSMutableArray arrayWithArray:self.imageArray];
    [marr removeObject:self.picture];
    if ([RecordManage isFileExist]) {
        [marr addObject:RecordAudioFilePath];
    }
    if (marr.count) {
        NSMutableArray *taskmarr = [UploadManager uploadImagesWith:marr uploadFinish:^(NSArray *imFailArr){
            if (imFailArr.count) {
                [self alertController:@"提示" prompt:[NSString stringWithFormat:@"您有%lu张图片上传失败！，是否继续",(unsigned long)marr.count] sure:@"是" cancel:@"否" success:^{
                    [self UpdateLoad];
                } failure:^{
                    
                }];
            }else{
                [self UpdateLoad];
            }
            
        } success:^(NSDictionary *imgDic, int idx) {
            NSInteger code = [imgDic[@"code"] integerValue];
            if (code == 1) {
                if ([imgDic[@"data"][@"type"] isEqualToString:@"1"]) {
                    self.model.images = [imgDic[@"data"][@"url"] SeparatorStr:self.model.images];
                }else if ([imgDic[@"data"][@"type"] isEqualToString:@"2"]){
                    self.model.url = imgDic[@"data"][@"url"];
                }
            }else{
                [AlertView showMsg:imgDic[@"msg"]];
            }
        } failure:^(NSError *error, int idx) {
            
        }];
        [self addSessionDataTasks:taskmarr];
    }else{
        [self UpdateLoad];
    }

//    [UserUtils postPicture:marr type:@"1@@1" success:^(id response) {
//        LFLog(@"多图上传：%@",response);
//    } failure:^(NSError *error) {
//        LFLog(@"多图上传error：%@",error);
//    }];
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([UserUtils getUserRole] == UserStyleStudent) {
        return self.answer_type ? 2 : 3;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2)    return self.dataArray.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        AskQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AskQuestionTableViewCell class]) forIndexPath:indexPath];
        cell.model = self.model;
        self.imageArray = cell.imageArray;
        self.picture = cell.picture;
        if ([UserUtils getUserRole] == UserStyleStudent) {
            if (self.answer_type) {
                cell.textTf.placeholder = nil;
                cell.textView.placeholder = @"请输入您要回复的内容...";
                cell.textTf.hidden = YES;
                cell.vlineHeight.constant = 0;
                cell.tfHeight.constant = 0;
            }else{
                cell.textView.placeholder = @"请描述内容";
            }
        }else if ([UserUtils getUserRole] == UserStyleTeacher){
            cell.textView.placeholder = @"请输入您要回复的内容...";
            cell.textTf.leftView = self.selectTimeView;
            cell.textTf.leftViewMode = UITextFieldViewModeAlways;
            cell.vlineHeight.constant = 0;
        }
        WEAKSELF;
        cell.collectionHeightRefsh = ^(NSInteger count) {
            [weakSelf.tableView reloadData];
        };
        return cell;
    }
    if (indexPath.section == 1) {
        PlayVoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PlayVoiceTableViewCell class]) forIndexPath:indexPath];
        
        if ([RecordManage isFileExist]) {
            cell.deleteBtn.hidden = NO;
            cell.playIm.hidden = NO;
            cell.timeLb.hidden = NO;
            cell.timeLb.text = [NSString stringWithFormat:@"%ld\"",(long)self.recoreM.countDown];
            [cell.playBtn setImage:[UIImage imageNamed:@"ting"] forState:UIControlStateSelected];
            cell.nameLb.text = @"点击播放";
        }else{
            cell.deleteBtn.hidden = YES;
            cell.playIm.hidden = YES;
            cell.timeLb.hidden = YES;
            cell.nameLb.text = @"按住录音";
            [cell.playBtn setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        }
        WEAKSELF;
        cell.playBtnBlock = ^(BOOL isDown) {
            if (isDown) {//按下
                if (![RecordManage isFileExist]) {
                    [weakSelf.recoreM startRecord:^(BOOL success) {
                        if (success) {//开始录音
                            
                        }else{//录音失败
                            
                        }
                    }];
                    self.isRecording = YES;
                }else{
                    self.isRecording = NO;
                }
                
            }else{//松开
                [weakSelf.recoreM stopRecord];
                if (!self.isRecording && [RecordManage isFileExist]) {
                    [weakSelf.recoreM PlayRecord];
                }
            }

        };
        cell.deleteBlock = ^{
            [weakSelf.recoreM DeleteFile];
            [weakSelf.tableView reloadData];
        };
        return cell;
    }

    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    TextFiledModel *cmo = self.dataArray[indexPath.row];
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            if (self.subjectArray.count) {
                [self showPickerview:self.subjectArray tag:indexPath.row ];
            }else{
                [self presentLoadingTips];
                [self getDataSubject:nil result:^(NSArray *arr) {
                    [self showPickerview:arr tag:indexPath.row ];
                }];
            }
        }else{
            TextFiledModel *cmo = self.dataArray[0];
            if (!cmo.value) {
                [self presentLoadingTips:@"请先选择科目！"];
                return;
            }
            if (self.teacherArray.count) {
                [self showPickerview:self.teacherArray tag:indexPath.row ];
            }else{
                [self presentLoadingTips];
                [self getDataSubject:cmo.value result:^(NSArray *arr) {
                    [self showPickerview:arr tag:indexPath.row ];
                }];
            }
        }
    }
}
-(void)showPickerview:(NSArray *)array tag:(NSInteger )tag{
    PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
    picker.tag = tag;
    picker.titlestr = @"";
    picker.inter =2;
    picker.delegate = self;
//    picker.arrayType = YMDWarray;
    picker.arrayType = HeightArray;
    for (int i = 0; i < array.count; i ++) {
        if (tag == 0) {
            [picker.typearr addObject:array[i][@"name"]];

        }else{
            BOOL isAdd = YES;
            for (int j = 1; j < self.dataArray.count; j ++) {
                if (j != tag && isAdd) {
                    TextFiledModel *cmo = self.dataArray[j];
                    if (cmo.text && [array[i][@"name"] isEqualToString:cmo.text]) {
                        isAdd = NO;

                    }
                }

            }
            if (isAdd) [picker.typearr addObject:array[i][@"name"]];
        }

    }
    [self.view addSubview:picker];
}
#pragma mark -------- TFPickerDelegate

- (void)PickerSelectorIndixString:(id)picker str:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    PickerChoiceView *pc = (PickerChoiceView *)picker;
    LFLog(@"%@",str);
    TextFiledModel *cmo = self.dataArray[pc.tag];
    NSArray *temarr = nil;
    if (pc.tag == 0) {//科目
        temarr = self.subjectArray;
    }else{
        temarr =self.teacherArray;
    }
    for (NSDictionary *dt in temarr) {
        if ([dt[@"name"] isEqualToString:str]) {
            BOOL isUpdte = YES;//是否更新所选老师
            if (cmo.text == str) isUpdte = NO;
            cmo.text = str;
            cmo.value = [NSString stringWithFormat:@"%@",dt[@"id"]];
            [self.tableView reloadData];
            if (pc.tag == 0) {
                if (isUpdte) {
                    for (int i = 1; i < self.dataArray.count; i ++) {
                        TextFiledModel *cmo = self.dataArray[i];
                        cmo.value = nil;
                        cmo.text = nil;
                    }
                }
                self.model.subject_id = cmo.value;
                [self getDataSubject:cmo.value result:nil];
            }
            return;
        }
    }
}

#pragma mark - 获取科目
-(void)getDataSubject:(NSString *)codeid result:(void (^)(NSArray *arr))result{
    if (!codeid) {
        [self.subjectArray removeAllObjects];
    }else{
        [self.teacherArray removeAllObjects];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,codeid ? AnswerSubjectTeacherUrl : AnswerSubjectsUrl  ) params:codeid ? @{@"id":codeid} :nil viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"获取科目:%@",response);
        NSNumber *code = @([response[@"code"] integerValue]);
        if (code.integerValue == 1) {
            if (result) {
                result(response[@"data"]);
            }
            if (!codeid) {
                [self.subjectArray removeAllObjects];
                for (NSDictionary *temDt in response[@"data"]) {
                    [self.subjectArray addObject:temDt];
                }
            }else{
                [self.teacherArray removeAllObjects];
                for (NSDictionary *temDt in response[@"data"]) {
                    [self.teacherArray addObject:temDt];
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
#pragma mark 提交
-(void)UpdateLoad{
    NSMutableDictionary *mdt = [self.model mj_keyValues];
    if (self.answer_type && [UserUtils getUserRole] == UserStyleTeacher) {
        [mdt setObject:self.answer_type forKey:@"answer_type"];
    }
    if (self.ID) {
        [mdt setObject:self.ID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,[UserUtils getUserRole] == UserStyleStudent ?(self.answer_type ? AnswerReplySubmitUrl : AnswerSubmitUrl) : AnswerTeacherSubmitUrl) params:mdt viewcontrllerEmpty:self success:^(id response) {
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
