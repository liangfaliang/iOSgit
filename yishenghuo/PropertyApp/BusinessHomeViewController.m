//
//  BusinessHomeViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/8/14.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "BusinessHomeViewController.h"
#import "SDCycleScrollView.h"
#import "PromotionsTableViewCell.h"
#import "CollectioncellTableViewCell.h"
#import "ImLbModel.h"
#import "HouserTableViewCell.h"
#import "BusinessHomeTableViewCell.h"
#import "BusinessListViewController.h"
#import "GNRGoodsModel.h"
#import "PeripheralBusinessViewController.h"//周边商业
#import "ShopDoodsDetailsViewController.h"//新商品详情
#import "IntegralShopListViewController.h"//积分商城
#import "HouseRentingViewController.h"
#import "ShopViewController.h"
#import "BusinessStoreDetailsViewController.h"
#import "HouserDetailViewController.h"
#define headerHt SCREEN.size.width * 12/25
@interface BusinessHomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger more;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSMutableArray *pictureArr;
@property(nonatomic, strong)NSMutableArray *menuArr;
@property(nonatomic, strong)NSMutableArray *housesArr;
@property(nonatomic, strong)NSMutableArray *PromoArr;
@property(nonatomic, strong)NSMutableArray *businessArr;
@property(nonatomic, strong)NSMutableArray *hotArr;
@property(nonatomic, strong)UIView *herderView;
@property (nonatomic, strong)SDCycleScrollView *sdCySV;

@end

