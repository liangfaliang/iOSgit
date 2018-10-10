//
//  LeaveListViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/7.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "LeaveListViewController.h"
#import "LeaveListTableViewCell.h"
#import "LeaveSubmitViewController.h"
#import "LeaveResultViewController.h"
#import "LeaveSubModel.h"
#import "LeaveHistoryViewController.h"
@interface LeaveListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation LeaveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self UpData];
    if ([UserUtils getUserRole] == UserStyleStudent) {
        self.navigationBarTitle = @"请假申请";
    }else if ([UserUtils getUserRole] == UserStyleInstructor){//考勤设定
        self.navigationBarTitle = @"请假审批";
    }
    
    [self createBaritem];
    
}
-(void)UpData{
    [super UpData];
    self.page = 1;
    self.more = 0;
    [self getDataList:self.page];
}
-(void)createBaritem{
    if ([UserUtils getUserRole] == UserStyleStudent) {
        UIButton *btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.bottom.offset(-30);
        }];
    }else if ([UserUtils getUserRole] == UserStyleInstructor){//考勤设定
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"请假历史" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
        rightBar.tintColor = JHMaincolor;
        self.navigationItem.rightBarButtonItem = rightBar;
    }

    

}
#pragma mark  查看详情
-(void)rightClick{
    LeaveHistoryViewController *vc = [[LeaveHistoryViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark  加
-(void)addClick{
    LeaveSubmitViewController *vc = [[LeaveSubmitViewController alloc]init];
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStylePlain];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"LeaveListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LeaveListTableViewCell"];
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf UpData];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf footerWithRefresh];
            
        }];
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
        return self.dataArray.count;
//    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeaveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LeaveListTableViewCell class]) forIndexPath:indexPath];
    if ([UserUtils getUserRole] == UserStyleStudent) {
        cell.nameLb.hidden = YES;
        cell.nameLbWidth.constant = 0;
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeaveResultViewController *vc = [[LeaveResultViewController alloc]init];
    LeaveSubModel  *model = self.dataArray[indexPath.row];
    vc.ID = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //第二组可以左滑删除
    return YES;
}
// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"shanchu");
        WEAKSELF;
        [self alertController:@"提示" prompt:@"是否删除" sure:@"是" cancel:@"否" success:^{
            [weakSelf DeleteData:self.dataArray[indexPath.row]];
        } failure:^{
            
        }];
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
#pragma mark - 删除
- (void)DeleteData:(LeaveSubModel *)cmo{
    [self presentLoadingTips];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (cmo && cmo.ID.length) {
        [dt setObject:cmo.ID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,[UserUtils getUserRole] == UserStyleStudent ? LeaveStuDeleteUrl :LeaveInsDeleteUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"删除:%@",response);
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            [self.dataArray removeObject:cmo];
        }
        [self presentLoadingTips:response[@"msg"]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - 获取列表
- (void)getDataList:(NSInteger )pageNum{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    [dt setObject:[NSString stringWithFormat:@"%ld",(long)pageNum] forKey:@"page"];
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,[UserUtils getUserRole] == UserStyleStudent ? LeaveStuListUrl :LeaveInsListUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            if (pageNum == 1) {
                [self.dataArray removeAllObjects];
            }
            self.more = [response[@"data"][@"isEnd"] integerValue];
            [LeaveSubModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"category" : @"name"};
            }];
            for (NSDictionary *temDt in response[@"data"][@"list"]) {
                LeaveSubModel *model = [LeaveSubModel mj_objectWithKeyValues:temDt];
                [self.dataArray addObject:model];
            }
            [LeaveSubModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return nil;
            }];
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
