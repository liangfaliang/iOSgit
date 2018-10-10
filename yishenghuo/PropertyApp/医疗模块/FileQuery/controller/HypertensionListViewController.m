

//
//  HypertensionListViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/8/28.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "HypertensionListViewController.h"
#import "FileIListTableViewCell.h"
#import "Diabetes2ViewController.h"
@interface HypertensionListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger index;

@end

@implementation HypertensionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"高血压患者随访服务记录列表";
    self.index = 0;
    [self initTableView];
    [self UpData];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)UpData{
    [self getData:self.index];
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}

#pragma mark - tableView
- (void)initTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH ) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //    _tableView.estimatedRowHeight = 60;
    _tableView.rowHeight = 100;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FileIListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FileIListTableViewCell class])];
    WEAKSELF;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData:1];
    }];
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FileIListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FileIListTableViewCell class]) forIndexPath:indexPath];
    NSDictionary *model = self.dataArray[indexPath.row];
    [cell.iconIm sd_setImageWithURL:[NSURL URLWithString:model[@""]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    cell.nameLb.text = model[@"hp_name"];
    cell.timeLb.text = model[@"hd_recodate"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{//个人基本信息表
    NSDictionary *model = self.dataArray[indexPath.row];
    Diabetes2ViewController *VC = [[Diabetes2ViewController alloc]init];
    [VC InitializationData:model];
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark - 数据
- (void)getData:(NSInteger )index{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    NSString *uid = [UserDefault objectForKey:@"uid"];
    if (uid == nil) uid = @"";
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) coid = @"";
    coid = @"53";
    [dt setObject:coid forKey:@"coid"];
    [dt setObject:uid forKey:@"uid"];
    [dt setObject:@"1" forKey:@"iszb"];
    if (self.archive_no) {
        [dt setObject:self.archive_no forKey:@"hp_no"];
    }
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,self.tr_InterfaceID) params:dt success:^(id response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        LFLog(@" 数据提交:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *temdt in [response objectForKey:@"data"]) {
                [self.dataArray addObject:temdt];
            }
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
@end
