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
#import "AppDelegate.h"
#import "LoginViewController.h"
@interface AppFirstStartViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionview;

@property(nonatomic,strong)NSArray *imageArr;

@property(nonatomic,strong)UIPageControl *pageControl;

@end

@implementation AppFirstStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageArr = @[@"guide1",@"guide2",@"guide3"];
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN.size.height - 60, SCREEN.size.width, 30)];
    self.pageControl.numberOfPages = self.imageArr.count;
    self.pageControl.currentPageIndicatorTintColor = JHAssistRedColor;
    self.pageControl.pageIndicatorTintColor = JHBorderColor;
    self.pageControl.userInteractionEnabled =NO;
    [self createCollectionview];

//    [self.view addSubview:self.pageControl];
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
        [btn setTitle:@"立即体验" forState:UIControlStateNormal];
        btn.layer.borderColor = [JHMaincolor CGColor];
        btn.layer.borderWidth = 1;
        [btn setTitleColor:JHMaincolor forState:UIControlStateNormal];
        btn.layer.cornerRadius = 20;
        [cell.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView.mas_centerX);
            make.bottom.offset(-(150/1333.0 * screenH));
            make.height.offset(40);
            make.width.offset(160);
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
    if ([UserUtils getUserInfo]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.tabbar) {
            [UIApplication sharedApplication].keyWindow.rootViewController = appDelegate.tabbar;
        }else{
            LFLTabBarViewController *tabbar = [[LFLTabBarViewController alloc]init];
            appDelegate.tabbar = tabbar;
            [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
        }
    }else{
        [UIApplication sharedApplication].keyWindow.rootViewController = [[LoginViewController alloc]init];
    }
    
    
    
    
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
