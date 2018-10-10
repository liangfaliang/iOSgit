//
//  EditGradeViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/16.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "EditGradeViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "ReleaseGradeTableViewCell.h"
#import "ScoreModel.h"
@interface EditGradeViewController ()<UITableViewDataSource, UITableViewDelegate,TFPickerDelegate>{
    UIView *footer;
}
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableArray *stuArray;
@property(nonatomic, strong)NSMutableArray *subjectArray;
@property(nonatomic, strong)NSMutableArray *GradeCgArray;
@property(nonatomic, strong)NSMutableArray *examArray;
@property(nonatomic, copy)NSString *explain;//考试说明
@property(nonatomic, strong)NSMutableDictionary *sorceDt;
@property(nonatomic, strong)TextSectionModel *stuModel;
@end

@implementation EditGradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = self.typeStyle == EditGradeStyleRelease ? @"测试成绩" :@"查看成绩";
    self.isEmptyDelegate = NO;
    [self.view addSubview:self.tableView];
    if (self.typeStyle != EditGradeStyleNone) {
        [self createFootview];
    }
    [self UpData];
    
}
-(void)UpData{
    [super UpData];
    if (self.typeStyle != EditGradeStyleRelease) {
        [self getDataDetail];
    }else{
        [self getData:nil];
        [self getDataSubjectresult:nil];
        [self getDataGradeCategory:nil];
    }

}
LazyLoadDict(sorceDt)
LazyLoadArray(stuArray)
LazyLoadArray(GradeCgArray)
LazyLoadArray(subjectArray)
LazyLoadArray(examArray)
-(void)createFootview{
    if (footer == nil) {
        footer = [[UIView alloc]initWithFrame:CGRectMake(0, screenH - 60, screenW, 60)];
        footer.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:footer];
    }
    [footer removeAllSubviews];
    NSArray * nameArr = self.typeStyle == EditGradeStyleEdit ? @[@"修改"] : @[@"发布",self.typeStyle == EditGradeStyleSave ? @"编辑" :@"保存"];
    CGFloat wid = nameArr.count == 1 ? (screenW -  30) : (screenW -  45)/2;
    CGFloat xx = nameArr.count == 1 ? 15 : (screenW -  45)/2 + 22.5;
    for (int i = 0; i < nameArr.count; i ++) {
        ImTopBtn *footview = [[ImTopBtn alloc]initWithFrame:CGRectMake(i == 1 ? 15 : xx, 10, wid,  40)];
        if (i == 0) {
            footview.backgroundColor = JHMaincolor;
            [footview setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            footview.backgroundColor = JHbgColor;
            [footview setTitleColor:JHdeepColor forState:UIControlStateNormal];
            [footview setViewBorderColor:JHBorderColor borderWidth:1];
        }
        footview.layer.cornerRadius = 3;
        footview.layer.masksToBounds = YES;
        footview.index = i;
        [footview setTitle:nameArr[i] forState:UIControlStateNormal];
        footview.titleLabel.font = [UIFont systemFontOfSize:15];
        [footview addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
        [footer addSubview:footview];
    }

}
-(void)submitClick:(ImTopBtn *)btn{
    if ([btn.titleLabel.text isEqualToString:@"编辑"] || [btn.titleLabel.text isEqualToString:@"修改"]) {
        for (TextFiledModel *cmo in self.stuModel.child) {
            cmo.enable = @"1";
            cmo.placeholder = @"请输入";
        }
        [self.tableView reloadData];
        [btn setTitle:[btn.titleLabel.text isEqualToString:@"编辑"] ? @"保存" :@"确定" forState:UIControlStateNormal];
        return;
    }
    TextSectionModel *smo = self.dataArray[0];
    TextFiledModel *excmo = smo.child[3];
    if (!excmo.text.length) {
        [self presentLoadingTips:@"请选择考试"];
        return;
    }
    if (!self.stuModel) {
        [self presentLoadingTips:@"请选择班级"];
        return;
    }
    NSMutableArray *marr = [NSMutableArray array];
    for (TextFiledModel *cmo in self.stuModel.child) {
        if (cmo.text.length) {
            [marr addObject:@{@"student_id":cmo.idStr,@"score":cmo.text}];
        }
    }
    if (!marr.count) {
        [self presentLoadingTips:@"请输入分数"];
        return;
    }
    NSMutableDictionary *mdt = [NSMutableDictionary dictionaryWithDictionary:@{@"score":marr}];
    if (self.typeStyle == EditGradeStyleRelease) {
        [mdt setObject:self.stuModel.idStr forKey:@"class_id"];
        [mdt setObject:excmo.value forKey:@"exam_id"];
    }else{
        if (self.ID)  [mdt setObject:self.ID forKey:@"id"];
    }
    if (btn.index == 0) {//发布
        if (self.typeStyle != EditGradeStyleSave) {
            [self UpdateLoad:mdt isRelease:YES];
        }else{
            [self ReleaseGrade:self.ID];
        }
    }else{
        [self UpdateLoad:mdt isRelease:NO];
    }
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray *array = @[@{@"child":@[@{@"name":@"类别",@"key":@"type",Tprompt : @"请选择考试类别！"},
                                        @{@"name":@"科目",@"key":@"subject_id",Tprompt : @"请选择考试科目！"},
                                        @{@"name":@"时间",@"key":@"date",Tprompt : @"请选择时间！"},
                                        @{@"name":@"考试",@"key":@"name",Tprompt : @"请选择考试！"}]
                             },
                           @{@"child":@[@{@"name":@"",@"key":@""}]
                             },
                           @{@"child":@[@{@"name":@"班级",@"key":@"",Tprompt : @"请选择班级！"}]
                             }];
        int i = 0;
        for (NSDictionary *dt in array) {
            TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
            if ((i == 0 || i == 2) && self.typeStyle == EditGradeStyleRelease){
                for (TextFiledModel *cmo in model.child) {
                    cmo.rightim = @"1";
                }
            }
            [_dataArray addObject:model];
            i ++;
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
        _tableView.estimatedSectionHeaderHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"ReleaseGradeTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReleaseGradeTableViewCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"herader"];
    }
    return _tableView;
}


#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count  + (self.stuModel ? 1 :0);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section < self.dataArray.count) {
        TextSectionModel *smo = self.dataArray[section];
        return smo.child.count;
    }

    return self.stuModel.child.count ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        ReleaseGradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReleaseGradeTableViewCell" forIndexPath:indexPath];
