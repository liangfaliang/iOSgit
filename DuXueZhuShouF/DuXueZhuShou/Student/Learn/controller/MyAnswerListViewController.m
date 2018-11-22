//
//  MyAnswerListViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "MyAnswerListViewController.h"
#import "MyAnswerListTableViewCell.h"
#import "AnswerDetailViewController.h"
#import "AskQuestionViewController.h"
#import "SPPageMenu.h"
#import "TeacherCountViewController.h"
@interface MyAnswerListViewController ()<UITableViewDataSource, UITableViewDelegate,SPPageMenuDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property(nonatomic, strong)NSMutableDictionary *dataDt;
@end

@implementation MyAnswerListViewController
-(instancetype)init{
    if (self = [super init]) {
        _isPublic = NO;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([UserUtils getUserRole] == UserStyleTeacher && self.isRecord){
        [self AddTitleview];
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    [self UpData];
    if ([UserUtils getUserRole] == UserStyleStudent) {
        if (self.isPublic) {
            self.navigationBarTitle = @"已公开问答";
        }else{
            self.navigationBarTitle = @"我的答疑";
            [self createBaritem];
        }
    }else if ([UserUtils getUserRole] == UserStyleTeacher){
        
        if (self.isRecord) {
            [self AddTitleview];
            UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"统计" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
            rightBar.tintColor = JHMaincolor;
            self.navigationItem.rightBarButtonItem = rightBar;
            [self getDataList:1 index:0];
            [self getDataList:1 index:1];
        }else{
            self.navigationBarTitle = @"督学助手";
        }

        
    }
    
}

-(void)AddTitleview{
    self.navigationItem.titleView = nil;
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0  , screenW, 44)];
    self.navigationItem.titleView = view;
    //主线程列队一个block， 这样做 可以获取到autolayout布局后的frame，也就是titleview的frame。在viewDidLayoutSubviews中同样可以获取到布局后的坐标
    WEAKSELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        //坐标系转换到titleview
        CGFloat width = 150;
        self.pageMenu.frame = CGRectMake((screenW - width)/2, SAFE_NAV_HEIGHT - 44, width, 44);
        self.pageMenu.frame = [weakSelf.view.window convertRect:self.pageMenu.frame toView:view];
        //centerview添加到titleview
        LFLog(@"=======:%@",NSStringFromCGRect(self.pageMenu.frame));
        [weakSelf.navigationItem.titleView addSubview:self.pageMenu];
//        weakSelf.navigationItem.titleView = weakSelf.pageMenu;
    });
}
-(void)UpData{
    [super UpData];
    self.page = 1;
    self.more = 0;
    if ([UserUtils getUserRole] == UserStyleTeacher && self.isRecord){
        [self.dataDt setObject:@"1" forKey:DataPage(self.pageMenu.selectedItemIndex)];
        [self.dataDt setObject:@"0" forKey:DataMore(self.pageMenu.selectedItemIndex)];
        [self getDataList:self.page index:self.pageMenu.selectedItemIndex];
    }else{
        [self getDataList:self.page index:-1];
    }

    
}
-(void)createBaritem{
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"已公开问答" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    rightBar.tintColor = JHMaincolor;
    self.navigationItem.rightBarButtonItem = rightBar;
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.bottom.offset(-30);
    }];
    
}
#pragma mark  公开问答
-(void)rightClick{
    if ([UserUtils getUserRole] == UserStyleTeacher){
        TeacherCountViewController *vc = [[TeacherCountViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MyAnswerListViewController *vc = [[MyAnswerListViewController alloc]init];
        vc.isPublic = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    

}
#pragma mark  加
-(void)addClick{
    AskQuestionViewController *vc = [[AskQuestionViewController alloc]init];
    vc.successBlock = ^{
        [self UpData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(NSMutableDictionary *)dataDt{
    
    if (_dataDt == nil) {
        _dataDt = [NSMutableDictionary dictionaryWithDictionary:@{DataKey(0):[NSMutableArray array],DataKey(1):[NSMutableArray array],DataPage(0):@"1",DataPage(1):@"1",DataMore(0):@"0",DataPage(1):@"0"}];
    }
    return _dataDt;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(SPPageMenu *)pageMenu{
    if (!_pageMenu) {
        CGFloat width = 150;
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
        [_pageMenu setItems:@[@"公开",@"普通"] selectedItemIndex:0];
        
    }
    return _pageMenu;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH  - (([UserUtils getUserRole] == UserStyleTeacher && self.isRecord) ? SAFE_BOTTOM_HEIGHT : 0)) style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"MyAnswerListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyAnswerListTableViewCell"];
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
    if ([UserUtils getUserRole] == UserStyleTeacher && self.isRecord){
        self.more = [self.dataDt[DataMore(self.pageMenu.selectedItemIndex)] integerValue];
        self.page = [self.dataDt[DataPage(self.pageMenu.selectedItemIndex)] integerValue];
    }
    if (self.more == 1) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        self.page ++;
        if ([UserUtils getUserRole] == UserStyleTeacher && self.isRecord){
            [self.dataDt setObject:[NSString stringWithFormat:@"%ld",(long)self.page] forKey:DataPage(self.pageMenu.selectedItemIndex)];
            [self getDataList:self.page index:self.pageMenu.selectedItemIndex];
        }else{
            [self getDataList:self.page index:-1];
        }
    }
}
#pragma mark - tableView
-(void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index{
    [self.tableView reloadData];
}
#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([UserUtils getUserRole] == UserStyleTeacher && self.isRecord){
        NSMutableArray *marr = self.dataDt[DataKey(self.pageMenu.selectedItemIndex)];
        return marr.count;
    }
        return self.dataArray.count;
//    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAnswerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyAnswerListTableViewCell class]) forIndexPath:indexPath];
    if ([UserUtils getUserRole] == UserStyleTeacher && self.isRecord){
        NSMutableArray *marr = self.dataDt[DataKey(self.pageMenu.selectedItemIndex)];
        cell.model = marr[indexPath.row];
    }else{
        cell.model = self.dataArray[indexPath.row];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerListModel *mo = nil;
    if ([UserUtils getUserRole] == UserStyleTeacher && self.isRecord){
        NSMutableArray *marr = self.dataDt[DataKey(self.pageMenu.selectedItemIndex)];
        mo = marr[indexPath.row];
    }else{
        mo = self.dataArray[indexPath.row];
    }
    AnswerDetailViewController *vc = [[AnswerDetailViewController alloc]init];
    vc.ID = mo.ID;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 获取列表
- (void)getDataList:(NSInteger )pageNum index:(NSInteger )index{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pageNum];
    [dt setObject:page forKey:@"page"];
    NSString *url = @"";
    if ([UserUtils getUserRole] == UserStyleStudent) {
        url = AnswerMyListUrl;
        if (self.isPublic) {
            [dt setObject:@"2" forKey:@"type"];
        }else{
            [dt setObject:@"1" forKey:@"type"];
        }
    }else if ([UserUtils getUserRole] == UserStyleTeacher){
        url = AnswerTeacherListUrl;
        if (self.isRecord) {
            [dt setObject:[NSString stringWithFormat:@"%lu",(unsigned long)index + 1] forKey:@"type"];
        }else{
            [dt setObject:@"3" forKey:@"type"];
        }
        
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,url) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            if ([UserUtils getUserRole] == UserStyleTeacher && self.isRecord){
                [self.dataDt setObject:response[@"data"][@"isEnd"] forKey:DataMore(index)];
                NSMutableArray *marr = self.dataDt[DataKey(index)];
                self.dataArray = marr;
            }
            if (pageNum == 1) {
                [self.dataArray removeAllObjects];
            }
            self.more = [response[@"data"][@"isEnd"] integerValue];
            for (NSDictionary *temDt in response[@"data"][@"list"]) {
                AnswerListModel *model = [AnswerListModel mj_objectWithKeyValues:temDt];
                [self.dataArray addObject:model];
            }
            
        }else{
            
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
@end
