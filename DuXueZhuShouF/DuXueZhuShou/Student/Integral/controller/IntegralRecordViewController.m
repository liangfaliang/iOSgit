//
//  IntegralRecordViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/9.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "IntegralRecordViewController.h"
#import "SPPageMenu.h"
#import "IntegralRecordTableViewCell.h"
@interface IntegralRecordViewController ()<SPPageMenuDelegate,UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation IntegralRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0  , screenW, 44)];
    self.navigationItem.titleView = view;
    //主线程列队一个block， 这样做 可以获取到autolayout布局后的frame，也就是titleview的frame。在viewDidLayoutSubviews中同样可以获取到布局后的坐标
    WEAKSELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        //坐标系转换到titleview
        self.pageMenu.frame = [weakSelf.view.window convertRect:self.pageMenu.frame toView:weakSelf.navigationItem.titleView];
        //centerview添加到titleview
        [weakSelf.navigationItem.titleView addSubview:self.pageMenu];
    });
    [self.view addSubview:self.tableView];
    [self UpData];
    
}
- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObjectsFromArray:@[@"今日",@"本周",@"总"]];
    }
    return _dataArr;
}
-(SPPageMenu *)pageMenu{
    if (!_pageMenu) {
        CGFloat width = 200;
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake((screenW - width)/2, SAFE_NAV_HEIGHT - 44, width, 44) trackerStyle:SPPageMenuTrackerStyleLine];
        _pageMenu.itemPadding = 10;
        _pageMenu.tracker.backgroundColor = JHAssistColor;
        _pageMenu.SPPageMenuLineColor = [UIColor clearColor];
        _pageMenu.backgroundColor = [UIColor clearColor];
        // 传递数组，默认选中第1个
        // 可滑动的自适应内容排列
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        // 设置代理
        _pageMenu.selectedItemTitleColor = JHAssistColor;
        _pageMenu.unSelectedItemTitleColor = JHmiddleColor;
        _pageMenu.delegate = self;
        [_pageMenu setItems:self.dataArr selectedItemIndex:0];
    }
    return _pageMenu;
}
-(void)UpData{
    [super UpData];
    self.page = 1;
    self.more = 0;
    [self getDataList:self.page];
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
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 70;
        _tableView.backgroundColor = JHbgColor;
        [_tableView registerNib:[UINib nibWithNibName:@"IntegralRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"IntegralRecordTableViewCell"];
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
#pragma mark - SPPageMenu
-(void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index{
    [self UpData];
}
#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.dataArray.count;
//    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IntegralRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntegralRecordTableViewCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    PunchOperationDetailViewController *vc = [[PunchOperationDetailViewController alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - 获取列表
- (void)getDataList:(NSInteger )pageNum{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pageNum];
    [dt setObject:page forKey:@"page"];
    [dt setObject:[NSString stringWithFormat:@"%lu",(unsigned long)self.pageMenu.selectedItemIndex + 1] forKey:@"type"];
    if (pageNum == 1) {
        [self.dataArray removeAllObjects];
        [_tableView reloadData];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,IntegralRecordUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
            if (pageNum == 1) {
                [self.dataArray removeAllObjects];
            }
            self.more = [response[@"data"][@"isEnd"] integerValue];
            for (NSDictionary *temDt in response[@"data"][@"list"]) {
                IgRecordModel *mo = [IgRecordModel mj_objectWithKeyValues:temDt];
                [self.dataArray addObject:mo];
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