//        cell.backView.hidden = YES;
//        cell.backViewHeight.constant = 0;
//        cell.contentLb.hidden = NO;
        cell.textview.userInteractionEnabled = NO;
        cell.textview.text = self.explain;
        return cell;
    }
    __block   TextSectionModel *smo = (indexPath.section < self.dataArray.count) ? self.dataArray[indexPath.section] : self.stuModel;
    __block  TextFiledModel *cmo = smo.child[indexPath.row];
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    cell.NameTfSpace.constant = 50;
    cell.nameBtn.titleLabel.numberOfLines = 1;
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    cell.textfiled.keyboardType = UIKeyboardTypeNumberPad;
    cell.nameBtn.userInteractionEnabled =NO;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) return 40;
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 if(section ==  1){
        UIView *hview = [[UIView alloc]init];
        UILabel *lb = [UILabel initialization:CGRectMake(15, 0, screenW - 30, 40) font:[UIFont systemFontOfSize:14] textcolor:JHmiddleColor numberOfLines:0 textAlignment:0];
        lb.text = @"测试说明";
        [hview addSubview:lb];
        return hview;
    }
    return nil;
}
-(void)headerClick:(UITapGestureRecognizer *)tap{
    TextSectionModel *smo = self.stuArray[tap.view.tag - self.dataArray.count];
    smo.isSelect = smo.isSelect ? 0 : 1;
    [self.tableView reloadData];
    //    header.model = cmo;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.dataArray.count) {
        if (self.typeStyle != EditGradeStyleRelease) {
            return;
        }
        if (indexPath.section == 0 && indexPath.row == 0 ) {//类别
            if (self.GradeCgArray.count) {
                [self showPickerview:self.GradeCgArray tag:indexPath.row ];
            }else{
                [self presentLoadingTips];
                [self getDataGradeCategory:^(NSArray *arr) {
                    [self showPickerview:arr tag:indexPath.row ];
                }];
            }
            
        }else if (indexPath.section == 0 && indexPath.row == 1 ) {//科目
            if (self.subjectArray.count) {
                [self showPickerview:self.subjectArray tag:indexPath.row ];
            }else{
                [self presentLoadingTips];
                [self getDataSubjectresult:^(NSArray *arr) {
                    [self showPickerview:arr tag:indexPath.row ];
                }];
            }
        }else if (indexPath.section == 0 && indexPath.row == 2 ) {//时间
            [self showPickerview:nil tag:indexPath.row ];
        }else if (indexPath.section == 0 && indexPath.row == 3 ) {//时间
            if (self.examArray.count) {
                [self showPickerview:self.examArray tag:indexPath.row ];
            }else{
                [self getDataExam:^(NSArray *arr) {
                    if (arr.count) {
                        [self showPickerview:arr tag:indexPath.row ];
                    }else{
                        [self presentLoadingTips:@"暂无可选考试"];
                    }
                    
                }];
            }
        }else if (indexPath.section == 2 && indexPath.row == 0 ) {//班级
            if (self.stuArray.count) {
                [self showPickerview:self.stuArray tag:4];
            }else{
                [self presentLoadingTips];
                [self getData:^(NSArray *arr) {
                    [self showPickerview:arr tag:indexPath.row ];
                }];
            }
        }
        return;
    }

}
-(void)showPickerview:(NSArray *)array tag:(NSInteger )tag{
    PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:self.view.bounds];
    picker.tag = tag;
    picker.titlestr = @"";
    picker.inter =2;
    picker.delegate = self;
    if (tag == 2) {
        picker.arrayType = YMDWarray;
    }else{
        picker.arrayType = HeightArray;
        for (int i = 0; i < array.count; i ++) {
            id mo = array[i];
            [picker.typearr addObject:[mo valueForKey:@"name"]];
        }
    }

    [self.view addSubview:picker];
}
#pragma mark -------- TFPickerDelegate

