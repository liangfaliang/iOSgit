//
//  SurveyResultsViewController.m
//  shop
//
//  Created by 梁法亮 on 16/8/22.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "SurveyResultsViewController.h"
#import "SurveyTableViewCell.h"
#import "surveyModel.h"
#define maincolor JHColor(204, 229, 245)
@interface SurveyResultsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)baseTableview *tableview;
@property(nonatomic,strong)UIImageView *footimageview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger tetail;
@end

@implementation SurveyResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = maincolor;
    // Do any additional setup after loading the view.
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    if (self.type_id) {
        self.navigationBarTitle = @"测评结果";
    }else if (self.type) {
        self.navigationBarTitle = @"测评结果";
    }else{
        self.navigationBarTitle = @"社区共建调查结果";
    }
    
    self.footimageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dibeijing_manyidudiaocha"]];
//    [self.view addSubview:self.footimageview];
    self.footimageview.layer.masksToBounds = NO;
    self.footimageview.contentMode = UIViewContentModeBottom;
    CGFloat hh = SCREEN.size.width * self.footimageview.image.size.height/self.footimageview.image.size.width;
    self.footimageview.frame =CGRectMake(0, 0, SCREEN.size.width, hh + 30);
    [self createtableview];
    [self upDataforsurvey];
}

-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    
    return _dataArray;
}

-(void)createtableview{

    self.tableview = [[baseTableview alloc]initWithFrame:CGRectMake(15, 0, SCREEN.size.width - 30, SCREEN.size.height)];
    // - self.footimageview.height - 20
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorColor = maincolor;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.layer.cornerRadius = 10;
    self.tableview.layer.masksToBounds = NO;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.showsHorizontalScrollIndicator = NO;
//    self.tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 0)];
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[SurveyTableViewCell class] forCellReuseIdentifier:@"SurveyTableViewCell"];
    self.tableview.tableFooterView = self.footimageview;

}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
//    return 5;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SurveyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SurveyTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView removeAllSubviews];
    cell.tetail = self.tetail;
    cell.taga = indexPath.row + 1;
    cell.model = self.dataArray[indexPath.row];
    cell.backgroundColor = JHColoralpha(255, 255, 255, 0.6);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    surveyModel *model = self.dataArray[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"1.%@",model.subject_name];
    CGSize titlesize = [str selfadap:15 weith:20];
    CGFloat HH = 20;
    if (titlesize.height > HH) {
        HH = titlesize.height + 5;
    }
    
    NSMutableString *mstr = [NSMutableString string];
    for (int i = 0; i < model.option.count; i ++) {
        SurOptionModel *opmodel  = model.option[i];
        [mstr appendFormat:@"%@",opmodel.option];
        if (i < model.option.count - 1) {
            [mstr appendString:@","];
        }
    }
    NSString * text = [NSString stringWithFormat:@"答：%@; %@",mstr,model.opinion];
    CGFloat h = [text selfadap:15 weith:25].height + 10;
    
    return HH  + h + 30;

}


#pragma mark 数据请求
- (void)upDataforsurvey{
    
    [self presentLoadingTips];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.strid) {
        [dt setObject:self.strid forKey:@"id"];
    }
    if (self.type) {
        [dt setObject:self.type forKey:@"stfctype"];
    }
    if (self.type_id) {
        [dt setObject:self.type_id forKey:@"type_id"];
    }
    LFLog(@"满意度dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,SatisfactionSubmitResultUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        [self dismissTips];
        LFLog(@"满意度:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            self.tetail = [[NSString stringWithFormat:@"%@",response[@"data"][@"count"]] integerValue];
            for (NSDictionary *dt in response[@"data"][@"subject"]) {
                surveyModel *model = [[surveyModel alloc]initWithDictionary:dt error:nil];
                [self.dataArray addObject:model];
            }
            if ([response[@"data"][@"score"] isKindOfClass:[NSString class]]) {
                UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, 110)];
                header.backgroundColor = maincolor;
                UIButton *lb = [[UIButton alloc]init];
                [lb setBackgroundImage:[UIImage imageNamed:@"tiaotikuang_manyidu"] forState:UIControlStateNormal];
                [lb setTitle:response[@"data"][@"score"] forState:UIControlStateNormal];
                [lb setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                lb.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
                lb.titleLabel.numberOfLines = 0;
                lb.titleLabel.textAlignment = NSTextAlignmentCenter;
                [header addSubview:lb];
                [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(header.mas_centerX);
                    make.centerY.equalTo(header.mas_centerY);
                }];
//                UIView *vline = [[UIView alloc]initWithFrame:CGRectMake(0, header.height - 4, self.tableview.width, 8)];
//                vline.backgroundColor =JHColoralpha(255, 255, 255, 1);
//                vline.layer.cornerRadius = 4;
//                vline.layer.masksToBounds = YES;
//                [header addSubview:vline];
                self.tableview.tableHeaderView = header;
//                [self.view addSubview:header];
//                self.tableview.frame = CGRectMake(15, header.height + 64, SCREEN.size.width - 30, SCREEN.size.height - self.footimageview.height - 20 - header.height - 64);
            }
            [self.tableview reloadData];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@""]) {
                        [self upDataforsurvey];
                    }
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self dismissTips];
      [_tableview.mj_header endRefreshing];
    }];
    
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self upDataforsurvey];
    }];
}



@end
