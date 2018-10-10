//
//  AppFirstStartViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/1.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "AppFirstStartViewController.h"
#import "LFLTabBarViewController.h"
#import "AFNetworking.h"
@interface AppFirstStartViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionview;

@property(nonatomic,strong)NSArray *imageArr;

@property(nonatomic,strong)UIPageControl *pageControl;

@end

@implementation AppFirstStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageArr = @[@"yindaoye1",@"yindaoye2",@"yindaoye3"];
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN.size.height - 60, SCREEN.size.width, 30)];
    self.pageControl.numberOfPages = self.imageArr.count;
    self.pageControl.currentPageIndicatorTintColor = JHAssistRedColor;
    self.pageControl.pageIndicatorTintColor = JHBorderColor;
    self.pageControl.userInteractionEnabled =NO;
    [self createCollectionview];

    [self.view addSubview:self.pageControl];
//
}
-(void)createCollectionview{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.itemSize = CGSizeMake(SCREEN.size.width , SCREEN.size.height);
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    
    self.collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height + 5) collectionViewLayout:flowLayout];
    //    self.collectionview.panEnabled = YES;
    self.collectionview.pagingEnabled = YES;
    self.collectionview.dataSource=self;
    //    self.collectionview.scrollEnabled = YES;
    self.collectionview.backgroundColor = [UIColor whiteColor];
    self.collectionview.delegate=self;
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:self.collectionview];
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //    CGPoint pInView = [self.view convertPoint:self.collectionview.center toView:self.collectionview];
    //    // 获取这一点的indexPath
    //    NSIndexPath *indexPathNow = [self.collectionview indexPathForItemAtPoint:pInView];
    //    // 赋值给记录当前坐标的变量
    //

    NSInteger currentIndex = (self.collectionview.contentOffset.x + SCREEN.size.width/2) / self.collectionview.frame.size.width;
        
    self.pageControl.currentPage = currentIndex;
    
    
    
}

#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.imageArr.count;
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    cell.backgroundImage = [UIImage imageNamed:self.imageArr[indexPath.item]];
    if (indexPath.row == self.imageArr.count - 1) {
        UIButton * btn = [[UIButton alloc]init];
//        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(loginBtnclick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"立即开启" forState:UIControlStateNormal];
        btn.backgroundColor = JHAssistRedColor;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        btn.layer.borderColor = [JHColor(229, 229, 229) CGColor];
//        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 3;
        [cell.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView.mas_centerX);
            make.bottom.offset(-60);
            make.height.offset(40);
            make.width.offset(120);
        }];
    }
    
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.imageArr.count) {
        if (self.collectionview.contentOffset.x -20 > SCREEN.size.width * (self.imageArr.count - 1)) {
            LFLog(@"进入主页");
            [self loginBtnclick:nil];
        }
    }
    
    
}
-(void)loginBtnclick:(UIButton *)btn{
    
    [UserDefault setInteger:1 forKey:@"AppFirstLogin"];
    LFLTabBarViewController *tabbar = [[LFLTabBarViewController alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;

}

// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


@end
