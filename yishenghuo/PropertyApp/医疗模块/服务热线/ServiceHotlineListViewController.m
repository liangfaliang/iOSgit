//
//  ServiceHotlineListViewController.m
//  PropertyApp
//
//  Created by admin on 2018/9/7.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ServiceHotlineListViewController.h"
#import "ServiceHotlineTableViewCell.h"
@interface ServiceHotlineListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation ServiceHotlineListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"服务热线";
    [self.view addSubview:self.tableView];
    [self UpData];
}
-(void)UpData{
    [super UpData];
    self.page = 1;
    self.more = 0;
    [self getData];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"ServiceHotlineTableViewCell" bundle:nil] forCellReuseIdentifier:@"ServiceHotlineTableViewCell"];
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf UpData];
        }];
//        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [weakSelf footerWithRefresh];
//
//        }];
    }
    return _tableView;
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
    //    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceHotlineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ServiceHotlineTableViewCell class]) forIndexPath:indexPath];
    [cell setCellWithDict:self.dataArray[indexPath.row] indexPath:indexPath];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *de_tel = self.dataArray[indexPath.row][@"de_tel"];
    if ([de_tel isKindOfClass:[NSString class]] && de_tel.length) {
        [UserModel MakeTelephoneCall:de_tel];
    }
}


#pragma mark - 获取列表
- (void)getData{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    NSString *uid = [UserDefault objectForKey:@"uid"];
    if (uid == nil) uid = @"";
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) coid = @"";
    coid = @"53";
    [dt setObject:coid forKey:@"coid"];
    [dt setObject:uid forKey:@"uid"];
    [dt setObject:@"1" forKey:@"iszb"];
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,@"104") params:dt success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *temDt in response[@"data"]) {
                [self.dataArray addObject:temDt];
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
