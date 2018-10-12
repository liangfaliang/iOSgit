//
//  MineNewViewController.m
//  PropertyApp
//
//  Created by admin on 2018/10/11.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "MineNewViewController.h"
#import "MineMenuTableViewCell.h"
#import "ImLbModel.h"
#import "MineHeaderNewView.h"
#import "SetupPageViewController.h"
@interface MineNewViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)MineHeaderNewView *headerView;
@property (nonatomic, strong) UILabel *titleView;
@end

@implementation MineNewViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showTabbar];
    [self UpData];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self hideTabbar];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    //    [self.navigationController setNavigationAlpha:0 animated:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView =self.titleView;
    [self.view addSubview:self.tableView];
    [self createBaritem];
}
-(void)UpData{
    [self setName];
    [self refushUserInfo];
}
-(void)createBaritem{
    
    UIImage *btnim = [UIImage imageNamed:@"shezhi_ysh"];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnim.size.width, btnim.size.height)];
    [btn setImage:btnim forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)rightItemClick:(UIBarButtonItem *)btn{
    SetupPageViewController *set = [[SetupPageViewController alloc]init];
    [self.navigationController pushViewController:set animated:YES];
}
-(void)setName{
    NSString *headimage = [UserDefault objectForKey:@"userheadimage"];
    NSString *name = [UserDefault objectForKey:@"nickname"];
    NSString *po_name = [UserDefault objectForKey:@"po_name"];
    NSString *usernamec = [UserDefault objectForKey:@"usernamec"];
    NSString *company = [UserDefault objectForKey:@"company"];
    NSString *rank_name = [UserDefault objectForKey:@"userrank_name"];
    
    _titleView.text = company;
    if (headimage.length > 0) {
        [self.headerView.icon sd_setImageWithURL:[NSURL URLWithString:headimage] placeholderImage:[UIImage imageNamed:@"gerentouxiang"]];
    }
    self.headerView.name.text = name ? name : (usernamec ? usernamec : @"未登录");
    self.headerView.adressLb.text = po_name ? po_name : @"";
    [self.headerView.hiuyuanBtn setTitle:rank_name ? [NSString stringWithFormat:@"(%@)",rank_name] : nil forState:UIControlStateNormal];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray * arr1 = @[@{@"name":@"物业服务|邻里互动",
                             @"height":@190,
                             @"child":@[@{@"name":@"业主认证",@"imgurl":@"yezhurenzheng",@"data":@{@"ios_class":@"AttestViewController",@"property":@{@"":@""}}},
                                         @{@"name":@"家庭成员",@"imgurl":@"jiatingchengyuan",@"data":@{@"ios_class":@"",@"property":@{@"":@""}}},
                                         @{@"name":@"租售发布",@"imgurl":@"zushoufabu",@"data":@{@"ios_class":@"HouseRentingViewController",@"property":@{@"":@""}}},
                                         @{@"name":@"开门记录",@"imgurl":@"kaimengjilu",@"data":@{@"ios_class":@"",@"property":@{@"":@""}}},
                                         @{@"name":@"活动记录",@"imgurl":@"huodongjilu",@"data":@{@"ios_class":@"ActivityViewController",@"property":@{@"":@""}}},
                                         @{@"name":@"测评记录",@"imgurl":@"cepingjilu",@"data":@{@"ios_class":@"",@"property":@{@"":@""}}},
                                         @{@"name":@"我的发帖",@"imgurl":@"wodetiezi",@"data":@{@"ios_class":@"UserInfoViewController",@"property":@{@"":@""}}},
                                         @{@"name":@"快递服务",@"imgurl":@"kuaidifuwu",@"data":@{@"ios_class":@"ExpressViewController",@"property":@{@"":@""}}}]},
                           @{@"name":@"医疗服务|商业服务",
                             @"height":@120,
                             @"child":@[@{@"name":@"医疗预约",@"imgurl":@"yiliaoyuyue"},
                                         @{@"name":@"商城订单",@"imgurl":@"shangchengdingdan",@"data":@{@"ios_class":@"",@"property":@{@"":@""}}},
                                         @{@"name":@"家政订单",@"imgurl":@"jiazhengdingdan",@"data":@{@"ios_class":@"",@"property":@{@"":@""}}},
                                         @{@"name":@"三金订单",@"imgurl":@"sanjingdingdan",@"data":@{@"ios_class":@"",@"property":@{@"":@""}}},
                                         @{@"name":@"服务公告",@"imgurl":@"fuwugonggao1",@"data":@{@"ios_class":@"",@"property":@{@"":@""}}}]},
                           @{@"name":@"会员互动",
                             @"height":@190,
                             @"child":@[@{@"name":@"会员权益",@"imgurl":@"huiyuanquanyi",@"data":@{@"ios_class":@"",@"property":@{@"":@""}}},
                                         @{@"name":@"积分查询",@"imgurl":@"jifengchaxun",@"data":@{@"ios_class":@"MyIntegralViewController",@"property":@{@"":@""}}},
                                         @{@"name":@"我的钱包",@"imgurl":@"wodeqianbao",@"data":@{@"ios_class":@"MyWalletViewController",@"property":@{@"":@""}}},
                                         @{@"name":@"优惠券",@"imgurl":@"youhuijuan",@"data":@{@"ios_class":@"CouponExchangeViewController",@"property":@{@"":@""}}},
                                         @{@"name":@"会员收益",@"imgurl":@"huiyuanshouyi",@"data":@{@"ios_class":@"",@"property":@{@"":@""}}},
                                         @{@"name":@"意见反馈",@"imgurl":@"yijianfankui",@"data":@{@"ios_class":@"",@"property":@{@"":@""}}},
                                         @{@"name":@"我的收藏",@"imgurl":@"shoucang",@"data":@{@"ios_class":@"",@"property":@{@"":@""}}},
                                         @{@"name":@"更多",@"imgurl":@"menumore",@"data":@{@"ios_class":@"",@"property":@{@"":@""}}}]}];
        
        for (NSDictionary *temdt in arr1) {
            ImLbModel *mo = [ImLbModel mj_objectWithKeyValues:temdt];
            [_dataArray addObject:mo];
        }

    }
    return _dataArray;
}
- (UILabel *)titleView
{
    if (!_titleView) {
        _titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenW - 120, 44)];
        _titleView.textColor = [UIColor whiteColor];
        [_titleView sizeToFit];
    }
    return _titleView;
}
-(MineHeaderNewView *)headerView{
    if (_headerView == nil) {
        _headerView = [MineHeaderNewView view];
        
    }
    return  _headerView;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -NaviH , screenW, screenH + NaviH - JHTabbarH) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.estimatedRowHeight = 70;
