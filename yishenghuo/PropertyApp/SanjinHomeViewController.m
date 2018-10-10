//
//  SanjinHomeViewController.m
//  PropertyApp
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "SanjinHomeViewController.h"
#import "CollectioncellTableViewCell.h"
#import "InformationTableViewCell.h"
#import "SDCycleScrollView.h"
#import "InformationCycleCollectionViewCell.h"
#import "MKJCollectionViewFlowLayout.h"
#import "ImLbModel.h"
#import "ChildCareHomeview.h"
#import "MedicalPlanTableViewCell.h"
#import "InforViewController.h"
#import "SanjinListViewController.h"
#import "InformationViewController.h"
#import "ShopDoodsDetailsViewController.h"
#define headerHt SCREEN.size.width * 12/25
#define InfoKey @"InfoKey"
typedef NS_ENUM(NSInteger, SanJintypeStyle) {
    SanJinStyleYaoshi = 0,                  // 能源周刊
    SanJinStyleDouzi = 1,        // 能源思考
    SanJinStyleXiyang = 2,            // 能源书籍
};

@interface SanjinHomeViewController ()<UITableViewDataSource, UITableViewDelegate,SDCycleScrollViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableDictionary *dataDt;
@property(nonatomic, strong)NSMutableDictionary *InfoDt;
@property(nonatomic,strong)ChildCareHomeview *headerview;
@property (nonatomic, retain)SDCycleScrollView *sdCySV;
@property (nonatomic,strong)NSMutableArray *pictureArr;//存储的信息数组
@property(nonatomic,strong)NSMutableArray *iconbtnArr;
@property (nonatomic, assign) SanJintypeStyle typeStyle;
@end

@implementation SanjinHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.typeStyle = SanJinStyleYaoshi;
    [self initData];
    [self.view addSubview:self.tableView];
    [self UpData];
}
-(void)UpData{
    NSArray *urlArr = @[HomeInformationListUrl,MedicalInfoListUrl,BusinessInfoListUrl,GoldenInfoListUrl];
    for (int i = 0; i < 4; i ++) {
        NSString *key = [NSString stringWithFormat:@"InfoKey%d",i];
        [self UploadDataisInformation:key url:urlArr[i]];
    }
    for (int i = 0; i < 3; i ++) {
        [self UploadDataGold:i];
    }
    [self rotatePicture];
}
-(void)initData{
    NSArray *arr1 = @[];
    NSArray *arr2 = @[];
    arr1 = @[@{@"name":@"",@"backimage":@"threegold_gold_key"},
             @{@"name":@"",@"backimage":@"threegold_gold_beans"},
             @{@"name":@"",@"backimage":@"threegold_golden_sunset"}];
    arr2 = @[@{@"name":@"金豆子套餐",@"imgurl":@"jiancexuzhiyunyufw",@"backcolor":@"F2F2F2"},
             @{@"name":@"金豆子套餐",@"imgurl":@"manbingjzfw",@"backcolor":@"F2F2F2"},
             @{@"name":@"金豆子套餐",@"imgurl":@"manbingjzfw",@"backcolor":@"F2F2F2"}];
    
    NSMutableArray *marr1 = [NSMutableArray array];
    for (NSDictionary *temdt in arr1) {
        ImLbModel *mo = [ImLbModel mj_objectWithKeyValues:temdt];
        [marr1 addObject:mo];
    }
    [self.dataDt setObject:marr1 forKey:@"section1"];
    
//    NSMutableArray *marr2 = [NSMutableArray array];
//    for (NSDictionary *temdt in arr2) {
//        ImLbModel *mo = [ImLbModel mj_objectWithKeyValues:temdt];
//        mo.cornerRadius = @"3";
//        [marr2 addObject:mo];
//    }
//    [self.dataDt setObject:marr2 forKey:@"section2"];
}
-(NSMutableDictionary *)dataDt{
    if (_dataDt == nil) {
        _dataDt = [NSMutableDictionary dictionary];
    }
    return _dataDt;
}
-(NSMutableDictionary *)InfoDt{
    if (_InfoDt == nil) {
        _InfoDt = [NSMutableDictionary dictionary];
    }
    return _InfoDt;
}
- (NSMutableArray *)pictureArr
{
    if (!_pictureArr) {
        _pictureArr = [[NSMutableArray alloc]init];
    }
    return _pictureArr;
}
-(NSMutableArray *)iconbtnArr{
    if (_iconbtnArr == nil) {
        NSArray *arr = @[@"",@"物业服务咨询",@"医疗服务咨询",@"商业服务咨询",@"三金服务咨询"];
        _iconbtnArr = [NSMutableArray arrayWithArray:arr];
    }
    return _iconbtnArr;
}


