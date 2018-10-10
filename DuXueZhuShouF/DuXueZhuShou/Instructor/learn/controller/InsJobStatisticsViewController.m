//
//  InsJobStatisticsViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/9/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "InsJobStatisticsViewController.h"
#import "SPPageMenu.h"
#import "PunchOperationListViewController.h"
#import "JobInsStatisticsViewController.h"
@interface InsJobStatisticsViewController ()<SPPageMenuDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@end

@implementation InsJobStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0  , screenW, 44)];
    self.navigationItem.titleView = view;
    //主线程列队一个block， 这样做 可以获取到autolayout布局后的frame，也就是titleview的frame。在viewDidLayoutSubviews中同样可以获取到布局后的坐标
    WEAKSELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        //坐标系转换到titleview
        CGFloat width = 150;
        self.pageMenu.frame = [weakSelf.view.window convertRect:CGRectMake((screenW - width)/2, SAFE_NAV_HEIGHT - 44, width, 44) toView:weakSelf.navigationItem.titleView];
        //centerview添加到titleview
        [weakSelf.navigationItem.titleView addSubview:self.pageMenu];
    });
    [self RefreshCategoryData];
}
LazyLoadArray(myChildViewControllers)
- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        NSArray *arr = @[@{@"name":@"今日"},@{@"name":@"历史"}];
        for (NSDictionary *temdt in arr) {
            SPitemModel *model = [SPitemModel mj_objectWithKeyValues:temdt];
            [_dataArr addObject:model];
        }
    }
    return _dataArr;
}
-(SPPageMenu *)pageMenu{
    if (!_pageMenu) {
        CGFloat width = 150;
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake((screenW - width)/2, SAFE_NAV_HEIGHT - 44, width, 44) trackerStyle:SPPageMenuTrackerStyleLine];
        _pageMenu.itemPadding = 10;
        _pageMenu.tracker.backgroundColor = JHMaincolor;
        _pageMenu.SPPageMenuLineColor = [UIColor clearColor];
        _pageMenu.backgroundColor = [UIColor clearColor];
        // 传递数组，默认选中第1个
        // 可滑动的自适应内容排列
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        // 设置代理
        _pageMenu.selectedItemTitleColor = JHMaincolor;
        _pageMenu.unSelectedItemTitleColor = JHmiddleColor;
        _pageMenu.delegate = self;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SAFE_NAV_HEIGHT, screenW, screenH - SAFE_NAV_HEIGHT )];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:scrollView];
//        [self tz_addPopGestureToView:scrollView];
        _scrollView = scrollView;
    }
    return _pageMenu;
}

-(void)RefreshCategoryData{
    [self.pageMenu setItems:self.dataArr selectedItemIndex:0];
    for (UIViewController *vc in self.myChildViewControllers) {
        [vc removeFromParentViewController];
    }
    [self.myChildViewControllers removeAllObjects];
    for (int i = 0; i < self.dataArr.count; i++) {
        UIViewController *vc = nil;
        if (i == 0) {
            PunchOperationListViewController *baseVc = [[PunchOperationListViewController alloc] init];
            baseVc.isHomework = YES;
            vc = baseVc;
        }else{
            JobInsStatisticsViewController *baseVc = [[JobInsStatisticsViewController alloc] init];
            vc = baseVc;
        }
        vc.hidesBottomBarWhenPushed = NO;
        [self addChildViewController:vc];
        // 控制器本来自带childViewControllers,但是遗憾的是该数组的元素顺序永远无法改变，只要是addChildViewController,都是添加到最后一个，而控制器不像数组那样，可以插入或删除任意位置，所以这里自己定义可变数组，以便插入(删除)(如果没有插入(删除)功能，直接用自带的childViewControllers即可)
        [self.myChildViewControllers addObject:vc];
        vc.view.frame = CGRectMake(screenW * i, 0, screenW, screenH);
        [_scrollView addSubview:vc.view];
    }
    
    // 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
    self.pageMenu.bridgeScrollView = self.scrollView;
    // pageMenu.selectedItemIndex就是选中的item下标
    if (self.pageMenu.selectedItemIndex < self.myChildViewControllers.count) {
        UIViewController *baseVc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
        [_scrollView addSubview:baseVc.view];
        baseVc.view.frame = CGRectMake(screenW*self.pageMenu.selectedItemIndex, 0, screenW, _scrollView.height_i);
        _scrollView.contentOffset = CGPointMake(screenW*self.pageMenu.selectedItemIndex, 0);
        _scrollView.contentSize = CGSizeMake(self.dataArr.count*screenW, 0);
    }
}
#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    NSLog(@"%zd",index);
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    NSLog(@"%zd------->%zd",fromIndex,toIndex);
    // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        [self.scrollView setContentOffset:CGPointMake(screenW * toIndex, 0) animated:NO];
    } else {
        [self.scrollView setContentOffset:CGPointMake(screenW * toIndex, 0) animated:YES];
    }
    if (self.myChildViewControllers.count <= toIndex) {return;}
    
    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(screenW * toIndex, 0, screenW, _scrollView.height_i);
    [_scrollView addSubview:targetViewController.view];
    
}


@end
