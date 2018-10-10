//
//  VolunteerActivitylistViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/6.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "VolunteerActivitylistViewController.h"
#import "VolunteerActivityTableViewCell.h"
#import "VolunteerActivityDetailViewController.h"
#import "VolunteerApplyViewController.h"
@interface VolunteerActivitylistViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,assign)NSInteger page;
@end

@implementation VolunteerActivitylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    self.navigationBarTitle = @"志愿活动列表";
    [self createtableView];
    [self setupRefresh];
}

- (NSMutableArray *)activityArr
{
    if (!_activityArr) {
        _activityArr = [[NSMutableArray alloc]init];
    }
    return _activityArr;
}
-(void)createtableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height + 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorColor = JHColor(222, 222, 222);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"confirmCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"VolunteerActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"VolunteerActivityTableViewCell"];
    _tableView.separatorStyle = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
   }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (self.activityArr.count ) {
        return self.activityArr.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.activityArr.count) {
        return 100;
    }
    return SCREEN.size.height - 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.activityArr.count) {

        NSString *CellIdentifier = @"VolunteerActivityTableViewCell";
        VolunteerActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (self.activityArr.count) {
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSDictionary *dt = self.activityArr[indexPath.row];
            [cell.pictureIm sd_setImageWithURL:[NSURL URLWithString:dt[@"imgurl"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            cell.titleLabel.text = dt[@"ac_name"];
            cell.timeLabel.text = dt[@"add_time"];
            NSString * countStr = [NSString stringWithFormat:@"已有%@人参加",dt[@"count"]];
            cell.countLB.attributedText = [countStr AttributedString:dt[@"count"] backColor:nil uicolor:JHAssistColor uifont:[UIFont systemFontOfSize:13]];
            
            
        }
        return cell;
        
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"confirmCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell.contentView removeAllSubviews];
        UIImageView *plImview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuneirong"]];
        [cell.contentView addSubview:plImview];
        [plImview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(20);
            make.centerX.equalTo(cell.contentView.mas_centerX);
        }];
        return cell;
        
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isVolunteer) {
        if (self.activityArr.count) {
            VolunteerActivityDetailViewController *datil = [[VolunteerActivityDetailViewController alloc]init];
            datil.detailid = self.activityArr[indexPath.row][@"ac_id"];
            [self.navigationController pushViewController:datil animated:YES];
        }
    }else{
        VolunteerApplyViewController *active = [[VolunteerApplyViewController alloc]init];

        [self.navigationController pushViewController:active animated:YES];
    
    }



}
#pragma mark 首页活动
-(void)ActivityData:(NSInteger)pagenum{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"5",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,volunteersActivityUrl) params:dt success:^(id response) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        LFLog(@"活动：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            if (pagenum == 1) {
                [self.activityArr removeAllObjects];
            }
            
            for (NSDictionary *dt in response[@"data"]) {
                
                [self.activityArr addObject:dt];
                
            }
            
            [self.tableView reloadData];
            
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self ActivityData:1];
        
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
      
        self.page ++;
        [self ActivityData:self.page];
    }] ;

}

@end
