//
//  HouseRentingViewController.m
//  shop
//
//  Created by 梁法亮 on 16/7/19.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "HouseRentingViewController.h"
#import "HouserTableViewCell.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "NSString+selfSize.h"
#import "HouserDetailViewController.h"
#import "sortLabelview.h"
#import "LFLUibutton.h"
@interface HouseRentingViewController ()<UITableViewDelegate,UITableViewDataSource,sortLabelviewDelegate>{
    sortLabelview *soreview;//分类标签
    UIView *headerview;
    UIView *Coverview;
    UIView *backview;
}
@property(nonatomic,strong)baseTableview *tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSArray *btnnameArr;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;
@property(nonatomic,strong)UIButton *selectBtn;
@end

@implementation HouseRentingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.page = 1;
    self.more = @"1";
    self.view.backgroundColor = [UIColor whiteColor];
    self.btnnameArr = @[@"全绵阳",@"租金",@"户型"];
//     [self createHeaderview];
//    self.tableview = [[baseTableview alloc]initWithFrame:CGRectMake(0, 109, SCREEN.size.width, SCREEN.size.height - 109 )];
    self.tableview = [[baseTableview alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height )];
    self.navigationBarTitle = @"房屋租售";
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"HouserTableViewCell" bundle:nil] forCellReuseIdentifier:@"housercell"];
    [self requestDatahouser:1];
    [self setupRefresh];

   
}

#pragma mark - Table view data source


-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(void)createHeaderview{
    if (headerview == nil) {
        headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, 45)];
        headerview.backgroundColor = [UIColor whiteColor];
    }
    for (int i = 0; i < self.btnnameArr.count; i ++) {
        LFLUibutton *button = [headerview viewWithTag:50 + i];
        if (button == nil) {
            LFLUibutton *button = [[LFLUibutton alloc]initWithFrame:CGRectMake(i * SCREEN.size.width/(self.btnnameArr.count ? self.btnnameArr.count:1), 0, SCREEN.size.width/(self.btnnameArr.count ? self.btnnameArr.count:1), 45)];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button.imageView setContentMode:UIViewContentModeCenter];
            [button setTitle:self.btnnameArr[i] forState:UIControlStateNormal];
            [button setTitleColor:JHColor(102, 102, 102) forState:UIControlStateNormal];
            [button setTitleColor:JHshopMainColor forState:UIControlStateSelected];
            //        [button setAttributedTitle:[self AttributedString:self.btnNameArr[i] image:[UIImage imageNamed:@"shangjiantoumoren"] UIcolor:JHColor(51, 51, 51)] forState:UIControlStateNormal];
            //        [button setAttributedTitle:[self AttributedString:self.btnNameArr[i] image:[UIImage imageNamed:@"shangjiantouhongse"] UIcolor:[UIColor redColor]] forState:UIControlStateSelected];
            
            [button addTarget:self action:@selector(listClick:) forControlEvents:UIControlEventTouchUpInside];
            button.index = 50 + i;
            [button.titleLabel setTextAlignment:NSTextAlignmentRight];
            button.Ratio = 0.7;
            [button setImage:[UIImage imageNamed:@"shaixuan"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"shaixuanxuanzhong"] forState:UIControlStateSelected];
            if (i == 0) {
                button.selected = YES;
                self.selectBtn = button;
            }
            [headerview addSubview:button];
        }
    }
    [self.view addSubview:headerview];
