//
//  ActivityViewController.m
//  shop
//
//  Created by 梁法亮 on 16/7/16.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityTableViewCell.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "DetailsActivityController.h"
#import "UIViewController+BackButtonHandler.h"
@interface ActivityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)baseTableview *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
//    self.fd_interactivePopDisabled = YES;
    self.page = 1;
    self.more = @"1";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[baseTableview alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height )];
    if (self.isJion) {
        self.navigationBarTitle = @"我的活动";
    }else{
    self.navigationBarTitle = @"社区活动";
    }
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"ActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"Activitycell"];
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

    return 120;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Activitycell"];
    NSDictionary *dt = self.dataArray[indexPath.row];
    cell.titleLabel.text = dt[@"title"];
     cell.contentLabel.text = dt[@"content"];
     cell.countLabel.text = [NSString stringWithFormat:@"已有%@人参加",dt[@"partake"]];
    cell.timelabel.text = dt[@"add_time"];
    cell.timeLbWidth.constant = [dt[@"add_time"] selfadap:12 weith:100].width + 10;
    [cell.iconimage sd_setImageWithURL:[NSURL URLWithString:dt[@"index_img"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
//    cell.imageview.layer.cornerRadius = 3;
//    
//    cell.imageview.layer.masksToBounds  = YES;
  
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailsActivityController *detial = [[DetailsActivityController alloc]init];
    detial.detailid = self.dataArray[indexPath.row][@"id"];
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
    LFLog(@"社区活动dt:%@",dt);
    if (self.isJion == nil) {
        self.isJion = ActivityListUrl;
    }
    //self.isJion
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,self.isJion) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"社区活动:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (pagenum == 1) {
                [self.dataArray removeAllObjects];
            }
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
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@""]) {
                        [self requestData:self.page];
                    }
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"社区活动error:%@",error);
        [self presentLoadingTips:@"暂无数据"];
        [self createFootview];
      [_tableview.mj_header endRefreshing];
      [_tableview.mj_footer endRefreshing];
    }];
    
}


//-(void)createFootview{
//    UIImageView *footview = [[UIImageView alloc]init];
//    footview.image = [UIImage imageNamed:@"appfootview"];
//    
//    [self.view addSubview:footview];
//    [footview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.offset(0);
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.width.offset(SCREEN.size.width);
//    }];
//    
//}

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

//-(BOOL)goBackPreviousPage{
//    [self alertController:@"提示" prompt:@"是否返回" sure:@"确定" cancel:@"取消" success:^{
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    } failure:^{
//        
//    }];
//    return YES;
//
//}




@end
