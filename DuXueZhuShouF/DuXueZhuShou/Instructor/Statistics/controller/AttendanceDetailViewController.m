//
//  AttendanceDetailViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AttendanceDetailViewController.h"
#import "SPPageMenu.h"
#import "TextFiledLableTableViewCell.h"
#import "SignInViewController.h"
#define attDataKey(str) [NSString stringWithFormat:@"status_%ld",(long)str +1]
@interface AttendanceDetailViewController ()<SPPageMenuDelegate,UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableDictionary *dataDt;

@end

@implementation AttendanceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self UpData];
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0  , screenW, 44)];
    self.navigationItem.titleView = view;
    WEAKSELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        //坐标系转换到titleview
        CGFloat width = 250;
        self.pageMenu.frame = CGRectMake((screenW - width)/2, SAFE_NAV_HEIGHT - 44, width, 44);
        self.pageMenu.frame = [weakSelf.view.window convertRect:self.pageMenu.frame toView:weakSelf.navigationItem.titleView];
        //centerview添加到titleview
        [weakSelf.navigationItem.titleView addSubview:self.pageMenu];
    });
    
    [self.pageMenu setItems:self.dataArr selectedItemIndex:0];
    
}
-(void)UpData{
    [super UpData];
    self.page = 1;
    [self getData];
}

-(NSMutableDictionary *)dataDt{
    if (_dataDt == nil) {
        _dataDt = [NSMutableDictionary dictionaryWithDictionary:@{attDataKey(0):[NSMutableArray array],
                                                                  attDataKey(1):[NSMutableArray array],
                                                                  attDataKey(2):[NSMutableArray array]}];
    }
    return _dataDt;
}
- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        NSArray *arr = @[@{@"name":@"正常签到"},@{@"name":@"异常签到"},@{@"name":@"未签到"}];
        for (NSDictionary *temdt in arr) {
            SPitemModel *model = [SPitemModel mj_objectWithKeyValues:temdt];
            [_dataArr addObject:model];
        }
    }
    return _dataArr;
}
-(SPPageMenu *)pageMenu{
    if (!_pageMenu) {
        CGFloat width = 250;
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
        
    }
    return _pageMenu;
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.estimatedSectionHeaderHeight = 70;
        _tableView.rowHeight = -1;
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"herader"];
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf UpData];
        }];

    }
    return _tableView;
}
-(void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index{
    [self.tableView reloadData];
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSMutableArray *marr = self.dataDt[attDataKey(self.pageMenu.selectedItemIndex)];
    return marr.count;;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *marr = self.dataDt[attDataKey(self.pageMenu.selectedItemIndex)];
    TextSectionModel *smo = marr[section];
    return smo.isSelect ? smo.child.count :0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *marr = self.dataDt[attDataKey(self.pageMenu.selectedItemIndex)];
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    cell.NameTfSpace.constant = 50;
    cell.nameBtn.titleLabel.numberOfLines = 1;
    __block   TextSectionModel *smo = marr[indexPath.section];
    __block  TextFiledModel *cmo = smo.child[indexPath.row];
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    cell.nameBtn.userInteractionEnabled =NO;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return -1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSMutableArray *marr = self.dataDt[attDataKey(self.pageMenu.selectedItemIndex)];
    TextFiledLableTableViewCell *header = [tableView dequeueReusableCellWithIdentifier:@"herader"];
    header.nameBtn.userInteractionEnabled = NO;
    header.nameBtn.titleLabel.numberOfLines = 1;
    header.backgroundColor = [UIColor whiteColor];
    header.tag = section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerClick:)];
    tap.cancelsTouchesInView = NO;
    [header addGestureRecognizer:tap];
    __block TextSectionModel *smo = marr[section];
    smo.tfmodel.leftim = smo.isSelect ? @"xlh" :@"enter" ;
    TextFiledModel *cmo = smo.tfmodel;
    header.model = cmo;
    header.NameTfSpace.constant = screenW - [cmo.name selfadapUifont:header.nameBtn.titleLabel.font weith:30].width - 40 - header.nameBtn.imageView.image.size.width - 40;
    
    return header;
}
-(void)headerClick:(UITapGestureRecognizer *)tap{
    NSMutableArray *marr = self.dataDt[attDataKey(self.pageMenu.selectedItemIndex)];
    TextFiledLableTableViewCell *header = (TextFiledLableTableViewCell *)tap.view;
    TextSectionModel *smo = marr[header.tag];
    smo.isSelect = smo.isSelect ? 0 : 1;
    [self.tableView reloadData];
    //    header.model = cmo;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *marr = self.dataDt[attDataKey(self.pageMenu.selectedItemIndex)];
    TextSectionModel *smo = marr[indexPath.section];
    TextFiledModel *cmo = smo.child[indexPath.row];
    SignInViewController *vc = [[SignInViewController alloc]init];
    vc.ID = self.ID;
    vc.date = self.date;
    vc.student_id = cmo.idStr;
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSMutableArray *marr = self.dataDt[attDataKey(self.pageMenu.selectedItemIndex)];
    if (!marr.count) {
        return  [super buttonTitleForEmptyDataSet:scrollView forState:state];
    }
    return nil;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    NSMutableArray *marr = self.dataDt[attDataKey(self.pageMenu.selectedItemIndex)];
    if (!marr.count) {
        [super emptyDataSet:scrollView didTapButton:button];
    }
}

#pragma mark - 获取列表
-(void)getData{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.ID) {
        [dt setObject:self.ID forKey:@"id"];
    }
    if (self.date) {
        [dt setObject:self.date forKey:@"date"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,AttendancStuStaUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self dismissTips];
        LFLog(@"获取考勤组:%@",response);
        NSNumber *code = @([response[@"code"] integerValue]);
        if (code.integerValue == 1) {
            NSArray *keyArr = @[@"status_1",@"status_2",@"status_3"];
            for (NSString *key in keyArr) {
                NSMutableArray *marr = self.dataDt[key];
                [marr removeAllObjects];
                [TextFiledModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"idStr" : @"id"};
                }];
                [TextSectionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"idStr" : @"id",@"child" : @"student"};
                }];
                for (NSDictionary *temDt in response[@"data"][key]) {
                    TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:temDt];
                    model.tfmodel = [TextFiledModel mj_objectWithKeyValues:@{@"name":temDt[@"name"],@"idStr":temDt[@"id"],@"leftim":@"enter"}];
                    model.tfmodel.isSelect = 1;
                    for (TextFiledModel *cmo in model.child) {
                        cmo.rightim = @"1";
                        if (!cmo.isSelect) model.tfmodel.isSelect = 0;
                    }
                    model.isSelect = 1;//默认展开
                    [marr addObject:model];
                }
                [TextFiledModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return nil;
                }];
                [TextSectionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return nil;
                }];

            }

        }else{
            [AlertView showMsg:response[@"msg"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self dismissTips];
        LFLog(@"error：%@",error);
    }];
}

@end
