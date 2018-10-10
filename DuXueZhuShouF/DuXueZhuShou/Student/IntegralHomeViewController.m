//
//  IntegralHomeViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/7/26.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "IntegralHomeViewController.h"
#import "SDCycleScrollView.h"
#import "ImageLabelCollectionViewCell.h"
#import "IntegralViewController.h"
#import "PunchSubmitViewController.h"
#import "ScoreboardViewController.h"
#define headerHt SCREEN.size.width * 12/25
@interface IntegralHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)NSMutableArray * bookArr;
@property (nonatomic,strong)UICollectionView * collectionview;
@property (nonatomic, strong)SDCycleScrollView *sdCySV;

@end

@implementation IntegralHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"积分";
    [self.view addSubview:self.sdCySV];
    [self.view addSubview:self.collectionview];
    [self updata];
    
}

-(void)updata{
    
}



- (NSMutableArray *)bookArr
{
    if (!_bookArr) {
        _bookArr = [[NSMutableArray alloc]init];
        NSArray *arr = @[@{@"name":@"积分",@"imgurl":@"jf"},
                    @{@"name":@"申请补分",@"imgurl":@"sqbf"},
                    @{@"name":@"排行榜",@"imgurl":@"phb"}];
        for (NSDictionary *dt in arr) {
            ImLbModel *mo = [ImLbModel mj_objectWithKeyValues:dt];
            [_bookArr addObject:mo];
        }
    }
    return _bookArr;
}

- (SDCycleScrollView *)sdCySV {
    if(!_sdCySV){
        _sdCySV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, SAFE_NAV_HEIGHT, screenW, headerHt) delegate:self placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        _sdCySV.currentPageDotColor = [UIColor whiteColor];
        _sdCySV.localizationImageNamesGroup = @[@"jfbj"];
    }
    
    return _sdCySV;
}

-(UICollectionView *)collectionview{
    if (!_collectionview) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((screenW - 51) /3, 100);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 0, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, SAFE_NAV_HEIGHT + headerHt, screenW,screenH - SAFE_NAV_HEIGHT - headerHt) collectionViewLayout:flowLayout];
        _collectionview.dataSource=self;
        _collectionview.delegate=self;
        _collectionview.backgroundColor = [UIColor whiteColor];
        [_collectionview registerNib:[UINib nibWithNibName:@"ImageLabelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageLabelCollectionViewCell"];
        //        [_AcCollectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ActivityHomeCollectionViewCell"];
    }
    return _collectionview;
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
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[[IntegralViewController alloc]init] animated:YES];
    }else if (indexPath.row == 1){
        PunchSubmitViewController *vc = [[PunchSubmitViewController alloc]init];
        vc.isAmend = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        [self.navigationController pushViewController:[[ScoreboardViewController alloc]init] animated:YES];
    }
    
}

#pragma mark 5e推荐

-(void)FiveEUpdata:(NSInteger )pageNum{
    NSMutableDictionary *dt = [NSMutableDictionary dictionary];
    [dt setObject:[NSString stringWithFormat:@"%ld",(long)pageNum] forKey:@"page"];
    
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,@"") params:dt viewcontrllerEmpty:self success:^(id response) {
        
        [_collectionview.mj_footer endRefreshing];
        [_collectionview.mj_header endRefreshing];
        LFLog(@"5e推荐:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"]) {
            if (pageNum == 1) {
                [self.bookArr removeAllObjects];
            }
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in response[@"data"]) {
                    
                }
                if (![response[@"data"] count]) {
                    [_collectionview.mj_footer endRefreshingWithNoMoreData];
                    [self presentLoadingTips:@"暂无数据！"];
                }
            }
            [self.collectionview reloadData];
        }else{
            [self presentLoadingTips:response[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self presentLoadingTips:@"请求失败！"];
        [_collectionview.mj_footer endRefreshing];
        [_collectionview.mj_header endRefreshing];
    }];
    
}
@end