- (void)PickerSelectorIndixString:(id)picker str:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    PickerChoiceView *pc = (PickerChoiceView *)picker;
    LFLog(@"%@",str);
    TextSectionModel *smo = self.dataArray[pc.tag != 4 ? 0 : 2];
    TextFiledModel *cmo = smo.child[pc.tag != 4 ? pc.tag : 0];
    if (pc.tag != 2) {//科目
        NSMutableArray *marr = pc.tag == 0 ? self.GradeCgArray : (pc.tag == 1 ? self.subjectArray : (pc.tag == 3 ? self.examArray : self.stuArray) ) ;
        for (id mo in marr) {
            if ([[mo valueForKey:@"name"] isEqualToString:str]) {
                cmo.text = str;
                if ([mo isKindOfClass:[IDnameModel class]]) {
                    IDnameModel * idmo = (IDnameModel *)mo;
                    cmo.value = [NSString stringWithFormat:@"%@",idmo.ID];
                    if (pc.tag == 3) {
                        self.explain = idmo.data[@"explain"];
                    }
                }else{
                    self.stuModel = mo;
                    cmo.value = [NSString stringWithFormat:@"%@",self.stuModel.idStr];
                }

            }
        }
    }else{
        cmo.value = [UserUtils getShowDateWithTime:str dateFormat:@"yyyy-MM-dd"];
        cmo.text = [UserUtils getShowDateWithTime:str dateFormat:@"yyyy.MM.dd"];
    }
    if (pc.tag != 3 && pc.tag != 4) {
        TextFiledModel *excmo = smo.child[3];
        excmo.text = nil;
        excmo.value = nil;
        self.explain = nil;
        [self.examArray removeAllObjects];
        [self getDataExam:nil];
    }
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
            if (self.GradeCgArray.count && result) {
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

#pragma mark - 获取考试
-(void)getDataExam:(void (^)(NSArray *arr))result{
    NSMutableDictionary *mdt = [NSMutableDictionary dictionary];
    TextSectionModel *smo = self.dataArray[0];
    for (int i = 0; i < smo.child.count - 1; i ++) {
        TextFiledModel *cmo = smo.child[i];
        if ( !cmo.value.length && cmo.prompt ) {
            if (result) [self presentLoadingTips:cmo.prompt];
            return;
        }else{
            if (cmo.value.length) {
                [mdt setObject:cmo.value forKey:cmo.key];
            }
        }
    }
    if (result) [self presentLoadingTips];
    [self.examArray removeAllObjects];
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP, GradeEmaxUrl  ) params:mdt viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"获取科目:%@",response);
        NSNumber *code = @([response[@"code"] integerValue]);
        if (code.integerValue == 1) {
            [self.examArray removeAllObjects];
            for (NSDictionary *temDt in response[@"data"]) {
                IDnameModel *mo = [IDnameModel mj_objectWithKeyValues:temDt];
                mo.data = temDt;
                [self.examArray addObject:mo];
            }
            if (result) {
                result(self.examArray);
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
- (void)getDataDetail{
    //NSStringWithFormat(SERVER_IP,IntegralTeaListUrl)
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,GradeInsDetailUrl) params:self.ID ? @{@"id":self.ID} : nil viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
            TextSectionModel *smo = self.dataArray[0];
            int i = 0;
            for (TextFiledModel *cmo in smo.child) {
                NSString *key = i == 1 ? @"subject" : cmo.key;
                if (response[@"data"][key]) {
                    cmo.text = response[@"data"][key];
                }
                i ++;
            }
            [TextSectionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"idStr" : @"id",@"child" : @"student"};
            }];
            [TextFiledModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{TidStr : @"student_id",Ttext : @"score"};
            }];
            self.stuModel = [TextSectionModel mj_objectWithKeyValues:response[@"data"][@"class"]];
            [TextFiledModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return nil;
            }];
            [TextSectionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return nil;
            }];
            TextSectionModel *classSmo = self.dataArray[2];
            TextFiledModel *classCmo = classSmo.child.firstObject;
            classCmo.text = self.stuModel.name;
            self.explain = response[@"data"][@"explain"];
            [self.sorceDt removeAllObjects];
            for (NSDictionary *temdt in response[@"data"][@"score"]) {
                if (![temdt[@"student_id"] isKindOfClass:[NSNull class]] && ![temdt[@"score"] isKindOfClass:[NSNull class]]) {
                    [self.sorceDt setObject:lStringFor(temdt[@"score"]) forKey:lStringFor(temdt[@"student_id"])];
                }

            }
            if (self.typeStyle == EditGradeStyleNone) {
                if (response[@"data"][@"status"]) {
                    self.typeStyle = [lStringFor(response[@"data"][@"status"]) isEqualToString:@"1"] ? EditGradeStyleSave : EditGradeStyleEdit;
                }
                [self createFootview];
            }
            
