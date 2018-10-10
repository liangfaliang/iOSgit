//
//  BaseViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/12.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+TZPopGesture.h"
#import "UIScrollView+EmptyDataSet.h"
#define navBarAlpha     1.0f
#define navBarHeight    44.0f
#define navBarColor    JHColor(247, 247, 247)
@interface BaseViewController : UIViewController <DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, assign) BOOL navigationHidden;    // default NO
@property (nonatomic, assign) CGFloat navigationHeight; // default 44.0
@property (nonatomic, assign) CGFloat navigationAlpha;  // default 1.0
@property (nonatomic, strong) UIColor *navigationColor;  // default r:0.3373 g:0.6706 b:0.3569
@property (nonatomic, strong)id navigationBarTitle;
@property (nonatomic, strong)id navigationBarRightItem;
@property (nonatomic, strong) UIImageView *basefootview;
@property (nonatomic, assign) BOOL isShowASR;//是否显示语音输入
@property (nonatomic, assign) BOOL isEmptyDelegate;//  是否设置空白页代理
@property (nonatomic, strong) NSNumber * isLoadEnd;//数据是否加载完 0 正在加载 1加载完成 2加载失败
-(void)UpData;//请求数据调此方法
// 设置返回回调Block
- (void)setRightBarBlock:(void (^)(UIBarButtonItem *sender))rightBarBlock;
// push时隐藏TabBar 跳转二级页面调用
- (void)hidesBottomBarWhenPushed:(void(^)())exec;

// 设置返回回调Block
- (void)setBackBlock:(void (^)(UIViewController *))backBlock;

// 默认返回
- (void)goBack:(UIButton *)btn;
// 拦截返回事件
- (BOOL)goBackPreviousPage;
//跳转登陆页面
-(void)showLogin:(void (^)(id response))resultBlock;
////提示框相关方法
//- (void)indeterminateExample;

- (void)presentLoadingTips:(NSString *)str;
- (void)presentLoadingTips;
- (void)presentLoadingStr:(NSString *)str;
- (void)presentPromptStr:(NSString *)str;
- (void)presentTextStr:(NSString *)str;
-(void)dismissTips;
- (void)showTabbar;
- (void)hideTabbar;
//提示框 获取当前最顶层的ViewController
- (UIViewController *)topViewController;
//提示框
-(void)alertController:(NSString *)name prompt:(NSString *)prompt sure:(NSString *)sure cancel:(NSString *)cancel success:(void (^)())success failure:(void (^)())failure;
-(void)createFootview;//显示底部视图
-(void)tabbarDoubleClick:(BOOL)isDouble;//tabbar双击
//获取IP地址
- (void)getDeviceIPIpAddresses:(void (^)(NSString *IP))Addresses;
@end


@interface UINavigationController (XPBaseViewController)

@property (nonatomic, assign) CGFloat navigationAlpha;
- (void)setNavigationAlpha:(CGFloat)navigationAlpha animated:(BOOL)animated;



@property (nonatomic, strong) UIColor *navigationColor;
- (void)setNavigationColor:(UIColor *)navigationColor animated:(BOOL)animated;


@end
