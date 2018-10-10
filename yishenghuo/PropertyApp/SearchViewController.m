//
//  SearchViewController.m
//  shop
//
//  Created by 梁法亮 on 16/5/11.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "SearchViewController.h"
#import "D0BBsTableViewCell.h"
#import "D0BBBSmodel.h"
#import "DetailsViewController.h"
#import "GovernmentPostTableViewCell.h"
@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UISearchBar *searchbar;
@property(nonatomic,strong)UITableView *tableview;


@property(nonatomic,strong)NSMutableArray *recordArray;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *searchArray;
@property(nonatomic,strong)UILabel *searchlabel;
@property (nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;
@property(nonatomic,strong)NSString *keyword;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.more = @"1";
    // Do any additional setup after loading the view.
    

//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.view.backgroundColor = [UIColor whiteColor];
    
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

    [self createTableview];
    self.tableview.hidden = YES;
    [self requestrecordData];
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

-(NSMutableArray *)searchArray{
    
    if (_searchArray == nil) {
        _searchArray = [[NSMutableArray alloc]init];
    }
    
    
    return _searchArray;
}


-(void)createUI{

    _searchlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 84, 60, 30)];
    _searchlabel.text = @"最近搜索";
    _searchlabel.font = [UIFont systemFontOfSize:14];
    
    [self.view addSubview:_searchlabel];
    CGFloat wieth = 0;
    CGFloat heigth = 0;
    CGFloat totalwieth = 0;
    int count = 0;
    for (int i = 0; i < (self.recordArray.count < 8 ? self.recordArray.count :8); i++) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
        NSString *str = self.recordArray[i][@"keyword"];
        [button setTitle:str forState:UIControlStateNormal];
        UIFont *font = [UIFont fontWithName:@"Arial" size:12];
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
        CGSize size = [str boundingRectWithSize:(CGSize){300, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.frame = CGRectMake(15 + count* 20 + wieth, 124 + heigth, size.width + 10, 21);
        NSString *str1 = [[NSString alloc]init];
        if (i == self.recordArray.count-1) {
            
        }else{
        
            str1 = self.recordArray[i+1][@"keyword"];
            
        }
        LFLog(@"%@",str1);
        CGSize size1 = [str1 boundingRectWithSize:(CGSize){300, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
        if (totalwieth + size1.width + size.width + 20 < SCREEN.size.width-15 ) {
            
            wieth  += size.width;
            count ++;
        }else{
            heigth += 25;
            totalwieth = 0;
            wieth = 0;
            count = 0;

        }
        
        
        
        button.layer.borderWidth = 1;
        button.layer.borderColor = [[UIColor colorWithRed:214/256.0 green:214/256.0 blue:214/256.0 alpha:1]CGColor];
        button.tag = 100 + i;
        button.layer.cornerRadius = 5;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        
        totalwieth = 15 + count* 20 + wieth;
    }
    
   


}


-(void)buttonClick:(UIButton *)bt{

    self.searchbar.text = bt.titleLabel.text;
    [self.searchbar becomeFirstResponder];
    [self removeRecode];


}
-(void)createTableview{

    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"GovernmentPostTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchCell"];
    
    [self.view addSubview:self.tableview];
    [self setupRefresh];



}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count ;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GovernmentPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.hotIm.hidden = YES;
    cell.GovernmentModel = self.dataArray[indexPath.row];
    cell.contentLbLeft.constant = 60;
    CGSize h = [cell.GovernmentModel.content selfadap:14 weith:50];
    CGFloat HH = h.height + 10;
    if (HH > 105) {
        HH = 105;
    }
    cell.contentLbHeight.constant = HH;
    __weak typeof(cell) weakcell = cell;
    [cell setLikeblock:^(UIButton *sender) {
        [self upDataforpraise:weakcell.GovernmentModel.id index:indexPath.row cell:weakcell];
    }];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    return cell;

    
    return cell;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     if (self.dataArray.count == 0) {
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height)];
    lb.text = @"很遗憾，没有搜索到数据~~";
    lb.textAlignment = NSTextAlignmentCenter;
    lb.textColor = JHColor(153, 153, 153);
    return lb;
     }

    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.dataArray.count) {
        GovernmentModel *mo = self.dataArray[indexPath.row];
        CGSize h = [mo.content selfadap:14 weith:20];
        CGFloat HH = h.height + 10;
        if (HH > 105) {
            HH = 105;
        }
        if (mo.imgurl.count) {
            CGFloat imgWidth = (SCREEN.size.width - 90)/3 + 10;
            if (mo.imgurl.count == 1) {
                imgWidth = (SCREEN.size.width - 90)/3 * 2;
            }else if (mo.imgurl.count == 4){
                imgWidth += imgWidth;
            }else{
                imgWidth = imgWidth * (((mo.imgurl.count - 1)/3 +1) < 4? (mo.imgurl.count - 1)/3 +1:3);
            }
            
            return HH + 110 + imgWidth;
        }else{
            return HH + 110;
            
        }
    }

    
    return 120;


}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (self.dataArray.count == 0) {
        return 44;
    }
    return 0.001;
}