//            [self getData];
        }else{
            [self presentLoadingTips:response[@"msg"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - 获取列表
- (void)getData:(void (^)(NSArray *arr))result{
    //NSStringWithFormat(SERVER_IP,IntegralTeaListUrl)
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,AttendanceGetStuUrl) params:nil viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"] ) {
            [self.stuArray removeAllObjects];
            //            self.more = [response[@"data"][@"isEnd"] integerValue];
            [TextFiledModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"idStr" : @"id"};
            }];
            [TextSectionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"idStr" : @"id",@"child" : @"student"};
            }];
            for (NSDictionary *temDt in response[@"data"]) {
                TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:temDt];
                model.tfmodel = [TextFiledModel mj_objectWithKeyValues:@{@"name":temDt[@"name"],@"idStr":temDt[@"id"],@"leftim":@"enter"}];
                for (TextFiledModel *cmo in model.child) {
                    if (self.typeStyle == EditGradeStyleRelease) {
                        cmo.placeholder = @"请输入";
                        cmo.enable = @"1";
                    }else{
                        if (self.sorceDt[cmo.idStr]) {
                            cmo.text = self.sorceDt[cmo.idStr];
                        }
                    }
                }
                model.isSelect = 1;//默认展开
                [self.stuArray addObject:model];
            }
            [TextFiledModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return nil;
            }];
            [TextSectionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return nil;
            }];
            if (result) {
                result(self.stuArray);
            }
        }else{
            [self presentLoadingTips:response[@"msg"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark 提交
-(void)UpdateLoad:(NSMutableDictionary *)mdt isRelease:(BOOL )isRelease{

    [LFLHttpTool post:NSStringWithFormat(SERVER_IP, self.typeStyle == EditGradeStyleRelease ? GradeAddUrl : GradeEditUrl) params:mdt viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"tijaio:%@",response);
        NSNumber *code = @([response[@"code"] integerValue]);
        if (code.integerValue == 1) {
            NSLog(@"注册成功");
            if (isRelease && self.typeStyle == EditGradeStyleRelease) {
                [AlertView showProgress];
                [self ReleaseGrade:response[@"data"][@"id"]];
            }else{
                [AlertView showMsg:response[@"msg"]];
                if (self.successBlock) {
                    self.successBlock();
                }
                [self performSelector:@selector(dismissView) withObject:nil afterDelay:2.];
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
-(void)ReleaseGrade:(NSString *)Id{
    
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP, GradeReleaseUrl) params: Id ? @{@"id":Id} : nil viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        [AlertView dismiss];
        LFLog(@"tijaio:%@",response);
        NSNumber *code = @([response[@"code"] integerValue]);
        if (code.integerValue == 1) {
            NSLog(@"注册成功");
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        [AlertView showMsg:response[@"msg"]];
        
    } failure:^(NSError *error) {
        [self dismissTips];
        [AlertView dismiss];
        LFLog(@"error：%@",error);
    }];
}
-(void)dismissView{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

