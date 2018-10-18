//
//  StuNewsViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/7/26.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "StuNewsViewController.h"
#import "StuNewsTableViewCell.h"
#import "YBPopupMenu.h"
@interface StuNewsViewController ()<UITableViewDataSource, UITableViewDelegate,YBPopupMenuDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)ImTopBtn *rightBtn;

@end

@implementation StuNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationBarTitle = @"消息";
    [self.view addSubview:self.tableView];
    [self createBaritem];
    [self UpData];
   
}
-(void)UpData{
    [super UpData];
    self.page = 1;
    self.more = 0;
    [self getDataList:self.page];
}
-(void)createBaritem{
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    rightBar.tintColor = JHMaincolor;
    self.navigationItem.rightBarButtonItem = rightBar;
    
}
-(UIButton *)rightBtn{
    if (_rightBtn == nil) {
        _rightBtn = [[ImTopBtn alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
        _rightBtn.space = 10;
        _rightBtn.edgeInsetsStyle =  MKButtonEdgeInsetsStyleRight;
        [_rightBtn setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
        _rightBtn.tag = 1;
        [_rightBtn setTitle:@"全部" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:JHMaincolor forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = SYS_FONTBold(15);
        [_rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
#pragma mark  公开问答
-(void)rightClick{
    [YBPopupMenu showAtPoint:CGPointMake(screenW - 30, SAFE_NAV_HEIGHT) titles:@[@"全部", @"系统",@"其他"] icons:nil menuWidth:80 otherSettings:^(YBPopupMenu *popupMenu) {
        //        popupMenu.dismissOnSelected = NO;
        popupMenu.type = YBPopupMenuTypeDefault;
        popupMenu.isShowShadow = YES;
        popupMenu.delegate = self;
        popupMenu.offset = 5;
        popupMenu.textColor = JHMaincolor;
        
        //        popupMenu.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    }];
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
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerNib:[UINib nibWithNibName:@"StuNewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"StuNewsTableViewCell"];
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1;
            weakSelf.more = 0;
            [weakSelf getDataList:weakSelf.page];
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
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    //推荐回调
    NSLog(@"点击了 %@ 选项",ybPopupMenu.titles[index]);
    [self.rightBtn setTitle:ybPopupMenu.titles[index] forState:UIControlStateNormal];
    self.rightBtn.tag = index == 0 ? 1 : (4 - index);
    [self UpData];
}
#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
//        return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StuNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([StuNewsTableViewCell class]) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StuNewsModel *model  = self.dataArray[indexPath.row];
    [self HaveRead:model];
    
    [UserUtils MessagePushContriller:self type:model.type ID:model.ID push_data:model.push_data];
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
            [weakSelf DeleteData:weakSelf.dataArray[indexPath.row]];
        } failure:^{
            
        }];
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
#pragma mark - 删除
- (void)DeleteData:(StuNewsModel *)cmo{
    [self presentLoadingTips];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (cmo && cmo.ID.length) {
        [dt setObject:cmo.ID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,NewsDeleteUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
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
#pragma mark - 已读
- (void)HaveRead:(StuNewsModel *)cmo{
    [self presentLoadingTips];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (cmo && cmo.ID.length) {
        [dt setObject:cmo.ID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,NewsHaveReadUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"已读:%@",response);
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            cmo.is_read = @"1";
        }else{
            [self presentLoadingTips:response[@"msg"]];
        }
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
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pageNum];
    [dt setObject:page forKey:@"page"];
    [dt setObject:[NSString stringWithFormat:@"%ld",(long)self.rightBtn.tag] forKey:@"type"];
    if (pageNum == 1) {
        [self.dataArray removeAllObjects];
        [_tableView reloadData];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,NewsListUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"]) {
            if (pageNum == 1) {
                [self.dataArray removeAllObjects];
            }
            self.more = [response[@"data"][@"isEnd"] integerValue];
            for (NSDictionary *temDt in response[@"data"][@"list"]) {
                StuNewsModel *model  = [StuNewsModel mj_objectWithKeyValues:temDt];
                [self.dataArray addObject:model];
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
