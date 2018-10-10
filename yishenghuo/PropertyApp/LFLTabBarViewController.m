//
//  LFLTabBarViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/4.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "LFLTabBarViewController.h"
#import "LFLTabbar.h"
#import "LFLNavigationController.h"
#import "MineViewController.h"
#import "BBShomeViewController.h"
#import "HomeWorkViewController.h"
#import "ShopViewController.h"
#import "GovernmentOnlineViewController.h"
#import "LoginViewController.h"
#import "AttestViewController.h"
#import "MedicalHomeViewController.h"
#import "MedicalViewController.h"
#import "ShopHomeViewController.h"
#import "SanjinHomeViewController.h"//三金
@interface LFLTabBarViewController ()<UITabBarControllerDelegate>
//创建一个自定制的TabBar
@property(nonatomic, strong) LFLTabbar * customTabBar;

@property(nonatomic,assign)NSInteger index;
@end

@implementation LFLTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UITabBar appearance].backgroundColor = [UIColor whiteColor];
    //    UIView *baview = [[UIView alloc]initWithFrame:self.tabBar.bounds];
    //    baview.backgroundColor = [UIColor whiteColor];
    //    [[UITabBar appearance] insertSubview:baview atIndex:0];
    //    self.selectedIndex = 0;
    //    self.index = 0;
    //    [self creatTabBar];
    //    [self creatUI];
    [UITabBar appearance].translucent = NO;
    [self addSubViews];
    
//    self.selectedIndex = 2;
}
-(void)addSubViews
{
    
    //1.首页
    HomeWorkViewController * home = [[HomeWorkViewController alloc] init];
     [self addOneChildVC:home title:@"物业" norImageName:@"wuyefuwu" selectedImageName:@"wuyefuwudianji"];
    //    //1.医疗
    MedicalViewController * proper = [[MedicalViewController alloc] init];
    [self addOneChildVC:proper title:@"医疗"norImageName:@"yiliao" selectedImageName:@"yiliao_xuanzhong"];
    //    //1.三金
    SanjinHomeViewController * sanjin = [[SanjinHomeViewController alloc] init];
    [self addOneChildVC:sanjin title:@"三金"norImageName:@"sanjing" selectedImageName:@"sanjingSelsect"];
    //2.商城
    ShopHomeViewController * shop = [[ShopHomeViewController alloc] init];
    [self addOneChildVC:shop title:@"商业"norImageName:@"shenghuofuwu" selectedImageName:@"shenghufuwudianji"];
//    //2.商城
//    ShopViewController * shop = [[ShopViewController alloc] init];
//    [self addOneChildVC:shop title:@"生活服务"norImageName:@"shenghuofuwu" selectedImageName:@"shenghufuwudianji"];
    //2.政务在线
//    GovernmentOnlineViewController * ment = [[GovernmentOnlineViewController alloc] init];
//    [self addOneChildVC:ment title:@"政务在线"norImageName:@"zhengfuzaixian" selectedImageName:@"zhengfuzaixiandianji"];


    //2.我的
//    BBShomeViewController * bbs = [[BBShomeViewController alloc] init];
//    [self addOneChildVC:bbs title:@"互助共建"norImageName:@"linlihudong" selectedImageName:@"linlihudongdianji"];
    //2.我的
    MineViewController * mine = [[MineViewController alloc] init];
    [self addOneChildVC:mine title:@"我" norImageName:@"gerenfuwu" selectedImageName:@"gerenfuwudianji"];

   
    
}



/**
 *  添加子控制器
 *
 *  @param childVC           子控制器
 *  @param title             标题
 *  @param imagName          普通状态图片
 *  @param selectedImageName 高亮状态图片
 */
- (void)addOneChildVC:(UIViewController *)childVC title:(NSString *)title norImageName:(NSString *)imagName selectedImageName: (NSString *)selectedImageName
{
    //设置title
    childVC.title = title;
    //设置tabbaritem的文字颜色

    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[NSForegroundColorAttributeName] = JHColor(51, 51, 51);
    [childVC.tabBarItem setTitleTextAttributes:md forState:UIControlStateNormal];
    
    
    NSMutableDictionary *selectedmd = [NSMutableDictionary dictionary];
    selectedmd[NSForegroundColorAttributeName] = JHMaincolor;
    [childVC.tabBarItem setTitleTextAttributes:selectedmd forState:UIControlStateSelected];

    
    
    //    设置图标
    childVC.tabBarItem.image = [UIImage resizedImage:imagName];
    
    //    设置选中的图标
    UIImage *selectedImage = [UIImage resizedImage:selectedImageName];
    childVC.tabBarItem.selectedImage = selectedImage;
    
    
    LFLNavigationController *nav = [[LFLNavigationController alloc]initWithRootViewController:childVC];
    [self addChildViewController:nav];
    
}

