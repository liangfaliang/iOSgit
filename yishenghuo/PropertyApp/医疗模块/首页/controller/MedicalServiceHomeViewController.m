//
//  MedicalHomeViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/7/24.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "MedicalServiceHomeViewController.h"
#import "CollectioncellTableViewCell.h"
#import "HealthEducateListTableViewCell.h"
#import "FSTableViewCell.h"
#import "SDCycleScrollView.h"
#import "InformationCycleCollectionViewCell.h"
#import "MKJCollectionViewFlowLayout.h"
#import "ImLbModel.h"
#import "FileQueryHomeViewController.h"
#import "HealthRecordsFirstViewController.h"
#import "InformationTableViewCell.h"
#import "MeGoodModel.h"
#import "ServiceHotlineListViewController.h"
#import "SatisfactionListViewController.h"
#import "InforViewController.h"
#import "InformationViewController.h"
#import "ShopDoodsDetailsViewController.h"
#define headerHt SCREEN.size.width * 12/25
@interface MedicalServiceHomeViewController ()<UITableViewDataSource, UITableViewDelegate,FSGridLayoutViewDelegate,SDCycleScrollViewDelegate,MKJCollectionViewFlowLayoutDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableDictionary *dataDt;
@property (nonatomic, strong) NSMutableArray *infoArr;//
@property (nonatomic, strong) NSMutableArray *healthArr;//
@property (nonatomic, strong) NSMutableArray *goodArr;//
@property (nonatomic, strong)SDCycleScrollView *sdCySV;
@property (nonatomic, strong)SDCycleScrollView *sdCySVHeder;
@end

@implementation MedicalServiceHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self.view addSubview:self.tableView];
    [self UpData];
}
-(void)initData{
    NSArray *arr1 = @[@{@"name":@"门诊挂号",@"imgurl":@"menzhenguahao"},
                      @{@"name":@"档案认证",@"imgurl":@"jiatingqianyue"},
                      @{@"name":@"预约建档",@"imgurl":@"yuyuejiandang"},
                      @{@"name":@"档案查询",@"imgurl":@"jiatingqianyue"},
                      @{@"name":@"家庭签约",@"imgurl":@"jiatingqianyue"},
                      @{@"name":@"家庭医生",@"imgurl":@"jiatingyisheng"},
                      @{@"name":@"服务热线",@"imgurl":@"fuwurexian"},
                      @{@"name":@"在线咨询",@"imgurl":@"zaixianzixun"}];
    NSMutableArray *marr1 = [NSMutableArray array];
    for (NSDictionary *temdt in arr1) {
        [marr1 addObject:[ImLbModel mj_objectWithKeyValues:temdt]];
    }
    [self.dataDt setObject:marr1 forKey:@"section1"];
    NSArray *arr2 = @[@{@"name":@"公共卫生服务介绍",@"imgurl":@"gongweijieshao"},
                      @{@"name":@"和平医院介绍",@"imgurl":@"hepingjieshao"},
                      @{@"name":@"社区服务中心介绍",@"imgurl":@"shequjieshao"}];
    NSMutableArray *marr2 = [NSMutableArray array];
    for (NSDictionary *temdt in arr2) {
        [marr2 addObject:[ImLbModel mj_objectWithKeyValues:temdt]];
    }
    [self.dataDt setObject:marr2 forKey:@"section2"];
}
-(NSMutableDictionary *)dataDt{
    if (_dataDt == nil) {
        _dataDt = [NSMutableDictionary dictionary];
    }
    return _dataDt;
}
-(NSMutableArray *)infoArr{
    if (_infoArr == nil) {
        _infoArr = [NSMutableArray array];
    }
    return _infoArr;
}
-(NSMutableArray *)healthArr{
    if (_healthArr == nil) {
        _healthArr = [NSMutableArray array];
    }
    return _healthArr;
}
-(NSMutableArray *)goodArr{
    if (_goodArr == nil) {
        _goodArr = [NSMutableArray array];
    }
    return _goodArr;
}
-(void)UpData{
    [self getData];
    [self UploadDataisInformation];
    [self UploadDataGoods];
    [self UploadDataLecture];
}
- (SDCycleScrollView *)sdCySVHeder {
    if(!_sdCySVHeder){
        _sdCySVHeder = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screenW, headerHt) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        //        _sdCySV.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        //        _sdCySV.currentPageDotColor = JHColor(138, 181, 255);
        _sdCySVHeder.showPageControl = NO;
        _sdCySVHeder.backgroundColor = [UIColor whiteColor];
        _sdCySVHeder.imageURLStringsGroup = @[@"yiliaobanner"];
    }
    
    return _sdCySVHeder;
}
- (SDCycleScrollView *)sdCySV {
    if(!_sdCySV){
        _sdCySV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screenW, 50) delegate:self placeholderImage:[UIImage imageNamed:@""]];
