//
//  ShareSingledelegate.h
//  PropertyApp
//
//  Created by 梁法亮 on 17/2/23.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
@interface ShareSingledelegate : NSObject
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(ShareSingledelegate);
-(void)ShareContent:(UIView *)view content:(NSString *)content title:(NSString *)title  url:(NSString *)url image:(UIImage *)image;
-(void)ShareContentPlatformType:(SSDKPlatformType )PlatformType content:(NSString *)content title:(NSString *)title  url:(NSString *)url image:(UIImage *)image;//指定平台分享
@end
