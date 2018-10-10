//
//  PublishedViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "PublishedViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "ButtonsTableViewCell.h"
#import "InsPunchViewController.h"
#import "PublishedModel.h"
@interface PublishedViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableDictionary *stuDt;
@property(nonatomic, strong)PublishedModel *model;
@property(nonatomic, assign)NSInteger selectIndex;//
@end

@implementation PublishedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"已发布作业";
    self.selectIndex = 0;
    self.isEmptyDelegate = NO;
    [self.view addSubview:self.tableView];
    [self UpData];
    
}
-(void)UpData{
    [super UpData];
    [self getData];
    for (int i = 0 ; i < 3; i ++) {
        [self getDataList:i];
    }
}
-(NSMutableDictionary *)stuDt{
    if (_stuDt == nil) {
        _stuDt = [NSMutableDictionary dictionary];
        [_stuDt setObject:[[NSMutableArray array]init] forKey:@"student0"];
        [_stuDt setObject:[[NSMutableArray array]init] forKey:@"student1"];
        [_stuDt setObject:[[NSMutableArray array]init] forKey:@"student2"];
    }
    return _stuDt;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray *array = @[@{@"child":@[@{@"name":@"作业下发时间",@"key":@"start_time"},
                                        @{@"name":@"最晚打卡时间",@"key":@"end_time"},
                                        @{@"name":@"未打卡提醒时间",@"key":@"clock_time"}]
                             },
                           @{@"child":@[@{@"name":@"",@"key":@"status"}]
                             }];
        for (NSDictionary *dt in array) {
            TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
            [_dataArray addObject:model];
        }
        
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH ) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.estimatedSectionHeaderHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"ButtonsTableViewCell" bundle:nil] forCellReuseIdentifier:@"ButtonsTableViewCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"herader"];
    }
    return _tableView;
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSMutableArray *marr = self.stuDt[[NSString stringWithFormat:@"student%ld",(long)self.selectIndex]];
    return self.model ? self.dataArray.count + marr.count :0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    TextSectionModel *smo = nil;
    if (section > 1) {
        NSMutableArray *marr = self.stuDt[[NSString stringWithFormat:@"student%ld",(long)self.selectIndex]];
        smo = marr[section - self.dataArray.count];
        return smo.isSelect ? smo.child.count :0;
    }else{
        smo = self.dataArray[section];
    }
    return smo.child.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        
        ButtonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsTableViewCell" forIndexPath:indexPath];

