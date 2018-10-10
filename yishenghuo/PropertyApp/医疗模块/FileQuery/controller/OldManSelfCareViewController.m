//
//  OldManSelfCareViewController.m
//  PropertyApp
//
//  Created by admin on 2018/8/29.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "OldManSelfCareViewController.h"
#import "TextFiledLableTableViewCell.h"
@interface OldManSelfCareViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation OldManSelfCareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"老年人生活自理能力评估表";
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH ) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = JHbgColor;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
        //        WEAKSELF;
        //        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //            [weakSelf getData];
        //        }];
    }
    return _tableView;
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TextSectionModel *smo = self.dataArray[section];
    return smo.child.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextFiledLableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFiledLableTableViewCell" forIndexPath:indexPath];
    TextSectionModel *smo = self.dataArray[indexPath.section];
    TextFiledModel *cmo = smo.child[indexPath.row];
    cell.model = cmo;
    cell.textfiled.textAlignment = NSTextAlignmentRight;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.dataArray.count - 1 > section) {
        TextSectionModel *model =  self.dataArray[section +1];
        return model.section ? 0.001 : 10;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    TextSectionModel *model =  self.dataArray[section];
    return model.section ? 40 : 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TextSectionModel *model =  self.dataArray[section];
    if (model.section) {
        UIView *header = [[UIView alloc]init];
        header.backgroundColor = JHbgColor;
        if (model.section) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, screenW - 30, 40)];
            [btn setTitle:model.section forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
            if (model.image) {
                [btn setImage:[UIImage imageNamed:model.image] forState:UIControlStateNormal];
            }
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [header addSubview:btn];
        }
        return header;
    }
    return nil;
}
#pragma mark - 数据
- (void)getData{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    NSString *uid = [UserDefault objectForKey:@"uid"];
    if (uid == nil) uid = @"";
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) coid = @"";
    coid = @"53";
    [dt setObject:coid forKey:@"coid"];
    [dt setObject:uid forKey:@"uid"];
    [dt setObject:@"1" forKey:@"iszb"];
    if (self.archive_no) {
        [dt setObject:self.archive_no forKey:@"hp_no"];
    }
    //
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,self.tr_InterfaceID) params:dt success:^(id response) {
        LFLog(@" 数据:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
                [self InitializationData:response[@"data"]];
            }
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
-(void)InitializationData:(NSDictionary *)dict{
    //基本信息
    NSArray *basicArr = @[@{@"key":@"zhengzhuang",
                            @"child":@[@{@"name":@"姓名",@"key":@"hp_name"},
                                       @{@"name":@"总得分",@"key":@"hp_no"}]
                            },
                          @{@"section":@"   自评表",
                            @"image":@"yibanzhuangk",
                            @"key":@"zhengzhuang",
                            @"child":@[]
                            }];
    
    for (NSDictionary *dt in basicArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:dt];
        for (TextFiledModel *cmo in model.child) {
            cmo.label = @"1";
            cmo.text = @"";
            NSDictionary *temDt = dict;
            if (temDt) {
                if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                    cmo.text = temDt[cmo.key];
                }
            }
        }
        [self.dataArray addObject:model];
    }
    NSArray *checkitemArr =dict[@"checkitem"];
    for (NSDictionary *temDt in checkitemArr) {
        TextSectionModel *model = [TextSectionModel mj_objectWithKeyValues:@{@"key":@"zhengzhuang",@"child":@[@{@"name":@"评估事项",@"key":@"hs_project"},@{@"name":@"等度等级",@"key":@"hsd_grade"},@{@"name":@"判断评分",@"key":@"hse_fraction"}]
                                                                             }];
        for (TextFiledModel *cmo in model.child) {
            cmo.label = @"1";
            if ([temDt[cmo.key] isKindOfClass:[NSString class]]) {
                cmo.text = temDt[cmo.key];
            }
        }
        [self.dataArray addObject:model];
    }

    [self.tableView reloadData];
}
@end
