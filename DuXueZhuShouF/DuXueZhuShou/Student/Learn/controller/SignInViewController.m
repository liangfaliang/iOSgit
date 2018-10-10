//
//  SignInViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/1.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "SignInViewController.h"
#import "SignInHeaderView.h"
#import "SignInTableViewCell.h"
#import "SignInMapViewController.h"
@interface SignInViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)SignInHeaderView *headerview;
@property(nonatomic, strong)UIView *footerView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)StuSignInModel *model;
@property(nonatomic, strong)UIButton *signBtn;
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"考勤组";
    [self.view addSubview:self.tableView];
    self.tableView.estimatedSectionHeaderHeight = 100;
//    self.tableView.tableHeaderView = self.headerview;
    [self UpData];
}
-(void)UpData{
    [super UpData];
    self.page = 1;
    [self getData];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(SignInHeaderView *)headerview{
    if (_headerview == nil) {
        _headerview = [SignInHeaderView view];
    }
    return _headerview;
}
-(UIView *)footerView{
    if (_footerView == nil) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 200)];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(screenW/2 - 50, 50, 100, 100)];
        [btn setPropertys:@"" font:SYS_FONT(15) textcolor:[UIColor whiteColor] image:nil state:UIControlStateNormal];
        btn.backgroundColor = JHMaincolor;
        btn.layer.cornerRadius = 50;
        btn.layer.masksToBounds = YES;
        [btn setViewBorderColor:JHColor(189, 216, 240) borderWidth:5];
        [btn addTarget:self action:@selector(signBtnClcik) forControlEvents:UIControlEventTouchUpInside];
        _signBtn = btn;
        [_footerView addSubview:btn];
        
    }
    return _footerView;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 60;
        _tableView.rowHeight = -1;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"SignInTableViewCell" bundle:nil] forCellReuseIdentifier:@"SignInTableViewCell"];
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf UpData];
        }];
    }
    return _tableView;
}
#pragma mark - 签到
-(void)signBtnClcik{
    SignInMapViewController *vc = [[SignInMapViewController alloc]init];
    vc.successBlock = ^{
        [self UpData];
    };
    vc.smodel = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.model) return 0;
    if (section == 0) {
        return ((self.model.sign_in.time && self.model.sign_in.time.integerValue > 0) ? 1: 0) ;
    }
    return (self.model.sign_out.time && self.model.sign_out.time.integerValue > 0) ? 1 : 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  section == 0 ? -1 : 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return section == 0 ? self.headerview : nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SignInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SignInTableViewCell class]) forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.typeLb.text = @"上";
        cell.vlineBottom.hidden = NO;
        cell.vlineTop.hidden = YES;
        cell.model = self.model.sign_in;
    }else{
        cell.typeLb.text = @"下";
        cell.vlineBottom.hidden = YES;
        cell.vlineTop.hidden = NO;
        cell.model = self.model.sign_out;
    }
    return cell;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (self.model) {
        return  nil;
    }
    return [super buttonTitleForEmptyDataSet:scrollView forState:state];
}

#pragma mark - 获取详情
- (void)getData{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.ID) {
        [dt setObject:self.ID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,AttendanceDetailUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1 && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
            self.model = [StuSignInModel mj_objectWithKeyValues:response[@"data"]];
            self.headerview.model = self.model;
            if (self.model.status == 4 || self.model.status == 5) {
                self.tableView.tableFooterView = self.footerView;
                [_signBtn setTitle: self.model.status == 5 ? @"上课签到" : @"下课签退" forState:UIControlStateNormal];
            }else{
                self.tableView.tableFooterView = nil;
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
