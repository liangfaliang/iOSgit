//
//  LeaveSubmitViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/7.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "LeaveSubmitViewController.h"
#import "AskQuestionTableViewCell.h"
#import "TextFiledLableTableViewCell.h"
#import "TextFiledModel.h"
#import "PlayVoiceTableViewCell.h"
#import "MHDatePicker.h"
#import "LeaveSubModel.h"
#import "UploadManager.h"
@interface LeaveSubmitViewController ()<UITableViewDataSource, UITableViewDelegate,TFPickerDelegate,MHSelectPickerViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableArray *typeArray;
@property(nonatomic, strong)LeaveSubModel *model;
@property(nonatomic,strong)NSMutableArray  *imageArray;
@property(nonatomic,strong)UIImage  *picture;
@end

@implementation LeaveSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle  =@"请假";
    UserModel *model = [UserUtils getUserInfo];
    NSArray *array = @[@{@"name":@"请假人",@"text":model ? model.name :@"",@"key":@"archive_no",@"enable":@"1"},
                       @{@"name":@"类型",@"key":@"leave_category_id",@"rightim":@"1",Tprompt:@"请选择类型！"},
                       @{@"name":@"请假开始时间",@"key":@"start_time",@"rightim":@"1",Tprompt:@"请选择开始时间"},
                       @{@"name":@"请假结束时间",@"key":@"end_time",@"rightim":@"1",Tprompt:@"请选择结束时间"}];
    for (NSDictionary *dt in array) {
        TextFiledModel *model = [TextFiledModel mj_objectWithKeyValues:dt];
        if (self.dataArray.count) {
            model.placeholder = @"请选择";
        }
        [self.dataArray addObject:model];
    }
    [self.view addSubview:self.tableView];
    [self createFootview];
    [self UpData];
    
}
-(void)UpData{
    [super UpData];
    self.page = 1;
    [self getDataType:nil];
}
-(NSMutableArray *)typeArray{
    if (!_typeArray) {
        _typeArray = [NSMutableArray array];
    }
    return _typeArray;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(LeaveSubModel *)model{
    if (!_model) {
        _model = [[LeaveSubModel alloc]init];
    }
    return _model;
}
-(void)createFootview{
    UIButton *footview = [[UIButton alloc]initWithFrame:CGRectMake(15, screenH -  60, screenW -  30,  50)];
    footview.backgroundColor = JHMaincolor;
    [footview setTitle:@"提交" forState:UIControlStateNormal];
    footview.titleLabel.font = [UIFont systemFontOfSize:15];
    [footview addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footview];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH - 60) style:UITableViewStylePlain];
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
#pragma mark - 确定
-(void)submitClick{
    for (TextFiledModel *cmo in self.dataArray) {
        if (!cmo.value.length && cmo.prompt) {
            [self presentLoadingTips:cmo.prompt];
            return;
        }else{
            if (cmo.value.length) {
                [self.model setValue:cmo.value forKey:cmo.key];
            }
            
        }
    }
    if (!self.model.content.length) {
        [self presentLoadingTips:@"请填写理由！"];
        return;
    }
    self.model.images = nil;
    NSMutableArray *marr = [NSMutableArray arrayWithArray:self.imageArray];
    [marr removeObject:self.picture];
    [self presentLoadingTips];
    if (marr.count) {
        NSMutableArray *taskmarr = [UploadManager uploadImagesWith:marr uploadFinish:^(NSArray *imFailArr){
            if (imFailArr.count) {
                [self alertController:@"提示" prompt:[NSString stringWithFormat:@"您有%lu张图片上传失败！，是否继续",(unsigned long)marr.count] sure:@"是" cancel:@"否" success:^{
                    [self UpdateLoad];
                } failure:^{
                    [self dismissTips];
                }];
            }else{
                [self UpdateLoad];
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
        [self addSessionDataTasks:taskmarr];
    }else{
        [self UpdateLoad];
    }
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)    return self.dataArray.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        AskQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AskQuestionTableViewCell class]) forIndexPath:indexPath];
        cell.textTf.hidden = YES;
        cell.tfTop.constant = 0;
        cell.tfBottom.constant = 0;
        cell.lmodel = self.model;
        self.imageArray = cell.imageArray;
        self.picture = cell.picture;
        cell.textView.placeholder = @"请假事由...";
        WEAKSELF;
        cell.collectionHeightRefsh = ^(NSInteger count) {
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
    if (indexPath.section == 0 ) {
        if (indexPath.row == 1) {
            if (self.typeArray.count) {
                [self showPickerview:self.typeArray tag:indexPath.row ];
            }else{
                [self presentLoadingTips];
                [self getDataType:^(NSArray *arr) {
                    [self showPickerview:arr tag:indexPath.row ];
                }];
            }
        }else if (indexPath.row == 2 || indexPath.row == 3){
            if (indexPath.row == 3) {
                TextFiledModel *cmo = self.dataArray[2];
                if (!cmo.value.length) {
                    [self presentLoadingTips:cmo.prompt];
                    return;
                }
            }
            MHDatePicker *date = [[MHDatePicker alloc]init];
            date.tag = indexPath.row;
            date.delegate = self;
            date.isBeforeTime = NO;
            date.datePickerMode = UIDatePickerModeDateAndTime;
//            date.maxSelectDate = [NSDate date];
            date.Displaystr = @"yyyy-MM-dd HH:mm";
        }

    }
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
#pragma mark - 时间回传值
- (void)timeString:(MHDatePicker *)datePicker timeString:(NSString *)timeString date:(NSDate *)date
{
    TextFiledModel *cmo = self.dataArray[datePicker.tag];
    LFLog(@"%@",timeString);
    cmo.value = [NSString stringWithFormat:@"%.f",[date timeIntervalSince1970]];
    cmo.text = timeString;
    [self.tableView reloadData];
}
#pragma mark -------- TFPickerDelegate

- (void)PickerSelectorIndixString:(id)picker str:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    LFLog(@"%@",str);
    TextFiledModel *cmo = self.dataArray[1];
    for (NSDictionary *dt in self.typeArray) {
        if ([dt[@"name"] isEqualToString:str]) {
            cmo.text = str;
            cmo.value = [NSString stringWithFormat:@"%@",dt[@"id"]];
            [self.tableView reloadData];
            return;
        }
    }
}
#pragma mark - 获取类型
-(void)getDataType:(void (^)(NSArray *arr))result{
    [self.typeArray removeAllObjects];
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,LeaveStuCategoryUrl) params:nil viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"获取科目:%@",response);
        NSNumber *code = @([response[@"code"] integerValue]);
        if (code.integerValue == 1) {
            
            [self.typeArray removeAllObjects];
            for (NSDictionary *temDt in response[@"data"]) {
                [self.typeArray addObject:temDt];
            }
            if (result) {
                result(self.typeArray);
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
    [mdt removeObjectForKey:@"status"];
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP, LeaveStuSubmitUrl) params:mdt viewcontrllerEmpty:self success:^(id response) {
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
