//
//  ChildVaccinationRecordViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/23.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ChildVaccinationRecordViewController.h"
#import "ChildVaccinationRecordTableViewCell.h"
@interface ChildVaccinationRecordViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(nonatomic,strong)baseTableview *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;

@end

@implementation ChildVaccinationRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    self.more = @"1";
    self.view.backgroundColor = JHbgColor;
    [self createUI];
}

-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
-(void)createUI{

    self.tableview = [[baseTableview alloc]initWithFrame:self.view.frame];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    [self.tableview registerNib:[UINib nibWithNibName:@"ChildVaccinationRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChildVaccinationRecordcell"];
    self.tableview.backgroundColor = [UIColor clearColor];
    [self requestData:1];
    [self setupRefresh];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *vaccinateArr = self.dataArray[section][@"Vaccine"];
    if (vaccinateArr && vaccinateArr.count) {
        return vaccinateArr.count;
    }
    //    return self.dataArray.count;
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChildVaccinationRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildVaccinationRecordcell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    NSArray *vaccinateArr = self.dataArray[indexPath.section][@"Vaccine"];
    NSDictionary *dt = vaccinateArr[indexPath.row];
    if ([[NSString stringWithFormat:@"%@",dt[@"is_vac"]] isEqualToString:@"1"]) {//已注射
        cell.iconIm.image = [UIImage imageNamed:@"jiezhongwan"];
    }else{
        cell.iconIm.image = [UIImage imageNamed:@"weijiezhongwan"];
    }
    cell.nameLb.text = dt[@"va_name"];
    cell.timeLb.text = dt[@"vr_inoculation_date"];
    if (dt[@"times"] && [dt[@"times"] length]) {
        cell.numLb.text =[NSString stringWithFormat:@"(%@)",dt[@"times"]];
    }else{
        cell.numLb.text = @"";
    }
    
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = JHbgColor;
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(10, 10, screenW - 20, 39)];
    backview.backgroundColor = [UIColor whiteColor];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backview.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = backview.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    backview.layer.mask = maskLayer;
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenW - 20, 39)];
//    lab.text = @"3 月龄";
    lab.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    NSString *tname = [NSString stringWithFormat:@"   %@",self.dataArray[section][@"va_monthold"]];
    lab.textColor = JHdeepColor;
    lab.attributedText = [tname AttributedString:@"月龄" backColor:nil uicolor:nil uifont:[UIFont systemFontOfSize:12]];

    [backview addSubview:lab];
    [header addSubview:backview];
    
    return header;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    DoctorInfoViewController *detail = [[DoctorInfoViewController alloc]init];
    //    detail.titieStr = self.titieStr;
    //    detail.listId = self.dataArray[indexPath.row][@"id"];
//    [self.navigationController pushViewController:detail animated:YES];
    
}


#pragma mark - *************接种计划列表*************
-(void)requestData:(NSInteger )pagenum{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    NSString *url = ERPVaccinationPlanUrl;
    if (self.child_id) {
        [dt setObject:self.child_id forKey:@"hp_no"];
    }else{
        url =  PregnantCheckPlanUrl;
    }
    NSString *uid = [UserDefault objectForKey:@"uid"];
    if (uid == nil) uid = @"";
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) coid = @"";
    coid = @"53";
    [dt setObject:coid forKey:@"coid"];
    [dt setObject:uid forKey:@"uid"];
    [dt setObject:@"1" forKey:@"iszb"];
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,ERPVaccinationListUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"接种计划列表:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (![response[@"note"] isKindOfClass:[NSString class]]) {
                for (NSDictionary *dt in response[@"data"]) {
                    [self.dataArray addObject:dt];
                }
                if (self.dataArray.count) {
                    [self.tableview reloadData];
                }else{
                    [self presentLoadingTips:@"暂无数据~~~"];
                }
                self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            }else{
                [self presentLoadingTips:@"数据格式错误！"];
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        self.page = 1;
                        self.more = @"1";
                        [self requestData:self.page];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"%@",error);
        [self presentLoadingTips:@"请求失败！"];
        [self createFootview];
        [_tableview.mj_footer endRefreshing];
        [_tableview.mj_header endRefreshing];
    }];
    
}


#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.more = @"1";
        [self requestData:1];
    }];
//    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//
//        if ([self.more isEqualToString:@"0"]) {
//            [self presentLoadingTips:@"没有更多数据了"];
//            [self.tableview.mj_footer endRefreshing];
//        }else{
//            self.page ++;
//            [self requestData:self.page];
//        }
//        
//    }];
}
@end
