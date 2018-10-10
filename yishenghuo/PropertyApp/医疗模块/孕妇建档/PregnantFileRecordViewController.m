//
//  PregnantFileRecordViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/27.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "PregnantFileRecordViewController.h"
#import "PregnantFileRecordTableViewCell.h"

@interface PregnantFileRecordViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(nonatomic,strong)baseTableview *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;

@end

@implementation PregnantFileRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.more = @"1";
    self.view.backgroundColor = JHbgColor;
    [self createUI];
    [self requestData:1];
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
    [self.tableview registerNib:[UINib nibWithNibName:@"PregnantFileRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"PregnantFileRecordTableViewCell"];
    self.tableview.backgroundColor = [UIColor clearColor];
    [self setupRefresh];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSArray *vaccinateArr = self.dataArray[section][@"vaccinate"];
//    if (vaccinateArr && vaccinateArr.count) {
//        return vaccinateArr.count;
//    }
    //    return self.dataArray.count;
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dt = self.dataArray[indexPath.section];
    NSString *allstr = [NSString stringWithFormat:@"免费项目:%@\n自费项目: %@",dt[@"vaccinate_isfree"],dt[@"vaccinate_notfree"]];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:allstr];
    text.yy_font = [UIFont boldSystemFontOfSize:15];
    text.yy_lineSpacing = 10;
    CGSize strSize = [text selfadaption:90];
    return (strSize.height + 20) < 60 ? 60 :(strSize.height + 20);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PregnantFileRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PregnantFileRecordTableViewCell"];
    NSDictionary *dt = self.dataArray[indexPath.section];
    NSString *allstr = [NSString stringWithFormat:@"免费项目:%@\n自费项目: %@",dt[@"vaccinate_isfree"],dt[@"vaccinate_notfree"]];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:allstr];
    text.yy_font = [UIFont boldSystemFontOfSize:15];
    text.yy_color = JHsimpleColor;
    text.yy_lineSpacing = 10;
    NSRange range0 =[[text string]rangeOfString:@"免费项目:"];
    [text yy_setColor:JHMedicalColor range:range0];
    NSRange range1 =[[text string]rangeOfString:@"自费项目:"];
    [text yy_setColor:JHdeepColor range:range1];
//
    cell.contentYYlb.attributedText = text;
    [cell.nameBtn setTitle:dt[@"name"] forState:UIControlStateNormal];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = JHbgColor;
    return header;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    DoctorInfoViewController *detail = [[DoctorInfoViewController alloc]init];
    //    detail.titieStr = self.titieStr;
    //    detail.listId = self.dataArray[indexPath.row][@"id"];
    //    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark - *************产检记录列表*************
-(void)requestData:(NSInteger )pagenum{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    //    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    //    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    //    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"产检记录列表dt:%@",dt);
    if (pagenum == 1) {
        [self.dataArray removeAllObjects];
    }
//    if (self.child_id) {
//        [dt setObject:self.child_id forKey:@"child_id"];
//    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PregnantCheckPlanRecordUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"产检记录列表:%@",response);
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
