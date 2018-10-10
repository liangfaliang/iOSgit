//
//  CastVoteListViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/18.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "CastVoteListViewController.h"
#import "CastVoteListTableViewCell.h"
#import "CastVoteViewDetailController.h"
@interface CastVoteListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;

@end

@implementation CastVoteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    //    self.fd_interactivePopDisabled = YES;
    self.page = 1;
    self.more = @"1";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBarTitle = @"投票表决";
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height )];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CastVoteListTableViewCell" bundle:nil] forCellReuseIdentifier:@"CastVoteListTableViewCell"];
    [self requestDataVote:1];
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
    
    return 80;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CastVoteListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CastVoteListTableViewCell"];
    NSDictionary *dt = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.nameLb.text = dt[@"title"];
    cell.timeLb.text = [NSString stringWithFormat:@"时间：%@ 至 %@",dt[@"start_time"],dt[@"end_time"]];
    UIImage *im = [UIImage imageNamed:@"toupiaozhong_toupiaobiaojue"];
    cell.iconWidth.constant = im.size.width;
    if ([[NSString stringWithFormat:@"%@",dt[@"status"]] isEqualToString:@"1"]) {
        cell.iconIMage.image = im;
    }else if ([[NSString stringWithFormat:@"%@",dt[@"status"]] isEqualToString:@"2"]) {
        cell.iconIMage.image = [UIImage imageNamed:@"yijieshutoupiao"];
    }else{
        cell.iconIMage.image = [UIImage imageNamed:@"weikaishi"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CastVoteViewDetailController *detial = [[CastVoteViewDetailController alloc]init];
    detial.detailid = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:detial animated:YES];
    
    
}


#pragma mark - *************请求数据*************
-(void)requestDataVote:(NSInteger )pagenum{
    [self presentLoadingTips];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"投票表决dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,CastVotelistUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        [self dismissTips];
        LFLog(@"投票表决:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            if (![response[@"data"] isKindOfClass:[NSString class]]) {
                for (NSDictionary *dt in response[@"data"]) {
                    [self.dataArray addObject:dt];
                }
                if (self.dataArray.count) {
                    [self.tableview reloadData];
                }else{
                    [self presentLoadingTips:@"暂无数据~~~"];
                }
                self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            }else{
                [self presentLoadingStr:@"暂无数据~~~"];
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@""]) {
                        [self requestDataVote:self.page];
                    }
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"社区活动error:%@",error);
        [self dismissTips];
        [self presentLoadingTips:@"暂无数据"];
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
        [self requestDataVote:1];
    }];
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多数据了"];
            [self.tableview.mj_footer endRefreshing];
        }else{
            self.page ++;
            [self requestDataVote:self.page];
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
