//
//  SelectStudentViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/29.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "SelectStudentViewController.h"
#import "TextFiledLableTableViewCell.h"
@interface SelectStudentViewController ()<UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation SelectStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"选择学生" ;
    [self.view addSubview:self.tableView];
    [self UpData];
    [self createFootview];
}
-(void)UpData{
    [super UpData];
    [self getData];
}
-(void)createFootview{
    UIButton *footview = [[UIButton alloc]initWithFrame:CGRectMake(15, screenH -  60, screenW -  30,  50)];
    footview.backgroundColor = JHMaincolor;
    [footview setTitle:@"确定" forState:UIControlStateNormal];
    footview.titleLabel.font = [UIFont systemFontOfSize:15];
    [footview addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footview];
}
-(void)submitClick{
    NSMutableArray *mstr = [[NSMutableArray alloc]init];
    for (TextSectionModel *smo in self.dataArray) {
        for (TextFiledModel *cmo in smo.child) {
            if (cmo.isSelect && cmo.idStr.length) {
                [mstr addObject:cmo.idStr];
            }
        }
    }
    if (!mstr.count) {
        [self presentLoadingTips:@"请选择学生！"];
        return;
    }
    self.model.student = mstr;
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
//        NSArray *array = @[@{@"tfmodel":@{@"name":@"科目",@"leftim":@"enter",@"key":@"status",@"rightim":@"1",@"image":@"choose"},
//                             @"child":@[@{@"name":@"科目",@"key":@"status",@"rightim":@"1",@"image":@"choose"}]
//                             },
//                           @{@"tfmodel":@{@"name":@"科目",@"leftim":@"enter",@"key":@"status",@"rightim":@"1",@"image":@"choose"},
//                             @"child":@[@{@"name":@"接受学生组",@"text":@"",@"key":@"",@"rightim":@"1",@"image":@"choose"},
//                                        @{@"name":@"作业下发时间",@"text":@"",@"key":@"",@"rightim":@"1",@"image":@"choose"},
//                                        @{@"name":@"最晚打卡时间",@"text":@"",@"key":@"",@"rightim":@"1",@"image":@"choose"},
//                                        @{@"name":@"未打卡提醒时间",@"text":@"",@"key":@"",@"rightim":@"1",@"image":@"choose"},
//                                        @{@"name":@"接受学生组",@"text":@"",@"key":@"",@"rightim":@"1",@"image":@"choose"},
//                                        @{@"name":@"作业下发时间",@"text":@"",@"key":@"",@"rightim":@"1",@"image":@"choose"},
//                                        @{@"name":@"最晚打卡时间",@"text":@"",@"key":@"",@"rightim":@"1",@"image":@"choose"},
//                                        @{@"name":@"未打卡提醒时间",@"text":@"",@"key":@"",@"rightim":@"1",@"image":@"choose"}]
//                             }];
//        for (NSDictionary *dt in array) {
//            TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
//            model.tfmodel.name = [NSString stringWithFormat:@"%@",model.tfmodel.name];
//            [_dataArray addObject:model];
//        }
        
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
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"herader"];
    }
    return _tableView;
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TextSectionModel *smo = self.dataArray[section];
    return smo.isSelect ? smo.child.count :0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    cell.NameTfSpace.constant = 50;
    cell.nameBtn.titleLabel.numberOfLines = 1;
    __block   TextSectionModel *smo = self.dataArray[indexPath.section];
    __block  TextFiledModel *cmo = smo.child[indexPath.row];
    if (cmo.isSelect) {
        cmo.image = @"choosed";
    }else{
        cmo.image = @"choose";
    }
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    cell.nameBtn.userInteractionEnabled =NO;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return -1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TextFiledLableTableViewCell *header = [tableView dequeueReusableCellWithIdentifier:@"herader"];
    header.nameBtn.userInteractionEnabled = NO;
    header.nameBtn.titleLabel.numberOfLines = 1;
    header.backgroundColor = [UIColor whiteColor];
    header.tag = section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerClick:)];
    tap.cancelsTouchesInView = NO;
    [header addGestureRecognizer:tap];
    __block TextSectionModel *smo = self.dataArray[section];
    smo.tfmodel.image = smo.tfmodel.isSelect ? @"choosed" :@"choose" ;
    smo.tfmodel.leftim = smo.isSelect ? @"xlh" :@"enter" ;
    TextFiledModel *cmo = smo.tfmodel;
    header.model = cmo;
    header.NameTfSpace.constant = screenW - [cmo.name selfadapUifont:header.nameBtn.titleLabel.font weith:30].width - 40 - header.nameBtn.imageView.image.size.width - 40;
    WEAKSELF;
    header.rightViewBlock = ^{
        cmo.isSelect = cmo.isSelect ? 0 : 1;
        for (TextFiledModel *chmo in smo.child) {
            chmo.isSelect = cmo.isSelect;
        }
        cmo.image = cmo.isSelect ? @"choosed" :@"choose" ;
        [weakSelf.tableView reloadData];
    };

    return header;
}
-(void)headerClick:(UITapGestureRecognizer *)tap{
    TextFiledLableTableViewCell *header = (TextFiledLableTableViewCell *)tap.view;
    TextSectionModel *smo = self.dataArray[header.tag];
    smo.isSelect = smo.isSelect ? 0 : 1;
    [self.tableView reloadData];
    //    header.model = cmo;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TextFiledLableTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    TextSectionModel *smo = self.dataArray[indexPath.section];
    TextFiledModel *cmo = smo.child[indexPath.row];
    cmo.isSelect = cmo.isSelect ? 0 : 1;
    cmo.image = cmo.isSelect ? @"choosed" :@"choose" ;
    cell.model = cmo;
    for (TextFiledModel *temCmo in smo.child) {
        if (temCmo.isSelect != cmo.isSelect) {
            smo.tfmodel.isSelect  = 0;
            [self.tableView reloadData];
            return ;
        }
    }
    smo.tfmodel.isSelect = cmo.isSelect;
    [self.tableView reloadData];
    
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (!self.dataArray.count) {
        return  [super buttonTitleForEmptyDataSet:scrollView forState:state];
    }
    return nil;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    if (!self.dataArray.count) {
        [super emptyDataSet:scrollView didTapButton:button];
    }
}

