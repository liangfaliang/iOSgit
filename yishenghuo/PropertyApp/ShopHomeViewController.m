//
//  ShopHomeViewController.m
//  PropertyApp
//
//  Created by admin on 2018/8/15.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ShopHomeViewController.h"
#import "SPPageMenu.h"
#import "BusinessHomeViewController.h"
#import "PreschoolHomeViewController.h"
#import "WKViewViewController.h"
@interface ShopHomeViewController ()<SPPageMenuDelegate, UIScrollViewDelegate,UISearchBarDelegate,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *categoryArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;

@end

@implementation ShopHomeViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showTabbar];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self hideTabbar];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self RefreshCategoryData];
    
}
- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObjectsFromArray:@[@"商业",@"幼教",@"金融"]];
    }
    return _dataArr;
}
- (NSMutableArray *)categoryArr {
    
    if (!_categoryArr) {
        _categoryArr = [NSMutableArray array];
    }
    return _categoryArr;
}
- (NSMutableArray *)myChildViewControllers {
    
    if (!_myChildViewControllers) {
        _myChildViewControllers = [NSMutableArray array];
    }
    return _myChildViewControllers;
}

// 示例7:可滑动的自适应内容排列，pageMenu.permutationWay = SPPageMenuPermutationWayScrollAdaptContent;
-(SPPageMenu *)pageMenu{
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, NaviH  , screenW, 40) trackerStyle:SPPageMenuTrackerStyleLineLongerThanItem];
        _pageMenu.tracker.backgroundColor = JHAssistColor;
        _pageMenu.SPPageMenuLineColor = [UIColor clearColor];
        _pageMenu.backgroundColor = [UIColor whiteColor];
        // 传递数组，默认选中第1个
        // 可滑动的自适应内容排列
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollAdaptContent;
        // 设置代理
        _pageMenu.selectedItemTitleColor = JHAssistColor;
        _pageMenu.unSelectedItemTitleColor = JHmiddleColor;
        _pageMenu.delegate = self;
        [self.view addSubview:_pageMenu];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NaviH + 40, screenW, screenH - NaviH -TabH - 40)];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:scrollView];
        [self tz_addPopGestureToView:scrollView];
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
            BusinessHomeViewController *baseVc = [[BusinessHomeViewController alloc] init];
            vc = baseVc;
        }else if(i == 1){
            PreschoolHomeViewController *baseVc = [[PreschoolHomeViewController alloc] init];
            vc = baseVc;
        }else{
            WKViewViewController *baseVc = [[WKViewViewController alloc] init];
            baseVc.urlStr = FinancialUrl;
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
        BusinessHomeViewController *baseVc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
        [_scrollView addSubview:baseVc.view];
        baseVc.view.frame = CGRectMake(screenW*self.pageMenu.selectedItemIndex, 0, screenW, scrollViewHeight);
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
    
    targetViewController.view.frame = CGRectMake(screenW * toIndex, 0, screenW, scrollViewHeight);
    [_scrollView addSubview:targetViewController.view];
    
}


#pragma mark - insert or remove

- (void)removeItemAtIndex:(NSInteger)index {
    
    if (index >= self.myChildViewControllers.count) {
        return;
    }
    
    [self.pageMenu removeItemAtIndex:index animated:YES];
    
    // 删除之前，先将新控制器之后的控制器view往前偏移
    for (int i = 0; i < self.myChildViewControllers.count; i++) {
        if (i >= index) {
            UIViewController *childController = self.myChildViewControllers[i];
            childController.view.frame = CGRectMake(screenW * (i>0?(i-1):i), 0, screenW, scrollViewHeight);
            [self.scrollView addSubview:childController.view];
        }
    }
    if (index <= self.pageMenu.selectedItemIndex) { // 移除的item在当前选中的item之前
        // scrollView往前偏移
        NSInteger offsetIndex = self.pageMenu.selectedItemIndex-1;
        if (offsetIndex < 0) {
            offsetIndex = 0;
        }
        self.scrollView.contentOffset = CGPointMake(screenW*offsetIndex, 0);
    }
    
    UIViewController *vc = [self.myChildViewControllers objectAtIndex:index];
    [self.myChildViewControllers removeObjectAtIndex:index];
    [vc removeFromParentViewController];
    [vc.view removeFromSuperview];
    
    // 重新设置scrollView容量
    self.scrollView.contentSize = CGSizeMake(screenW*self.myChildViewControllers.count, 0);
}

- (void)removeAllItems {
    [self.pageMenu removeAllItems];
    for (UIViewController *vc in self.myChildViewControllers) {
        [vc removeFromParentViewController];
        [vc.view removeFromSuperview];
    }
    [self.myChildViewControllers removeAllObjects];
    
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.scrollView.contentSize = CGSizeMake(0, 0);
    
}

@end
