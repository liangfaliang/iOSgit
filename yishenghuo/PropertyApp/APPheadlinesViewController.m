//
//  APPheadlinesViewController.m
//  shop
//
//  Created by 梁法亮 on 16/8/23.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "APPheadlinesViewController.h"
#import "HeadlineViewController.h"
#import "InformationTableViewCell.h"
@interface APPheadlinesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableveiw;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;
@end

@implementation APPheadlinesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.navigationBarTitle = @"物业公示";
    self.view.backgroundColor = [UIColor whiteColor];
    self.more = @"1";
    self.page = 1;
    [self creatableveiw];
    [self setupRefresh];
    [self requestInforData:self.page];
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
}
-(void)creatableveiw{
    
    self.tableveiw = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    self.tableveiw.delegate = self;
    self.tableveiw.dataSource = self;
    self.tableveiw.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableveiw registerClass:[UITableViewCell class] forCellReuseIdentifier:@"APPheadlinesViewController"];
    [self.view addSubview:self.tableveiw];
    [self.tableveiw registerNib:[UINib nibWithNibName:@"InformationTableViewCell" bundle:nil] forCellReuseIdentifier:@"APPheadlinesCell"];
    self.tableveiw.emptyDataSetSource = self;
    self.tableveiw.emptyDataSetDelegate = self;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"APPheadlinesCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dt = self.dataArray[indexPath.row];
    NSString *index_img = dt[@"index_img"];
    if (index_img && index_img.length) {
        cell.imageTop.constant = 15;
        cell.imageBottom.constant = 15;
        cell.titleLeft.constant = 10;
        [cell.iconimage sd_setImageWithURL:[NSURL URLWithString:index_img] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }else{
        cell.imageTop.constant = 10;
        cell.imageBottom.constant = 10;
        cell.iconimage.image = nil;
        cell.titleLeft.constant = - 40 * 115/91.0 ;
    }
    cell.titleLb.text = dt[@"in_title"];
    cell.nameLb.text = dt[@"le_name"];
    cell.timeLb.text = dt[@"in_endate"];
    
    cell.timeWidth.constant = [cell.timeLb.text selfadap:13 weith:20].width + 10;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HeadlineViewController *line = [[HeadlineViewController alloc]init];
    line.dataArrray = _dataArray[indexPath.row];
    [self.navigationController pushViewController:line animated:YES];
    
    
}
#pragma mark - *************cell高度***********
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.dataArray.count) {
        NSDictionary *dt = self.dataArray[indexPath.row];
        NSString *index_img = dt[@"index_img"];
        if (index_img && index_img.length) {
            return 100;
        }
    }
    return 70;
    
}

#pragma mark - *************项目资讯页面请求数据*************
-(void)requestInforData:(NSInteger )pagenum{
    [self presentLoadingTips];
    NSString *leid = [UserDefault objectForKey:@"leid"];
    if (leid == nil) {
        leid = @"";
    }
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) {
        coid = @"";
    }
    NSString *mobile = [UserDefault objectForKey:@"mobile"];
    if (mobile == nil) {
        mobile = @"";
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:leid,@"leid",coid,@"coid",mobile,@"mobile", nil];
    LFLog(@"项目资讯dt:%@",dt);
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,@"2") params:dt success:^(id response) {
        [self.tableveiw.mj_header endRefreshing];
        [self.tableveiw.mj_footer endRefreshing];
        [self dismissTips];
        if ([response isKindOfClass:[NSDictionary class]]) {
            if (response[@"error"]) {
                NSString *str = [NSString stringWithFormat:@"%@",response[@"error"]];
                LFLog(@"项目资讯:%@",response);
                if ([str isEqualToString:@"0"]) {
                    if (pagenum == 1) {
                        [self.dataArray removeAllObjects];
                    }
                    //            self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
                    NSArray *arr = [response objectForKey:@"note"];
                    for (NSDictionary *dic in arr) {
                        [self.dataArray addObject:dic];
                    }
                    
                }else{
                    //            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
                    //            if ([error_code isEqualToString:@"100"]) {
                    //                [self showLogin];
                    //            }
                    
                    [self presentLoadingTips:response[@"date"]];
                    
                }
                [self.tableveiw reloadData];
            }else{
                [self presentLoadingTips:@"数据格式错误！"];
            }

        }else{
            [self presentLoadingTips:@"数据格式错误！"];
        }
        
    } failure:^(NSError *error) {
        [self dismissTips];
        [self.tableveiw.mj_header endRefreshing];
        [self.tableveiw.mj_footer endRefreshing];
    }];
    
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableveiw.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.more = @"1";
        [self requestInforData:self.page];
    }];
//    _tableveiw.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//        if ([self.more isEqualToString:@"0"]) {
//            [self presentLoadingTips:@"没有更多数据了"];
//            [self.tableveiw.mj_footer endRefreshing];
//        }else{
//            self.page ++;
//            [self requestInforData:self.page];
//        }
//        
//    }];
    
}

@end