- (SDCycleScrollView *)sdCySV {
    if(!_sdCySV){
        _sdCySV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screenW, headerHt) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        //        _sdCySV.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        //        _sdCySV.currentPageDotColor = JHColor(138, 181, 255);
        _sdCySV.showPageControl = YES;
        _sdCySV.backgroundColor = JHbgColor;
        _sdCySV.scrollDirection = UICollectionViewScrollDirectionVertical;
//        _sdCySV.imageURLStringsGroup = @[@"",@""];
    }
    
    return _sdCySV;
}

#pragma mark - tableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStyleGrouped];
        if (iOS11) {
            self.tableView.height = SCREEN.size.height - TabH;
        }
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = JHbgColor;
        _tableView.estimatedRowHeight = 110;
        [_tableView registerNib:[UINib nibWithNibName:@"CollectioncellTableViewCell" bundle:nil] forCellReuseIdentifier:@"CollectioncellTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"InformationTableViewCell" bundle:nil] forCellReuseIdentifier:@"InformationTableViewCell"];
        _tableView.tableHeaderView = self.sdCySV;
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
    if (section == 1) {
        NSString *key = [NSString stringWithFormat:@"%ld",(long)self.typeStyle];
        return self.dataDt[key] ? 1 : 0;
    }
    if (section > 1) {
        NSString *key = [NSString stringWithFormat:@"InfoKey%ld",(long)section -2];
        NSMutableArray *marr = self.InfoDt[key];
        return marr.count ? 1 : 0;
    }
    
    return 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( indexPath.section == 1 || indexPath.section == 0 ) {
        CollectioncellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CollectioncellTableViewCell class]) forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.collectionView.backgroundColor = [UIColor whiteColor];
        if (indexPath.section == 0) {
            cell.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            cell.layout.itemSize = CGSizeMake((screenW - 70)/3 - 1, 130);
            cell.layout.minimumLineSpacing = 20;
            cell.layout.minimumInteritemSpacing = 0.001;
            CGFloat oneX = 15;
            CGFloat oneY = 10;
            cell.layout.sectionInset = UIEdgeInsetsMake(oneY, oneX, oneY, oneX);
            cell.itemSize = cell.layout.itemSize;
            cell.Identifier = @"ImageLabelCollectionViewCell";
            cell.titleArr = self.dataDt[@"section1"];
        }else if (indexPath.section == 1) {
            cell.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            cell.layout.itemSize = CGSizeMake((screenW - 80)/3 - 1, 140);
            cell.layout.minimumLineSpacing = 15;
            cell.layout.minimumInteritemSpacing = 0.001;
            CGFloat oneX = 20;
            cell.layout.sectionInset = UIEdgeInsetsMake(5, oneX, 10, oneX);
            cell.itemSize = cell.layout.itemSize;
            cell.Identifier = @"ImageLabelCollectionViewCell";
            NSString *key = [NSString stringWithFormat:@"%ld",(long)self.typeStyle];
            cell.titleArr = self.dataDt[key];
        }
        WEAKSELF;
        cell.ClickBlock = ^(NSIndexPath *indexpath) {
            if (indexPath.section == 0) {
                weakSelf.typeStyle = indexpath.row;
                [weakSelf.tableView reloadData];
            }else if (indexPath.section == 1){
                ShopDoodsDetailsViewController *vc = [[ShopDoodsDetailsViewController alloc]init];
                NSString *key = [NSString stringWithFormat:@"%ld",(long)self.typeStyle];
                NSMutableArray *marr = self.dataDt[key];
                ImLbModel *mo = marr[indexpath.row];
                vc.goods_id = mo.data[@"goods_id"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        
        return cell;
    }
    InformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationTableViewCell"];
    NSString *key = [NSString stringWithFormat:@"InfoKey%ld",(long)indexPath.section -2];
    NSMutableArray *marr = self.InfoDt[key];
    [cell setCellWithDict:marr[indexPath.row] indexPath:indexPath];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) return 150;
    if (indexPath.section == 1) return 140;
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        if (section > 1) {
            NSString *key = [NSString stringWithFormat:@"InfoKey%ld",(long)section -2];
            NSMutableArray *marr = self.InfoDt[key];
            return marr.count ? 50 : 0.001;
        }
        return 50;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        if (section > 1) {
            NSString *key = [NSString stringWithFormat:@"InfoKey%ld",(long)section -2];
            NSMutableArray *marr = self.InfoDt[key];
            if (!marr.count) return nil;
        }
        UIView *header = [[UIView alloc]init];
        header.backgroundColor = [UIColor whiteColor];
        NSArray *nameArr = @[@"",@"物业资讯",@"医疗资讯",@"商业资讯",@"三金资讯"];
        NSArray *colorArr = @[@"89E782",@"FE504F",@"89E782",@"4FC4FC",@"EBA400"];
        UILabel *lb = [UILabel initialization:CGRectMake(15, 0, screenW - 30, 50) font:[UIFont fontWithName:@"Helvetica-Bold" size:15] textcolor:[UIColor colorFromHexCode:colorArr[section - 1]] numberOfLines:0 textAlignment:0];
        lb.text = nameArr[section - 1];
        if (section == 1) {
            if (self.typeStyle == SanJinStyleYaoshi) {
                lb.text = @"金钥匙服务";
            }
            if (self.typeStyle == SanJinStyleDouzi) {
                lb.text = @"金豆子服务";
            }
            if (self.typeStyle == SanJinStyleXiyang) {
                lb.text = @"金夕阳服务";
            }
        }
        [header addSubview:lb];
        ImRightBtn *btn = [[ImRightBtn alloc]init];
        btn.section = section;
        [btn setImage:[UIImage imageNamed:@"gerenzhongxinjiantou"] forState:UIControlStateNormal];
        [btn setTitle:@"查看更多 " forState:UIControlStateNormal];
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
    if (section == 0) {
        return 30;
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *footer = [[UIView alloc] init];
        footer.backgroundColor = [UIColor whiteColor];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, screenW - 30, 10)];
        imageview.image = [UIImage imageNamed:@"threegold_gradientslider"];
        [footer addSubview:imageview];
        UIImageView *thimageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 10, 10)];
        NSArray *imNameArr = @[@"threegold_gold_key_triangle",@"threegold_gold_beans_triangle",@"threegold_golden_sunset_triangle"];
        thimageview.image = [UIImage imageNamed:imNameArr[self.typeStyle]];
        thimageview.centerX = 15 + (self.typeStyle + 0.5) * ((screenW  - 30)/ 3);
        [footer addSubview:thimageview];
        return footer;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section > 1) {
        NSString *key = [NSString stringWithFormat:@"InfoKey%ld",(long)indexPath.section -2];
        NSMutableArray *marr = self.InfoDt[key];
        InforViewController *infor = [[InforViewController alloc]init];
        infor.detailid = marr[indexPath.row][@"id"];
        infor.type = indexPath.section - 2;
        [self.navigationController pushViewController:infor animated:YES];
    }
    
}
#pragma mark - 查看全部
-(void)moreBtnClick:(ImRightBtn *)btn{
    if (btn.section == 1) {
        SanjinListViewController *vc = [[SanjinListViewController alloc]init];
        NSArray *cateArr = @[@"111",@"112",@"110"];
        vc.category_id = cateArr[self.typeStyle];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        InformationViewController *hot = [[InformationViewController alloc]init];
        hot.type = btn.section - 2;
        [self.navigationController pushViewController:hot animated:YES];
    }
}
#pragma mark 轮播图数据
-(void)rotatePicture{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session};
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,GoldenHomeBannerUrl) params:dt success:^(id response) {
        LFLog(@"轮播图数据:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.pictureArr removeAllObjects];
            NSMutableArray *marr = [NSMutableArray array];
            for (NSDictionary *dt in response[@"data"]) {
                [self.pictureArr addObject:dt];
                [marr addObject:dt[@"imgurl"]];
            }
            self.sdCySV.imageURLStringsGroup = marr;
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark 金钥匙服务
-(void)UploadDataGold:(SanJintypeStyle )style{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary *dt = [NSMutableDictionary dictionaryWithDictionary:@{@"session":session,@"pagination":@{@"count":@"3",@"page":@"1"}}];
    NSString *category_id  =@"";
    if (style == SanJinStyleXiyang) {
        category_id = @"110";
    }else if (style == SanJinStyleDouzi) {
        category_id = @"112";
    }else if (style == SanJinStyleYaoshi) {
        category_id = @"111";
    }
    NSString *key = [NSString stringWithFormat:@"%ld",(long)style];
    [dt setObject:category_id forKey:@"category_id"];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,GoldenGoodsListUrl) params:dt success:^(id response) {
        LFLog(@"金钥匙服务:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            NSMutableArray *marr = [NSMutableArray array];
            [ImLbModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"imgurl":@"img"};
            }];
            for (NSDictionary *temDt in response[@"data"]) {
                ImLbModel *mo = [ImLbModel mj_objectWithKeyValues:temDt];
                mo.backcolor = @"F0F0F0";
                mo.data = temDt;
                mo.cornerRadius = @"3";
                [marr addObject:mo];
            }
            [self.dataDt setObject:marr forKey:key];
            [ImLbModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return nil;
            }];
            
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark 社区资讯
-(void)UploadDataisInformation:(NSString *)key url:(NSString *)url{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session,@"pagination":@{@"count":@"2",@"page":@"1"}};
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt success:^(id response) {
        LFLog(@"社区资讯:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            NSMutableArray *marr = [NSMutableArray array];
            for (NSDictionary *dt in response[@"data"]) {
                [marr addObject:dt];
            }
            [self.InfoDt setObject:marr forKey:key];
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showTabbar];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self hideTabbar];
    [self.navigationController setNavigationAlpha:1.0 animated:YES];

    
}
@end
