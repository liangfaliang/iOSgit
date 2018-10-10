//
//  SelectAddressViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/1.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "SelectAddressViewController.h"
#import "ManageAddressTableViewCell.h"
#import "ManageAddressViewController.h"
#import "ConfirmOrderViewController.h"
@interface SelectAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation SelectAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"选择收货地址";
    
    [self createTableview];
    
    [self setupRefresh];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
//管理
-(void)rightItemClick:(UIBarButtonItem *)barbtn{
    ManageAddressViewController *manage = [[ManageAddressViewController alloc]init];
    for (NSDictionary *dt in self.dataArray) {
        [manage.dataArray addObject:dt];
    }
    [self.navigationController pushViewController:manage animated:YES];

}
-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height  + 50)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"ManageAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"ManageAddressTableViewCell"];
    [self.view addSubview:self.tableview];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSDictionary *dt = self.dataArray[indexPath.section];
    NSString *addstr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ ",dt[@"country_name"],dt[@"province_name"],dt[@"city_name"],dt[@"district_name"],dt[@"address"]];
    CGSize size = CGSizeZero;

    if ([dt[@"default_address"] isEqual:@1]) {
        size = [[NSString stringWithFormat:@"（默认地址）%@",addstr] selfadap:15 weith:20];
    }else{
       size = [addstr selfadap:15 weith:20];
    }
    return 55 + size.height;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ManageAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ManageAddressTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.addressHeight.constant = 10;
    cell.manageView.hidden = YES;
    NSDictionary *dt = self.dataArray[indexPath.section];
    cell.addname.text = dt[@"consignee"];
    NSString *addstr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ ",dt[@"country_name"],dt[@"province_name"],dt[@"city_name"],dt[@"district_name"],dt[@"address"]];
    
    if ([dt[@"default_address"] isEqual:@1]) {
        cell.addressLb.attributedText = [self AttributedString:[NSString stringWithFormat:@"（默认地址）%@",addstr] attstring:@"（默认地址）"];
    }else{
        cell.addressLb.attributedText = [self AttributedString:addstr attstring:@""];
    }
    cell.addPhone.text = dt[@"mobile"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSArray *vcarr = self.navigationController.viewControllers;
    for (UIViewController *vc in vcarr) {
        if ([vc isKindOfClass:[ConfirmOrderViewController class]]) {
            ConfirmOrderViewController *con = (ConfirmOrderViewController *)vc;

            con.addressDict = self.dataArray[indexPath.section];
            LFLog(@"con.addressDict:%@",con.addressDict);
            [con updateTableview];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIImageView *view = [[UIImageView alloc]init];
    view.image = [UIImage imageNamed:@"fengexiantongyong"];
    
    return view;
}
-(NSMutableAttributedString *)AttributedString:(NSString *)allstr attstring:(NSString *)attstring{
    NSMutableAttributedString* htinstr = [[NSMutableAttributedString alloc]initWithString:allstr];
    NSString *str = attstring;
    NSRange range =[[htinstr string]rangeOfString:str];
    [htinstr addAttribute:NSForegroundColorAttributeName value:JHColor(255, 79, 0) range:range];
    [htinstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    return htinstr;
    
}
#pragma mark - *************收货人地址请求*************
-(void)UploadDataAddressList{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,AddressListUrl) params:dt success:^(id response) {
        [self.tableview.mj_header endRefreshing];
        LFLog(@"收货人地址：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *dt in response[@"data"]) {
                [self.dataArray addObject:dt];
            }
            [self.tableview reloadData];
        }else{
            
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self UploadDataAddressList];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            [self.tableview reloadData];
        }
        
    } failure:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
    }];
    
    
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self UploadDataAddressList];
    }];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self UploadDataAddressList];
}
@end
