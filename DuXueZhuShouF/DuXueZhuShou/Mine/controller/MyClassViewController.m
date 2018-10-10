//
//  MyClassViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "MyClassViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "MyClassStudentViewController.h"
@interface MyClassViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation MyClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle =  @"我的班级";
    [self.view addSubview:self.tableView];
    [self UpData];
}
-(void)UpData{
    [super UpData];
    self.page = 1;
    self.more = 0;
    [self getDataList:1];
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
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    __block TextFiledModel *cmo = self.dataArray[indexPath.row];
    
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;

    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TextFiledModel *cmo = self.dataArray[indexPath.row];
    MyClassStudentViewController *vc = [[MyClassStudentViewController alloc]init];
    vc.class_id = cmo.idStr;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 获取列表
- (void)getDataList:(NSInteger )pageNum{

    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,InsClassListUrl) params:nil viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            [self.dataArray removeAllObjects];
//            self.more = [response[@"data"][@"isEnd"] integerValue];
            [TextFiledModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"idStr" : @"id"};
            }];
            for (NSDictionary *temDt in response[@"data"]) {
                TextFiledModel *model = [TextFiledModel mj_objectWithKeyValues:temDt];
                model.rightim = @"1";
                [self.dataArray addObject:model];
            }
            [TextFiledModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
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