//        _sdCySV.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//        _sdCySV.currentPageDotColor = JHColor(138, 181, 255);
        _sdCySV.showPageControl = NO;
        _sdCySV.backgroundColor = [UIColor whiteColor];
        _sdCySV.scrollDirection = UICollectionViewScrollDirectionVertical;
        _sdCySV.imageURLStringsGroup = @[@""];
    }
    
    return _sdCySV;
}
#pragma mark CycleScrollViewdelegate
-(UINib *)customCollectionViewCellNibForCycleScrollView:(SDCycleScrollView *)view{
    if (view == _sdCySV) {
        return [UINib nibWithNibName:@"InformationCycleCollectionViewCell" bundle:nil];
    }
    return nil ;
    
}
-(void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view{
    InformationCycleCollectionViewCell *mcell = (InformationCycleCollectionViewCell *)cell;
    [mcell labelSetText:@"乳腺癌越早发现越好治！教你发现乳..." tag:@"热点" index:1];
    [mcell labelSetText:@"得了高血压，吃药有讲究！服药七忌..." tag:@"健康" index:2];
}
#pragma mark - tableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH -NaviH-TabH) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 110;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = JHbgColor;
        [_tableView registerNib:[UINib nibWithNibName:@"CollectioncellTableViewCell" bundle:nil] forCellReuseIdentifier:@"CollectioncellTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"InformationTableViewCell" bundle:nil] forCellReuseIdentifier:@"InformationTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HealthEducateListTableViewCell" bundle:nil] forCellReuseIdentifier:@"HealthEducateListTableViewCell"];
        _tableView.tableHeaderView = self.sdCySVHeder;
        WEAKSELF;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf UpData];
        }];
    }
    return _tableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) return self.infoArr.count;
    if (section == 2) return self.healthArr.count;
    if (section == 4) return self.goodArr.count ? 1 :0;
    return 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 4) {
        CollectioncellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CollectioncellTableViewCell class]) forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.collectionView.backgroundColor = [UIColor clearColor];
        if (indexPath.section == 0) {
            cell.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            cell.layout.itemSize = CGSizeMake((screenW - 75)/4 - 1, 80);
            cell.layout.minimumLineSpacing = 15;
            cell.layout.minimumInteritemSpacing = 0.001;
            CGFloat oneX = 15;
            CGFloat oneY = 10;
            cell.layout.sectionInset = UIEdgeInsetsMake(oneY, oneX, oneY, oneX);
            cell.itemSize = cell.layout.itemSize;
            cell.Identifier = @"ImageLabelCollectionViewCell";
            cell.titleArr = self.dataDt[@"section1"];
        }else{
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.layout.itemSize = CGSizeMake((screenW - 70)/3 , 190);
            cell.layout.minimumLineSpacing = 10;
            CGFloat oneX = 15;
            CGFloat oneY = 0;
            cell.layout.sectionInset = UIEdgeInsetsMake(oneY, oneX, 10, oneX);
            cell.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            cell.itemSize = cell.layout.itemSize;
            cell.Identifier = @"HealthShopCollectionViewCell";
            cell.titleArr = self.goodArr;
        }
        WEAKSELF;
        cell.ClickBlock = ^(NSIndexPath *indexpath) {
            if (indexPath.section == 0) {
                if (indexpath.row == 1) {
                    HealthRecordsFirstViewController *vc = [[HealthRecordsFirstViewController alloc]init];
                    vc.isSecond = @"isSecond";
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                if (indexpath.row == 2) {
                    [weakSelf.navigationController pushViewController:[[HealthRecordsFirstViewController alloc]init] animated:YES];
                }
                if (indexpath.row == 3) {
                    [weakSelf.navigationController pushViewController:[[FileQueryHomeViewController alloc]init] animated:YES];
                }
                if (indexpath.row == 6) {
                    [weakSelf.navigationController pushViewController:[[ServiceHotlineListViewController alloc]init] animated:YES];
                }
                
            }else if (indexPath.section == 4){
                MeGoodModel *mo = self.goodArr[indexpath.row];
                ShopDoodsDetailsViewController * goods = [[ShopDoodsDetailsViewController alloc]init];
                goods.goods_id = mo.goods_id;
                [self.navigationController pushViewController:goods animated:YES];
            }
        };
        
        return cell;
    }else if (indexPath.section == 1){
        InformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationTableViewCell"];
        [cell setCellWithDict:self.infoArr[indexPath.row] indexPath:indexPath];
        return cell;
    }else if (indexPath.section == 3){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView removeAllSubviews];
        UIImageView *voteImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cepingbanner"]];
        [cell.contentView addSubview:voteImage];
        [voteImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(0);
            make.right.offset(0);
            make.bottom.offset(0);
        }];
        voteImage.contentMode = UIViewContentModeScaleAspectFill;
        voteImage.layer.masksToBounds = YES;
        
        return cell;
    }

    HealthEducateListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthEducateListTableViewCell"];
    cell.model = self.healthArr[indexPath.row];
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) return 190;
    if (indexPath.section == 1 || indexPath.section == 2) return 100;
    if (indexPath.section == 3) return 100;
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        if (section == 1 && !self.infoArr.count) return 0.001;
        if (section == 2 && !self.healthArr.count) return 0.001;
        if (section == 4 && !self.goodArr.count) return 0.001;
        return 50;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        if (section == 1 && !self.infoArr.count) return nil;
        if (section == 2 && !self.healthArr.count) return nil;
        if (section == 4 && !self.goodArr.count) return nil;
        UIView *header = [[UIView alloc]init];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *lb = [UILabel initialization:CGRectMake(15, 0, screenW - 30, 50) font:[UIFont fontWithName:@"Helvetica-Bold" size:15] textcolor:JHMedicalColor numberOfLines:0 textAlignment:0];
        NSArray *nameArr = @[@"医疗咨询",@"健康讲座",@"满意度测评",@"健康商城"];
        lb.text = nameArr[section - 1];
        [header addSubview:lb];
        if (section == 3) return header;
        ImRightBtn *btn = [[ImRightBtn alloc]init];
        btn.section = section;
        [btn setImage:[UIImage imageNamed:@"gerenzhongxinjiantou"] forState:UIControlStateNormal];
        [btn setTitle:@"查看全部 " forState:UIControlStateNormal];
        [btn setTitleColor:JHmiddleColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
//    if (section == 0) {
//        return 60;
//    }
    return 0.001;
}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section == 0) {
//        return self.sdCySV;
//    }
//    return nil;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        SatisfactionListViewController *hot = [[SatisfactionListViewController alloc]init];
        hot.type_id = @"1";
        [self.navigationController pushViewController:hot animated:YES];
    }else if (indexPath.section == 1 || indexPath.section == 2) {
        
        InforViewController *hot = [[InforViewController alloc]init];
        if (indexPath.section == 1) {
            hot.detailid = self.infoArr[indexPath.row][@"id"];
            hot.type = InfoStyleYiLiao;
        }else{
            AritcleNewModel *mo = self.healthArr[indexPath.row];
            hot.detailid = mo.ID;
            hot.type = InfoStyleWenZhang;
        }
        
        [self.navigationController pushViewController:hot animated:YES];
    }
}
#pragma mark - 查看全部
-(void)moreBtnClick:(ImRightBtn *)btn{
    if (btn.section == 1 || btn.section == 2) {
        InformationViewController *hot = [[InformationViewController alloc]init];
        if (btn.section == 1) {
            hot.type = InfoStyleYiLiao;
        }else{
            hot.type = InfoStyleWenZhang;
            hot.url = MedicalLectureListUrl;
            hot.titleStr = @"健康讲座";
        }
        [self.navigationController pushViewController:hot animated:YES];
    }

}
#pragma mark 社区资讯
-(void)UploadDataisInformation{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session,@"pagination":@{@"count":@"2",@"page":@"1"}};
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,MedicalInfoListUrl) params:dt success:^(id response) {
        LFLog(@"社区资讯:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.infoArr removeAllObjects];
            for (NSDictionary *temdt in response[@"data"]) {
                [self.infoArr addObject:temdt];
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
#pragma mark 讲座
-(void)UploadDataLecture{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session,@"pagination":@{@"count":@"2",@"page":@"1"}};
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,MedicalLectureListUrl) params:dt success:^(id response) {
        LFLog(@"讲座:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.healthArr removeAllObjects];
            for (NSDictionary *temdt in response[@"data"]) {
                AritcleNewModel *mo = [AritcleNewModel mj_objectWithKeyValues:temdt];
                [self.healthArr addObject:mo];
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
#pragma mark 商品
-(void)UploadDataGoods{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session,@"pagination":@{@"count":@"2",@"page":@"1"}};
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,MedicalGoodsListUrl) params:dt success:^(id response) {
        LFLog(@"商品:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.goodArr removeAllObjects];
            for (NSDictionary *temdt in response[@"data"]) {
                MeGoodModel *mo = [MeGoodModel mj_objectWithKeyValues:temdt];
                [self.goodArr addObject:mo];
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
#pragma mark - 数据
- (void)getData{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,MyFileQueryListUrl) params:dt success:^(id response) {
        LFLog(@" 数据提交:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            for (NSDictionary *temdt in response[@"data"]) {

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
