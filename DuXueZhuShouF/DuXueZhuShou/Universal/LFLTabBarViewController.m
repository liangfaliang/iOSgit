//
//  LFLTabBarViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/4.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "LFLTabBarViewController.h"
#import "LFLNavigationController.h"
#import "LearnHomeViewController.h"
#import "IntegralHomeViewController.h"
#import "StatisticsHomeViewController.h"
#import "MineHomeViewController.h"
#import "ScoreboardViewController.h"
#import "MyAnswerListViewController.h"
//#import "LoginViewController.h"
@interface LFLTabBarViewController ()<UITabBarControllerDelegate>
@property(nonatomic,assign)NSInteger index;
@end

@implementation LFLTabBarViewController
-(instancetype)init{
    if (self = [super init]) {
        _type = UserStyleNone;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UITabBar appearance].backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    [UITabBar appearance].translucent = NO;
    [self addSubViews];
    
//    self.selectedIndex = 2;
}
-(void)setType:(UserRoleStyle)type{
    
//    if (!self.childViewControllers.count) {
//        [self addSubViews];
//    }else{
//        if (_type != type) {
//            for (UIViewController *vc in self.childViewControllers) {
//                [vc removeFromParentViewController];
//
//            }
//            for (UIView * object in self.tabBar.subviews) {
//                //3.如果不是YTTabBar，就将其从父视图上移除
//                LFLog(@"object:%@",NSStringFromClass([object class]));
//                if ([NSStringFromClass([object class]) isEqualToString:@"UITabBarButton"]) {
//                    [object removeFromSuperview];
//                }
//
//            }
////            self.tabBar.items = @[];
////            [self setToolbarItems:nil animated:NO];
//
//            [self addSubViews];
//        }
//    }
    _type = type;
}
-(void)addSubViews
{
    if ([UserUtils getUserRole] == UserStyleTeacher) {
        MyAnswerListViewController * home = [[MyAnswerListViewController alloc] init];
        [self addOneChildVC:home title:@"答疑" norImageName:@"dayi" selectedImageName:@"dayil"];
        MyAnswerListViewController * shop = [[MyAnswerListViewController alloc] init];
        shop.isRecord = YES;
        [self addOneChildVC:shop title:@"记录"norImageName:@"jilu" selectedImageName:@"jilul"];
    }else if([UserUtils getUserRole] == UserStyleStudent  || [UserUtils getUserRole] == UserStyleInstructor ){
        //学生
        LearnHomeViewController * home = [[LearnHomeViewController alloc] init];
        [self addOneChildVC:home title:@"学习" norImageName:@"home" selectedImageName:@"homel"];
        StatisticsHomeViewController * shop = [[StatisticsHomeViewController alloc] init];
        [self addOneChildVC:shop title:@"统计"norImageName:@"tongji" selectedImageName:@"tongjil"];
        if ([UserUtils getUserRole] == UserStyleInstructor) {
            ScoreboardViewController * proper = [[ScoreboardViewController alloc] init];
            [self addOneChildVC:proper title:@"积分"norImageName:@"jifen" selectedImageName:@"jifenl"];
        }else if ([UserUtils getUserRole] == UserStyleStudent){
            IntegralHomeViewController * proper = [[IntegralHomeViewController alloc] init];
            [self addOneChildVC:proper title:@"积分"norImageName:@"jifen" selectedImageName:@"jifenl"];
        }
    }
    MineHomeViewController *mine = [[MineHomeViewController alloc]init];
    [self addOneChildVC:mine title:@"我的"norImageName:@"mine" selectedImageName:@"minel"];

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
    ((BasicViewController *)childVC).backItemHidden = YES;
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


-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UINavigationController *na = (UINavigationController *)viewController;
//    LFLog(@"viewController:%@",[na.topViewController class]);
    UIViewController *vc =((UINavigationController *)tabBarController.selectedViewController).topViewController;
//    LFLog(@"selectedViewController:%@",[vc class]);
//    if ([na.topViewController isKindOfClass:[MineViewController class]]) {
//        if (![UserUtils getUserInfo]) {
//            [vc presentViewController:[[LoginViewController alloc]init] animated:YES completion:nil];
//            return NO;
//        }
//    }
    return YES;
}

@end