#pragma mark - 获取列表
- (void)getData{
    //NSStringWithFormat(SERVER_IP,IntegralTeaListUrl)
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,AttendanceGetStuUrl) params:nil viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"] ) {
            [self.dataArray removeAllObjects];
//            self.more = [response[@"data"][@"isEnd"] integerValue];
            [TextFiledModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"idStr" : @"id"};
            }];
            [TextSectionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"idStr" : @"id",@"child" : @"student"};
            }];
            for (NSDictionary *temDt in response[@"data"]) {
                TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:temDt];
                model.tfmodel = [TextFiledModel mj_objectWithKeyValues:@{@"name":temDt[@"name"],@"idStr":temDt[@"id"],@"leftim":@"enter",@"rightim":@"1",@"image":@"choose",@"unedit":@"1",@"enable":@"1"}];
                model.tfmodel.isSelect = 1;
                for (TextFiledModel *cmo in model.child) {
                    cmo.rightim = @"1";
                    cmo.rightim = @"choose";
                    if (self.model.student) {
                        for (id IDstr in self.model.student) {
                            if ([cmo.idStr isEqualToString:[IDstr isKindOfClass:[NSString class]] ? IDstr : lStringFor(IDstr[@"id"])]) {
                                cmo.isSelect = 1;
                            }
                        }
                    }
                    if (!cmo.isSelect) model.tfmodel.isSelect = 0;
                }
                model.isSelect = 1;//默认展开
                [self.dataArray addObject:model];
            }
            [TextFiledModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return nil;
            }];
            [TextSectionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return nil;
            }];
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
