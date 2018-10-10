//
//  MyIntegralViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/7/21.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "MyIntegralViewController.h"
#import "MyWalletTableViewCell.h"
@interface MyIntegralViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *integralArr;
@property(strong,nonatomic)UILabel *integralLb;
@property(nonatomic,strong)NSString *more;
@property(nonatomic,assign)NSInteger page;
@end

@implementation MyIntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"我的积分";
    self.page = 1;
    self.more = @"1";
    [self createTable];
    [self setupRefresh];
    [self rotateData:1];
}

-(NSMutableArray *)integralArr{
    
    if (_integralArr == nil) {
        _integralArr = [[NSMutableArray alloc]init];
    }
    return _integralArr;
}

-(void)createTable{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height ) style:UITableViewStylePlain] ;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerNib:[UINib nibWithNibName:@"MyWalletTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyIntegralViewController"];
    UIImage *backim = [UIImage imageNamed:@"jinfen_yuan"];
    UIImage *im = [UIImage imageNamed:@"jifenmingxi_wenzi"];
    UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, backim.size.height + im.size.height + 40)];
    UIImageView *backimage = [[UIImageView alloc]init];
    backimage.image = backim;
    [headerview addSubview:backimage];
    [backimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerview.mas_centerX);
        make.top.offset(15);
        make.height.offset(backimage.image.size.height);
    }];
    self.integralLb = [[UILabel alloc]init];
    self.integralLb.textColor = [UIColor whiteColor];
    self.integralLb.numberOfLines = 0;
    self.integralLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
    NSString *meony  = [userDefaults objectForKey:@"user_pay_points"];
    if (meony == nil) {
        meony = @"0.00";
    }
    self.integralLb.attributedText = [[NSString stringWithFormat:@"积分\n%@",meony] AttributedString:@"积分" backColor:nil uicolor:nil uifont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    self.integralLb.textAlignment = NSTextAlignmentCenter;
    [backimage addSubview:self.integralLb ];
    [self.integralLb  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backimage.mas_centerX);
        make.centerY.equalTo(backimage.mas_centerY);
        
    }];
    
    UIImageView *integralIamge = [[UIImageView alloc]init];
    integralIamge.image = im;
    [headerview addSubview:integralIamge];
    [integralIamge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerview.mas_centerX);
        make.top.equalTo(backimage.mas_bottom).offset(15);
        make.height.offset(im.size.height);
    }];
    
    self.tableview.tableHeaderView = headerview;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.integralArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.001;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIntegralViewController"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dt = self.integralArr[indexPath.row];
    cell.nameLb.text = [NSString stringWithFormat:@"%@",dt[@"change_desc"]];
    cell.timeLb.text = [NSString stringWithFormat:@"%@",dt[@"add_time"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",dt[@"user_money"]];
    cell.priceLbWidth.constant = [cell.priceLabel.text selfadap:15 weith:20].width + 5;
    return cell;
    
}
#pragma mark 请求数据
-(void)rotateData:(NSInteger )pagenum{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    NSDictionary *dt = @{@"session":session,@"is_points":@"1",@"pagination":pagination};
    LFLog(@"请求数据dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,RechargeRecordingUrl) params:dt success:^(id response) {
        LFLog(@"请求数据:%@",response);
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {

            self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            if (pagenum == 1) {
                [self.integralArr removeAllObjects];
            }
            for (NSDictionary *dt in response[@"data"]) {
                [self.integralArr addObject:dt];
                
            }
       
            
            [self.tableview reloadData];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@""]) {
                        [self rotateData:self.page];
                    }
                }];
            }
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
        
    } failure:^(NSError *error) {
        [self presentLoadingTips:@"加载失败"];
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
    }];
    
}

#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.more = @"1";
        [self rotateData:self.page];
        //        [self wheelrequestData];
    }];
    //    _tableView.mj_footer = [MJRefreshBackFooter]
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多数据了"];
            [_tableview.mj_footer endRefreshing];
        }else{
            self.page ++;
            [self rotateData:self.page];
        }
        
    }];
}


@end
