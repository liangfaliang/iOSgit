//
//  AppDelegate.m
//  DuXueZhuShou
//
//  Created by admin on 2018/7/24.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#import "AFNetworkReachabilityManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"
#import <UMShare/UMShare.h>
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <UMAnalytics/MobClick.h>//友盟统计
//#import "WeiboSDK.h"//微博
#import "LoginViewController.h"
#import "AppFirstStartViewController.h"
#import <UMCommon/UMCommon.h>
#import <UMCommon/UMConfigure.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import "IQKeyboardManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _type = [UserUtils getUserRole];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    NSInteger first = [[UserDefault objectForKey:@"AppFirstLogin"] integerValue];
//    if (first == 1) {
        if ([UserUtils getUserInfo]) {
            _tabbar = [[LFLTabBarViewController alloc]init];
            self.window.rootViewController = _tabbar;
        }else{
            self.window.rootViewController = [[LoginViewController alloc]init];
        }
        
//    }else{
//        self.window.rootViewController = [[AppFirstStartViewController alloc]init];
//    }
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //向微信注册
//    [WXApi registerApp:WeixinAppid enableMTA:YES];
    [Notification addObserver:self selector:@selector(receiveJPushMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];//接受自定义发送的消息
    [Notification addObserver:self selector:@selector(jpushDidClose) name:kJPFNetworkDidCloseNotification object:nil];
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    [JPUSHService crashLogON];//开启地理位置统计
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    [self isConnectionAvailable];//监听网络状态
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];//状态栏颜色
    //分享
    [UMConfigure initWithAppkey:UMengAppid channel:@"AppStore"];
    [self setupUSharePlatforms];
    //友盟统计
    [self umengTrack];
    //高德 收集崩溃日志 最好放在友盟统计之后
    [AMapServices sharedServices].apiKey = AMAP_KEY;
    if (@available(ios 11.0,*)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    UITableViewCell.appearance.selectionStyle = UITableViewCellSelectionStyleNone;
    UITableView.appearance.tableFooterView = [UIView new];

    return YES;
}
-(void)setType:(UserRoleStyle)type{
    
    if (!self.tabbar || _type != type) {
        _tabbar = nil;
        _tabbar = [[LFLTabBarViewController alloc]init];
        self.window.rootViewController = _tabbar;
    }
    _type = type;
}
//友盟分享
- (void)setupUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WeixinAppid appSecret:WeixinSecret redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_Sina)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppid/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    
}

//友盟统计
- (void)umengTrack {
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];
    [MobClick setScenarioType:E_UM_NORMAL];
}


//状态栏颜色
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
}
//后台转前台
-(void)applicationDidBecomeActive:(UIApplication *)application{
    LFLog(@"后台转前台");
//    if (_tabbar) {
//        UIViewController *vc = [_tabbar topVC:self.window.rootViewController];
//        if ([NSStringFromClass([vc class]) isEqualToString:@"MSetUpViewController"]) {
//            [vc performSelector:@selector(refresh)];
//        }
//    }
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    LFLog(@"callbackUrl1:%@",url.host);
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (result) {
        return result;
        // 其他如支付等SDK的回调
    }
    if ([url.host isEqualToString:@"pay"]) {//微信
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }else if ([url.host isEqualToString:@"safepay"]){//支付宝
        [[AlipaySDK defaultService]processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSLog(@"result = %@",resultDic);
        }];
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
        }];
        return YES;
        
    }else if([url.host isEqualToString:@"nengyuan"]) {
        return YES;
    }else{
        return YES;
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            //            NSLog(@"result = %@",resultDic);

        }];
        return YES;
    }else  if ([url.host isEqualToString:@"pay"] || [url.host isEqualToString:@"oauth"]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }else if([url.host isEqualToString:@"nengyuan"]) {

    }else {
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
        if (!result) {
            return result;
        }
    }
    return YES;
}



- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options{
    LFLog(@"callbackUrl3:%@",url.host);
    if ([url.host isEqualToString:@"pay"] || [url.host isEqualToString:@"oauth"]) {//微信
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }else if ([url.host isEqualToString:@"safepay"]){//支付宝
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
           
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            //            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        return YES;
        
    }else if (YES == [TencentOAuth CanHandleOpenURL:url])
    {
        return [TencentOAuth HandleOpenURL:url];
    }else if([url.host isEqualToString:@"nengyuan"]) {

    }else {
        BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
        if (!result) {
            return result;
        }
    }
    return YES;
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

//ios7以下调用此方法
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    if (application.applicationState == UIApplicationStateActive){//程序当前处于前台
        
        NSLog(@"前台");
    }else if (application.applicationState == UIApplicationStateInactive) {//程序从后台打开
        NSLog(@"后台");
    }
    
    
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知1:%@", [self logDic:userInfo]);
    
}

//测试调用了此方法ios7以上
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    if (application.applicationState == UIApplicationStateActive){//程序当前处于前台
        NSLog(@"前台2");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:userInfo[@"aps"][@"alert"][@"title"] preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"立即去查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self skipViewcontroller:userInfo];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }else if (application.applicationState == UIApplicationStateInactive) {//程序从后台打开
        [self skipViewcontroller:userInfo];
        NSLog(@"后台2");
    }
    NSLog(@"applicationState:%ld",(long)application.applicationState);
    
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知3123:%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

-(void)skipViewcontroller:(NSDictionary *)userInfo{
    UIViewController *vc = [_tabbar topVC:self.window.rootViewController];
    [UserUtils MessagePushContriller:vc type:lStringFor(userInfo[@"type"]) ID:lStringFor(userInfo[@"push_data"]) push_data:lStringFor(userInfo[@"push_data"])];
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListFromData:tempData
                                                     mutabilityOption:NSPropertyListImmutable
                                                               format:NULL
                                                     errorDescription:NULL];
    return str;
}


//接受自定义消息调用此方法，极光的服务器直接发送的消息
- (void)receiveJPushMessage:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    NSLog(@"自定义消息:%@",userInfo);
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"有新的消息" message:userInfo[@"content"] preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"立即去查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self skipViewcontroller:userInfo];
//    }]];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }]];
//    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
}

- (void)jpushDidClose
{
    NSLog(@"jpushDidClose");
}

//判断网络状态
-(void)isConnectionAvailable{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSString *state = NetworkReachabilityUnknown;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                LFLog(@"未知网络");
                state = NetworkReachabilityUnknown;
                [UserDefault removeObjectForKey:NetworkReachability];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                LFLog(@"没有网络(断网)");
                [UserDefault removeObjectForKey:NetworkReachability];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                LFLog(@" 手机自带网络");
                state = NetworkReachabilityWWAN;
                [UserDefault setObject:NetworkReachabilityWWAN forKey:NetworkReachability];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                LFLog(@"WIFI");
                state = NetworkReachabilityWIFI;
                [UserDefault setObject:NetworkReachabilityWIFI forKey:NetworkReachability];
                break;
                
            default:
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkNotification object:nil userInfo:@{NetworkReachability:state}];
    }];
    //开启监控
    [manager startMonitoring];
}

//如果内存警告 SD清除图片缓存
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    
}
@end

