//
//  PhoneOpenDoorViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/2/25.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "PhoneOpenDoorViewController.h"
#import "UINavigationController+TZPopGesture.h"
#import "OpenDoorTableViewCell.h"
@interface PhoneOpenDoorViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *tableview;

@end

@implementation PhoneOpenDoorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"手机开门";
//    self.navigationHidden = YES;

    
//    [self creatableview];
//    [self UploadDatalateContingency];
}


-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(void)creatableview{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"attendcell"];
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[OpenDoorTableViewCell class] forCellReuseIdentifier:@"OpenDoorTableViewCell"];
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]init];
    [header addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.equalTo(header.mas_centerY);
    }];
    [btn setTitle:@" 滑动按钮开门" forState:UIControlStateNormal];
    [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setImage:[UIImage imageNamed:@"tishi_icon"] forState:UIControlStateNormal];
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [UIImage imageNamed:@"beijing_shoujikaimen"].size.height + 20;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * Identifier = [NSString stringWithFormat:@"OpenDoorcell_%ld",(long)indexPath.row];
    NSDictionary *dt = self.dataArray[indexPath.row];
    OpenDoorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[OpenDoorTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    [self tz_addPopGestureToView:cell.dwslider];
    cell.jsonDt = dt;
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    return nil;
    
}

#pragma mark - *************设备号列表*************
-(void)UploadDatalateContingency{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    LFLog(@"设备号列表dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,AccessGetDeviceNoUrl) params:dt success:^(id response) {
        LFLog(@"设备号列表：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *dt in response[@"data"]) {
                [self.dataArray addObject:dt];
            }
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self UploadDatalateContingency];
                    }
                    
                }];
            }
            [self presentLoadingTips:[NSString stringWithFormat:@"%@",response[@"status"][@"error_desc"]]];
        }
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        [_tableview.mj_header endRefreshing];
    }];
    
}

#pragma mark - *************推送消息已读*************
-(void)UploadDataHaveRead:(NSString *)log_id{
    NSDictionary * nameuser =[userDefaults objectForKey:@"nameuser"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (nameuser) {
        [dt setObject:nameuser forKey:@"tag"];
    }
    if (log_id) {
        [dt setObject:log_id forKey:@"log_id"];
    }
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PushMessageReadUrl) params:dt success:^(id response) {
        LFLog(@"推送消息反馈：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
        }else{
        }
    } failure:^(NSError *error) {
        [_tableview.mj_header endRefreshing];
    }];
    
}
-(BOOL)fd_interactivePopDisabled{
    return YES;
}
@end
