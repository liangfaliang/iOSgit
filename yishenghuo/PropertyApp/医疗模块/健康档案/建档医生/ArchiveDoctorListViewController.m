//
//  ArchiveDoctorListViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/20.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ArchiveDoctorListViewController.h"
#import "ArchiveDoctorTableViewCell.h"
#import "DoctorInfoViewController.h"
@interface ArchiveDoctorListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(nonatomic,strong)baseTableview *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;
@property(nonatomic,strong)UISearchBar *searchbar;
@end

@implementation ArchiveDoctorListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    self.more = @"1";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[baseTableview alloc]initWithFrame:self.view.frame];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerNib:[UINib nibWithNibName:@"ArchiveDoctorTableViewCell" bundle:nil] forCellReuseIdentifier:@"ArchiveDoctorTableViewCell"];
    [self requestData:1];
    [self setupRefresh];
    [self createSearch];
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
-(void)createSearch{
    self.searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width - 120, 40)];
    self.searchbar.layer.cornerRadius = 5;
    self.searchbar.layer.masksToBounds = YES;
    self.searchbar.placeholder = @"  输入疾病|药品|症状|医生|检查";
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
    //    UIBarButtonItem *bt = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick:)];
    //    bt.tintColor = JHshopMainColor;
    //    self.navigationItem.rightBarButtonItem = bt;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    return self.dataArray.count;
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100 + 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArchiveDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArchiveDoctorTableViewCell"];

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@" 医术高超    热情亲切 "];
    text.yy_font = [UIFont boldSystemFontOfSize:13];
    text.yy_color = JHColor(53, 111, 23);

    NSRange range0 =[[text string]rangeOfString:@" 医术高超 "];
    [text yy_setBackgroundColor:JHColor(231, 242, 226) range:range0];
    
    NSRange range1 =[[text string]rangeOfString:@" 热情亲切 "];
    [text yy_setBackgroundColor:JHColor(236, 244, 232) range:range1];
    cell.descYYLb.attributedText = text;
//    [cell.picture sd_setImageWithURL:[NSURL URLWithString:dt[@"imgurl"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
//    cell.contentLb.text = dt[@"abstract"];
//    cell.titleLb.text = dt[@"name"];
//    cell.priceLb.text = dt[@"current_price"];
//    cell.numberLb.text = [NSString stringWithFormat:@"%@人已预约",(dt[@"join_count"] ? dt[@"join_count"]:@"")];
//    cell.priceLbWidth.constant = [cell.priceLb.text selfadap:17 weith:20].width + 10;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DoctorInfoViewController *detail = [[DoctorInfoViewController alloc]init];
    //    detail.titieStr = self.titieStr;
//    detail.listId = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:detail animated:YES];
    
}


#pragma mark - *************预约体检列表*************
-(void)requestData:(NSInteger )pagenum{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"预约体检列表dt:%@",dt);
    if (pagenum == 1) {
        [self.dataArray removeAllObjects];
    }
    //    if (self.cat_id) {
    //        [dt setObject:self.cat_id forKey:@"cat_id"];
    //    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,MedicalExaminationListUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"预约体检列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (![response[@"note"] isKindOfClass:[NSString class]]) {
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
                [self presentLoadingTips:@"数据格式错误！"];
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        self.page = 1;
                        self.more = @"1";
                        [self requestData:self.page];
                    }
                    
                }];
            }
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
