//
//  addressViewController4.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/5.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "addressViewController4.h"
#import "AddaddressViewController.h"
@interface addressViewController4 ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation addressViewController4
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height)];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell4"];
    [self UploadDataRegionList];
    
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    
    return _dataArray;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
    
    cell.textLabel.text = self.dataArray[indexPath.row][@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LFLog(@"region:%@",self.region);
    LFLog(@"regionid:%@",self.regionid);
    NSArray *vcarr = self.navigationController.viewControllers;
    for (UIViewController *vc in vcarr) {
        if ([vc isKindOfClass:[AddaddressViewController class]]) {
            AddaddressViewController *con = (AddaddressViewController *)vc;
            con.region = [NSString stringWithFormat:@"%@ %@",self.region,self.dataArray[indexPath.row][@"name"]];
            con.regionid = [NSString stringWithFormat:@"%@,%@",self.regionid,self.dataArray[indexPath.row][@"id"]];
            [con.tableview reloadData];
            [self.navigationController popToViewController:con animated:YES];
        }
    }

    
}

#pragma mark - *************地区列表*************
-(void)UploadDataRegionList{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.parent_id,@"parent_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,RegionListUrl) params:dt success:^(id response) {
        LFLog(@"地区列表：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *dt in response[@"data"][@"regions"]) {
                [self.dataArray addObject:dt];
            }
            [self.tableview reloadData];
        }else{
            
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self UploadDataRegionList];;
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            [self.tableview reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
@end
