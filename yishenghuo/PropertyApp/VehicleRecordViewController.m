
//
//  VehicleRecordViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/6/20.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "VehicleRecordViewController.h"
#import "VehicleRecordCollectionViewCell.h"
@interface VehicleRecordViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate>
@property (nonatomic,strong)UICollectionView * collectionView;
@property (strong,nonatomic)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSString *more;
@end

@implementation VehicleRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"预约记录";
    self.page = 1;
    self.more = @"1";
    self.view.backgroundColor = JHColor(244, 244, 244);
    [self createCollectionview];
    [self upDateVehicleRecordList:self.page];
    [self setupRefresh];
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
        
    }
    return _dataArray;
}
-(void)createCollectionview{

    if (self.collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.itemSize = CGSizeMake(SCREEN.size.width-30, 100);
        self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) collectionViewLayout:flowLayout];
        self.collectionView.dataSource=self;
        self.collectionView.delegate=self;
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        [self tz_addPopGestureToView:self.collectionView];
        //注册Cell，必须要有
        [self.collectionView registerNib:[UINib nibWithNibName:@"VehicleRecordCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"VehicleRecordCollectionViewCell"];
        [self.view addSubview:self.collectionView];
        
    }
}
#pragma mark collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//
//    if (self.imageArray.count <= 3) {
//        return 1;
//    }else{
//    return 2;
//
//    }
//
//}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"VehicleRecordCollectionViewCell";
    VehicleRecordCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundImage = [UIImage imageNamed:@"jilubeijing"];
    NSDictionary *dt = self.dataArray[indexPath.item];
    if ([dt[@"vehicle_type"] isEqualToString:@"小型车"]) {
        cell.typeImage.image = [UIImage imageNamed:@"xiaoxingche"];
    }else if ([dt[@"vehicle_type"] isEqualToString:@"中型车"]){
        cell.typeImage.image = [UIImage imageNamed:@"zhongxingche"];
    }else if ([dt[@"vehicle_type"] isEqualToString:@"大型车"]){
        cell.typeImage.image = [UIImage imageNamed:@"daxingche"];
    }
    cell.brandLb.text = dt[@"plate_number"];
    cell.AnnualLb.text = dt[@"inspection_date"];
    cell.reserveLb.text = dt[@"reserve_date"];
    return cell;
}


// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

    
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    return YES;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN.size.width, 15);
}
#pragma mark 记录列表
-(void)upDateVehicleRecordList:(NSInteger)pagenum{
    [self presentLoadingTips];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"8",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"记录列表dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,VehicleRecordListUrl) params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"记录列表：%@",response);
        [self dismissTips];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if ([str isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *dic in response[@"data"]) {
                [self.dataArray addObject:dic];
            }
            self.more = [NSString stringWithFormat:@"%@",response[@"paginated"][@"more"]];
            [self.collectionView reloadData];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        self.page = 1;
                        self.more = @"1";
                        [self upDateVehicleRecordList:self.page];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self dismissTips];
        [self presentLoadingTips:@"数据加载失败！"];
    }];
    
    
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.more = @"1";
        [self upDateVehicleRecordList:1];
    }];
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if ([self.more isEqualToString:@"0"]) {
            [self presentLoadingTips:@"没有更多记录了"];
            [self.collectionView.mj_footer endRefreshing];
        }else{
            self.page ++;
            [self upDateVehicleRecordList:self.page];
        }
        
    }];
}
@end
