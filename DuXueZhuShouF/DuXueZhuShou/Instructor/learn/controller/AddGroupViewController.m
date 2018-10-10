//
//  AddGroupViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/10.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AddGroupViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "YBPopupMenu.h"
@interface AddGroupViewController ()<UITableViewDataSource, UITableViewDelegate,YBPopupMenuDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)UITextField *tf;
@property(nonatomic, assign)BOOL isEdit;//ID存在 生效
@end

@implementation AddGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.ID) self.navigationBarTitle = @"添加分组";
    self.isEmptyDelegate = NO;
    [self.view addSubview:self.tableView];
    if (self.ID) {
        [self createBaritem];
    }else{
        [self createFootview];
    }
    [self UpData];

}
-(void)UpData{
    [super UpData];
    [self getData];
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
        [self createFootview];
        self.isEdit = YES;
        [self.tableView reloadData];
    }
    
}
-(void)createFootview{
    self.tableView.height_i = screenH - 60;
    UIButton *footview = [[UIButton alloc]initWithFrame:CGRectMake(15, screenH -  60, screenW -  30,  50)];
    footview.backgroundColor = JHMaincolor;
    [footview setTitle:@"确定" forState:UIControlStateNormal];
    footview.titleLabel.font = [UIFont systemFontOfSize:15];
    [footview addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footview];
    
}
-(UITextField *)tf{
    if (_tf == nil) {
        _tf = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, screenW - 30, 50)];
        _tf.placeholder = @"请设置分组名称";
    }
    return _tf;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray *array = @[@{@"tfmodel":@{@"name":@"科目",@"leftim":@"enter",@"key":@"status",@"rightim":@"1",@"image":@"choose"},
                               @"child":@[@{@"name":@"科目",@"key":@"status",@"rightim":@"1",@"image":@"choose"}]
                             },
                           @{@"tfmodel":@{@"name":@"科目",@"leftim":@"enter",@"key":@"status",@"rightim":@"1",@"image":@"choose"},
                             @"child":@[@{@"name":@"接受学生组",@"text":@"",@"key":@"",@"rightim":@"1",@"image":@"choose"},
                                        @{@"name":@"作业下发时间",@"text":@"",@"key":@"",@"rightim":@"1",@"image":@"choose"},
                                        @{@"name":@"最晚打卡时间",@"text":@"",@"key":@"",@"rightim":@"1",@"image":@"choose"},
                                        @{@"name":@"未打卡提醒时间",@"text":@"",@"key":@"",@"rightim":@"1",@"image":@"choose"},
                                        @{@"name":@"接受学生组",@"text":@"",@"key":@"",@"rightim":@"1",@"image":@"choose"},
                                        @{@"name":@"作业下发时间",@"text":@"",@"key":@"",@"rightim":@"1",@"image":@"choose"},
                                        @{@"name":@"最晚打卡时间",@"text":@"",@"key":@"",@"rightim":@"1",@"image":@"choose"},
                                        @{@"name":@"未打卡提醒时间",@"text":@"",@"key":@"",@"rightim":@"1",@"image":@"choose"}]
                             }];
        for (NSDictionary *dt in array) {
            TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
            for (TextFiledModel *cmo in model.child) {
                cmo.label = @"1";
                cmo.text = @"英语、语文、数学,英语、语文、数学英语、语文、数学英语、语文、数学英语、语文、数学英语、语文、数学";
            }
//            [_dataArray addObject:model];
        }

    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.estimatedSectionHeaderHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"herader"];
        if (!self.ID) {
            UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, SAFE_NAV_HEIGHT, screenW, 60)];
            header.backgroundColor = [UIColor whiteColor];
            UIView *vline = [[UIView alloc]initWithFrame:CGRectMake(0, 50, screenW, 10)];
            vline.backgroundColor = JHbgColor;
            [header addSubview:vline];
            [header addSubview:self.tf];
            _tableView.tableHeaderView = header;
        }
    }
    return _tableView;
}
#pragma mark - 确定
-(void)submitClick{
    if (!self.tf.text.length) {
        [self presentLoadingTips:@"请设置分组名称"];
        return;
    }
    NSMutableString *mstr = [NSMutableString string];
    for (TextSectionModel *smo in self.dataArray) {
        for (TextFiledModel *cmo in smo.child) {
            if (cmo.isSelect) {
                if (mstr.length) {
                    [mstr appendFormat:@"%@%@",Separator,cmo.idStr];
                }else{
                    [mstr appendString:cmo.idStr];
                }
            }
        }
    }
    if (!mstr.length) {
        [self presentLoadingTips:@"请选择学生组"];
        return;
    }
    [self UpdateLoad:mstr];
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
    cell.nameBtn.userInteractionEnabled = NO;
    cell.contentLb.userInteractionEnabled = NO;
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
        if (weakSelf.ID && !weakSelf.isEdit) {
            return ;
        }
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
    if (self.ID && !self.isEdit) {
        return ;
    }
    TextFiledLableTableViewCell *header = (TextFiledLableTableViewCell *)tap.view;
    TextSectionModel *smo = self.dataArray[header.tag];
    smo.isSelect = smo.isSelect ? 0 : 1;
    [self.tableView reloadData];
    //    header.model = cmo;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.ID && !self.isEdit) {
        return ;
    }
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
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,self.ID ? OperationAddStuGroupDetailUrl : OperationAddStuGroupListUrl) params:self.ID ? @{@"id":self.ID} :nil viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"] ) {
            [self.dataArray removeAllObjects];
            //            self.more = [response[@"data"][@"isEnd"] integerValue];
            [TextFiledModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"idStr" : @"id",@"text" : @"subject",@"isSelect" : @"is_group"};
            }];
            [TextSectionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"idStr" : @"id",@"child" : @"student"};
            }];
            NSArray *temArr = nil;
            if (self.ID) {
                temArr = response[@"data"][@"students"];
                self.tf.text = response[@"data"][@"name"];
                self.navigationBarTitle = response[@"data"][@"name"];
            }else{
                temArr = response[@"data"];
            }
            for (NSDictionary *temDt in temArr) {
                TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:temDt];
                model.tfmodel = [TextFiledModel mj_objectWithKeyValues:@{@"name":temDt[@"name"],@"idStr":temDt[@"id"],@"leftim":@"enter",@"rightim":@"1",@"image":@"choose",@"unedit":@"1",@"enable":@"1"}];
                model.tfmodel.isSelect = 1;
                for (TextFiledModel *cmo in model.child) {
                    cmo.rightim = @"1";
                    cmo.rightim = @"choose";
                    cmo.label = @"1";
//                    cmo.text = @"英语、语文、数学";
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

#pragma mark - 解散
- (void)DisbandData{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.ID) {
        [dt setObject:self.ID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,OperationDeleteStuGroupUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
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
#pragma mark 提交
-(void)UpdateLoad:(NSString *)ids{
    NSMutableDictionary *mdt = [NSMutableDictionary dictionary];
    [mdt setObject:ids forKey:@"ids"];
    if (self.ID) {
        [mdt setObject:self.ID forKey:@"id"];
    }
    [mdt setObject:self.tf.text forKey:@"name"];
    
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,self.ID ? OperationEditStuGroupUrl : OperationAddStuGroupUrl) params:mdt viewcontrllerEmpty:self success:^(id response) {
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
