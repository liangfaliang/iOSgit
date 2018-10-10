//
//  VolunteerAlreadyJionViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/7.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "VolunteerAlreadyJionViewController.h"
#import "VolunteerActivityDetailViewController.h"
@interface VolunteerAlreadyJionViewController ()<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)NSInteger page;

@end

@implementation VolunteerAlreadyJionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"我的参与";
    [self createTableview];
    [self createFootview];
    [self ActivityData:1];

}

-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}


-(void)createTableview{
    
    //    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, SCREEN.size.width, SCREEN.size.height)];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [UIView new];
    self.tableview.separatorColor = JHColor(244, 244, 244);
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"confirmCell"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"VolunteerAlreadyJioncell"];
//    [self.tableview registerNib:[UINib nibWithNibName:@"ShopgoodsDecTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderShopgoodsDecTableViewCell"];
    
    [self.view addSubview:self.tableview];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count) {
        return self.dataArray.count;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count) {
        
        return self.dataArray.count;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count) {
        return 60;
    }
    return SCREEN.size.height - 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (self.dataArray.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VolunteerAlreadyJioncell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView removeAllSubviews];
        UILabel *textLabel = [[UILabel alloc]init];
        textLabel.text = self.dataArray[indexPath.row][@"add_time"];
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.textColor = JHmiddleColor;
        [cell.contentView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(10);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.width.offset([textLabel.text selfadap:14 weith:100].width + 5);
        }];
        UILabel *namelb = [[UILabel alloc]init];
        namelb.text = self.dataArray[indexPath.row][@"ac_name"];
        namelb.font = [UIFont systemFontOfSize:14];
        namelb.textColor = JHmiddleColor;
        [cell.contentView addSubview:namelb];
        [namelb mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(textLabel.mas_right).offset(30);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.offset(-60);
        }];
        UIButton *detailBtn = [[UIButton alloc]init];
        detailBtn.userInteractionEnabled = NO;
//        zhiyuanzhexiangqing
        [detailBtn setImage:[UIImage imageNamed:@"zhiyuanzhexiangqing"] forState:UIControlStateNormal];
        [cell.contentView addSubview:detailBtn];
        [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.offset(-10);
        }];
        
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"confirmCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView removeAllSubviews];
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
    if (self.dataArray.count) {
        VolunteerActivityDetailViewController *datil = [[VolunteerActivityDetailViewController alloc]init];
        datil.detailid = self.dataArray[indexPath.row][@"ac_id"];
        [self.navigationController pushViewController:datil animated:YES];
    }
    
    
    
}

#pragma mark 活动
-(void)ActivityData:(NSInteger)pagenum{
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"5",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }else{
        [self showLogin:^(id response) {
            if ([response isEqualToString:@""]) {
                [self ActivityData:self.page];
            }
        }];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,volunteersActivityJionlogUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        LFLog(@"活动：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            if (pagenum == 1) {
                [self.dataArray removeAllObjects];
            }
            
            for (NSDictionary *dt in response[@"data"]) {
                [self.dataArray addObject:dt];
        
            }
            
            [self.tableview reloadData];
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@""]) {
                        [self ActivityData:self.page];
                    }
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self ActivityData:1];
        
    }];
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.page ++;
        [self ActivityData:self.page];
    }] ;
    
}


@end