@implementation BusinessHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *arr1 = @[@{@"name":@"商业街",@"imgurl":@"menzhenguahao"},
                      @{@"name":@"兴业商城",@"imgurl":@"jiatingqianyue"},
                      @{@"name":@"周边商业",@"imgurl":@"yuyuejiandang"},
                      @{@"name":@"积分商城",@"imgurl":@"jiatingqianyue"}];
    for (NSDictionary *temdt in arr1) {
        [self.menuArr addObject:[ImLbModel mj_objectWithKeyValues:temdt]];
    }
    
    [self.view addSubview:self.tableView];
    [self UpData];

}
-(void)UpData{
    [super UpData];
    [self rotatePicture];
    [self rotateHouse];
    [self rotatePromotion];
    [self getDataBusiness];
    [self getDataHotSale];
}
-(NSMutableArray *)hotArr{
    if (!_hotArr) {
        _hotArr = [NSMutableArray array];
    }
    return _hotArr;
}
-(NSMutableArray *)businessArr{
    if (!_businessArr) {
        _businessArr = [NSMutableArray array];
    }
    return _businessArr;
}
-(NSMutableArray *)PromoArr{
    if (!_PromoArr) {
        _PromoArr = [NSMutableArray array];
    }
    return _PromoArr;
}
-(NSMutableArray *)housesArr{
    if (!_housesArr) {
        _housesArr = [NSMutableArray array];
    }
    return _housesArr;
}
-(NSMutableArray *)menuArr{
    if (!_menuArr) {
        _menuArr = [NSMutableArray array];
    }
    return _menuArr;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH - NaviH -TabH - 40) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = JHbgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 70;
        _tableView.rowHeight = -1;
        [_tableView registerNib:[UINib nibWithNibName:@"PromotionsTableViewCell" bundle:nil] forCellReuseIdentifier:@"PromotionsTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HouserTableViewCell" bundle:nil] forCellReuseIdentifier:@"HouserTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"CollectioncellTableViewCell" bundle:nil] forCellReuseIdentifier:@"CollectioncellTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"BusinessHomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"BusinessHomeTableViewCell"];
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf UpData];
        }];
        
        _tableView.tableHeaderView = self.sdCySV;
    }
    return _tableView;
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if (section == 1) return self.PromoArr.count > 3 ? 3 : self.PromoArr.count;
    if (section == 2) return self.housesArr.count > 3 ? 3:  self.housesArr.count;
    if (section == 3) return self.businessArr.count ? 1 : 0;
    if (section == 4) return self.hotArr.count ? 1 : 0;
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }
    return -1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CollectioncellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CollectioncellTableViewCell class]) forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.collectionView.backgroundColor = [UIColor clearColor];
        cell.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        cell.layout.itemSize = CGSizeMake((screenW - 75)/4 - 1, 80);
        cell.layout.minimumLineSpacing = 15;
        cell.layout.minimumInteritemSpacing = 0.001;
        CGFloat oneX = 15;
        CGFloat oneY = 10;
        cell.layout.sectionInset = UIEdgeInsetsMake(oneY, oneX, oneY, oneX);
        cell.itemSize = cell.layout.itemSize;
        cell.Identifier = @"ImageLabelCollectionViewCell";
        cell.titleArr = self.menuArr;
        WEAKSELF;
        cell.ClickBlock = ^(NSIndexPath *indexpath) {
            if (indexPath.section == 0) {
                if (indexpath.row == 0) {
                    [weakSelf.navigationController pushViewController:[[BusinessListViewController alloc]init] animated:YES];
                }else if (indexpath.row == 1){
                    [weakSelf.navigationController pushViewController:[[ShopViewController alloc]init] animated:YES];
                    
                }else if (indexpath.row == 2){
                    [weakSelf.navigationController pushViewController:[[PeripheralBusinessViewController alloc]init] animated:YES];
                }else if (indexpath.row == 3){
                    [weakSelf.navigationController pushViewController:[[IntegralShopListViewController alloc]init] animated:YES];
                }
                
            }
        };
        return cell;
    }else if (indexPath.section == 1){
        PromotionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PromotionsTableViewCell class]) forIndexPath:indexPath];
        [cell setCellWithDict:self.PromoArr[indexPath.row] indexPath:indexPath];
        return cell;
    }else if (indexPath.section ==2) {
        HouserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouserTableViewCell"];
        NSDictionary *dt = self.housesArr[indexPath.row];
        if (dt[@"index_img"]) {
            [cell.iconimage sd_setImageWithURL:[NSURL URLWithString:dt[@"index_img"]]placeholderImage:[UIImage imageNamed:@"placeholderImage"]];

        }else{
            cell.iconimage.image = [UIImage imageNamed:@"placeholderImage"];

        }
        cell.titlelable.text = dt[@"title"];

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
        return cell;
        
    }
    BusinessHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BusinessHomeTableViewCell class]) forIndexPath:indexPath];
    if (indexPath.section == 4) {
        cell.imageView.userInteractionEnabled = YES;
        [cell setViewHideen:YES];
        NSMutableArray *imageArr = [NSMutableArray array];
        for (GNRGoodsModel *gmo in self.hotArr) {
            [imageArr addObject:gmo.imgurl];
        }
        [cell setImageArr:imageArr];
        WEAKSELF;
        cell.imageclickBlock = ^(NSInteger index) {
            if (weakSelf.hotArr.count > index) {
                BusinessStoreDetailsViewController *detial = [[BusinessStoreDetailsViewController alloc]init];
                GNRGoodsModel *bmo = weakSelf.hotArr[index];
                detial.shop_id  = bmo.shop_id;
                [weakSelf.navigationController pushViewController:detial animated:YES];
            }

        };
    }else{
        cell.imageView.userInteractionEnabled = NO;
        cell.bmodel = self.businessArr[indexPath.row];
        [cell setViewHideen:NO];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section ? 45 : 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        UIView *header = [[UIView alloc]init];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *lb = [UILabel initialization:CGRectMake(15, 0, screenW - 30, 50) font:[UIFont fontWithName:@"Helvetica-Bold" size:15] textcolor:JHdeepColor numberOfLines:0 textAlignment:0];
        if (section == 1) {
            lb.text  = @"促销活动";
        }else if (section == 2){
            lb.text  = @"招租信息";
        }else if (section == 3){
            lb.textAlignment = NSTextAlignmentCenter;
            lb.text  = @"新增商业";
        }else if (section == 4){
            lb.textAlignment = NSTextAlignmentCenter;
            lb.text  = @"热卖商品";
        }
        
        [header addSubview:lb];
        if (section < 3) {
            ImRightBtn *btn = [[ImRightBtn alloc]init];
            btn.section = section;
            [btn setImage:[UIImage imageNamed:@"gerenzhongxinjiantou"] forState:UIControlStateNormal];
            [btn setTitle:@"更多 " forState:UIControlStateNormal];
            [btn setTitleColor:JHmiddleColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [header addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(header.mas_centerY);
                make.right.offset(-10);
            }];
        }

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
    if (indexPath.section == 3) {
        BusinessStoreDetailsViewController *detial = [[BusinessStoreDetailsViewController alloc]init];
        businessModel *bmo = self.businessArr[indexPath.row];
        detial.shop_id  = bmo.shop_id;
        [self.navigationController pushViewController:detial animated:YES];
    }else if (indexPath.section == 2){
        HouserDetailViewController *detial = [[HouserDetailViewController alloc]init];
        detial.isBusiness = YES;
        NSDictionary *dt = self.housesArr[indexPath.row];
        detial.detailid = dt[@"id"];
        [self.navigationController pushViewController:detial animated:YES];
    }else if (indexPath.section == 1){
        NSDictionary *mo = self.PromoArr[indexPath.row];
        BusinessStoreDetailsViewController *detial = [[BusinessStoreDetailsViewController alloc]init];
        detial.shop_id  = mo[@"shop_id"];
        [self.navigationController pushViewController:detial animated:YES];
    }

}
#pragma mark - 查看全部
-(void)moreBtnClick:(ImRightBtn *)btn{
    if (btn.section == 1) {
        [self.navigationController pushViewController:[[BusinessListViewController alloc]init] animated:YES];
    }else if (btn.section == 2) {
        HouseRentingViewController *houser = [[HouseRentingViewController alloc]init];
        houser.isBusiness = YES;
        [self.navigationController pushViewController:houser animated:YES];
    }

}
#pragma mark 轮播图数据
-(void)rotatePicture{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session};//
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BusinessBannerBUrl) params:dt success:^(id response) {
        LFLog(@"轮播图数据:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.pictureArr removeAllObjects];
            NSMutableArray *imaurlArr = [NSMutableArray array];
            for (NSDictionary *dt in response[@"data"]) {
                [self.pictureArr addObject:dt];
                [imaurlArr addObject:dt[@"imgurl"]];
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
#pragma mark 促销活动
-(void)rotatePromotion{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session};//
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BusinessPromotionListBUrl) params:dt success:^(id response) {
        LFLog(@"促销活动:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.PromoArr removeAllObjects];
            for (NSDictionary *dt in response[@"data"]) {
                [self.PromoArr addObject:dt];
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
#pragma mark 招租
-(void)rotateHouse{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session};//
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BusinessRentListBUrl) params:dt success:^(id response) {
        LFLog(@"招租:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.housesArr removeAllObjects];
            for (NSDictionary *dt in response[@"data"]) {
                [self.housesArr addObject:dt];
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
#pragma mark 新增商业
-(void)getDataBusiness{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session};//
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BusinessListBUrl) params:dt success:^(id response) {
        LFLog(@"新增商业:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.businessArr removeAllObjects];
            for (NSDictionary *temdt in response[@"data"]) {
                businessModel *model = [businessModel mj_objectWithKeyValues:temdt];
                [self.businessArr addObject:model];
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

#pragma mark 热卖商品
-(void)getDataHotSale{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session};//
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,BusinessHotSalegoodUrl) params:dt success:^(id response) {
        LFLog(@"新增商业:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.hotArr removeAllObjects];
            for (NSDictionary *temdt in response[@"data"]) {
                GNRGoodsModel *model = [GNRGoodsModel mj_objectWithKeyValues:temdt];
                [self.hotArr addObject:model];
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
@end
