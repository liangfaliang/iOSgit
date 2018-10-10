//
//  StudentGroupViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/10.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "StudentGroupViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "AddGroupViewController.h"
#import "EditGroupViewController.h"
#import "AddSignInViewController.h"
@interface StudentGroupViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)TextFiledModel *selectModel;

@end

@implementation StudentGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBarTitle = self.isSignSet ? @"签到设定" : @"学生组";
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
    if (self.isSignSet) {
        AddSignInViewController *vc = [[AddSignInViewController alloc]init];
        WEAKSELF;
        vc.successBlock = ^{
            [weakSelf UpData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        AddGroupViewController *vc = [[AddGroupViewController alloc]init];
        WEAKSELF;
        vc.successBlock = ^{
            [weakSelf UpData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
//        NSArray *array = @[@{@"name":@"   接受学生组",@"text":@"",@"key":@"",@"rightim":@"1",@"isSelect":@"1"},
//                           @{@"name":@"   作业下发时间",@"text":@"",@"key":@"",@"rightim":@"1"},
//                           @{@"name":@"   最晚打卡时间",@"text":@"",@"key":@"",@"rightim":@"1"},
//                           @{@"name":@"   未打卡提醒时间",@"text":@"",@"key":@"",@"rightim":@"1"}];
//        for (NSDictionary *dt in array) {
//            TextFiledModel *model = [TextFiledModel mj_objectWithKeyValues:dt];
//            if (!self.isSignSet) {
//                if (model.isSelect) {
//                    model.leftim = @"choosed";
//                }else{
//                    model.leftim = @"choose";
//                }
//            }
//
//            [_dataArray addObject:model];
//        }
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    __block TextFiledModel *cmo = self.dataArray[indexPath.row];
    if (!self.isSignSet) {
        if (cmo.isSelect) {
            cmo.leftim = @"choosed";
        }else{
            cmo.leftim = @"choose";
        }
    }

    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    if (!self.isSignSet) {
        cell.nameBtnBlock = ^{
            cmo.isSelect = cmo.isSelect ? 0 : 1;
            if (self.selectModel != cmo) self.selectModel.isSelect = 0;
            self.selectModel = cmo;
            self.model.value = nil;
            self.model.text = nil;
            if (cmo.isSelect){
                 self.model.value = cmo.idStr;
                 self.model.text = cmo.name;
            }
            [self.tableView reloadData];
        };
    }

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
    if (self.isSignSet) {
        EditGroupViewController *vc = [[EditGroupViewController alloc]init];
        
        vc.titleStr = cmo.name;
        vc.ID = cmo.idStr;
        WEAKSELF;
        vc.successBlock = ^{
            [weakSelf.dataArray removeObject:cmo];
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        AddGroupViewController *vc = [[AddGroupViewController alloc]init];
        WEAKSELF;
        vc.successBlock = ^{
            [weakSelf UpData];
        };
        vc.ID = cmo.idStr;
        [self.navigationController pushViewController:vc animated:YES];
    }

}
#pragma mark - 获取列表
- (void)getDataList:(NSInteger )pageNum{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    [dt setObject:[NSString stringWithFormat:@"%ld",(long)pageNum] forKey:@"page"];
    NSString *url = @"";
    if (self.isSignSet) {
        url = AttendanceListUrl;
    }else {
        url = OperationStuGroupListUrl;
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,url) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            if (pageNum == 1) {
                [self.dataArray removeAllObjects];
            }
            self.more = [response[@"data"][@"isEnd"] integerValue];
            [TextFiledModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"idStr" : @"id"};
            }];
            for (NSDictionary *temDt in response[@"data"][@"list"]) {
                TextFiledModel *model = [TextFiledModel mj_objectWithKeyValues:temDt];
                model.rightim = @"1";
                if (!self.isSignSet) {
                    if (self.model && [model.idStr isEqualToString:self.model.value]) {
                        model.isSelect = 1;
                        self.selectModel = model;
                    }
                    if (model.isSelect) {
                        model.leftim = @"choosed";
                    }else{
                        model.leftim = @"choose";
                    }

                }
                
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
