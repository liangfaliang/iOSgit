//
//  MChooseBanKuaiViewController.m
//  meitan
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 fanyang. All rights reserved.
//

#import "MChooseBanKuaiViewController.h"


@interface MChooseBanKuaiViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArr;
@property (nonatomic, retain) NSDictionary *dict;
@end

@implementation MChooseBanKuaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"请选择";
    _dataArr = [[NSMutableArray alloc] init];
    [self getData];
    [self.view addSubview:self.tableView];
    if (self.isMultiple) {
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
        rightBar.tintColor = JHMaincolor;
        self.navigationItem.rightBarButtonItem  = rightBar;
    }
}
-(void)rightClick{
    NSMutableArray *marr = [NSMutableArray array];
    for (HSDTagModel *mo in self.dataArr) {
        if (mo.isSelect) {
            [marr addObject:mo];
        }
    }
    if (self.doneBlock) {
        self.doneBlock(nil,marr);
        [self cancleClick];
    }
}
- (void)cancleClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf getData];
        }];
    }
    return _tableView;
}
#pragma mark 申请类型

- (void)getData {
    [self presentLoadingTips];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];

    NSString *urlStr = @"";
    if (self.type == SelectPreschool) {
        NSDictionary * session =[userDefaults objectForKey:@"session"];
        if (session == nil) {
            session = @{};
        }
        [dt setObject:session forKey:@"session"];
        urlStr = NSStringWithFormat(ZJShopBaseUrl,PreschoolTypeUrl);
        [LFLHttpTool post:urlStr params:dt success:^(id response) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self dismissTips];
            NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
            if ([str isEqualToString:@"1"]) {
                NSArray *result = [response objectForKey:@"data"];
                for (NSDictionary *dic in result) {
                    [_dataArr addObject:[HSDTagModel mj_objectWithKeyValues:dic]];
                }
            }else{
                [self presentLoadingTips:response[@"status"][@"error_desc"]];
            }
            LFLog(@"response:%@",response);
            
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [self dismissTips];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self presentLoadingTips:@"服务器繁忙！"];
        }];
    }else {
        NSString *uid = [UserDefault objectForKey:@"uid"];
        NSString *coid = [UserDefault objectForKey:@"coid"];
        if (coid == nil) coid = @"";
        coid = @"53";
        [dt setObject:coid forKey:@"coid"];
        [dt setObject:uid forKey:@"uid"];
        [dt setObject:@"1" forKey:@"iszb"];
        if (self.codeid) {
            [dt setObject:[self.codeid stringByReplacingOccurrencesOfString:@"太原市" withString:@""] forKey:@"keyword"];
        }
        if (self.rs_type) {
            [dt setObject:self.rs_type forKey:@"rs_type"];
        }
        if (self.type == SelectReserveTime){
            urlStr = NSStringWithFormat(ZJERPIDBaseUrl,@"81");
        }if (self.type == SelectFileStandard){
            urlStr = NSStringWithFormat(ZJERPIDBaseUrl,@"110");
        }
        
        [LFLHttpTool get:urlStr params:dt success:^(id response) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self dismissTips];
            NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
            if (self.type == SelectFileStandard && [response[@"data"] isKindOfClass:[NSArray class]]){
                for (NSDictionary *dic in [response objectForKey:@"data"]) {
                    if ([dic[@"option_key"] isEqualToString:self.option_key]) {
                        NSString *option_value  = dic[@"option_value"];
                        NSArray *arr = [option_value componentsSeparatedByString:@","];
                        for (NSString *str in arr) {
                            HSDTagModel *mo = [[HSDTagModel alloc]init];
                            mo.content = str;
                            [_dataArr addObject:mo];
                        }
                        
                    }
                }
            }else{
                if ([str isEqualToString:@"1"]) {
                    if (self.type == SelectReserveTime){
                        self.dict = response[@"data"];;
                        for (NSDictionary *dic in self.dict[@"reserveDQ"]) {
                            HSDTagModel *model = [HSDTagModel mj_objectWithKeyValues:dic];
                            [_dataArr addObject:model];
                        }
                    } else{
                        NSArray *result = [response objectForKey:@"data"];
                        for (NSDictionary *dic in result) {
                            
                            [_dataArr addObject:[HSDTagModel mj_objectWithKeyValues:dic]];
                        }
                    }
                    
                }else{
                    [self presentLoadingTips:response[@"status"][@"error_desc"]];
                }
            }

            LFLog(@"response:%@",response);
            
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [self dismissTips];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self presentLoadingTips:@"服务器繁忙！"];
        }];
    }


}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.textColor = [UIColor colorFromHexCode:@"333333"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    HSDTagModel *model = _dataArr[indexPath.row];
     if (self.type == SelectReserveTime){
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",model.rs_reserveDate,model.reserveDQ];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"剩余%@人",model.avg_num_new];
        cell.detailTextLabel.textColor = JHMedicalColor;
     }else{
         cell.textLabel.text = model.content;
     }
    if (self.isMultiple && model.isSelect) {
        cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType =  UITableViewCellAccessoryNone;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isMultiple) {
        HSDTagModel *model = _dataArr[indexPath.row];
        model.isSelect = model.isSelect ? 0 : 1;
        [self.tableView reloadData];
    }else{
        if (self.doneBlock) {
            self.doneBlock(_dataArr[indexPath.row],self.dict);
            [self cancleClick];
        }
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
