//
//  CityNewsViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/2/23.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "CityNewsViewController.h"
#import "CityNewsTableViewCell.h"
#import "CityNewsDetailViewController.h"
@interface CityNewsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)baseTableview *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;

@end

@implementation CityNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    self.more = @"1";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[baseTableview alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height )];
    self.navigationBarTitle = @"城市新闻";
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"firstcell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CityNewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CityNewsCell"];
    [self requestData:1];
    [self setupRefresh];
}

#pragma mark - Table view data source


-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
    //    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dt = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        CGSize nameSize =[dt[@"title"] selfadapUifont:[UIFont fontWithName:@"Helvetica-Bold" size:15] weith:20];
        return nameSize.height + 10 +160 + 40;
    }
    NSString *index_img = dt[@"index_img"];
    if (index_img.length > 0) {
        return 100;
    }
    return 80;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dt = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstcell"];
        [cell.contentView removeAllSubviews];
        UILabel *nameLb = [[UILabel alloc]init];
        nameLb.textColor = JHdeepColor;
        nameLb.text = dt[@"title"];
        nameLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        CGSize nameSize =[nameLb.text selfadapUifont:[UIFont fontWithName:@"Helvetica-Bold" size:15] weith:20];
        nameLb.numberOfLines = 0;
        [cell.contentView addSubview:nameLb];
        
        [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-10);
            make.top.offset(10);
            make.height.offset(nameSize.height + 10);
        }];
        
        UIImageView *imageview = [[UIImageView alloc]init];
        [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dt[@"index_img"]]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        imageview.layer.masksToBounds = YES;
        [cell.contentView addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-10);
            make.top.equalTo(nameLb.mas_bottom).offset(0);
            make.height.offset(160);
        }];
        
        UILabel *countLabel = [[UILabel alloc]init];
        countLabel.font = [UIFont systemFontOfSize:13];
        countLabel.textColor = JHmiddleColor;
        countLabel.textAlignment = NSTextAlignmentRight;
        countLabel.text = [NSString stringWithFormat:@"%@",dt[@"add_time"]];
        [cell.contentView addSubview:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageview.mas_bottom).offset(0);
            make.right.offset(-10);
            make.width.offset([countLabel.text selfadap:13 weith:20].width + 5);
            make.bottom.offset(0);
        }];
        
        UILabel *authorLb = [[UILabel alloc]init];
        authorLb.textColor = JHmiddleColor;
        authorLb.font = [UIFont systemFontOfSize:13];
        authorLb.text = dt[@"author"];
        [cell.contentView addSubview:authorLb];
        [authorLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageview.mas_bottom).offset(0);
            make.left.offset(10);
            make.bottom.offset(0);
            make.right.equalTo(countLabel.mas_left).offset(0);
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        CityNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityNewsCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        cell.titleLabel.text = dt[@"title"];
        [cell.telButon setTitle:dt[@"author"] forState:UIControlStateNormal];
        cell.timeLabel.text = dt[@"add_time"];
        cell.timeLbwidth.constant = [dt[@"add_time"] selfadap:13 weith:100].width + 10;
        NSString *index_img = dt[@"index_img"];
        if (index_img.length > 0) {
            //        cell.titleLeft.constant = 10;
            cell.iconimage.hidden = NO;
            cell.imageleft.constant = 10;
            [cell.iconimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dt[@"index_img"]]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                cell.imageWidth.constant = 100;
            }];
        }else{
            cell.iconimage.hidden = YES;
            cell.imageWidth.constant = 0;
            //        cell.titleLeft.constant = 90;
            //        cell.iconimage.hidden = YES;
            cell.imageleft.constant = 10 ;
            //        cell.imageTop.constant = 90;* 91/73
        }
        
        //    cell.imageleft.constant = 90 ;
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CityNewsDetailViewController *detial = [[CityNewsDetailViewController alloc]init];
    detial.detailid = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:detial animated:YES];
    
    
}


#pragma mark - *************请求数据*************
-(void)requestData:(NSInteger )pagenum{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"城市新闻dt:%@",dt);
    if (pagenum == 1) {
        [self.dataArray removeAllObjects];
    }
    
//    NSDictionary *dic = @{@"curPage":@"1",@"pageSize":@"12"};
//    NSDictionary *para = @{@"method":@"interaction_list",@"param":dic};
//    [LFLHttpTool post:@"https://106.38.99.198:8443/SoMooc/mobile/ajax/get.action" params:para success:^(id response) {
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,CityNewslistUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"周边商业:%@",response);
        
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (![response[@"note"] isKindOfClass:[NSString class]]) {

                for (NSDictionary *dt in response[@"data"]) {
                    [self.dataArray addObject:dt];
                }
                if (self.dataArray.count) {
                    [self.tableview reloadData];
                    if (self.dataArray.count < 4) {
                        [self createFootview];
                    }else{
                        self.basefootview.hidden = YES;
                    }
                }else{
                    [self createFootview];
                    [self presentLoadingTips:@"暂无数据~~~"];
                }
                self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]]; 
            }else{
                
                
                
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
        [self presentLoadingTips:@"暂无数据"];
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
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多数据了"];
            [self.tableview.mj_footer endRefreshing];
        }else{
            self.page ++;
            [self requestData:self.page];
        }
        
    }];
}


@end
