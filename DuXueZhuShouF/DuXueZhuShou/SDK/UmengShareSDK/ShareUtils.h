//
//  ShareUtils.h
//  AppProject
//
//  Created by admin on 2018/5/30.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
typedef NS_ENUM(NSInteger,SharePlatformType)
{
    SharePlatformTypeWeb            = 0,
    SharePlatformTypeText           = 1
};
@interface ShareUtils : NSObject
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(ShareUtils);
-(void)ShareContent:(UIViewController *)vc title:(NSString *)title content:(NSString *)content url:(NSString *)url image:(id)image;
@end
