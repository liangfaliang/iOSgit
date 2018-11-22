//
//  PunchOperationListViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/7/30.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "PunchOperationListViewController.h"
#import "SPPageMenu.h"
#import "PunchOperationTableViewCell.h"
#import "PunchOperationDetailViewController.h"
#import "PostOperationViewController.h"
#import "LookOperationViewController.h"
#import "JobInsStatisticsViewController.h"
#import "PublishedViewController.h"
@interface PunchOperationListViewController ()<SPPageMenuDelegate,UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
//@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableDictionary *dataDt;
@end

@implementation PunchOperationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    self.more = 0;
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0  , screenW, 44)];
    self.navigationItem.titleView = view;
    //主线程列队一个block， 这样做 可以获取到autolayout布局后的frame，也就是titleview的frame。在viewDidLayoutSubviews中同样可以获取到布局后的坐标
    WEAKSELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        //坐标系转换到titleview
        CGFloat width = self.isHomework ? 200 :150;
        self.pageMenu.frame = [weakSelf.view.window convertRect:CGRectMake((screenW - width)/2, SAFE_NAV_HEIGHT - 44, width, 44) toView:weakSelf.navigationItem.titleView];
        //centerview添加到titleview
        [weakSelf.navigationItem.titleView addSubview:self.pageMenu];
    });
    [self.view addSubview:self.tableView];
    [self.pageMenu setItems:self.dataArr selectedItemIndex:0];
    if ([UserUtils getUserRole] == UserStyleInstructor) {
        if (!self.isHomework) {
            [self createBaritem];
        }
    }else{
        if (self.isHomework) {
            [self getDataList:1 index:2];
        }
    }
    [self getDataList:1 index:0];
    [self getDataList:1 index:1];
}
-(void)UpData{
    [super UpData];
    [self.dataDt setObject:@"1" forKey:DataPage(self.pageMenu.selectedItemIndex)];
    [self.dataDt setObject:@"0" forKey:DataMore(self.pageMenu.selectedItemIndex)];
    self.page = 1;
    self.more = 0;
    [self getDataList:self.page index:self.pageMenu.selectedItemIndex];
}
-(NSMutableDictionary *)dataDt{
    if (_dataDt == nil) {
        _dataDt = [NSMutableDictionary dictionaryWithDictionary:@{DataKey(0):[NSMutableArray array],DataPage(0):@"1",DataMore(0):@"0",DataKey(1):[NSMutableArray array],DataPage(1):@"1",DataMore(1):@"0",DataKey(2):[NSMutableArray array],DataPage(2):@"1",DataMore(2):@"0"}];
    }
    return _dataDt;
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
//    [self.navigationController pushViewController:[[LeaveSubmitViewController alloc]init] animated:YES];
    if ([UserUtils getUserRole] == UserStyleStudent) {

    }else if ([UserUtils getUserRole] == UserStyleInstructor){
        PostOperationViewController *vc = [[PostOperationViewController alloc]init];
        WEAKSELF;
        vc.successBlock = ^{
            [weakSelf UpData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        NSArray *arr = nil;
        if ([UserUtils getUserRole] == UserStyleStudent) {
            arr = self.isHomework ?  @[@{@"name":@"已完成"},@{@"name":@"未完成"},@{@"name":@"未打卡"}] : @[@{@"name":@"今日"},@{@"name":@"历史"}];
        }else if([UserUtils getUserRole] == UserStyleInstructor){
            arr = self.isHomework ? @[@{@"name":@"今日"},@{@"name":@"历史"}] :  @[@{@"name":@"待发布"},@{@"name":@"已发布"}];
        }
        for (NSDictionary *temdt in arr) {
            SPitemModel *model = [SPitemModel mj_objectWithKeyValues:temdt];
            [_dataArr addObject:model];
        }
    }
    return _dataArr;
}
-(SPPageMenu *)pageMenu{
    if (!_pageMenu) {
        CGFloat width = self.isHomework ? 200 :150;
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake((screenW - width)/2, SAFE_NAV_HEIGHT - 44, width, 44) trackerStyle:SPPageMenuTrackerStyleLine];
        _pageMenu.itemPadding = 10;
        _pageMenu.tracker.backgroundColor = JHMaincolor;
        _pageMenu.SPPageMenuLineColor = [UIColor clearColor];
        _pageMenu.backgroundColor = [UIColor clearColor];
        // 传递数组，默认选中第1个
        // 可滑动的自适应内容排列
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        // 设置代理
        _pageMenu.selectedItemTitleColor = JHMaincolor;
        _pageMenu.unSelectedItemTitleColor = JHmiddleColor;
        _pageMenu.delegate = self;

    }
    return _pageMenu;
}

//-(NSMutableArray *)dataArray{
//    if (!_dataArray) {
//        _dataArray = [NSMutableArray array];
//    }
//    return _dataArray;
//}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH ) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
         if ([UserUtils getUserRole] == UserStyleInstructor && self.isHomework){
             _tableView.height_i = screenH - SAFE_NAV_HEIGHT;
        }
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"PunchOperationTableViewCell" bundle:nil] forCellReuseIdentifier:@"PunchOperationTableViewCell"];
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
    self.more = [self.dataDt[DataMore(self.pageMenu.selectedItemIndex)] integerValue];
    if (self.more == 1) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        self.page = [self.dataDt[DataPage(self.pageMenu.selectedItemIndex)] integerValue];
        self.page ++;
        [self.dataDt setObject:[NSString stringWithFormat:@"%ld",(long)self.page] forKey:DataPage(self.pageMenu.selectedItemIndex)];
        [self getDataList:self.page index:self.pageMenu.selectedItemIndex];
    }
}
#pragma mark - SPPageMenudelegate
-(void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index{
    [self.tableView reloadData];
//    [self UpData];
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSMutableArray *marr = self.dataDt[DataKey(self.pageMenu.selectedItemIndex)];
    return marr.count;;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([UserUtils getUserRole] == UserStyleStudent && !self.isHomework && self.pageMenu.selectedItemIndex == 1) {
        NSMutableArray *marr = self.dataDt[DataKey(self.pageMenu.selectedItemIndex)];
        OperateListModel *mo = marr[section];
        return mo ? mo.list.count : 0;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([UserUtils getUserRole] == UserStyleStudent && !self.isHomework && self.pageMenu.selectedItemIndex == 1) {
        return 40;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([UserUtils getUserRole] == UserStyleStudent && !self.isHomework && self.pageMenu.selectedItemIndex == 1) {
        NSMutableArray *marr = self.dataDt[DataKey(self.pageMenu.selectedItemIndex)];
        OperateListModel *mo = marr[section];
        if (mo && mo.start_time) {
            UIView *header = [[UIView alloc]init];
            header.backgroundColor = [UIColor colorFromHexCode:@"F0F1F5"];
            UILabel *lb = [UILabel initialization:CGRectMake(15, 0, screenW - 30, 40) font:SYS_FONT(15) textcolor:JHmiddleColor numberOfLines:0 textAlignment:0];
            lb.text = [UserUtils getShowDateWithTime:mo.start_time dateFormat:@"yyyy.MM.dd"];
            [header addSubview:lb];
             return header;
        }
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PunchOperationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PunchOperationTableViewCell class]) forIndexPath:indexPath];
    if([UserUtils getUserRole] == UserStyleInstructor){
        cell.bageLb.hidden = YES;
    }
    NSMutableArray *marr = self.dataDt[DataKey(self.pageMenu.selectedItemIndex)];
    if ([UserUtils getUserRole] == UserStyleStudent && !self.isHomework && self.pageMenu.selectedItemIndex == 1) {
        OperateListModel *mo = marr[indexPath.section];
        cell.omodel = mo.list[indexPath.row];
    }else{
        cell.omodel = marr[indexPath.section];
    }
    
    [cell.contentLb NSParagraphStyleAttributeName:5];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block NSMutableArray *marr = self.dataDt[DataKey(self.pageMenu.selectedItemIndex)];
    if ([UserUtils getUserRole] == UserStyleStudent) {
        OperateListModel *lmo = marr[indexPath.section];
        if (!self.isHomework && self.pageMenu.selectedItemIndex == 1) lmo = lmo.list[indexPath.row];
        lmo.is_read = 1;
        PunchOperationDetailViewController *vc = [[PunchOperationDetailViewController alloc]init];
        vc.successBlock = ^{
            [self UpData];
        };
        vc.ID = lmo.ID;
        [self.navigationController pushViewController:vc animated:YES];
        [self refrshBage:self.pageMenu.selectedItemIndex];
    }else if ([UserUtils getUserRole] == UserStyleInstructor){
        OperateListModel *mo = marr[indexPath.section];
        if (self.isHomework) {
            PublishedViewController *vc = [[PublishedViewController alloc]init];
            vc.ID = mo.ID;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            
            LookOperationViewController *vc = [[LookOperationViewController alloc]init];
            vc.OperateID = mo.ID;
            WEAKSELF;
            vc.successBlock = ^(BOOL isDelete) {
                if (isDelete) {
                    [marr removeObjectAtIndex:indexPath.section];
                    [weakSelf.tableView reloadData];
                }else{
                    [weakSelf UpData];
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }

    
}
#pragma mark  刷新角标
-(void)refrshBage:(NSInteger )index{
    BOOL badge = NO;//默认不显示角标
    NSMutableArray *marr = self.dataDt[DataKey(index)];
    for (OperateListModel *temo in marr) {
        for (OperateListModel *ltmo in temo.list) {
            if (!ltmo.is_read) badge = YES;
        }
        if (!temo.list) {
            if (!temo.is_read) badge = YES;
        }
    }
    SPitemModel *smo = self.dataArr[index];
    smo.badge = badge ? @1 : nil;
    [self.pageMenu RefreshBtnBadge:index];
    [self.tableView reloadData];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([UserUtils getUserRole] == UserStyleInstructor) {
        NSMutableArray *marr = self.dataDt[DataKey(self.pageMenu.selectedItemIndex)];
        OperateListModel *mo = marr[indexPath.section];
        if (mo.status == 3) {
            return YES;
        }
    }
    return NO;
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
            NSMutableArray *marr = self.dataDt[DataKey(self.pageMenu.selectedItemIndex)];
            OperateListModel *mo = marr[indexPath.section];
            [weakSelf DeleteData:mo];
        } failure:^{
            
        }];
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
#pragma mark - 删除
- (void)DeleteData:(OperateListModel *)cmo{
    [self presentLoadingTips];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (cmo && cmo.ID.length) {
        [dt setObject:cmo.ID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,OperationInsDeleteUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"删除:%@",response);
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            NSMutableArray *marr = self.dataDt[DataKey(self.pageMenu.selectedItemIndex)];
            [marr removeObject:cmo];
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
- (void)getDataList:(NSInteger )pageNum index:(NSInteger )index{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    [dt setObject:[NSString stringWithFormat:@"%ld",(long)pageNum] forKey:@"page"];
    NSString *url = OperationStuNowListUrl;
    if ([UserUtils getUserRole] == UserStyleStudent) {
        if (!self.isHomework && index== 1) {
            url = OperationStuHistoryListUrl;
        }else{
            if (self.isHomework) {//1未打卡，2已完成，3未完成,4今日
                [dt setObject:index== 0 ? @"2" : (index== 1 ? @"3" : @"1") forKey:@"type"];
            }else{
                [dt setObject:@"4" forKey:@"type"];
            }
        }
    }else if ([UserUtils getUserRole] == UserStyleInstructor){
        if (self.isHomework) {//1待发布,2已发布，3今日
            [dt setObject: @"3" forKey:@"type"];
        }else{
            [dt setObject:index== 0 ? @"1" : @"2" forKey:@"type"];
        }
    }
//    NSInteger index = self.pageMenu.selectedItemIndex;
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,[UserUtils getUserRole] == UserStyleStudent ? url :OperationInsListUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            NSMutableArray *marr = self.dataDt[DataKey(index)];
            if (pageNum == 1) {
                [marr removeAllObjects];
            }
            [self.dataDt setObject:response[@"data"][@"isEnd"] forKey:DataMore(index)];
            for (NSDictionary *temDt in response[@"data"][@"list"]) {
                OperateListModel *model = [OperateListModel mj_objectWithKeyValues:temDt];
                [marr addObject:model];
            }
            if (!self.isHomework && [UserUtils getUserRole] == UserStyleStudent) {
                [self refrshBage:[url isEqualToString:OperationStuNowListUrl] ? 0 : 1];
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
