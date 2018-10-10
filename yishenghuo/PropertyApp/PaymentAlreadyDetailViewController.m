//
//  PaymentAlreadyDetailViewController.m
//  PropertyApp
//
//  Created by admin on 2018/8/13.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "PaymentAlreadyDetailViewController.h"
#import "PaymentAlreadyHeaderView.h"
#import "PaymentListTableViewCell.h"

@interface PaymentAlreadyDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)PaymentAlreadyHeaderView *headerview;
@property(nonatomic, strong)NSDictionary *dataDt;

@end

@implementation PaymentAlreadyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"账单详情";
    [self.view addSubview:self.tableView];
    [self getData];
}

-(PaymentAlreadyHeaderView *)headerview{
    if (_headerview == nil) {
        _headerview = [[NSBundle mainBundle]loadNibNamed:@"PaymentAlreadyHeaderView" owner:nil options:nil].firstObject;
    }
    return _headerview;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH ) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.rowHeight = -1;
        _tableView.estimatedSectionHeaderHeight = 150;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerNib:[UINib nibWithNibName:@"PaymentListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PaymentListTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PaymentListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PaymentListTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.dataArray.count;
    if (section > 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            PaymentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PaymentListTableViewCell class]) forIndexPath:indexPath];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            NSArray *keyArr = @[@"cu_name",@"oc_company",@"po_name",@"fr_period",@"hj"];
            for (int i = 1; i < 6; i ++) {
                NSString *name = [NSString stringWithFormat:@"lab%d",i];
                UILabel *lb = [cell valueForKey:name];
                lb.text = self.dataDt[keyArr[i - 1]];
                if (!lb.text.length) {
                    lb.text = @" ";
                }
            }
            cell.detailBtn.hidden = YES;
            cell.detailBtnHeight.constant = YES;
            [cell hideSubViews:YES];
            return cell;
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.textLabel.text = @"应缴费明细";
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = @"应缴费明细";
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section > 0 ? 40 : -1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section > 0) {
        UIView *header =[[UIView alloc]init];
        header.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 160, 40)];
        [btn setTitle:@"缴费明细" forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [header addSubview:btn];
        return header;
    }else{
        return self.headerview;
    }
    
    
}
#pragma mark - 获取列表
- (void)getData{
    NSString *coid = [UserDefault objectForKey:@"coid"] ? [UserDefault objectForKey:@"coid"] : @"";
    NSString *mobile = [UserDefault objectForKey:@"mobile"] ? [UserDefault objectForKey:@"mobile"] : @"";
    NSString *leid = [UserDefault objectForKey:@"leid"] ? [UserDefault objectForKey:@"leid"] : @"";
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    [dt setObject:coid forKey:@"coid"];
    [dt setObject:leid forKey:@"leid"];
    [dt setObject:mobile forKey:@"tel"];
    if (self.faid) [dt setObject:self.faid forKey:@"faid"];

    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,@"212") params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        //        NSInteger code = [response[@"code"] integerValue];
        if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
            self.dataDt = response[@"data"];
            [self refrshData];
        }else{
            
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

-(void)refrshData{
    if (self.dataDt) {
        [self.headerview.nameBtn setTitle:self.dataDt[@"oc_company"] forState:UIControlStateNormal];
        self.headerview.priceLb.text = self.dataDt[@"fa_total"];
        self.headerview.typeLb.text = self.dataDt[@"fa_way"];
        self.headerview.timeLb.text = self.dataDt[@"fa_date"];
        self.headerview.numLb.text = self.dataDt[@"faid"];
    }
}
@end