//        _tableView.rowHeight = -1;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerNib:[UINib nibWithNibName:@"MineMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineMenuTableViewCell"];
        _tableView.tableHeaderView = self.headerView;
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
 
            [weakSelf UpData];
        }];

    }
    return _tableView;
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArray.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MineMenuTableViewCell class]) forIndexPath:indexPath];
    cell.layout.itemSize = CGSizeMake((screenW - 31)/(indexPath.section == 1 ? 5 : 4) , 70);
    cell.layout.minimumLineSpacing = 0.001;
    cell.layout.minimumInteritemSpacing = 0.001;
    CGFloat oneX = 0;
    cell.layout.sectionInset = UIEdgeInsetsMake(0, oneX, 0, oneX);
    cell.Identifier = @"ImageLabelCollectionViewCell";
    ImLbModel *imo = self.dataArray[indexPath.section];
    cell.titleLb.text = imo.name;
    cell.titleArr = imo.child;
    WEAKSELF;
    cell.ClickBlock = ^(NSIndexPath *idxpath) {
        ImLbModel *cmo = imo.child[idxpath.row];
        [[UserModel shareUserModel] runtimePushviewController:cmo.data controller:weakSelf];
    };
    return cell;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImLbModel *imo = self.dataArray[indexPath.section];
    return imo.height.integerValue;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - *************用户信息*************
-(void)refushUserInfo{
    [UserModel UploadDataUserInfo:^(id response) {
        [self.tableView.mj_header endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"][@"activity_info"] isKindOfClass:[NSDictionary class]]) {
//                self.headerview.activity_info = response[@"data"][@"activity_info"];
//                [self.headerview.activiBtn setTitle:response[@"data"][@"activity_info"][@"title"] forState:UIControlStateNormal];
            }
            if ([response[@"data"][@"user_money"] isKindOfClass:[NSString class]]) {
                [UserDefault setObject:response[@"data"][@"user_money"]  forKey:@"user_money"];//用户余额
                [UserDefault setObject:response[@"data"][@"pay_points"] forKey:@"user_pay_points"];//用户积分
                [UserDefault setObject:response[@"data"][@"rank_name"] forKey:@"user_rank_name"];//用户等级名称
                [UserDefault setObject:response[@"data"][@"rank_level"] forKey:@"user_rank_level"];//用户等级
            }
            
//            if (response[@"data"][@"not_read"]) {
//                self.alertbtn.alertLabel.textnum = [NSString stringWithFormat:@"%@",response[@"data"][@"not_read"]];
//            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self refushUserInfo];;
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
            
        }
        [self.tableView reloadData];
    } error:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}
#pragma mark - 获取列表
- (void)getDataList{
    
    
}
@end
