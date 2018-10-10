//
//  GovernmentSearchViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/12/22.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "GovernmentSearchViewController.h"
#import "GovernmentSearchTableViewCell.h"
@interface GovernmentSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UISearchBar *searchbar;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *recordArray;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UILabel *searchlabel;
@property(nonatomic,strong)NSString *more;
@property(nonatomic,assign)NSInteger page;
@end

@implementation GovernmentSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    self.more = @"1";
    [self createTableview];
    [self createSearch];
    [self setupRefresh];
}

-(void)createSearch{
    self.searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width - 120, 40)];
    self.searchbar.layer.cornerRadius = 5;
    self.searchbar.layer.masksToBounds = YES;
    self.searchbar.placeholder = @"  输入关键词";
    UITextField *searchField = [self.searchbar valueForKey:@"_searchField"];
    if (searchField) {
        [searchField setValue:JHmiddleColor forKeyPath:@"_placeholderLabel.textColor"];
        [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    }
    [self.searchbar setImage:[UIImage imageNamed:@"sousuoshangcheng"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.searchbar.delegate = self;
    self.searchbar.returnKeyType = UIReturnKeySearch;
    [_searchbar setSearchFieldBackgroundImage:[UIImage imageNamed:@"sousuokuangshangcheng"] forState:UIControlStateNormal];
    UIView *seachview = [[UIView alloc]initWithFrame:CGRectMake(60, 20, SCREEN.size.width - 120, 40)];
    [seachview addSubview:_searchbar];
    if (iOS11) {
        self.navigationItem.titleView = seachview;
    }else{
        self.navigationItem.titleView = _searchbar;
    }
    UIBarButtonItem *bt = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick:)];
    bt.tintColor = JHmiddleColor;
    self.navigationItem.rightBarButtonItem = bt;
    [self.searchbar becomeFirstResponder];
}

//懒加载
-(NSMutableArray *)recordArray{
    
    if (_recordArray == nil) {
        _recordArray = [[NSMutableArray alloc]init];
    }
    
    return _recordArray;
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    
    return _dataArray;
}

-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"GovernmentSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"GovernmentSearchCell"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"searchCell"];
    [self.view addSubview:self.tableview];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.recordArray.count ;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GovernmentSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GovernmentSearchCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dt = self.recordArray[indexPath.row];
    NSString *search =self.searchbar.text;
    cell.contentLb.attributedText = [dt[@"title"] AttributedString:search backColor:nil uicolor:JHMaincolor uifont:nil];
    cell.typeLb.text = dt[@"source"];
    cell.timeLb.text = dt[@"add_time"];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.recordArray.count) {
        NSString *content = self.recordArray[indexPath.row][@"title"];
        return [content selfadap:15 weith:20].height + 55;
    }
    return 0.001;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

#pragma mark  点击cell,进入帖子详情页
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }
    if ([self.recordArray[indexPath.row][@"ios"] isKindOfClass:[NSDictionary class]]) {
        UIViewController *board = [[UserModel shareUserModel] runtimePushviewController:self.recordArray[indexPath.row][@"ios"] controller:self];
        if (board == nil) {
            [self presentLoadingTips:@"信息读取失败！"];
        }
        return;
    }
    
}



//searchbar的协议方法、、
//进入编辑状态时
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}



-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    

    [self.searchbar resignFirstResponder];
//    if (self.cateryId) {
//
//        ShopSupermarketListViewController *list = [[ShopSupermarketListViewController alloc]init];
//        list.category_id = self.cateryId;
//        list.keywords = searchBar.text;
//        [self.navigationController pushViewController:list animated:YES];
//    }else{
//
//        ShopSortListViewController *list = [[ShopSortListViewController alloc]init];
//        list.natitle = searchBar.text;
//        list.keywords = searchBar.text;
//        [self.navigationController pushViewController:list animated:YES];
//    }
    if (searchBar.text) {
        self.page = 1;
        [self presentLoadingTips];
        [self requestsearchData:self.page];
    }
    
    LFLog(@"搜索:%@",searchBar.text);
}
//取消点事件
-(void)cancelClick:(UIBarButtonItem *)btm{
    
    [self.searchbar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


#pragma mark 搜索数据
- (void)requestsearchData:(NSInteger )pagenum{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.searchbar.text) {
        [dt setObject:self.searchbar.text forKey:@"keywords"];
    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"搜索dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,GovernmentSearchListUrl) params:dt success:^(id response) {
        [self dismissTips];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        LFLog(@"搜索：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            if (pagenum == 1) {
                [self.recordArray removeAllObjects];
            }
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *str in response[@"data"]) {
                    [self.recordArray addObject:str];
                }
            }
            self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            [self.tableview reloadData];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    [self requestsearchData:self.page];
                }];
            }
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"连接失败！"];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    }];
    
}

#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.more = @"1";
        [self requestsearchData:self.page];
        
        //        [self wheelrequestData];
    }];
    
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多数据了"];
            [self.tableview.mj_footer endRefreshing];
        }else{
            self.page ++;
            [self requestsearchData:self.page];
        }
        
    }];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.searchbar isFirstResponder]) {
        [self.searchbar resignFirstResponder];
    }
    
}

@end
