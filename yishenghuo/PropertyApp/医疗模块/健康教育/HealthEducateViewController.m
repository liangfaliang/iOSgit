//
//  HealthEducateViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/9.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "HealthEducateViewController.h"
#import "HealthEducateListViewController.h"
#import "SPPageMenu.h"
@interface HealthEducateViewController ()<SPPageMenuDelegate, UIScrollViewDelegate,UISearchBarDelegate,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *categoryArr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@property(nonatomic,strong)UISearchBar *searchbar;
@end

@implementation HealthEducateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSearch];
    [self presentLoadingTips];
    [self requestCategoryData];

}
- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
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
-(void)createSearch{
    self.searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width - 120, 40)];
    self.searchbar.layer.cornerRadius = 5;
    self.searchbar.layer.masksToBounds = YES;
    self.searchbar.placeholder = @"  输入疾病|药品|症状|医生|检查";
    UITextField *searchField = [self.searchbar valueForKey:@"_searchField"];
    if (searchField) {
        [searchField setValue:JHmiddleColor forKeyPath:@"_placeholderLabel.textColor"];
        [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    }
    [self.searchbar setImage:[UIImage imageNamed:@"sousuoshangcheng"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.searchbar.delegate = self;
    self.searchbar.returnKeyType = UIReturnKeySearch;
    [_searchbar setSearchFieldBackgroundImage:[UIImage imageNamed:@"sousuokuangshangcheng"] forState:UIControlStateNormal];
    UIView *seachview = [[UIView alloc]initWithFrame:CGRectMake(60, 20, SCREEN.size.width - 120, 40)];
    [seachview addSubview:_searchbar];
    if (iOS11) {
        self.navigationItem.titleView = seachview;
    }else{
        self.navigationItem.titleView = _searchbar;
    }
//    UIBarButtonItem *bt = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick:)];
//    bt.tintColor = JHshopMainColor;
//    self.navigationItem.rightBarButtonItem = bt;
    
}
// 示例7:可滑动的自适应内容排列，pageMenu.permutationWay = SPPageMenuPermutationWayScrollAdaptContent;
-(SPPageMenu *)pageMenu{
    if (!_pageMenu) {
        SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, NaviH, screenW, pageMenuH) trackerStyle:SPPageMenuTrackerStyleLineLongerThanItem];
        pageMenu.tracker.backgroundColor = JHMedicalColor;
        // 传递数组，默认选中第1个
        // 可滑动的自适应内容排列
        pageMenu.permutationWay = SPPageMenuPermutationWayScrollAdaptContent;
        // 设置代理
        pageMenu.selectedItemTitleColor = JHMedicalColor;
        pageMenu.unSelectedItemTitleColor = JHmiddleColor;
        pageMenu.delegate = self;
    
        [self.view addSubview:pageMenu];
        _pageMenu = pageMenu;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NaviH+pageMenuH, screenW, scrollViewHeight)];
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
    [self.pageMenu setItems:self.dataArr selectedItemIndex:(self.selectedIndex ? [self.selectedIndex integerValue] :0)];
    for (UIViewController *vc in self.myChildViewControllers) {
        [vc removeFromParentViewController];
    }
    [self.myChildViewControllers removeAllObjects];
    for (int i = 0; i < self.dataArr.count; i++) {
        HealthEducateListViewController *baseVc = [[HealthEducateListViewController alloc] init];
        //            NSString *text = [self.pageMenu titleForItemAtIndex:i];
        baseVc.titieStr = self.dataArr[i];
        baseVc.cat_id = self.categoryArr[i][@"id"];
        [self addChildViewController:baseVc];
        // 控制器本来自带childViewControllers,但是遗憾的是该数组的元素顺序永远无法改变，只要是addChildViewController,都是添加到最后一个，而控制器不像数组那样，可以插入或删除任意位置，所以这里自己定义可变数组，以便插入(删除)(如果没有插入(删除)功能，直接用自带的childViewControllers即可)
        [self.myChildViewControllers addObject:baseVc];
        baseVc.view.frame = CGRectMake(screenW * i, 0, screenW, scrollViewHeight);
        [_scrollView addSubview:baseVc.view];
    }
    
    // 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
    self.pageMenu.bridgeScrollView = self.scrollView;
    // pageMenu.selectedItemIndex就是选中的item下标
    if (self.pageMenu.selectedItemIndex < self.myChildViewControllers.count) {
        HealthEducateListViewController *baseVc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
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

- (void)pageMenu:(SPPageMenu *)pageMenu functionButtonClicked:(UIButton *)functionButton {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"插入一个带标题的item" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self insertItemWithObject:@"十九大" toIndex:0];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"插入一个带图片的item" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self insertItemWithObject:[UIImage imageNamed:@"Expression_1"] toIndex:1];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"删除一个item" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self removeItemAtIndex:1];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"删除所有item" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self removeAllItems];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [alertController addAction:action4];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - insert or remove

// object是插入的对象(NSString或UIImage),insertNumber是插入到第几个
- (void)insertItemWithObject:(id)object toIndex:(NSInteger)insertNumber {
////     插入之前，先将新控制器之后的控制器view往后偏移
//    for (int i = 0; i < self.myChildViewControllers.count; i++) {
//        if (i >= insertNumber) {
//            UIViewController *childController = self.myChildViewControllers[i];
//            childController.view.frame = CGRectMake(screenW * (i+1), 0, screenW, scrollViewHeight);
//            [self.scrollView addSubview:childController.view];
//        }
//    }
//    if (insertNumber <= self.pageMenu.selectedItemIndex && self.myChildViewControllers.count) { // 如果新插入的item在当前选中的item之前
//        // scrollView往后偏移
//        self.scrollView.contentOffset = CGPointMake(screenW*(self.pageMenu.selectedItemIndex+1), 0);
//    } else {
//        self.scrollView.contentOffset = CGPointMake(0, 0);
//    }
//
//    SixViewController *sixVc = [[SixViewController alloc] init];
//    sixVc.text = @"我是新插入的";
//    [self addChildViewController:sixVc];
//    [self.myChildViewControllers insertObject:sixVc atIndex:insertNumber];
//
//    // 要先添加控制器，再添加item，如果先添加item，会立即调代理方法，此时myChildViewControllers的个数还是0，在代理方法中retun了
//    if ([object isKindOfClass:[NSString class]]) {
//        [self.pageMenu insertItemWithTitle:object atIndex:insertNumber animated:YES];
//    } else {
//        [self.pageMenu insertItemWithImage:object atIndex:insertNumber animated:YES];
//    }
//
//    // 重新设置scrollView容量
//    self.scrollView.contentSize = CGSizeMake(screenW*self.myChildViewControllers.count, 0);
}

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
#pragma mark - *************分类请求************
-(void)requestCategoryData{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    LFLog(@"分类请求dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,HealthEducateCategoryUrl) params:dt success:^(id response) {
        LFLog(@"分类请求:%@",response);
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSArray class]]) {
                [self.categoryArr removeAllObjects];
                [self.dataArr removeAllObjects];
                for (NSDictionary *temdt in response[@"data"]) {
                    [self.categoryArr addObject:temdt];
                    [self.dataArr addObject:temdt[@"name"]];
                }
                [self RefreshCategoryData];
                
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    [self requestCategoryData];
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"请求失败！"];
    }];
    
}

@end