//    self.tableview.tableHeaderView = headerview;
}
-(void)listClick:(LFLUibutton *)btn{
    if (Coverview == nil) {
        Coverview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 300)];
        Coverview.backgroundColor = [UIColor redColor];
        UIButton *sureBtn = [[UIButton alloc]init];
        [Coverview addSubview:sureBtn];
        sureBtn.backgroundColor = JHMaincolor;
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.offset(0);
            make.bottom.offset(0);
            make.height.offset(45);
        }];
    }
    if (backview == nil){
        backview = [[UIView alloc]initWithFrame:CGRectMake(0, 109, SCREEN.size.width, SCREEN.size.height - 109)];
        backview.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backClick:)];
        [backview addGestureRecognizer:ges];
    }
    backview.hidden = NO;
    [self.view addSubview:backview];
    [backview addSubview:Coverview];
    if (soreview == nil) {
        soreview = [[sortLabelview alloc]initWithFrame:CGRectMake(0,  10, SCREEN.size.width, 100)];
        soreview.delegate = self;
        soreview.isMoreBtn = NO;
        soreview.isBoder = NO;
        soreview.titleSelctColor = JHMaincolor;
        soreview.BtnCornerRadius = 3;
        soreview.BtnHeight = 40;
        soreview.btnBackColor = JHsimpleColor;
        [Coverview addSubview:soreview];
    }
    NSArray * sortArr = @[@"爱仕达",@"俗称",@"合格VB接口",@"上的都是积分",@"爱仕达",@"俗称",@"合格VB接口",@"上的都是积分",@"爱仕达",@"俗称",@"合格VB接口",@"上的都是积分"];
    NSMutableArray *marr = [NSMutableArray arrayWithArray:sortArr];
    [soreview initWithsortArray:marr currentIndex:0 sortH:50  font:14];
    [self viewDidLayoutSubviews];
    LFLog(@"soreview.Heigth:%f",soreview.Heigth);
}
#pragma mark sortLabelviewDelegate
-(void)sortLabelviewSelectSort:(NSString *)sort isSelect:(BOOL)isSelect{
    
    
}
-(void)backClick:(UIPanGestureRecognizer *)ges{
    backview.hidden = YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
    //    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HouserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"housercell"];
    
    NSDictionary *dt = self.dataArray[indexPath.row];
    if (dt[@"index_img"]) {
        [cell.iconimage sd_setImageWithURL:[NSURL URLWithString:dt[@"index_img"]]placeholderImage:[UIImage imageNamed:@"placeholderImage"]];

    }else{
        cell.iconimage.image = [UIImage imageNamed:@"placeholderImage"];
    
    }
    cell.titlelable.text = dt[@"title"];
    
    cell.locationlabel.text = [NSString stringWithFormat:@"%@-%@",dt[@"housetype"],dt[@"address"]];
    cell.locationlabel.text = [NSString stringWithFormat:@"%@-%@",dt[@"housetype"],dt[@"address"]];
    NSMutableString *mstr = [NSMutableString string];
    for (NSString *str in dt[@"tag"]) {
        [mstr appendFormat:@"    %@    ",str];
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:mstr];
    text.yy_font = [UIFont boldSystemFontOfSize:12];
    text.yy_color = JHColor(255, 69, 69);
    for (NSString *str in dt[@"tag"]) {
        NSRange range =[[text string]rangeOfString:[NSString stringWithFormat:@" %@ ",str]];
        [text yy_setColor:JHmiddleColor range:range];
        YYTextBorder *boder = [[YYTextBorder alloc]init];
        boder.strokeWidth = 1;
        boder.cornerRadius = 3;
        boder.strokeColor = JHColor(255, 69, 69);;
        [text yy_setTextBorder:boder  range:range];
        [text yy_setColor:JHColor(255, 69, 69) range:range];
    }
    
    cell.signYYlb.attributedText = text;
//    CGSize h = [dt[@"title"] selfadaption:15];
//    if (h.height > 21) {
//        cell.titleheigth.constant = 42;
//    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HouserDetailViewController *detial = [[HouserDetailViewController alloc]init];
    detial.isBusiness = self.isBusiness;
    detial.detailid = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:detial animated:YES];
    
    
}

#pragma mark - *************请求数据*************
//-(void)requestDatahouser{
//    
//    NSString *uid = [UserDefault objectForKey:@"useruid"];
//    if (uid == nil) {
//        uid = @"";
//    }
//    NSDictionary *dt = @{@"userid":uid};
//    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"28") params:nil success:^(id response) {
//        [_tableview.mj_header endRefreshing];
//        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
//        
//        if ([str isEqualToString:@"0"]) {
//            LFLog(@"获取成功%@",response);
//            [self.dataArray removeAllObjects];
////            if (![response[@"note"] isKindOfClass:[NSString class]]) {
//                for (NSDictionary *dt in response[@"note"]) {
//                    [self.dataArray addObject:dt];
//                }
//                if (self.dataArray.count) {
//                    [self.tableview reloadData];
//                    if (self.dataArray.count < 4) {
//                        [self createFootview];
//                    }else{
//                        self.basefootview.hidden = YES;
//                    }
//                }else{
//                    [self createFootview];
//                    [self presentLoadingTips:@"暂无数据~~~"];
//                }
////            }
//
//            
//        }else{
//            [self createFootview];
//            LFLog(@"------%@",response);
//            [self presentLoadingTips:response[@"err_msg"]];
//            
//            
//            
//        }
//        
//    } failure:^(NSError *error) {
//        [self createFootview];
//        [self presentLoadingTips:@"暂无数据"];
//      [_tableview.mj_header endRefreshing];  
//    }];
//    
//}
-(void)requestDatahouser:(NSInteger )pagenum{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"社区活动dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,self.isBusiness ? BusinessRentListBUrl : HouseRentingListUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        LFLog(@"社区活动:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (pagenum == 1) {
                [self.dataArray removeAllObjects];
            }
            
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
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self requestDatahouser:self.page];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        LFLog(@"社区活动error:%@",error);
        [self presentLoadingTips:@"暂无数据"];
        [self createFootview];
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
    }];
    
}

#pragma mark 集成刷新控件
- (void)setupRefresh
{
    {
        // 下拉刷新
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            self.more = @"1";
            [self requestDatahouser:1];
        }];
        _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            if ([self.more isEqualToString:@"0"]) {
                [self presentLoadingTips:@"没有更多商品了"];
                [self.tableview.mj_footer endRefreshing];
            }else{
                self.page ++;
                [self requestDatahouser:self.page];
            }
            
        }];
    }
}



@end
