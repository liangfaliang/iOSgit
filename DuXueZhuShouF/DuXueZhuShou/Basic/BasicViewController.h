//
//  BasicViewController.h
//  37℃Apartment
//
//  Created by SandClock on 2018/5/23.
//  Copyright © 2018年 PmMaster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"
@class LoginViewController;


@interface BasicViewController : UIViewController <DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, assign) BOOL isEmptyDelegate;//  是否设置空白页代理
@property (nonatomic, assign) BOOL isCancelNetwork;//  是否设置页面返回取消网络请求 默认yes

@property (nonatomic, strong) NSNumber * isLoadEnd;//数据是否加载完 0 正在加载 1加载完成 2加载失败
@property (nonatomic, strong)id navigationBarTitle;
@property (nonatomic, strong)UIButton *backButton;
//检测是否登录
-(void)CheckIsLogin;
/** 隐藏返回按钮 */
@property (assign, nonatomic) BOOL backItemHidden;
//// 登陆状态改变
//- (void)loginStatusChanged;
//返回按钮点击事件
- (void)navigationBackItemClicked;
//弹出登录提示框
- (void)showLoginAlert;
- (void)showLoginAlert:(void (^)(NSInteger code))resultBlock;
//提示框
-(void)alertController:(NSString *)name prompt:(NSString *)prompt sure:(NSString *)sure cancel:(NSString *)cancel success:(void (^)(void))success failure:(void (^)(void))failure;
//隐藏bar底部线
- (void)setNavigationBarShadowHidden;
-(void)UpData;//请求数据调此方法
- (void)backItemAction;//返回按钮单击

- (void)presentLoadingTips:(NSString *)str;
- (void)presentLoadingTips;
- (void)presentPromptStr:(NSString *)str;
- (void)presentTextStr:(NSString *)str;
-(void)dismissTips;

//网络
/** 记录将需要在退出VC取消的请求。
 *  在记录的时候，清理已经请求完成的task
 *  如果请求需要有取消功能，那么在failure的block中，需要添加对取消的失败不做任务处理的实现。
 */
- (void)addSessionDataTask:(NSURLSessionDataTask *)task;

/** 移除已经请求成功的请求
 * 在请求完成的block中，添加移除的操作
 */
- (void)removeSessionDataTask:(NSURLSessionDataTask *)task;

/** 取消所有的请求 */
- (void)cancelAllSessionDataTask;


@end
