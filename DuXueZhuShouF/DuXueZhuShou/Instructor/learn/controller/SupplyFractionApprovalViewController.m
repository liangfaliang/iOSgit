//
//  SupplyFractionApprovalViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/17.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "SupplyFractionApprovalViewController.h"
#import "TextFiledLableTableViewCell.h"
#import "DescriptionTableViewCell.h"
@interface SupplyFractionApprovalViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *selectTimeView;
@property(nonatomic, strong)IgDetailModel *model;
@property(nonatomic, strong)NSString *status;
@end

@implementation SupplyFractionApprovalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle =  @"补分审批"  ;

    [self.view addSubview:self.tableView];
    [self UpData];
    
}
-(void)UpData{
    [super UpData];
    [self getData];
}
-(void)createFootview{
    UIButton *footview = [[UIButton alloc]initWithFrame:CGRectMake(15, screenH -  60, screenW -  30,  50)];
    footview.backgroundColor = JHMaincolor;
    [footview setTitle:@"确定" forState:UIControlStateNormal];
    footview.titleLabel.font = [UIFont systemFontOfSize:15];
    [footview addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footview];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray *array = @[@{@"name":@"",@"key":@""},
                           @{@"name":@"申请人",@"text":@"",@"key":@""},
                           @{@"name":@"",@"key":@"",@"enable":@"1"},
                           @{@"name":@"补发积分",@"key":@"",@"enable":@"1",@"placeholder":@"请输入"}];
        for (NSDictionary *dt in array) {
            TextFiledModel *model = [TextFiledModel mj_objectWithKeyValues:dt];
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}
-(UIView *)selectTimeView{
    if (!_selectTimeView) {
  
        _selectTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW - 35 , 40)];
        for (int i = 0; i < 2; i ++) {
            ImTopBtn *btn = [[ImTopBtn alloc]initWithFrame:CGRectMake(i * 100, 0, 100, _selectTimeView.height_i)];
            btn.index = i;
            [btn addTarget:self action:@selector(SelectTimeClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"choosed"] forState:UIControlStateSelected];
            [btn setTitleColor:JHdeepColor forState:UIControlStateSelected];
            [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"   %@",i ? @"拒绝": @"同意"] forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"   %@",i ? @"拒绝": @"同意"] forState:UIControlStateSelected];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            if (i == 0) {
                btn.selected = YES;
                self.status = @"2";
            }
            [_selectTimeView addSubview:btn];
        }
    }
    return _selectTimeView;
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
        [_tableView registerNib:[UINib nibWithNibName:@"DescriptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"DescriptionTableViewCell"];
    }
    return _tableView;
}
-(void)SelectTimeClick:(ImTopBtn *)btn{
    btn.selected = YES;
    for (UIButton *sender in self.selectTimeView.subviews) {
        if (btn != sender) {
            sender.selected = NO;
        }
    }
    self.status = btn.index ? @"3" : @"2";
}
#pragma mark - 确定
-(void)submitClick{
    [self upDateLoad];
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model ? self.dataArray.count : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) return self.model ? 1 : 0;
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        DescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DescriptionTableViewCell class]) forIndexPath:indexPath];
        cell.Imodel = self.model;
        return cell;
    }
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];

    cell.model = self.dataArray[indexPath.section];;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    cell.nameBtn.userInteractionEnabled =NO;
    if (indexPath.section == 2 && self.model && (self.model.type.integerValue == 0)) {
        cell.textfiled.leftView = self.selectTimeView;
        cell.textfiled.leftViewMode = UITextFieldViewModeAlways;
    }else{
        cell.textfiled.leftView = nil;
    }
    return cell;
}
-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2 && self.model && (self.model.type.integerValue == 1)) {
        return 0.001;
    }
    return 10;
}
#pragma mark - 获取数据
- (void)getData{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (self.ID) {
        [dt setObject:self.ID forKey:@"id"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,IntegralTeaDetailUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            self.model = [IgDetailModel mj_objectWithKeyValues:response[@"data"]];
//            for (UIButton *sender in self.selectTimeView.subviews) {
//            }
            for (int i = 1 ; i < self.dataArray.count; i ++) {
                TextFiledModel *cmo = self.dataArray[i];
                if (i == 1) {
                    cmo.text = self.model.name;
                }
                if (i == 3 && self.model.score.integerValue > 0) {
                    cmo.text = self.model.score;
                }
                if (self.model.type.integerValue == 1) {
                    cmo.enable = nil;
                    if (i == 2) {
                        cmo.name = @"审批结果";
                        if (self.model.status.integerValue == 1) cmo.text = @"审核中";
                        if (self.model.status.integerValue == 2) cmo.text = @"同意";
                        if (self.model.status.integerValue == 3) cmo.text = @"拒绝";
                    }else if (i == 3){
                        cmo.text = self.model.score;
                    }
                }else{
                    self.tableView.height_i = screenH - 60;
                    [self createFootview];
                }
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
#pragma mark - 审批
- (void)upDateLoad{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    TextFiledModel *cmo = self.dataArray[3];
    if (cmo.text.length) {
        [dt setObject:cmo.text forKey:@"score"];
    }else{
        if ([self.status isEqualToString:@"2"]) {
            [self presentLoadingTips:@"请输入补发积分！"];
            return;
        }
    }
    if (self.ID) {
        [dt setObject:self.ID forKey:@"id"];
    }
    [dt setObject:self.status forKey:@"status"];
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,IntegralTeaSubmitUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            if (self.successBlock) {
                self.successBlock();
            }
            [self performSelector:@selector(dismissView) withObject:nil afterDelay:2.];
        }
        [self presentLoadingTips:response[@"msg"]];

    } failure:^(NSError *error) {

    }];
    
}
-(void)dismissView{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
