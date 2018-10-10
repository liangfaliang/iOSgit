//
//  PaymentDetailViewController.m
//  PropertyApp
//
//  Created by admin on 2018/8/13.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "PaymentDetailViewController.h"
#import "GradesRankTableViewCell.h"
#import "PaymentListTableViewCell.h"
@interface PaymentDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;

@end

@implementation PaymentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"缴费详情";
    [self.view addSubview:self.tableView];
}



-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH ) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.rowHeight = -1;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerNib:[UINib nibWithNibName:@"GradesRankTableViewCell" bundle:nil] forCellReuseIdentifier:@"GradesRankTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PaymentListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PaymentListTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model.dqfy.count+ 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.dataArray.count;
    if (section > 0) {
        if ([self.model.dqfy[section-1][@"items"] isKindOfClass:[NSArray class]]) {
            NSArray *items = self.model.dqfy[section-1][@"items"];
            return items.count;
        }
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            PaymentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PaymentListTableViewCell class]) forIndexPath:indexPath];
            cell.model = self.model;
            cell.detailBtn.hidden = YES;
            cell.detailBtnHeight.constant = YES;
            [cell hideSubViews:YES];
            return cell;
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.textLabel.text = @"应缴费明细";
        return cell;
    }
    GradesRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GradesRankTableViewCell class]) forIndexPath:indexPath];
    NSArray *items = self.model.dqfy[indexPath.section-1][@"items"];
    NSDictionary *dt =items[indexPath.row];
    [cell setlabels:@[dt[@"it_name"],dt[@"fr_pric"],dt[@"fr_count"],[NSString stringWithFormat:@"%@元",dt[@"fr_amou"]]]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section ? 50 : 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header =[[UIView alloc]init];
    header.backgroundColor = [UIColor whiteColor];
    if (section ) {
        NSDictionary *dt = self.model.dqfy[section-1];
        UILabel *lb = [UILabel initialization:CGRectZero font:[UIFont systemFontOfSize:15] textcolor:[UIColor colorFromHexCode:@"E31042"] numberOfLines:2 textAlignment:0];
        lb.text = [NSString stringWithFormat:@"%@应缴金额%@元",dt[@"fr_month"],dt[@"month_money"]];
        [header addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(15);
            make.right.mas_offset(-15);
            make.bottom.mas_offset(0);
            make.top.mas_offset(0);
        }];
    }

    return header;
}
@end
