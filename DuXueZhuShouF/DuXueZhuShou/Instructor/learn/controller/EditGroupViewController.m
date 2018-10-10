//
//  EditGroupViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/14.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "EditGroupViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "YBPopupMenu.h"
#import "AttendSubmitModel.h"
#import "AddSignInViewController.h"
@interface EditGroupViewController ()<UITableViewDataSource, UITableViewDelegate,YBPopupMenuDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, retain)AttendSubmitModel *model;
@end

@implementation EditGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = self.titleStr;
    self.isEmptyDelegate = NO;
    [self.view addSubview:self.tableView];
    [self createBaritem];
    [self UpData];
    
}
-(void)UpData{
    [super UpData];
    self.page = 1;
    self.more = 0;
    [self getData];
    [self getDataStuList];
    
}
-(void)createBaritem{
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    self.navigationItem.rightBarButtonItem = rightBar;
}
-(void)rightClick:(UIBarButtonItem *)sender{
    [YBPopupMenu showAtPoint:CGPointMake(screenW - 30, SAFE_NAV_HEIGHT) titles:@[@"编辑", @"解散"] icons:nil menuWidth:80 otherSettings:^(YBPopupMenu *popupMenu) {
//        popupMenu.dismissOnSelected = NO;
        popupMenu.type = YBPopupMenuTypeDefault;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = self;
        popupMenu.offset = 5;
        popupMenu.textColor = JHMaincolor;
        
//        popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    }];

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
//            model.tfmodel.name = [NSString stringWithFormat:@"%@                                                                                                                                                                                                                                                                                                                                ",model.tfmodel.name];
//            //            for (TextFiledModel *cmo in model.child) {
//            //                cmo.name = [NSString stringWithFormat:@"%@                                                                                                                                                                                                                                                                                                                                ",cmo.name];
//            //            }
//            [_dataArray addObject:model];
//        }
        
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
        _tableView.estimatedSectionHeaderHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"herader"];
    }
    return _tableView;
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    //推荐回调
    NSLog(@"点击了 %@ 选项",ybPopupMenu.titles[index]);
    if (index == 1) {//解散
        [self alertController:@"确定解散该学生组" prompt:nil sure:@"确定" cancel:@"取消" success:^{
            [self DisbandData];
        } failure:^{
            
        }];
    }else{//编辑
        AddSignInViewController *vc = [[AddSignInViewController alloc]init];
        vc.isEdit = YES;
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }

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
    cmo.image = cmo.isSelect ? @"choosed" :@"choose" ;
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    cell.nameBtn.userInteractionEnabled = NO;
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
    return header;
}
-(void)headerClick:(UITapGestureRecognizer *)tap{
    TextFiledLableTableViewCell *header = (TextFiledLableTableViewCell *)tap.view;
    TextSectionModel *smo = self.dataArray[header.tag];
    smo.isSelect = smo.isSelect ? 0 : 1;
    [self.tableView reloadData];
    //    header.model = cmo;
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
#pragma mark - 获取详情
- (void)getData{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.ID) {
        [dt setObject:self.ID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,AttendanceDetailUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1 && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
            self.model = [AttendSubmitModel mj_objectWithKeyValues:response[@"data"]];
            if (self.model && self.model.student) {
                NSMutableArray *marr  = [NSMutableArray array];
                for (NSDictionary *temdt in self.model.student) {
                    [marr addObject:lStringFor(temdt[@"id"])];
                }
                self.model.student = marr;
            }
            if (self.model.remark.length) {
                UIView *header = [[UIView alloc]init];
                header.backgroundColor =[UIColor whiteColor];
                UILabel *lb= [UILabel initialization:CGRectMake(15, 0, screenW - 30, 0) font:SYS_FONT(15) textcolor:JHdeepColor numberOfLines:0 textAlignment:0];
                lb.text = self.model.remark;
                [lb NSParagraphStyleAttributeName:10];
                CGFloat HH = [lb.attributedText selfadaption:30].height + 30;
                lb.height_i = HH;
                UIView *vline = [[UIView alloc]initWithFrame:CGRectMake(0, HH, screenW, 10)];
                vline.backgroundColor = JHbgColor;
                [header addSubview:lb];
                [header addSubview:vline];
                header.frame = CGRectMake(0, 0, screenW, HH + 10);
                self.tableView.tableHeaderView = header;
                
            }else{
                self.tableView.tableHeaderView =nil;
            }
            [self matchStu];
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
- (void)getDataStuList{
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
                model.tfmodel = [TextFiledModel mj_objectWithKeyValues:@{@"name":temDt[@"name"],@"idStr":temDt[@"id"],@"leftim":@"enter",@"rightim":@"1",@"image":@"choose"}];
                model.tfmodel.isSelect = 1;
                for (TextFiledModel *cmo in model.child) {
                    cmo.rightim = @"1";
                    cmo.rightim = @"choose";
                    if (!cmo.isSelect) model.tfmodel.isSelect = 0;
                }
                model.isSelect = 1;//默认展开
                [self.dataArray addObject:model];
            }
            [self matchStu];
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
-(void)matchStu{
    if (self.dataArray.count && self.model && self.model.student.count) {
        for (TextSectionModel *model in self.dataArray) {
            model.tfmodel.isSelect = 1;
            for (TextFiledModel *cmo in model.child) {
                if (self.model.student) {
                    for (NSString *IDstr in self.model.student) {
                        if ([cmo.idStr isEqualToString:IDstr]) {
                            cmo.isSelect = 1;
                        }
                    }
                }
                if (!cmo.isSelect) model.tfmodel.isSelect = 0;
            }
            model.isSelect = 1;//默认展开
        }
    }
}
#pragma mark - 解散
- (void)DisbandData{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.ID) {
        [dt setObject:self.ID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,AttendanceDisbandUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1 ) {
            if (self.successBlock) {
                self.successBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        [AlertView showMsg:response[@"msg"]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
@end
