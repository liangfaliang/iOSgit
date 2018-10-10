//
//  SanjinListViewController.m
//  PropertyApp
//
//  Created by admin on 2018/9/7.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "SanjinListViewController.h"
#import "SDCycleScrollView.h"
#import "ImageLabelCollectionViewCell.h"
#import "ShopDoodsDetailsViewController.h"
#define headerHt SCREEN.size.width * 12/25
@interface SanjinListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)NSMutableArray * bookArr;
@property (nonatomic,strong)NSMutableArray * pictureArr;
@property (nonatomic,strong)UICollectionView * collectionview;
@property (nonatomic, strong)SDCycleScrollView *sdCySV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, assign)NSInteger more;
@end

@implementation SanjinListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.category_id isEqualToString:@"111"]) self.navigationBarTitle = @"金钥匙服务";
    if ([self.category_id isEqualToString:@"110"]) self.navigationBarTitle = @"金夕阳服务";
    if ([self.category_id isEqualToString:@"112"]) self.navigationBarTitle = @"金豆子服务";
    [self.view addSubview:self.collectionview];
    [self updata];
    
}

-(void)updata{
    self.page = 1;
    self.more = 1;
    [self UploadDataGold:1];
}

-(NSMutableArray *)pictureArr{
    if (_pictureArr == nil) {
        _pictureArr = [NSMutableArray array];
    }
    return _pictureArr;
}

- (NSMutableArray *)bookArr
{
    if (!_bookArr) {
        _bookArr = [[NSMutableArray alloc]init];
        [_bookArr addObjectsFromArray:@[@"",@"",@"",@"",@"",@""]];
    }
    return _bookArr;
}

//- (SDCycleScrollView *)sdCySV {
//    if(!_sdCySV){
//        _sdCySV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, SAFE_NAV_HEIGHT, screenW, headerHt) delegate:self placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
//        _sdCySV.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//        _sdCySV.currentPageDotColor = [UIColor whiteColor];
//    }
//
//    return _sdCySV;
//}

-(UICollectionView *)collectionview{
    if (!_collectionview) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((screenW - 70) /3 -1, 130);
        flowLayout.minimumInteritemSpacing = 20;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 0, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenW,screenH ) collectionViewLayout:flowLayout];
        _collectionview.dataSource=self;
        _collectionview.delegate=self;
        _collectionview.backgroundColor = [UIColor whiteColor];
        [_collectionview registerNib:[UINib nibWithNibName:@"ImageLabelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageLabelCollectionViewCell"];
        WEAKSELF;
        _collectionview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf UpData];
        }];
        _collectionview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf footerWithRefresh];
            
        }];
    }
    return _collectionview;
}
-(void)footerWithRefresh{
    if (self.more == 1) {
        [_collectionview.mj_footer endRefreshingWithNoMoreData];
    }else{
        self.page ++;
        [self UploadDataGold:self.page];
    }
}
#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.bookArr.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"ImageLabelCollectionViewCell";
    ImageLabelCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.model = self.bookArr[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ShopDoodsDetailsViewController *vc = [[ShopDoodsDetailsViewController alloc]init];
    ImLbModel *mo = self.bookArr[indexPath.row];
    vc.goods_id = mo.data[@"goods_id"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark 金钥匙服务
-(void)UploadDataGold:(NSInteger )pageNum{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session,@"pagination":@{@"count":@"6",@"page":[NSString stringWithFormat:@"%ld",(long)pageNum]},@"category_id":self.category_id ? self.category_id : @"111"};
    if (pageNum == 1) {
        [self.bookArr removeAllObjects];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,GoldenGoodsListUrl) params:dt success:^(id response) {
        LFLog(@"金钥匙服务:%@",response);
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if (pageNum == 1) {
                [self.bookArr removeAllObjects];
            }
            self.more = [[NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]] integerValue];
            [ImLbModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"imgurl":@"img"};
            }];
            for (NSDictionary *temDt in response[@"data"]) {
                ImLbModel *mo = [ImLbModel mj_objectWithKeyValues:temDt];
                mo.backcolor = @"F0F0F0";
                mo.data = temDt;
                mo.cornerRadius = @"3";
                [self.bookArr addObject:mo];
            }
            [ImLbModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return nil;
            }];
            
        }else{
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        [self.collectionview reloadData];
    } failure:^(NSError *error) {
        [self.collectionview.mj_header endRefreshing];
        [self.collectionview.mj_footer endRefreshing];
    }];
    
}

@end
