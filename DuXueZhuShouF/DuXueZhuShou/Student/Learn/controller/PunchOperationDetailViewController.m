//
//  PunchOperationDetailViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/7/31.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "PunchOperationDetailViewController.h"
#import "DescriptionTableViewCell.h"
#import "LookClassmatesViewController.h"
#import "PunchSubmitViewController.h"//打卡
#import "OperateStuDatailModel.h"
@interface PunchOperationDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)OperateStuDatailModel *dmodel;
@end

@implementation PunchOperationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self createBaritem];
    [self UpData];
}
-(void)createFootview{
    self.tableView.height_i = screenH - 60;
    UIButton *footview = [[UIButton alloc]initWithFrame:CGRectMake(15, screenH -  60, screenW -  30,  50)];
    footview.backgroundColor = JHMaincolor;
    [footview setTitle:@"打卡" forState:UIControlStateNormal];
    footview.titleLabel.font = [UIFont systemFontOfSize:15];
    [footview addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footview];
}
-(void)createBaritem{
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"查看同学" style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
    rightBar.tintColor = JHMaincolor;
    self.navigationItem.rightBarButtonItem = rightBar;
}

-(void)UpData{
    [super UpData];
    [self getData];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)rightClick{
    LookClassmatesViewController *vc = [[LookClassmatesViewController alloc]init];
    vc.ID = self.dmodel.ID;
    [self.navigationController pushViewController:vc animated:YES];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DescriptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"DescriptionTableViewCell"];
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

            [weakSelf getData];
        }];

    }
    return _tableView;
}
-(void)submitClick{
    PunchSubmitViewController *vc = [[PunchSubmitViewController alloc]init];
    vc.ID = self.dmodel.ID;
    WEAKSELF;
    vc.successBlock = ^{
        if (weakSelf.successBlock) {
            weakSelf.successBlock();
        }
        [weakSelf UpData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dmodel ? (self.dmodel.comment.length ? 3 : (self.dmodel.type.integerValue != 1) ? 2 : 1) : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.dataArray.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DescriptionTableViewCell class]) forIndexPath:indexPath];
    if (indexPath.section == 0) {
        NSString *str  = [NSString stringWithFormat:@"%@\n%@",@"",[UserUtils getShowDateWithTime:self.dmodel.start_time dateFormat:@"yyyy.MM.dd HH:mm"]];
        [cell setNamelbattributedText:[cell getAttribute:str title:@""]];
        cell.contentLb.text = self.dmodel.content;
        [cell setImageArr:self.dmodel.images];
    }else if (indexPath.section == 1){
        NSString *type = [NSString stringWithFormat:@"作业状态:%@",self.dmodel.type.integerValue == 2 ? @"已完成" :(self.dmodel.type.integerValue == 3 ? @"未完成" :@"未打卡")];
        cell.nameLb.attributedText = [cell getAttribute:type title:type];
        cell.contentLb.text = self.dmodel.user_content;
        [cell setImageArr:self.dmodel.user_images];
    }else{
        cell.nameLb.attributedText =nil;
        cell.nameLb.text = nil;
        cell.contentLb.text = self.dmodel.comment;
        [cell setImageArr:nil];
    }

    [cell.contentLb NSParagraphStyleAttributeName:5];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        return 40;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        UIView *header = [[UIView alloc]init];
        header.backgroundColor = JHbgColor;
        UILabel *lb = [UILabel initialization:CGRectMake(15, 0, screenW - 30, 40) font:[UIFont systemFontOfSize:14] textcolor:JHmiddleColor numberOfLines:0 textAlignment:0];
        lb.text = section == 1 ? @"打卡详情":@"老师评价";
        [header addSubview:lb];
        return header;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section > 0) {
        return 0.001;
    }
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section > 0) {
        return nil;
    }
    UIView *footer = [[UIView alloc]init];
    footer.backgroundColor = JHbgColor;
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 10, screenW, 70)];
    backview.backgroundColor = [UIColor whiteColor];
    [footer addSubview:backview];
    UILabel *lb = [UILabel initialization:CGRectMake(15, 0, screenW - 30, backview.height_i) font:[UIFont systemFontOfSize:14] textcolor:JHmiddleColor numberOfLines:0 textAlignment:0];
    NSString *time = self.dmodel.completed_time.integerValue > 0 ? [NSString stringWithFormat:@"\n打卡时间:%@",[UserUtils getShowDateWithTime:self.dmodel.completed_time dateFormat:@"yyyy-MM-dd HH:mm"]] : @"";
    lb.text = [NSString stringWithFormat:@"最晚打卡时间：%@%@",[UserUtils getShowDateWithTime:self.dmodel.end_time dateFormat:@"yyyy-MM-dd HH:mm"],time];
    [lb NSParagraphStyleAttributeName:5];
    [backview addSubview:lb];
    return footer;
}
#pragma mark - 获取列表
- (void)getData{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.ID) {
        [dt setObject:self.ID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,OperationStuDetailUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"]) {
            self.dmodel = [OperateStuDatailModel mj_objectWithKeyValues:response[@"data"]];
            self.navigationBarTitle = self.dmodel.subject;
            NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970];
            if (self.dmodel.type.integerValue == 1 && self.dmodel.end_time.integerValue > nowtime) {
                [self createFootview];
            }else{
                [self.view addSubview:self.tableView];
                self.tableView.height_i = screenH ;
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
@end
