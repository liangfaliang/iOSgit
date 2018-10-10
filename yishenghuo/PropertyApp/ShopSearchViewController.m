//
//  ShopSearchViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/10.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ShopSearchViewController.h"
#import "ShopListingViewController.h"
#import "ShopSortListViewController.h"
#import "sortLabelview.h"
#import "ShopSupermarketListViewController.h"//超市直购列表
@interface ShopSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,sortLabelviewDelegate>{
    UIView *foot;
}

@property(nonatomic,strong)UISearchBar *searchbar;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)sortLabelview *sortview;
@property(nonatomic,strong)NSMutableArray *recordArray;

@property(nonatomic,strong)NSMutableArray *hotArray;
@property(nonatomic,strong)UILabel *searchlabel;

@end

@implementation ShopSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = JHbgColor;
    [self createSearch];
    [self createTableview];
    [self requestsearchData];
    
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
    bt.tintColor = JHshopMainColor;
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

-(NSMutableArray *)hotArray{
    
    if (_hotArray == nil) {
        _hotArray = [[NSMutableArray alloc]init];
    }
    
    
    return _hotArray;
}




-(void)buttonClick:(UIButton *)bt{
    
    self.searchbar.text = bt.titleLabel.text;
    [self.searchbar becomeFirstResponder];
//    [self removeRecode];
    
    
}
-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
//    [self.tableview registerNib:[UINib nibWithNibName:@"D0BBsTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchCell"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"searchCell"];
    [self.view addSubview:self.tableview];
   
    
   
    
    
}
-(sortLabelview *)sortview{

    if (_sortview == nil) {
        _sortview = [[sortLabelview alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 0)];
        _sortview.isMoreBtn = NO;
        _sortview.delegate = self;
    }
    
    return _sortview;
}
#pragma mark 分类标签点击
-(void)sortLabelviewSelectSort:(NSString *)sort isSelect:(BOOL)isSelect{
    LFLog(@"标签：%@",sort);
    if (self.cateryId) {
        
        ShopSupermarketListViewController *list = [[ShopSupermarketListViewController alloc]init];
        list.category_id = self.cateryId;
        list.keywords = sort;
        [self.navigationController pushViewController:list animated:YES];
    }else{
        
        ShopSortListViewController *list = [[ShopSortListViewController alloc]init];
        list.natitle = sort;
        list.keywords = sort;
        [self.navigationController pushViewController:list animated:YES];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.recordArray.count  + 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    for (UIView *subview in cell.contentView.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview removeFromSuperview];
        }
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.row == 0) {
        cell.textLabel.textColor = JHmiddleColor;
        cell.textLabel.text = @"历史搜索";
    }else{
        cell.textLabel.textColor = JHdeepColor;
        cell.textLabel.text = self.recordArray[indexPath.row - 1];
        UIButton *deleteBtn = [[UIButton alloc]init];
        [deleteBtn setImage:[UIImage imageNamed:@"shanchubuttun"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:event:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:deleteBtn];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            
        }];
    }
    
    return cell;
    
}
-(void)deleteBtnClick:(UIButton *)button event:(id)event{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableview];
    NSIndexPath *indexPath= [self.tableview indexPathForRowAtPoint:currentTouchPosition];
    [self deleteSearchData:self.recordArray[indexPath.row - 1]];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIImageView *view = [[UIImageView alloc]init];
    view.image = [UIImage imageNamed:@"fengexiantongyong"];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 44;
    
    
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
    if (indexPath.row > 0) {
        if (self.cateryId) {
            
            ShopSupermarketListViewController *list = [[ShopSupermarketListViewController alloc]init];
            list.category_id = self.cateryId;
            list.keywords = self.recordArray[indexPath.row - 1];
            [self.navigationController pushViewController:list animated:YES];
        }else{
            
            ShopSortListViewController *list = [[ShopSortListViewController alloc]init];
            list.natitle = self.recordArray[indexPath.row - 1];
            list.keywords = self.recordArray[indexPath.row - 1];
            [self.navigationController pushViewController:list animated:YES];
        }
    }

}



//searchbar的协议方法、、
//进入编辑状态时
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    

    
    return YES;
}



-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    

    
//    [self removeRecode];

    //保存历史记录
