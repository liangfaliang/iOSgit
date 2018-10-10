//
//  HotlineViewController.m
//  shop
//
//  Created by 梁法亮 on 16/8/15.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "HotlineViewController.h"

@interface HotlineViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (strong,nonatomic)UITableView *tableView;
@property (strong,nonatomic)UIView *view1;
@property (strong,nonatomic)UISegmentedControl *segment;
@property (nonatomic,strong)NSMutableArray *noteArr;//存储的信息数组
@property (nonatomic,strong)NSMutableArray *hotlineArr;//咨询热线数组
@property (nonatomic,strong)NSString *totalStr;//详细信息拼接


//数据请求对象
@property(nonatomic,strong)NSMutableArray *requestArr;

@end

@implementation HotlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestTelData];
    //    [self requestTelData];
    
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.navigationBarTitle  = @"服务热线";
    self.view.backgroundColor = [UIColor whiteColor];

    [self creatTableView];
    //刷新
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


#pragma mark - 创建TableView
- (void)creatTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height -64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"linecell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - 配置TableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return self.hotlineArr.count;
    
}

#pragma mark - *************cell内容***********


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textLabel.text = self.hotlineArr[indexPath.row][@"is_name"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.text = self.hotlineArr[indexPath.row][@"company_tel"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"服务热线" message:self.hotlineArr[indexPath.row][@"company_tel"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = indexPath.row;
    [alert show];
    

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        LFLog(@"拨打电话");
        
        NSString *tell = [NSString stringWithFormat:@"telprompt://%@",self.hotlineArr[alertView.tag][@"company_tel"]];
        NSURL *url = [NSURL URLWithString:tell];
        NSComparisonResult compare = [[UIDevice currentDevice].systemName compare:@"10.0"];
        if (compare == NSOrderedDescending || compare == NSOrderedSame) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }else{
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    
}
#pragma mark - *************服务热线页面请求数据*************
- (void)requestTelData{
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSDictionary *dt = @{@"userid":uid};
    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"7") params:dt success:^(id response) {
        [_tableView.mj_header endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            self.hotlineArr = nil;
            NSArray *arr = [response objectForKey:@"note"];
            for (NSDictionary *dic in arr) {
                [self.hotlineArr addObject:dic];
            }
            NSLog(@"获取成功");
            [self.tableView reloadData];

        }else{
            NSLog(@"获取失败");
            [self.tableView reloadData];
            
        }
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];        
    }];
    
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestTelData];
    }];
    
}



@end