#pragma mark  点击cell,进入帖子详情页
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }

    DetailsViewController *de = [[DetailsViewController alloc]init];
    de.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:de animated:YES];
}
//移除搜索记录
-(void)removeRecode{

    [self.searchlabel removeFromSuperview];
    for (int i = 0; i< self.recordArray.count; i++) {
        UIButton *bt = (UIButton *)[self.view viewWithTag:100 + i];
        [bt removeFromSuperview];
    }


}


//searchbar的协议方法、、
//进入编辑状态时
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{

    UIBarButtonItem *bt = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick:)];

    self.navigationItem.rightBarButtonItem = bt;

    return YES;
}
//退出编辑状态时
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{

//    self.searchbar.text = nil;
    self.keyword = searchBar.text;
    self.navigationItem.rightBarButtonItem = nil;
    if (self.searchbar.text.length) {
        self.tableview.hidden = NO;
    }else{
        for (int i = 0; i< self.recordArray.count; i++) {
            UIButton *bt = (UIButton *)[self.view viewWithTag:100 + i];
            if (bt) {
                return  YES;
            }else{
                self.tableview.hidden = YES;
                [self createUI];
                
                return YES;
                
            }
        }
    }
 

    return YES;
}

//输入框的值发生改变时调用的方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

 
    if (searchBar.text.length > 0) {
        [self removeRecode];
    }else{
    self.tableview.hidden = YES;
        [self createUI];
        
    }
}

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{



}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.keyword = searchBar.text;
    LFLog(@"点击搜索");
    [self removeRecode];
    self.page = 1;
    self.more = @"1";
    [self requestsearchData:searchBar.text page:self.page];
}
//取消点击事件
-(void)cancelClick:(UIBarButtonItem *)btm{

    self.searchbar.text = nil;
    [self.searchbar resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
    for (int i = 0; i< self.recordArray.count; i++) {
        UIButton *bt = (UIButton *)[self.view viewWithTag:100 + i];
        if (bt) {
            return;
        }else{
          
            self.tableview.hidden = YES;
            [self createUI];

            return;
        
        }
    }
    
}
#pragma mark 点赞数据请求
-(void)upDataforpraise:(NSString *)articleid index:(NSInteger)index cell:(GovernmentPostTableViewCell *)cell{
    
    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {
        }];
        return;
    }
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session",articleid,@"id", nil];
    LFLog(@"点赞dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BBSLikeUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            
            GovernmentModel *model = self.dataArray[index];
            NSInteger praise = [model.agree_count integerValue];
            if ([model.is_agree isEqualToString:@"0"]) {
                [self presentLoadingTips:@"点赞成功~~"];
                model.is_agree = @"1";
                praise ++;
            }else{
                [self presentLoadingTips:@"取消点赞~~"];
                model.is_agree = @"0";
                praise --;
                
            }
            model.agree_count = [NSString stringWithFormat:@"%d",(int)praise];
            [self.dataArray replaceObjectAtIndex:index withObject:model];
            [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            [self presentLoadingTips:response[@"err_msg"]];
            
        }
    } failure:^(NSError *error) {
        [_tableview.mj_header endRefreshing];
    }];
    
}

#pragma mark 搜索请求数据
- (void)requestsearchData:(NSString *)keyword page:(NSInteger)pagenum{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    if (keyword) {
        [dt setObject:keyword forKey:@"keyword"];
    }
    LFLog(@"获取成功dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BBSHomeListUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            LFLog(@"获取成功:%@",response);
            self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            if (pagenum == 1) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dt in response[@"data"]) {
                
                GovernmentModel *model=[[GovernmentModel alloc]initWithDictionary:dt error:nil];
                [self.dataArray addObject:model];
                
            }
            self.tableview.hidden = NO;
            [self.tableview reloadData];
            
           
        }else{
            [self.dataArray removeAllObjects];
            [self.tableview reloadData];
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
    }];
    
}


#pragma mark 历史记录请求数据
-(void)requestrecordData{
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSDictionary *dt = @{@"userid":uid};
    [LFLHttpTool get:NSStringWithFormat(ZJBBsBaseUrl,@"15") params:dt success:^(id response) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            for (NSDictionary *dt in response[@"note"]) {
                [self.recordArray addObject:dt];
            }
            [self createUI];
        }else{
            [self createUI];
            
        }
    } failure:^(NSError *error) {
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
        [self requestsearchData:self.keyword page:self.page];

        //        [self wheelrequestData];
    }];
    //    _tableView.mj_footer = [MJRefreshBackFooter]
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多帖子了"];
            [self.tableview.mj_footer endRefreshing];
        }else{
            self.page ++;
            [self requestsearchData:self.keyword page:self.page];
        }
        
    }];
}

@end
