//
//  MyAppointmentViewController.m
//  PropertyApp
//
//  Created by admin on 2018/7/26.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "MyAppointmentViewController.h"
#import "FileIListTableViewCell.h"
#import "FileCenterModel.h"
@interface MyAppointmentViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIView *headerView;
@property(nonatomic, strong)UIView *empView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation MyAppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBarTitle = @"我的预约";
    [self setupUI];
    [self UpData];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)UpData{
    [self getData];
}

- (void)setupUI{
    
    [self initTableView];
}
#pragma mark - tableView
- (void)initTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH ) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //    _tableView.estimatedRowHeight = 60;
    _tableView.rowHeight = 75;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FileIListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FileIListTableViewCell class])];
    _tableView.tableHeaderView = self.headerView;
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FileIListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FileIListTableViewCell class]) forIndexPath:indexPath];
    FileCenterModel *model = self.dataArray[indexPath.row];
//    [cell.iconIm sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    cell.nameLb.text = model.hr_name;
    cell.rightIm.hidden = YES;
    cell.timeLb.text = [NSString stringWithFormat:@"预约时间：%@",model.hr_reserveDate];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}



#pragma mark - 数据
- (void)getData{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,MyAppointmentListUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@" 数据:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            for (NSDictionary *temdt in response[@"data"]) {
                FileCenterModel *model = [FileCenterModel mj_objectWithKeyValues:temdt];
                [self.dataArray addObject:model];
            }
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

@end
