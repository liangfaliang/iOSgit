//
//  ReleaseGradeViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/16.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ReleaseGradeViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "EditGradeViewController.h"
@interface ReleaseGradeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation ReleaseGradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle =  @"成绩发布"  ;
    self.isEmptyDelegate = NO;
    [self.view addSubview:self.tableView];
    [self createBaritem];
    [self UpData];
    
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
    EditGradeViewController *vc = [[EditGradeViewController alloc]init];
    vc.typeStyle = EditGradeStyleRelease;
    WEAKSELF;
    vc.successBlock = ^{
        [weakSelf UpData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
//                NSArray *array = @[@{@"name":@"课表生效时间1",@"text":@"已发布",@"key":@"",@"label":@"1",@"textcolor":@"3995FF"},
//                                   @{@"name":@"课表失效时间2",@"text":@"保存",@"key":@"",@"label":@"1",@"textcolor":@"3995FF"},
//                                   @{@"name":@"课表失效时间3",@"text":@"保存",@"key":@"",@"label":@"1",@"textcolor":@"3995FF"}];
//                for (NSDictionary *dt in array) {
//                    TextFiledModel *model = [TextFiledModel mj_objectWithKeyValues:dt];
//                    [_dataArray addObject:model];
//                }
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH ) style:UITableViewStyleGrouped];
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
    TextFiledModel *cmo = self.dataArray[indexPath.row];
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    cell.nameBtn.userInteractionEnabled =NO;

    return cell;
}
-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TextFiledModel *cmo = self.dataArray[indexPath.row];
    EditGradeViewController *vc = [[EditGradeViewController alloc]init];
    vc.typeStyle = cmo.isSelect == 1 ? EditGradeStyleSave : EditGradeStyleEdit;
    vc.ID = cmo.idStr;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 获取列表
- (void)getDataList:(NSInteger )pageNum{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    [dt setObject:[NSString stringWithFormat:@"%ld",(long)pageNum] forKey:@"page"];
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,GradeInsListUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
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
                return @{@"idStr" : @"id",TisSelect : @"status"};
            }];
            for (NSDictionary *temDt in response[@"data"][@"list"]) {
                TextFiledModel *model = [TextFiledModel mj_objectWithKeyValues:temDt];
                if ([lStringFor(temDt[@"status"]) isEqualToString:@"1"]) {
                    model.text = @"保存";
                    model.textcolor = @"3995FF";
                }else{
                    model.text = @"已发布";
                    model.textcolor = @"666666";
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


