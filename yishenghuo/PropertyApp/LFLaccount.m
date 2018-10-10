//
//  LFLaccount.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/12.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "LFLaccount.h"

#import "AFNetworkReachabilityManager.h"

@implementation LFLaccount


//判断网络状态
 +(void)isConnectionAvailable{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];

    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
       
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                LFLog(@"未知网络");
                [userDefaults removeObjectForKey:NetworkReachability];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                LFLog(@"没有网络(断网)");
                [userDefaults removeObjectForKey:NetworkReachability];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                LFLog(@" 手机自带网络");
                [userDefaults setObject:NetworkReachability forKey:NetworkReachability];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                LFLog(@"WIFI");
                [userDefaults setObject:NetworkReachability forKey:NetworkReachability];
                break;
          
            default:
                break;
        }
        
    }];
     //开启监控
  [manager startMonitoring];
}



@end