#pragma mark - 创建TabBar
- (void)creatTabBar{
    
    //1.创建TabBar对象，使其大小为自带的TabBar的大小
    self.customTabBar = [[LFLTabbar alloc] initWithFrame:self.tabBar.bounds];
    //设置背景颜色
    self.customTabBar.backgroundColor = [UIColor grayColor];
    
    __weak typeof(self) weakself = self;
    
    [self.customTabBar setBolock:^(NSUInteger index) {
       
        
        weakself.selectedIndex = index;
    }];
    if (self.selectedIndex == 0) {
        self.customTabBar.isSelect = YES;
    }
    //2.添加到自带的tabBar上
    [self.tabBar addSubview:self.customTabBar];
    
    //3.自带的TabBar上面buttonItem
    //buttonItem还没有添加到界面上
    //    NSLog(@"%@", self.tabBar.subviews);
    
}


#pragma mark - 创建界面
//创建界面
- (void)creatUI{
   
    //1.首页
    HomeWorkViewController * home = [[HomeWorkViewController alloc] init];
    [self addControllerWithController:home Title:@"移动办公" ImageName:@"tabbar_limitfree" SelectedImageName:@"tabbar_limitfree_press"];
    
    //2.我的
    BBShomeViewController * bbs = [[BBShomeViewController alloc] init];
    [self addControllerWithController:bbs Title:@"员工互动" ImageName:@"tabbar_reduceprice" SelectedImageName:@"tabbar_reduceprice_press"];
    
    //1.首页
//    PropertyViewController * proper = [[PropertyViewController alloc] init];
//    [self addControllerWithController:proper Title:@"专业管理" ImageName:@"tabbar_limitfree" SelectedImageName:@"tabbar_limitfree_press"];
    
    //2.我的
    MineViewController * mine = [[MineViewController alloc] init];
    [self addControllerWithController:mine Title:@"内部管理" ImageName:@"tabbar_reduceprice" SelectedImageName:@"tabbar_reduceprice_press"];
    
   }

//添加一个控制器到tabBarController中
- (void)addControllerWithController:(UIViewController *)controller Title:(NSString *)title ImageName:(NSString *)imageName SelectedImageName:(NSString *)selectedImageName{
    
    //1.设置title
    controller.title = title;
    //    controller.tabBarItem.title = title;
    //2.设置控制器对应的tabBarItem的正常状态下的图标
    controller.tabBarItem.image = [UIImage imageNamed:imageName];
    //3.设置控制器对应的tabBarItem的选中状态下的图标
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //4.将控制器添加到NavigationController中
    LFLNavigationController * nav = [[LFLNavigationController alloc] initWithRootViewController:controller];
    
    //5.将控制器对应的导航控制器添加到TabBarController中
    //在这儿会自动的给系统自带的TabBar上添加一个对应的ButtonItem
    [self addChildViewController:nav];
    
    if (self.index == 0) {
    self.customTabBar.isSelect = YES;
    }else{
    
        self.customTabBar.isSelect = NO;
    }

    self.index ++;
    
    //6.让自定制的tabBar去创建一个对应button(给tabBar一个UItabBarItem模型)
    self.customTabBar.item = controller.tabBarItem;
    
    
    
}

-(UIViewController *)topVC:(UIViewController *)rootViewcontroller{
    
    if ([rootViewcontroller isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)rootViewcontroller;
        return [self topVC:tab.selectedViewController];
    }else if ([rootViewcontroller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *na = (UINavigationController *)rootViewcontroller;
        return [self topVC:na.visibleViewController];
    }else if (rootViewcontroller.presentedViewController) {
        UIViewController *vc = (UIViewController *)rootViewcontroller.presentedViewController;
        return [self topVC:vc];
    }else{
        return rootViewcontroller;
    }
}



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //    NSLog(@"%@", self.tabBar.subviews);
    //移除自带的tabBar上面的Button
    //1.遍历self.tabBar上面所有的子视图
//    for (UIView * object in self.tabBar.subviews) {
//        
//        //2.判断子视图的类型
//        //UITabBarButton是UIKit中一个私有的类（外部拿不到的）
//        if (![object isKindOfClass:[LFLTabbar class]]) {
//            
//            //3.如果不是YTTabBar，就将其从父视图上移除
//            [object removeFromSuperview];
//        }
//    }
}



@end