//    if (self.recordArray.count > 8) {
//        [self.recordArray removeObjectAtIndex:0];
//        [self.recordArray addObject:searchBar.text];
//        
//    }else{
//    [self.recordArray addObject:searchBar.text];
//    }
//    LFLog(@"点击搜索:%@",self.recordArray);
//    [UserDefault setObject:self.recordArray forKey:@"searchRcord"];
////    [self requestsearchData:searchBar.text page:@"0"];
    [self.searchbar resignFirstResponder];
    if (self.cateryId) {
        
        ShopSupermarketListViewController *list = [[ShopSupermarketListViewController alloc]init];
        list.category_id = self.cateryId;
        list.keywords = searchBar.text;
        [self.navigationController pushViewController:list animated:YES];
    }else{
    
        ShopSortListViewController *list = [[ShopSortListViewController alloc]init];
        list.natitle = searchBar.text;
        list.keywords = searchBar.text;
        [self.navigationController pushViewController:list animated:YES];
    }
    

    LFLog(@"搜索:%@",searchBar.text);
}
//取消点事件
-(void)cancelClick:(UIBarButtonItem *)btm{

    [self.searchbar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];

    
}
//清空历史记录
-(void)cleanBtnClick:(UIButton *)btm{
    [self deleteSearchData:nil];
}

#pragma mark 搜索数据
- (void)requestsearchData{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,searchHistoryAndHotUrl) params:dt success:^(id response) {
        LFLog(@"搜索：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [self.recordArray removeAllObjects];
            [self.hotArray removeAllObjects];
            if ([response[@"data"][@"his_search"] isKindOfClass:[NSArray class]]) {
                for (NSString *str in response[@"data"][@"his_search"]) {
                    [self.recordArray addObject:str];
                }
                if (self.recordArray.count) {
                    if (foot == nil) {
                        foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 50)];
                        UIButton *cleanBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 50)];
                        [cleanBtn setTitle:@"清除搜索历史" forState:UIControlStateNormal];
                        [cleanBtn setTitleColor:JHshopMainColor forState:UIControlStateNormal];
                        cleanBtn.titleLabel.font = [UIFont systemFontOfSize:15];
                        [cleanBtn addTarget:self action:@selector(cleanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [foot addSubview: cleanBtn];
                        
                    }
                    self.tableview.tableFooterView = foot;
                
                }else{
                 self.tableview.tableFooterView = nil;
                }
            }
            if ([response[@"data"][@"hot_search"] isKindOfClass:[NSArray class]]) {
                for (NSString *str in response[@"data"][@"hot_search"]) {
                    [self.hotArray addObject:str];
                }
                if (self.hotArray.count) {
                    if (self.headerView == nil) {
                        self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 40)];
                        UILabel *namelb = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN.size.width - 20, 40)];
                        namelb.text = @"热门搜索";
                        namelb.textColor = JHmiddleColor;
                        [self.headerView addSubview:namelb];
                    }
                    [self.sortview initWithsortArray:self.hotArray currentIndex:-1 sortH:40 font:12];
                    self.sortview.backgroundColor = [UIColor whiteColor];
                    [self.headerView addSubview:self.sortview];
                    self.sortview.frame = CGRectMake(0, 40, SCREEN.size.width, self.sortview.height);
                    self.headerView.frame = CGRectMake(0, 0, SCREEN.size.width, self.sortview.height + 40);
                    self.tableview.tableHeaderView = self.headerView;
                }
            }
            [self.tableview reloadData];
        }else{

            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        
    } failure:^(NSError *error) {
        [self presentLoadingTips:@"连接失败！"];
    }];
    
}

#pragma mark 删除记录
- (void)deleteSearchData:(NSString *)keyword{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (keyword) {
        [dt setObject:keyword forKey:@"keywords"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,searchDeleteUrl) params:dt success:^(id response) {
        LFLog(@"搜索：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            
            [self requestsearchData];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        
    } failure:^(NSError *error) {
        [self presentLoadingTips:@"连接失败！"];
    }];
    
}


-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];

    [self requestsearchData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.searchbar isFirstResponder]) {
        [self.searchbar resignFirstResponder];
    }
}


@end
