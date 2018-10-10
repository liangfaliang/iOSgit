//
//  InformationViewController.m
//  shop
//
//  Created by wwzs on 16/4/14.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//



#define RGBACOLOR [UIColor colorWithRed: 4/255.0f green:146/255.0f blue:245/255.0f alpha:1.0]
#import "InformationViewController.h"
#import "AttestViewController.h"
#import "LFLaccount.h"
#import "InforViewController.h"
#import "InformationTableViewCell.h"
#import "HealthEducateListTableViewCell.h"
@interface InformationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic)baseTableview *tableView;
@property (strong,nonatomic)UIView *view1;
@property (strong,nonatomic)UISegmentedControl *segment;
@property (nonatomic,strong)NSMutableArray *noteArr;//存储的信息数组
@property (nonatomic,strong)NSMutableArray *hotlineArr;//咨询热线数组
@property (nonatomic,strong)NSString *totalStr;//详细信息拼接

@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;
//数据请求对象
@property(nonatomic,strong)NSMutableArray *requestArr;
@end

@implementation InformationViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.more = @"1";
    self.page = 1;
    [self requestInforData:self.page];
//    [self requestTelData];
    //导航栏等设置
    [[UITableView appearance]setTableFooterView:[UIView new]];
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.navigationBarTitle = @"物业资讯";
    if (self.type == InfoStyleWenZhang) self.navigationBarTitle = self.titleStr;
    if (self.type == InfoStyleYiLiao) self.navigationBarTitle = @"医疗资讯";
    if (self.type == InfoStyleShangYe) self.navigationBarTitle = @"商业资讯";
    if (self.type == InfoStyleSanJin) self.navigationBarTitle = @"三金资讯";
    if (self.type == InfoStyleYouJiao) self.navigationBarTitle = @"幼教动态";
    self.view.backgroundColor = [UIColor whiteColor];
    //创建视图
//    [self creatSegment];

    [self creatTableView];
    [self setupRefresh];

    
}



- (NSMutableArray *)requestArr
{
    if (_requestArr == nil) {
        _requestArr = [[NSMutableArray alloc]init];
    }
    return _requestArr;
}

- (NSMutableArray *)noteArr
{
    if (!_noteArr) {
        _noteArr = [[NSMutableArray alloc]init];
    }
    return _noteArr;
}

- (NSMutableArray *)hotlineArr
{
    if (!_hotlineArr) {
        _hotlineArr = [[NSMutableArray alloc]init];
    }
    return _hotlineArr;
}
#pragma mark - *************项目资讯页面请求数据*************
-(void)requestInforData:(NSInteger )pagenum{
    [self presentLoadingTips];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"5",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"项目资讯dt:%@",dt);
    NSString *url = HomeInformationListUrl;
    if (self.type == InfoStyleWenZhang) url = self.url;
    if (self.type == InfoStyleYiLiao) url = MedicalInfoListUrl;
    if (self.type == InfoStyleShangYe) url = BusinessInfoListUrl;
    if (self.type == InfoStyleSanJin) url = GoldenInfoListUrl;
    if (self.type == InfoStyleYouJiao) url = PreschoolInfoListUrl;
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt success:^(id response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"项目资讯:%@",response);
        if ([str isEqualToString:@"1"]) {
            if (pagenum == 1) {
                [self.noteArr removeAllObjects];
            }
            self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            NSArray *arr = [response objectForKey:@"data"];
            for (NSDictionary *dic in arr) {
                [self.noteArr addObject:dic];
            }
    
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        self.page = 1;
                        self.more = @"1";
                        [self requestInforData:self.page];
                    }
                    
                }];
            }
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];

        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}






#pragma mark - 创建TableView
- (void)creatTableView
{
    self.tableView = [[baseTableview alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"InformationTableViewCell" bundle:nil] forCellReuseIdentifier:@"InformationTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HealthEducateListTableViewCell" bundle:nil] forCellReuseIdentifier:@"HealthEducateListTableViewCell"];
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"infocell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - 配置TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.noteArr.count;
}

#pragma mark - *************cell内容***********

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == InfoStyleWenZhang) {
        HealthEducateListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthEducateListTableViewCell"];
        [cell setCellWithDict:self.noteArr[indexPath.row] indexPath:indexPath];
        return cell;
    }
    InformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dt = self.noteArr[indexPath.row];
//    NSString *index_img = dt[@"index_img"];
//    if (index_img && index_img.length) {
//        cell.imageTop.constant = 15;
//        cell.imageBottom.constant = 15;
//        cell.titleLeft.constant = 10;
//        [cell.iconimage sd_setImageWithURL:[NSURL URLWithString:index_img] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
//    }else{
//        cell.imageTop.constant = 10;
//        cell.imageBottom.constant = 10;
//        cell.iconimage.image = nil;
//        cell.titleLeft.constant = - 40 * 115/91.0 ;
//    }
    [cell setCellWithDict:dt indexPath:indexPath];
//    cell.timeWidth.constant = [cell.timeLb.text selfadap:13 weith:20].width + 10;
    return cell;

}


#pragma mark - *************cell高度***********
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

//    if (self.noteArr.count) {
//        NSDictionary *dt = self.noteArr[indexPath.row];
//        NSString *index_img = dt[@"index_img"];
//        if (index_img && index_img.length) {
            return 100;
//        }
//    }
//    return 70;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    InforViewController *line = [[InforViewController alloc]init];
    line.type = self.type;
    line.detailid = self.noteArr[indexPath.row][@"id"];
    [self.navigationController pushViewController:line animated:YES];


}

#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.more = @"1";
        [self requestInforData:self.page];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多数据了"];
            [self.tableView.mj_footer endRefreshing];
        }else{
            self.page ++;
            [self requestInforData:self.page];
        }
        
    }];
    
}
#pragma mark 页面将要显示
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

}



-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.isPop = nil;
    
}




@end
