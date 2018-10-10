//
//  CateringViewController.m
//  shop
//
//  Created by 梁法亮 on 16/10/20.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "CateringViewController.h"
#import "CaterTableViewCell.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "NSString+selfSize.h"
#import "CateringDetailViewController.h"
@interface CateringViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)baseTableview *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation CateringViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height )];
    self.navigationBarTitle = @"餐饮服务";
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CaterTableViewCell" bundle:nil] forCellReuseIdentifier:@"CaterTableViewCell"];
    [self requestDatahouser];
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
    
    return 120;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CaterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CaterTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dt = self.dataArray[indexPath.row];
    LFLog(@"我擦：%@",dt);
    if (dt[@"cate_logo"]) {
        [cell.iconimage sd_setImageWithURL:[NSURL URLWithString:dt[@"cate_logo"]]placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        
    }else{
        cell.iconimage.image = [UIImage imageNamed:@"placeholderImage"];
        
    }

    cell.titlelable.text = dt[@"cate_name"];
    
    cell.locationlabel.text = [NSString stringWithFormat:@"%@",dt[@"cate_address"]];
    cell.cate_discount.text = dt[@"cate_discount"];
    //    CGSize h = [dt[@"title"] selfadaption:15];
    //    if (h.height > 21) {
    //        cell.titleheigth.constant = 42;
    //    }
    //
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CateringDetailViewController *detial = [[CateringDetailViewController alloc]init];
    detial.detailid = self.dataArray[indexPath.row][@"cate_id"];
    [self.navigationController pushViewController:detial animated:YES];
    
    
}

#pragma mark - *************请求数据*************
-(void)requestDatahouser{
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSDictionary *dt = @{@"userid":uid};
    [LFLHttpTool get:@"http://www.shequyun.cc/zssh/mobile/index.php?c=catering&a=index" params:nil success:^(id response) {
        [_tableview.mj_header endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"error"]];
        
        if ([str isEqualToString:@"0"]) {
            LFLog(@"获取成功%@",response);
            [self.dataArray removeAllObjects];
            //            if (![response[@"note"] isKindOfClass:[NSString class]]) {
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
            //            }
            
            
        }else{
            [self createFootview];
            LFLog(@"------%@",response);
            [self presentLoadingTips:response[@"msg"]];
            
            
            
        }
        
    } failure:^(NSError *error) {
        [self createFootview];
        [self presentLoadingTips:@"暂无数据"];
        [_tableview.mj_header endRefreshing];
    }];
    
}

#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestDatahouser];
    }];
}


@end
