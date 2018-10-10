//
//  SatisfactionListViewController.m
//  shop
//
//  Created by 梁法亮 on 16/9/12.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "SatisfactionListViewController.h"
#import "SatisfactionTableViewCell.h"
#import "SatisfactionViewController.h"

#import "SurveyResultsViewController.h"
@interface SatisfactionListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)baseTableview *tableveiw;
@property(nonatomic,strong)NSMutableArray *dataArray;
//数据请求对象
@property(nonatomic,strong)NSMutableArray *requestArr;
@property(nonatomic,copy)NSString *isSurver;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;
@end

@implementation SatisfactionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.page = 1;
    self.more = @"1";
    if (self.type_id) {
        self.navigationBarTitle = @"医疗满意度测评";
    }else if (self.type) {
        self.navigationBarTitle = @"测评列表";
    }else{
        self.navigationBarTitle = @"社区共建列表";
    }
    [self creatableveiw];
    [self setupRefresh];
    [self UploadDatalateContingency:1];


    
}
- (NSMutableArray *)requestArr
{
    if (_requestArr == nil) {
        _requestArr = [[NSMutableArray alloc]init];
    }
    return _requestArr;
}

-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
}

-(void)creatableveiw{
    
    self.tableveiw = [[baseTableview alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height ) style:UITableViewStyleGrouped];
    self.tableveiw.delegate = self;
    self.tableveiw.dataSource = self;
    self.tableveiw.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableveiw];
    [self.tableveiw registerNib:[UINib nibWithNibName:@"SatisfactionTableViewCell" bundle:nil] forCellReuseIdentifier:@"SatisfactionTableViewCell"];
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SatisfactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SatisfactionTableViewCell"];
    NSDictionary *dt = self.dataArray[indexPath.section];
    UIImage *im =[[UIImage alloc]init];
    if ([[NSString stringWithFormat:@"%@",dt[@"status"]] isEqualToString:@"1"]) {
        im =[UIImage imageNamed:@"toupiaozhong"];
    }else{
    
        im =[UIImage imageNamed:@"yijieshutoupiao"];
    }

    cell.iconimage.image = im;
    cell.labwidth.constant = SCREEN.size.width - im.size.width - 30;


    cell.titleLabel.text = [dt objectForKey:@"title"];

    cell.timeLabel.text = [NSString stringWithFormat:@"投票时间：%@至%@",[dt objectForKey:@"start_time"],[dt objectForKey:@"end_time"]];
    cell.timeLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//

    NSDictionary *dt = self.dataArray[indexPath.section];

    if ([[NSString stringWithFormat:@"%@",dt[@"status"]] isEqualToString:@"1"] && [[NSString stringWithFormat:@"%@",dt[@"is_com"]] isEqualToString:@"0"]) {
        SatisfactionViewController *hot = [[SatisfactionViewController alloc]init];
        if (self.type) {
            hot.type = self.type;
        }
        hot.strid = dt[@"id"];
        hot.type_id = self.type_id;
        [self.navigationController pushViewController:hot animated:YES];
//        [self surveryData:dt[@"id"] ];

    }else{

        SurveyResultsViewController *hot = [[SurveyResultsViewController alloc]init];
        hot.strid = dt[@"id"];
        if (self.type) {
            hot.type = self.type;
        }
        hot.type_id = self.type_id;
        [self.navigationController pushViewController:hot animated:YES];
    }
    

}

-(NSMutableAttributedString *)AttributedString:(NSString *)allstr attstring:(NSString *)attstring{
    NSMutableAttributedString* htinstr = [[NSMutableAttributedString alloc]initWithString:allstr];
    NSString *str = attstring;
    NSRange range =[[htinstr string]rangeOfString:str];
    [htinstr addAttribute:NSForegroundColorAttributeName value:JHColor(102, 102, 102) range:range];
    [htinstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    return htinstr;
    
}
#pragma mark - ************满意度调查*************
- (void)surveryData:(NSString *)strid{
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    [self presentLoadingTips];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithDictionary:@{@"userid":uid,@"id":strid}];
    if (self.type) {
        [dt setObject:self.type forKey:@"stfctype"];
    }
    if (self.type_id) {
        [dt setObject:self.type_id forKey:@"type_id"];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJguokaihangBaseUrl,@"52") params:dt success:^(id response) {
        [_tableveiw.mj_header endRefreshing];
        [self dismissTips];
        LFLog(@"是否投票：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        
        if ([str isEqualToString:@"0"]) {
            SatisfactionViewController *hot = [[SatisfactionViewController alloc]init];
            hot.strid = dt[@"id"];
            if (self.type) {
                hot.type = self.type;
            }
            [self.navigationController pushViewController:hot animated:YES];
        }else if ([str isEqualToString:@"2"]){
            
            [self presentLoadingTips:response[@"err_msg"]];

        }else{
             [self presentLoadingTips:response[@"err_msg"]];
            
        }
        
        
    } failure:^(NSError *error) {
        [self dismissTips];
      [_tableveiw.mj_header endRefreshing];
    }];
    
}

#pragma mark - *************满意度列表*************
- (void)UploadDatalateContingency:(NSInteger)pagenum{
    [self presentLoadingTips];
//    [LFLHttpTool get:@"https://mobile.juyouqian.com/app/index.shtml" params:nil success:^(id response) {
//        LFLog(@"测试数据：%@",response);
//    } failure:^(NSError *error) {
//        
//    }];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    if (self.type) {
        [dt setObject:self.type forKey:@"stfctype"];
    }
    if (self.type_id) {
        [dt setObject:self.type_id forKey:@"type_id"];
    }
    LFLog(@"满意度列表dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,SatisfactionListUrl) params:dt success:^(id response) {
        [_tableveiw.mj_header endRefreshing];
        [_tableveiw.mj_footer endRefreshing];
        [self dismissTips];
        LFLog(@"满意度列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *dt in response[@"data"]) {
                
                [self.dataArray addObject:dt];
                
            }
            if (self.dataArray.count) {
                [self.tableveiw reloadData];
                if (self.dataArray.count < 5) {
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
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@""]) {
                        [self UploadDatalateContingency:self.page];
                    }
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self createFootview];
        [self presentLoadingTips:@"暂无数据"];
      [_tableveiw.mj_header endRefreshing];
    }];
    
}

#pragma mark 集成刷新控件
- (void)setupRefresh
{

    _tableveiw.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.more = @"1";
        [self UploadDatalateContingency:1];
    }];
    _tableveiw.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多数据了"];
            [self.tableveiw.mj_footer endRefreshing];
        }else{
            self.page ++;
            [self UploadDatalateContingency:self.page];
        }
        
    }];
    
}



@end
