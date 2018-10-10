//
//  AppDelegate.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/4.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "AppDelegate.h"


//#import "UIViewController+MLTransition.h"
#import "JPUSHService.h"
#import "AFNetworkReachabilityManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <BmobSDK/Bmob.h>
#import "UMMobClick/MobClick.h"//友盟统计
//新浪微博SDK头文件
#import "WeiboSDK.h"
#import "WXApiManager.h"
#import "AppFirstStartViewController.h"
#import "APPheadlinesViewController.h"//APP头条
#import "ActivityViewController.h"//社区活动
#import "ShopDoodsDetailsViewController.h"//商品详情
#import "CateringViewController.h"//社区食堂
#import "SatisfactionListViewController.h"//满意度调查
#import "HouseRentingViewController.h"//房屋租售
#import "PayViewController.h"//物业缴费
#import "CityNewsViewController.h"//城市新闻
#import "PeripheralBusinessViewController.h"//周边商业
#import "InformationViewController.h"//社区资讯
static NSString * MobAppk = @"1bb4923594e30";
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    NSInteger first = [[UserDefault objectForKey:@"AppFirstLogin"] integerValue];
    if (first == 1) {
        _tabbar = [[LFLTabBarViewController alloc]init];
        self.window.rootViewController = _tabbar;
    }else{
        self.window.rootViewController = [[AppFirstStartViewController alloc]init];
        
    }

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //向微信注册
   BOOL wx = [WXApi registerApp:@"wx1bb076f0bc489265" enableMTA:YES];
    LFLog(@"向微信注册:%d",wx);
    //配置sharesdk
//    [SMSSDK registerApp:MobAppk withSecret:@"2cb954bef177cac152272c3fd368a49c"];
    
    [Notification addObserver:self selector:@selector(receiveJPushMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];//接受自定义发送的消息
    [Notification addObserver:self selector:@selector(jpushDidClose) name:kJPFNetworkDidCloseNotification object:nil];
   
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:@"userDidLogout" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoError) name:@"userInfoError" object:nil];
    
    [Bmob registerWithAppKey:@"cf999dc6731b89899eeaac298867ddbc"];

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
    
    //share分享
    [ShareSDK registerActivePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ), 
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             //                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class]
                                        tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                             
                         default:
                             break;
                     }
                 }          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2159181663"
                                           appSecret:@"d414bdd2de4f3d886fb7f5330e2052cd"
                                         redirectUri:@"http://www.pmmaster.com.cn/"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx1bb076f0bc489265"
                                       appSecret:@"0fa5b563b0c11f985b70800628104df1"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105939577"
                                      appKey:@"cccb3wSOzFdSzqiZ"
                                    authType:SSDKAuthTypeBoth];
                 
                 break;
                 
             default:
                 break;
                 
         }
     }];
 
//    [self creatShortcutItem];//3dtouch
    //友盟统计
    [self umengTrack];
    if (@available(ios 11.0,*)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    UITableViewCell.appearance.selectionStyle = UITableViewCellSelectionStyleNone;
    UITableView.appearance.tableFooterView = [UIView new];
    return YES;
}
//友盟统计
- (void)umengTrack {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];//参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setLogEnabled:YES];//输出log日志
    UMConfigInstance.appKey = @"595de84d04e20596c4000ff8";
    //    UMConfigInstance.secret = @"secretstringaldfkals";
    UMConfigInstance.eSType = E_UM_NORMAL;
    [MobClick startWithConfigure:UMConfigInstance];
    
}

//3dtouch
- (void)creatShortcutItem {
    //创建系统风格的icon
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"weixinzhifu"];
    //创建快捷选项
    UIApplicationShortcutItem * item = [[UIApplicationShortcutItem alloc]initWithType:@"com.Repair" localizedTitle:@"物业报修" localizedSubtitle:@"" icon:icon userInfo:nil];
    
    //添加到快捷选项数组
    [UIApplication sharedApplication].shortcutItems = @[item];
}
-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    LFLog(@"type:%@",shortcutItem.type);
    LFLog(@"localizedTitle:%@",shortcutItem.localizedTitle);
    LFLog(@"localizedSubtitle:%@",shortcutItem.localizedSubtitle);
    LFLog(@"userInfo:%@",shortcutItem.userInfo);
    UIViewController *vc = [_tabbar topVC:self.window.rootViewController];
    UIViewController *board  = nil;
