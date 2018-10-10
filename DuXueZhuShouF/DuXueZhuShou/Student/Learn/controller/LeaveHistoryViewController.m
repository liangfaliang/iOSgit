//
//  LeaveHistoryViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/9/4.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "LeaveHistoryViewController.h"
#import "TextFiledLableTableViewCell.h"
@interface LeaveHistoryViewController ()<UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation LeaveHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"请假历史" ;
    [self.view addSubview:self.tableView];
    [self UpData];
}
-(void)UpData{
    [super UpData];
    [self getData];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH -60) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.estimatedSectionHeaderHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"herader"];
    }
    return _tableView;
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TextSectionModel *smo = self.dataArray[section];
    return smo.isSelect ? smo.child.count :0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    cell.NameTfSpace.constant = 50;
    cell.nameBtn.titleLabel.numberOfLines = 1;
    TextSectionModel *smo = self.dataArray[indexPath.section];
    TextFiledModel *cmo = smo.child[indexPath.row];
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    cell.nameBtn.userInteractionEnabled =NO;
    cell.contentLbBlock = ^{
        LFLog(@"jjj");
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return -1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TextFiledLableTableViewCell *header = [tableView dequeueReusableCellWithIdentifier:@"herader"];
    header.nameBtn.userInteractionEnabled = NO;
    header.nameBtn.titleLabel.numberOfLines = 1;
    header.backgroundColor = [UIColor whiteColor];
    header.tag = section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerClick:)];
    tap.cancelsTouchesInView = NO;
    [header addGestureRecognizer:tap];
    __block TextSectionModel *smo = self.dataArray[section];
    smo.tfmodel.leftim = smo.isSelect ? @"xlh" :@"enter" ;
    TextFiledModel *cmo = smo.tfmodel;
    header.model = cmo;
    header.NameTfSpace.constant = screenW - [cmo.name selfadapUifont:header.nameBtn.titleLabel.font weith:30].width - 40 - header.nameBtn.imageView.image.size.width - 40;
    
    return header;
}
-(void)headerClick:(UITapGestureRecognizer *)tap{
    TextFiledLableTableViewCell *header = (TextFiledLableTableViewCell *)tap.view;
    TextSectionModel *smo = self.dataArray[header.tag];
    smo.isSelect = smo.isSelect ? 0 : 1;
    [self.tableView reloadData];
    //    header.model = cmo;
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (!self.dataArray.count) {
        return  [super buttonTitleForEmptyDataSet:scrollView forState:state];
    }
    return nil;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    if (!self.dataArray.count) {
        [super emptyDataSet:scrollView didTapButton:button];
    }
}

#pragma mark - 获取列表
- (void)getData{
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,LeaveInsHistoryUrl) params:nil viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"] ) {
            [self.dataArray removeAllObjects];
            //            self.more = [response[@"data"][@"isEnd"] integerValue];
            [TextFiledModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"idStr" : @"id",@"text" : @"leave_number"};
            }];
            [TextSectionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"idStr" : @"id",@"child" : @"student"};
            }];
            for (NSDictionary *temDt in response[@"data"]) {
                TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:temDt];
                model.tfmodel = [TextFiledModel mj_objectWithKeyValues:@{@"name":temDt[@"name"],@"idStr":temDt[@"id"],@"leftim":@"enter"}];
                for (TextFiledModel *cmo in model.child) {
                    cmo.label = @"1";
                    cmo.textcolor = @"3995FF";
                    if (cmo.text && cmo.text.integerValue > 0) {
                        cmo.text = [NSString stringWithFormat:@"%@次请假",cmo.text];
                    }
                }
                model.isSelect = 1;//默认展开
                [self.dataArray addObject:model];
            }
            [TextFiledModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return nil;
            }];
            [TextSectionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
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
