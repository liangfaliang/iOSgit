//
//  LFLNavigationController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/4.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "LFLNavigationController.h"

@interface LFLNavigationController ()

@end

@implementation LFLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isgoBack = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  拦截所有push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.viewControllers.count > 0) {
        // 如果navigationController的字控制器个数大于两个就隐藏
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
        
    }
    [super pushViewController:viewController animated:YES];
}
#pragma mark -  拦截所有pop方法
- (void)back {
    
    BOOL shouldPop = NO;
//    if (self.gobackdelegate) {
//        if([self.gobackdelegate respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
//            shouldPop = [self.gobackdelegate navigationShouldPopOnBackButton];
//        }
//    }


    if(!shouldPop) {
        [self popViewControllerAnimated:YES];
    }
    
}


@end
