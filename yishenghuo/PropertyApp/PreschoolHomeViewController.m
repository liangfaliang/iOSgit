//
//  PreschoolHomeViewController.m
//  PropertyApp
//
//  Created by admin on 2018/8/14.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "PreschoolHomeViewController.h"
#import "SDCycleScrollView.h"
#import "InformationTableViewCell.h"
#import "PreschoolGuideViewController.h"
#import "InformationViewController.h"
#define headerHt SCREEN.size.width * 12/25
@interface PreschoolHomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableArray *pictureArr;

@property(nonatomic, strong)UIView *herderView;
@property (nonatomic, strong)SDCycleScrollView *sdCySV;
@end

@implementation PreschoolHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self UpData];
    self.navigationBarTitle = @"幼教服务";
}
-(void)UpData{
    [super UpData];
    [self rotatePicture];
    self.page = 1;
    self.more = 1;
    [self UploadDataisInformation:1];
}

-(NSMutableArray *)pictureArr{
    if (!_pictureArr) {
        _pictureArr = [NSMutableArray array];
    }
    return _pictureArr;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (SDCycleScrollView *)sdCySV {
    if(!_sdCySV){
        _sdCySV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screenW, headerHt) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        _sdCySV.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _sdCySV.currentPageDotColor = [UIColor whiteColor];
    }
    
    return _sdCySV;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH- NaviH -TabH - 40 ) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"TextFiledLableTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFiledLableTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"InformationTableViewCell" bundle:nil] forCellReuseIdentifier:@"InformationTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.tableHeaderView = self.sdCySV;
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf UpData];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (weakSelf.more == 0) {
                [weakSelf presentLoadingTips:@"没有更多数据了"];
                [weakSelf.tableView.mj_footer endRefreshing];
            }else{
                weakSelf.page ++;
                [weakSelf UploadDataisInformation:weakSelf.page];
            }
            
        }];
    }
    return _tableView;
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = @"新生报名";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        return cell;
    }
    InformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationTableViewCell"];
    [cell setCellWithDict:self.dataArray[indexPath.row] indexPath:indexPath];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section ? 45 : 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *header = [[UIView alloc]init];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *lb = [UILabel initialization:CGRectMake(15, 0, screenW - 30, 50) font:[UIFont fontWithName:@"Helvetica-Bold" size:15] textcolor:JHdeepColor numberOfLines:0 textAlignment:0];
        lb.text  = @"幼儿园动态";
        [header addSubview:lb];
        ImRightBtn *btn = [[ImRightBtn alloc]init];
        btn.section = section;
        [btn setImage:[UIImage imageNamed:@"gerenzhongxinjiantou"] forState:UIControlStateNormal];
        [btn setTitle:@"更多 " forState:UIControlStateNormal];
        [btn setTitleColor:JHmiddleColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(header.mas_centerY);
            make.right.offset(-10);
        }];
        return header;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        PreschoolGuideViewController *vc = [[PreschoolGuideViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        InforViewController *line = [[InforViewController alloc]init];
        line.type = InfoStyleYouJiao;
        line.detailid = self.dataArray[indexPath.row][@"id"];
        [self.navigationController pushViewController:line animated:YES];
    }
}
#pragma mark - 查看全部
-(void)moreBtnClick{
    InformationViewController *hot = [[InformationViewController alloc]init];
    hot.type = InfoStyleYouJiao;
    [self.navigationController pushViewController:hot animated:YES];
}
#pragma mark 轮播图数据
-(void)rotatePicture{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session};//
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PreschoolBannerUrl) params:dt success:^(id response) {
        LFLog(@"轮播图数据:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.pictureArr removeAllObjects];
            NSMutableArray *imaurlArr = [NSMutableArray array];
            for (NSDictionary *dt in response[@"data"]) {
                [self.pictureArr addObject:dt];
                [imaurlArr addObject:dt[@"imgurl2"]];
            }
            self.sdCySV.imageURLStringsGroup = imaurlArr;
            
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark 社区资讯
-(void)UploadDataisInformation:(NSInteger )pagenum{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"5",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PreschoolInfoListUrl) params:dt success:^(id response) {
        LFLog(@"社区资讯:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (pagenum == 1) {
                [self.dataArray removeAllObjects];
            }
            self.more = [response[@"paginated"][@"more"]  integerValue];
            for (NSDictionary *dt in response[@"data"]) {
                [self.dataArray addObject:dt];
            }
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self UpData];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
@end
