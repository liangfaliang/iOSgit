//
//  ArticleListViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/28.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ArticleListViewController.h"
#import "SPPageMenu.h"
#import "ArticleListTableViewCell.h"
#import "RecommendArticleTableViewCell.h"
#import "ArticleDetailViewController.h"
@interface ArticleListViewController ()<SPPageMenuDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)baseTableview *tableview;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;
@property (nonatomic, strong) SPPageMenu *pageMenu;
@end

@implementation ArticleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = self.pageMenu;
    self.page = 1;
    self.more = @"1";
    [self createUI];
}
-(void)createUI{

    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[baseTableview alloc]initWithFrame:self.view.frame];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerNib:[UINib nibWithNibName:@"ArticleListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ArticleListTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"RecommendArticleTableViewCell" bundle:nil] forCellReuseIdentifier:@"ArticleCell"];
    [self requestData:1];
    [self setupRefresh];
}
-(SPPageMenu *)pageMenu{
    if (!_pageMenu) {
        SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, screenW - 60, 40) trackerStyle:SPPageMenuTrackerStyleLine];
        pageMenu.backgroundColor = [UIColor clearColor];
        pageMenu.tracker.backgroundColor = [UIColor clearColor];
        // 传递数组，默认选中第1个
        // 可滑动的自适应内容排列
        pageMenu.permutationWay = SPPageMenuPermutationWayScrollAdaptContent;
        // 设置代理
        pageMenu.selectedItemTitleColor = JHMedicalColor;
        pageMenu.unSelectedItemTitleColor = JHmiddleColor;
        pageMenu.delegate = self;
//        pageMenu.VerticalLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, 20)];
//        pageMenu.VerticalLine.backgroundColor = JHBorderColor;
        pageMenu.dividingLine.backgroundColor = [UIColor clearColor];
        _pageMenu = pageMenu;
        [_pageMenu setItems:@[@"推荐",@"宝宝"] selectedItemIndex:(self.selectIndex ? [self.selectIndex integerValue] :0)];
        
    }
    return _pageMenu;
}

#pragma mark - Table view data source


-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
//        return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dt = self.dataArray[indexPath.row];
    NSArray *imgurlArr = dt[@"imgurl"];
    if (imgurlArr.count >= 3) {
        NSString * nameLb = dt[@"title"];
        CGSize size = [nameLb selfadap:17 weith:20 Linespace:10];
        return 105 + (size.height+ 10 > 30 ? size.height + 10 : 30);
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dt = self.dataArray[indexPath.row];
    NSArray *imgurlArr = dt[@"imgurl"];
    if (imgurlArr.count >= 3) {
        ArticleListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleListTableViewCell"];
        cell.nameLb.text = dt[@"title"];
        [cell setimviewSubview:imgurlArr];
        cell.scroceLb.text = [NSString stringWithFormat:@"%@       %@",dt[@"author"],dt[@"add_time"]];
        return cell;
    }else{
        RecommendArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleCell"];
        cell.nameLb.text = dt[@"title"];
        [cell.praiseBtn setTitle:[NSString stringWithFormat:@"   %@",dt[@"read_count"]] forState:UIControlStateNormal];
        [cell.commentBtn setTitle:[NSString stringWithFormat:@"   %@",dt[@"comment_count"]] forState:UIControlStateNormal];
        if (imgurlArr.count) {
            [cell.picture sd_setImageWithURL:[NSURL URLWithString:imgurlArr[0]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        }
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ArticleDetailViewController *detail = [[ArticleDetailViewController alloc]init];
//    detail.titieStr = self.titieStr;
    detail.articleId = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:detail animated:YES];
    
}


#pragma mark - *************健康教育列表*************
-(void)requestData:(NSInteger )pagenum{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"健康教育列表dt:%@",dt);
    if (pagenum == 1) {
        [self.dataArray removeAllObjects];
    }
//    if (self.cat_id) {
//        [dt setObject:self.cat_id forKey:@"cat_id"];
//    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PregnantRecommendArticleListUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"健康教育列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dt in response[@"data"]) {
                    [self.dataArray addObject:dt];
                }
                [self.tableview reloadData];
                self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            }else{
                [self presentLoadingTips:@"数据格式错误！"];
            }
        }else{
            //            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            //            if ([error_code isEqualToString:@"100"]) {
            //                [self showLogin:^(id response) {
            //                    if ([response isEqualToString:@"1"]) {
            //                        self.page = 1;
            //                        self.more = @"1";
            //                        [self requestData:self.page];
            //                    }
            //
            //                }];
            //            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"%@",error);
        [self presentLoadingTips:@"请求失败！"];
        [self createFootview];
        [_tableview.mj_footer endRefreshing];
        [_tableview.mj_header endRefreshing];
    }];
    
}


#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.more = @"1";
        [self requestData:1];
    }];
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多数据了"];
            [self.tableview.mj_footer endRefreshing];
        }else{
            self.page ++;
            [self requestData:self.page];
        }
        
    }];
}


@end
