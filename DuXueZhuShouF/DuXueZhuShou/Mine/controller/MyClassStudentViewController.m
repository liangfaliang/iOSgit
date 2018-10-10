//
//  MyClassStudentViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "MyClassStudentViewController.h"
#import "MyClassTableViewCell.h"
#import "AddStudentsViewController.h"
#import "LookStudentsViewController.h"
@interface MyClassStudentViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation MyClassStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self UpData];
    [self createBaritem];
}
-(void)UpData{
    [super UpData];
    self.page = 1;
    self.more = 0;
    [self getDataList:1];
}
-(void)createBaritem{
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.bottom.offset(-30);
    }];
    
}
#pragma mark  加
-(void)addClick{
    AddStudentsViewController *vc = [[AddStudentsViewController alloc]init];
    vc.model.class_id = self.class_id;
    WEAKSELF;
    vc.successBlock = ^{
        [weakSelf UpData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"MyClassTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyClassTableViewCell"];
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf UpData];
        }];
//        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [weakSelf footerWithRefresh];
//
//        }];
    }
    return _tableView;
}
-(void)footerWithRefresh{
    if (self.more == 1) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        self.page ++;
        [self getDataList:self.page];
    }
}
#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count ? self.dataArray.count + 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyClassTableViewCell" forIndexPath:indexPath];
    [cell setCellWithDict:indexPath.row == 0 ? nil : self.dataArray[indexPath.row - 1] indexPath:indexPath];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0) {
        LookStudentsViewController *vc = [[LookStudentsViewController alloc]init];
        vc.stuDt = self.dataArray[indexPath.row -1];
        vc.class_id = self.class_id;
        WEAKSELF;
        vc.successBlock = ^{
            [weakSelf UpData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 获取列表
- (void)getDataList:(NSInteger )pageNum{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.class_id) {
        [dt setObject:self.class_id forKey:@"class_id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,InsClassStudtentUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            if (pageNum == 1) {
                [self.dataArray removeAllObjects];
            }
//            self.more = [response[@"data"][@"isEnd"] integerValue];
            self.navigationBarTitle = response[@"data"][@"name"];
            for (NSDictionary *temDt in response[@"data"][@"student"]) {
                [self.dataArray addObject:temDt];
            }

        }else{
            [self presentLoadingTips:response[@"msg"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
@end
