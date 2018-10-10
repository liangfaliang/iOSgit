//
//  ManageAddressViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/10/31.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ManageAddressViewController.h"
#import "ManageAddressTableViewCell.h"
#import "AddaddressViewController.h"
@interface ManageAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableview;


@end

@implementation ManageAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationBarTitle = @"管理收货地址";
    [self createTableview];
    [self createFootveiw];
    [self setupRefresh];
    if (!self.dataArray.count) {
        [self UploadDataAddressList];
    }
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(void)createFootveiw{
    UIButton *footbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN.size.height - 50, SCREEN.size.width, 50)];
    footbtn.backgroundColor = JHshopMainColor;
    [footbtn setTitle:@"添加新地址" forState:UIControlStateNormal];
    [footbtn addTarget:self action:@selector(footbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footbtn];


}
#pragma mark 添加地址
-(void)footbtnClick:(UIButton *)btn{
    AddaddressViewController *add = [[AddaddressViewController alloc]init];
    add.isAdd = NO;
    [self.navigationController pushViewController:add animated:YES];

}
-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height )];
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
    return 105 + size.height;
    
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
    cell.addressHeight.constant = 60;
    NSDictionary *dt = self.dataArray[indexPath.section];
    [cell setDefaultblock:^(NSInteger index) {
        if (index == 0) {//默认
            [self UploadDataDefault_address:dt[@"id"]];
        }else if (index == 1){//编辑
            AddaddressViewController *add = [[AddaddressViewController alloc]init];
            add.address_id = dt[@"id"];
            add.isAdd = NO;
            [self.navigationController pushViewController:add animated:YES];
        
        }else if (index == 2){//删除
        
            [self UploadDataDeleteaddress:dt[@"id"]];
        
        }
     }];
    
    cell.addname.text = dt[@"consignee"];
    NSString *addstr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ ",dt[@"country_name"],dt[@"province_name"],dt[@"city_name"],dt[@"district_name"],dt[@"address"]];
    cell.addressLb.text = addstr;
    if ([dt[@"default_address"] isEqual:@1]) {

        cell.defaultBtn.selected = YES;
    }else{
        cell.defaultBtn.selected = NO;
    }
    cell.addPhone.text = dt[@"mobile"];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIImageView *view = [[UIImageView alloc]init];
    view.image = [UIImage imageNamed:@"fengexiantongyong"];
    
    return view;
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
                    if ([response isEqualToString:@""]) {
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
#pragma mark - *************设置默认地址请求*************
-(void)UploadDataDefault_address:(NSString *)address_id{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:address_id,@"address_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,AddressDefaultUrl) params:dt success:^(id response) {
        LFLog(@"收货人地址：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
   
            [self UploadDataAddressList];
        }else{
            
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            [self.tableview reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - *************删除地址请求*************
-(void)UploadDataDeleteaddress:(NSString *)address_id{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:address_id,@"address_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,AddressDeleteUrl) params:dt success:^(id response) {
        LFLog(@"删除地址：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            
            [self UploadDataAddressList];
        }else{
            
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            [self.tableview reloadData];
        }
        
    } failure:^(NSError *error) {
        
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

@end
