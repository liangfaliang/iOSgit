//
//  FileQueryHomeViewController.m
//  PropertyApp
//
//  Created by admin on 2018/7/23.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "FileQueryHomeViewController.h"
#import "FileIListTableViewCell.h"
#import "MyFileModel.h"
#import "HealthMyRecordsViewController.h"
#define headerH screenW * (46/ 75.0)
@interface FileQueryHomeViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIView *headerView;
@property(nonatomic, strong)UIView *empView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITextField *searchbar;
@end

@implementation FileQueryHomeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = true;
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.translucent = false;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back-white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    [self setupUI];
    [self UpData];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
-(UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, headerH)];
        _headerView.backgroundImage = [UIImage imageNamed:@"dangansousuobg"];
        [_headerView addSubview:self.searchbar];
    }
    return _headerView;
}
-(UIView *)empView{
    if (_empView == nil) {
        _empView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH - headerH)];
        UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zanwujiandangtishi"]];
        [_empView addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_empView.mas_centerX);
            make.top.offset(20);
        }];
        UILabel *lb = [UILabel initialization:CGRectZero font:[UIFont systemFontOfSize:15] textcolor:JHsimpleColor numberOfLines:0 textAlignment:NSTextAlignmentRight];
        lb.text = @"您当前暂无档案记录";
        [_empView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_empView.mas_centerX);
            make.top.equalTo(imageview.mas_bottom).offset(20);
        }];
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:@"创建档案" forState:UIControlStateNormal];
        [btn setTitleColor:JHmiddleColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setViewBorderColor:JHBorderColor borderWidth:1];
        [btn addTarget:self action:@selector(createBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_empView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_empView.mas_centerX);
            make.top.equalTo(lb.mas_bottom).offset(20);
            make.width.offset(100);
            make.height.offset(30);
        }];
    }
    return _empView;
}
-(UITextField *)searchbar{
    if (_searchbar == nil) {
        _searchbar = [[UITextField alloc]initWithFrame:CGRectMake(15, headerH - 74, screenW - 30, 44)];
        _searchbar.backgroundColor = [UIColor whiteColor];
        _searchbar.layer.cornerRadius = 22;
        _searchbar.layer.masksToBounds = YES;
        _searchbar.placeholder = @"   输入档案编号|姓名|身份证号";
        _searchbar.returnKeyType = UIReturnKeySearch;
        UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_searchbar.frame) - 40, 0, 80, CGRectGetHeight(_searchbar.frame))];
        [searchBtn setImage:[UIImage  imageNamed:@"dangansousuoicon"] forState:UIControlStateNormal];
        _searchbar.rightView = searchBtn;
        _searchbar.rightViewMode = UITextFieldViewModeAlways;
    }
    return _searchbar;
}
#pragma mark 创建档案
-(void)createBtnClick{
    
}
#pragma mark - tableView
- (void)initTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -NaviH, screenW, screenH + NaviH) style:UITableViewStyleGrouped];
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
    MyFileModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = JHbgColor;
    UILabel *lb = [UILabel initialization:CGRectMake(15, 0, screenW - 30, 50) font:[UIFont systemFontOfSize:15] textcolor:JHmiddleColor numberOfLines:0 textAlignment:0];
    NSString *text = [NSString stringWithFormat:@"我的档案   %lu份",(unsigned long)self.dataArray.count];
    lb.attributedText = [text AttributedString:[NSString stringWithFormat:@"%lu份",(unsigned long)self.dataArray.count] backColor:nil uicolor:JHMedicalColor uifont:nil];
    [header addSubview:lb];
    return header;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HealthMyRecordsViewController *VC = [[HealthMyRecordsViewController alloc]init];
    [VC.itemArray addObject:self.dataArray[indexPath.row]];
    [self.navigationController pushViewController:VC animated:YES];
    
}
-(UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.isLoadEnd.integerValue == 1) {
        return self.empView;
    }
    return nil;
}
#pragma mark - 数据
- (void)getData{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSString *uid = [UserDefault objectForKey:@"uid"];
    if (uid == nil) uid = @"";
//    uid = @"21";
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) coid = @"";
    coid = @"53";
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    [dt setObject:coid forKey:@"coid"];
    [dt setObject:uid forKey:@"uid"];
    [dt setObject:@"1" forKey:@"iszb"];
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,ERPMyFileQueryListUrl) params:dt success:^(id response) {
        LFLog(@" 数据提交:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            for (NSDictionary *temdt in response[@"data"]) {
                MyFileModel *model = [MyFileModel mj_objectWithKeyValues:temdt];
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