//        NSRange range = [str rangeOfString:@"\n请登录后进行此操作"];
//        [text yy_setFont:[UIFont systemFontOfSize:13] range:range];
//        [text yy_setColor:JHmiddleColor range:range];
        NSArray *nameArr = @[@"btn1",@"btn2",@"btn3"];
        NSArray *key1Arr = @[@"student_completed_number",@"student_uncompleted_number",@"student_uncard_number"];
        NSArray *key2Arr = @[@"completed_rate",@"uncompleted_rate",@"uncard_rate"];
        NSArray *titleArr = @[@"已完成",@"未完成",@"未打卡"];
        int i = 0;
        for (NSString *namebtn in nameArr) {
            UIButton *btn = [cell valueForKey:namebtn];
            btn.titleLabel.numberOfLines = 0;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            NSString *str = [NSString stringWithFormat:@"%@%%\n%@%@人",[self.model valueForKey:key1Arr[i]],titleArr[i],[self.model valueForKey:key2Arr[i]]];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str] ;
            text.yy_lineSpacing = 10;
            text.yy_alignment = NSTextAlignmentCenter;
            text.yy_font = [UIFont systemFontOfSize:15];
            NSRange ran = [str rangeOfString:[NSString stringWithFormat:@"%@%%",[self.model valueForKey:key1Arr[i]]]];
            [text yy_setFont:SYS_FONTBold(20) range:ran];
            if (self.selectIndex == i) {
                text.yy_color = JHMaincolor;
            }else{
                text.yy_color = JHdeepColor;
            }
            [btn setAttributedTitle:text forState:UIControlStateNormal];
            i ++;
        }
        WEAKSELF;
        cell.clcikBlock = ^(NSInteger index) {
            weakSelf.selectIndex = index;
            [weakSelf.tableView reloadData];
        };
        return cell;
    }
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    cell.NameTfSpace.constant = 50;
    cell.nameBtn.titleLabel.numberOfLines = 1;
     __block TextSectionModel *smo = nil;
    if (indexPath.section > 1) {
        NSMutableArray *marr = self.stuDt[[NSString stringWithFormat:@"student%ld",(long)self.selectIndex]];
        smo = marr[indexPath.section - self.dataArray.count];
    }else{
        smo = self.dataArray[indexPath.section];
    }
    TextFiledModel *cmo = smo.child[indexPath.row];
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    cell.nameBtn.userInteractionEnabled =NO;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (section > 1) ? -1 : 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 1) {
        TextFiledLableTableViewCell *header = [tableView dequeueReusableCellWithIdentifier:@"herader"];
        header.NameTfSpace.constant = 50;
        header.nameBtn.userInteractionEnabled = NO;
        header.nameBtn.titleLabel.numberOfLines = 1;
        header.backgroundColor = [UIColor whiteColor];
        header.tag = section;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerClick:)];
        [header addGestureRecognizer:tap];
        NSMutableArray *marr = self.stuDt[[NSString stringWithFormat:@"student%ld",(long)self.selectIndex]];
        TextSectionModel *smo = marr[section - self.dataArray.count];
        TextFiledModel *cmo = smo.tfmodel;
        header.model = cmo;
        header.textfiled.textAlignment = NSTextAlignmentRight;
        return header;
    }
    return nil;
}
-(void)headerClick:(UITapGestureRecognizer *)tap{
    TextFiledLableTableViewCell *header = (TextFiledLableTableViewCell *)tap.view;
    NSMutableArray *marr = self.stuDt[[NSString stringWithFormat:@"student%ld",(long)self.selectIndex]];
    TextSectionModel *smo = marr[header.tag - self.dataArray.count];
    smo.isSelect = smo.isSelect ? 0 : 1;
    [self.tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section + 1 > self.dataArray.count) {
        NSMutableArray *marr = self.stuDt[[NSString stringWithFormat:@"student%ld",(long)self.selectIndex]];
        TextSectionModel *smo = marr[indexPath.section - self.dataArray.count];
        __block TextFiledModel *cmo = smo.child[indexPath.row];
        if (self.selectIndex == 2) {
            [self ReminderData:cmo];
            return;
        }
        InsPunchViewController *vc = [[InsPunchViewController alloc]init];
        vc.OperateID = cmo.idStr;
        vc.successBlock = ^{
            cmo.isSelect = 3;
            cmo.text = @"已评价";
            cmo.textcolor = @"666666";
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 获取数据
- (void)getData{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.ID) {
        [dt setObject:self.ID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,OperationInsPublishDetailUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取数据:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            self.model = [PublishedModel mj_objectWithKeyValues:response[@"data"]];
            TextSectionModel *smo =  self.dataArray[0];
            for (TextFiledModel *cmo in smo.child) {
                cmo.text = [UserUtils getShowDateWithTime:[self.model valueForKey:cmo.key] dateFormat:@"yyyy.MM.dd HH:mm"];
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
#pragma mark - 获取列表
- (void)getDataList:(NSInteger )index{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.ID) {
        [dt setObject:self.ID forKey:@"id"];
    }
    [dt setObject:index == 0 ? @"2" : (index == 1 ? @"3" :@"1") forKey:@"type"];//1未打卡，2已完成，3未完成
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,OperationInsPublishListUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
//            [self.dataArray removeObjectsInRange:NSMakeRange (2, self.dataArray.count - 2)];
            NSMutableArray *marr = self.stuDt[[NSString stringWithFormat:@"student%ld",(long)index]];
            [marr removeAllObjects];
            [TextFiledModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"idStr" : @"id",TisSelect : @"status"};//打卡情况,1未打卡，2已打卡（未评价），3已评价
            }];
            [TextSectionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"idStr" : @"id",@"child" : @"students"};
            }];
            for (NSDictionary *temDt in response[@"data"]) {
                TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:temDt];
                model.tfmodel = [TextFiledModel mj_objectWithKeyValues:@{@"name":temDt[@"class_name"],@"idStr":temDt[@"class_id"],@"leftim":@"enter"}];
                model.tfmodel.isSelect = 1;
                for (TextFiledModel *cmo in model.child) {
                    if (index < 2) {
                        cmo.rightim = @"1";
                        if (cmo.isSelect == 3) {//已评价
                            cmo.text = @"已评价";
                            cmo.textcolor = @"666666";
                        }else{
                            cmo.text = @"未评价";
                            cmo.textcolor = @"0490F6";
                        }
                    }else{
                        cmo.text = @"提醒打卡";
                        cmo.textcolor = @"0490F6";
                    }
                }
                model.isSelect = 1;//默认展开
                [marr addObject:model];
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

#pragma mark - 提醒打卡
- (void)ReminderData:(TextFiledModel *)cmo{
    [self presentLoadingTips];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (cmo && cmo.idStr.length) {
        [dt setObject:cmo.idStr forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,OperationInsReminderUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"提醒打卡:%@",response);
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
        }
        [self presentLoadingTips:response[@"msg"]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
@end
