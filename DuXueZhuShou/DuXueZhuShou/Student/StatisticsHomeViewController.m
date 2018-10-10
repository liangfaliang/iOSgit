//
//  StatisticsHomeViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/7/26.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "StatisticsHomeViewController.h"
#import "SDCycleScrollView.h"
#import "ImageLabelCollectionViewCell.h"
#import "JobStatisticsViewController.h"
#import "AttendanceStatisticsViewController.h"
#import "GradeAnalysisViewController.h"
#import "PunchOperationListViewController.h"
#import "PublishedViewController.h"
#import "JobInsStatisticsViewController.h"
#import "InsJobStatisticsViewController.h"
#define headerHt SCREEN.size.width * 12/25
@interface StatisticsHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)NSMutableArray * bookArr;
@property (nonatomic,strong)UICollectionView * collectionview;
@property (nonatomic, strong)SDCycleScrollView *sdCySV;

@end

@implementation StatisticsHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"统计";
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
        NSArray *arr = @[];
        if ([UserUtils getUserRole] == UserStyleStudent) {
            arr = @[@{@"name":@"作业统计",@"imgurl":@"zytj"},
                    @{@"name":@"考勤统计",@"imgurl":@"kqtj"},
                    @{@"name":@"成绩分析",@"imgurl":@"chfx"}];
        }else if ([UserUtils getUserRole] == UserStyleInstructor){
            arr = @[@{@"name":@"作业统计",@"imgurl":@"zytj"},
                    @{@"name":@"考勤统计",@"imgurl":@"kqtj"},
                    @{@"name":@"成绩分析",@"imgurl":@"chfx"}];
        }
        
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
        _sdCySV.localizationImageNamesGroup = @[@"tjbj"];

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
        if ([UserUtils getUserRole] == UserStyleStudent) {
            [self.navigationController pushViewController:[[JobStatisticsViewController alloc]init] animated:YES];
        }else if ([UserUtils getUserRole] == UserStyleInstructor){
//            PunchOperationListViewController *vc = [[PunchOperationListViewController alloc]init];
//            vc.isHomework = YES;
//            PublishedViewController *vc = [[PublishedViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
            
            InsJobStatisticsViewController *vc = [[InsJobStatisticsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        
    }else if (indexPath.row == 1){
        if ([UserUtils getUserRole] == UserStyleStudent) {
            [self.navigationController pushViewController:[[AttendanceStatisticsViewController alloc]init] animated:YES];
        }else if ([UserUtils getUserRole] == UserStyleInstructor){
            JobInsStatisticsViewController *vc = [[JobInsStatisticsViewController alloc]init];
            vc.isKaoQin = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (indexPath.row == 2){
        GradeAnalysisViewController *vc = [[GradeAnalysisViewController alloc]init];
        if ([UserUtils getUserRole] == UserStyleInstructor){
            vc.isClass = YES;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
