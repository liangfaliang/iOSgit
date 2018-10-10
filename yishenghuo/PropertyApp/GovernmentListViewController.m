//
//  GovernmentListViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/10.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "GovernmentListViewController.h"
#import <WebKit/WebKit.h>
#import "UIButton+WebCache.h"
#import "STPhotoBroswer.h"
#import "CityNewsTableViewCell.h"
#import "WKWebView+LookImage.h"
#import "GovernmentDetailViewController.h"
@interface GovernmentListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)baseTableview *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;

@end

@implementation GovernmentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = self.titleType;
    self.page = 1;
    self.more = @"1";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[baseTableview alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height )];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    //    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CityNewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CityNewsCell"];
    [self requestData:1];
    [self setupRefresh];
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
    //    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CityNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityNewsCell"];
    NSDictionary *dt = self.dataArray[indexPath.row];
    cell.titleLabel.text = dt[@"title"];
    cell.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [cell.telButon setTitle:dt[@"author"] forState:UIControlStateNormal];
    cell.timeLabel.text = dt[@"add_time"];
    cell.timeLbwidth.constant = [dt[@"add_time"] selfadap:13 weith:100].width + 10;
    NSString *index_img = dt[@"index_img"];
    if (index_img.length > 0) {
        //        cell.titleLeft.constant = 10;
        cell.iconimage.hidden = NO;
        cell.imageleft.constant = 10;
        [cell.iconimage sd_setImageWithURL:[NSURL URLWithString:dt[@"index_img"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.imageWidth.constant = 100;
        }];
    }else{
        cell.iconimage.hidden = YES;
        cell.imageWidth.constant = 0;
        //        cell.titleLeft.constant = 90;
        //        cell.iconimage.hidden = YES;
        cell.imageleft.constant = 10 ;
        //        cell.imageTop.constant = 90;* 91/73
    }
    
    //    cell.imageleft.constant = 90 ;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GovernmentDetailViewController *detial = [[GovernmentDetailViewController alloc]init];
    if ([self.urlType isEqualToString:GovernmentIndustryUrl]) {
        detial.urlType = GovernmentIndustryDetailUrl;
    }else if ([self.urlType isEqualToString:GovernmentGuidelineUrl]) {
        detial.urlType = GovernmentGuidelineDetaiUrl;
    }else if ([self.urlType isEqualToString:GovernmentPoliciesUrl]) {
        detial.urlType = GovernmentPoliciesDetaiUrl;
    }
    detial.detailId = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:detial animated:YES];
    
    
}


#pragma mark - *************请求数据*************
-(void)requestData:(NSInteger )pagenum{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"dt:%@",dt);
    if (pagenum == 1) {
        [self.dataArray removeAllObjects];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,self.urlType) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@":%@",response);
        
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (![response[@"note"] isKindOfClass:[NSString class]]) {
                
                for (NSDictionary *dt in response[@"data"]) {
                    [self.dataArray addObject:dt];
                }
                if (self.dataArray.count) {
                    [self.tableview reloadData];
                    if (self.dataArray.count < 4) {
                        [self createFootview];
                    }else{
                        self.basefootview.hidden = YES;
                    }
                }else{
                    [self createFootview];
                    [self presentLoadingTips:@"暂无数据~~~"];
                }
                self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            }else{
                
                
                
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        self.page = 1;
                        self.more = @"1";
                        [self requestData:1];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"%@",error);
        [self presentLoadingTips:@"暂无数据"];
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
