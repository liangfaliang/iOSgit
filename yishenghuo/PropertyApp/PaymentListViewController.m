//
//  PaymentListViewController.m
//  PropertyApp
//
//  Created by admin on 2018/8/13.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "PaymentListViewController.h"
#import "PaymentListTableViewCell.h"
#import "PayNewModel.h"
#import "PaymentAlreadyTableViewCell.h"
#import "PaymentAlreadyDetailViewController.h"
@interface PaymentListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)UILabel *totalLb;
@end

@implementation PaymentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    if (self.type != PayMentStyleAlready) {
        [self createFootview];
    }
    [self UpData];

    
}
-(void)createFootview{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, self.tableView.height , screenW , 50)];
    footer.backgroundColor = JHbgColor;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(screenW - 120, 0, 120, 50)];
    btn.backgroundColor = [UIColor colorFromHexCode:@"E31042"];
    [btn setTitle:@"立即付款" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [footer addSubview:btn];
    UILabel *lb = [UILabel initialization:CGRectMake(15, 0, screenW - 140, 50) font:[UIFont systemFontOfSize:18] textcolor:[UIColor colorFromHexCode:@"E31042"] numberOfLines:0 textAlignment:0];
    lb.attributedText = [@"合计：0.00元" AttributedString:@"合计：" backColor:nil uicolor:JHdeepColor uifont:[UIFont systemFontOfSize:15]];
    self.totalLb = lb;
    [footer addSubview:lb];
    [self.view addSubview:footer];
}
-(void)UpData{
    [super UpData];
    self.page = 1;
    [self getDataList:self.page];
}
-(void)payClick{


}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH  -NaviH-40 - (self.type == PayMentStyleAlready ? 0 : 50)) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"PaymentListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PaymentListTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PaymentAlreadyTableViewCell" bundle:nil] forCellReuseIdentifier:@"PaymentAlreadyTableViewCell"];
        
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1;
            self.more = 1;
            [self getDataList:weakSelf.page];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.more == 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                weakSelf.page ++;
                [self getDataList:weakSelf.page];
            }
            
        }];
    }
    return _tableView;
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == PayMentStyleAlready) {
        
        PaymentAlreadyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PaymentAlreadyTableViewCell class]) forIndexPath:indexPath];
        cell.model = self.dataArray[indexPath.section];
        return cell;
    }
    PaymentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PaymentListTableViewCell class]) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.section];
    return cell;
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    PayNewModel *model = self.dataArray[section];
    if (self.type != PayMentStyleAlready && [model.fc_type isEqualToString:@"dqsf"]) {
        return 40;
    }
    return self.type != PayMentStyleAlready ? 10 : 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]init];
    PayNewModel *model = self.dataArray[section];
    if (self.type != PayMentStyleAlready && [model.fc_type isEqualToString:@"dqsf"]) {
        IndexBtn *btn = [[IndexBtn alloc]initWithFrame:CGRectMake(30, 0, 80, 40)];
        [btn setTitle:@"选择" forState:UIControlStateNormal];
        if (!model.isSelect) {
            [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor colorFromHexCode:@"E31042"] forState:UIControlStateNormal];
        }
        
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.section = section;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:btn];
    }

    return header;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == PayMentStyleAlready) {
        PayNewModel *model = self.dataArray[indexPath.section];
        PaymentAlreadyDetailViewController *vc = [[PaymentAlreadyDetailViewController alloc]init];
        vc.faid = model.faid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)btnClick:(IndexBtn *)btn{
    PayNewModel *model = self.dataArray[btn.section];
    model.isSelect = !model.isSelect;
    [self.tableView reloadData];
    float price = 0.00;
    for (PayNewModel *model in self.dataArray) {
        if (model.isSelect) {
            price += [model.hj floatValue];
        }
    }
    self.totalLb.attributedText = [[NSString stringWithFormat:@"合计：%.2f元",price] AttributedString:@"合计：" backColor:nil uicolor:JHdeepColor uifont:[UIFont systemFontOfSize:15]];
}
#pragma mark - 获取列表
- (void)getDataList:(NSInteger )pageNum{
    NSString *coid = [UserDefault objectForKey:@"coid"] ? [UserDefault objectForKey:@"coid"] : @"";
    NSString *mobile = [UserDefault objectForKey:@"mobile"] ? [UserDefault objectForKey:@"mobile"] : @"";
    NSString *leid = [UserDefault objectForKey:@"leid"] ? [UserDefault objectForKey:@"leid"] : @"";
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    [dt setObject:coid forKey:@"coid"];
    [dt setObject:leid forKey:@"leid"];
    [dt setObject:mobile forKey:@"tel"];
    if (self.type == PayMentStyleNew) [dt setObject:@"1" forKey:@"isThisMonth"];
    if (self.type == PayMentStyleHalfYear) [dt setObject:@"6" forKey:@"num"];
    if (self.type == PayMentStyleYear) [dt setObject:@"12" forKey:@"num"];
    if (pageNum == 1) {
        [self.dataArray removeAllObjects];
        [_tableView reloadData];
    }
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,self.type == PayMentStyleAlready ? @"211" :@"210") params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
//        NSInteger code = [response[@"code"] integerValue];
        if ([response[@"data"] isKindOfClass:[NSArray class]]) {
            if (pageNum == 1) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *temDt in response[@"data"]) {
                PayNewModel *model = [PayNewModel mj_objectWithKeyValues:temDt];
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