//    if ([shortcutItem.type isEqualToString:@"com.Repair"]) {
//        board = [[RepairOrderViewController alloc]init];
//    }else if ([shortcutItem.type isEqualToString:@"com.Payment"]) {
//        board = [[RepairOrderViewController alloc]init];
//    }
    if (board) {
        [vc.navigationController pushViewController:board animated:YES];
    }

}
//状态栏颜色
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    LFLog(@"callbackUrl1:%@",url.host);
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
        
    }else{
        return YES;
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    LFLog(@"callbackUrl2:%@",url.host);
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
        
    }else{
        return YES;
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options{
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

    }else{
        return YES;
    }

    
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
    UIViewController *vc = [_tabbar topVC:self.window.rootViewController];
    
    [vc.navigationController pushViewController:[ActivityViewController alloc] animated:YES];
    
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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:userInfo[@"aps"][@"alert"] preferredStyle:UIAlertControllerStyleAlert];
        
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
    UIViewController *board  = nil;
    NSString *keyid = [NSString stringWithFormat:@"%@",userInfo[@"id"]];
    NSString *keywords = [NSString stringWithFormat:@"%@",userInfo[@"type"]];
     NSString *log_id = [NSString stringWithFormat:@"%@",userInfo[@"log_id"]];
    if ([keywords isEqualToString:@"goods"]) {//商品
        ShopDoodsDetailsViewController *good = [[ShopDoodsDetailsViewController alloc]init];
        good.goods_id = keyid;
        board = good;
    }
    if ([keywords isEqualToString:@"sqst"]) {//社区食堂
        board = [[CateringViewController alloc]init];
    }
    if ([keywords isEqualToString:@"myddc"]) {//满意度调查
        board = [[SatisfactionListViewController alloc]init];
    }
    if ([keywords isEqualToString:@"fwzs"]) {//房屋租售
        board = [[HouseRentingViewController alloc]init];
    }
    if ([keywords isEqualToString:@"sqhd"]) {//社区新活动
        board = [[ActivityViewController alloc]init];
    }
    if ([keywords isEqualToString:@"wyjf"]) {//物业缴费
        board = [[PayViewController alloc]init];
    }
    if ([keywords isEqualToString:@"apptt"]) {//物业头条
        board = [[APPheadlinesViewController alloc]init];
    }
    if ([keywords isEqualToString:@"csxw"]) {//城市新闻
        board = [[CityNewsViewController alloc]init];
    }
    if ([keywords isEqualToString:@"zbsy"]) {//周边商业
        board = [[PeripheralBusinessViewController alloc]init];
    }
    if ([keywords isEqualToString:@"sqzx"]) {//社区资讯
        board = [[InformationViewController alloc]init];
    }
    if ([keywords isEqualToString:@"runtime"]) {//runtime跳转
        // 类名
        NSString *class =[NSString stringWithFormat:@"%@", userInfo[@"ios_class"]];
        const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
        
        // 从一个字串返回一个类
        Class newClass = objc_getClass(className);
        if (!newClass)
        {
            // 创建一个类
            Class superClass = [NSObject class];
            newClass = objc_allocateClassPair(superClass, className, 0);
            // 注册你创建的这个类
            objc_registerClassPair(newClass);
        }
        // 创建对象
        id instance = [[newClass alloc] init];
        if ([userInfo[@"property"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *propertys = userInfo[@"property"];
            [propertys enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                // 检测这个对象是否存在该属性
                if ([self checkIsExistPropertyWithInstance:instance verifyPropertyName:key]) {
                    // 利用kvc赋值
                    [instance setValue:obj forKey:key];
                }
            }];
            LFLog(@"instance:%@",instance);
            
        }
        board = instance;
        
        if (![board respondsToSelector:@selector(viewDidLoad)]) {
            board = nil;
        }


    }
    
    
    if (board) {
        [self UploadDataHaveRead:log_id];
        [vc.navigationController pushViewController:board animated:YES];
    }
}
/**
 *  检测对象是否存在该属性
 */
- (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName
{
    unsigned int outCount, i;
    
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance
                                                           class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    
    return NO;
}

#pragma mark - *************推送消息已读*************
-(void)UploadDataHaveRead:(NSString *)log_id{
    NSDictionary * nameuser =[userDefaults objectForKey:@"nameuser"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (nameuser) {
        [dt setObject:nameuser forKey:@"tag"];
    }
    if (log_id) {
        [dt setObject:log_id forKey:@"log_id"];
    }
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PushMessageReadUrl) params:dt success:^(id response) {
        LFLog(@"推送消息反馈：%@",response);
        
    } failure:^(NSError *error) {
        
    }];
    
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
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


//接受自定义消息调用此方法，极光的服务器直接发送的消息
- (void)receiveJPushMessage:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    NSLog(@"noti:%@",noti);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"有新的消息" message:userInfo[@"content"] preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"立即去查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self skipViewcontroller:userInfo[@"extras"]];
    }]];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    
    
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
}

- (void)jpushDidClose
{
    NSLog(@"jpushDidClose");
}

//监听网络状态
//判断网络状态
-(void)isConnectionAvailable{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSString *state = NetworkReachabilityUnknown;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                LFLog(@"未知网络");
                state = NetworkReachabilityUnknown;
                [userDefaults removeObjectForKey:NetworkReachability];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                LFLog(@"没有网络(断网)");
                [userDefaults removeObjectForKey:NetworkReachability];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                LFLog(@" 手机自带网络");
                state = NetworkReachabilityWWAN;
                [userDefaults setObject:NetworkReachabilityWWAN forKey:NetworkReachability];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                LFLog(@"WIFI");
                state = NetworkReachabilityWIFI;
                [userDefaults setObject:NetworkReachabilityWIFI forKey:NetworkReachability];
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
