//
//  SMSSDK.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/9/24.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "SMSSDK.h"
@implementation SMSSDK
SYNTHESIZE_SINGLETON_FOR_CLASS(SMSSDK);
- (void) getVerificationCodeByMethod:(NSString * )method
                         phoneNumber:(NSString *)phoneNumber
                                zone:(NSString *)zone
                              success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]init];
    if (phoneNumber) {
        [dt setObject:phoneNumber forKey:@"mobile"];
    }
    if (method) {
        [dt setObject:method forKey:@"purpose"];
    }
    LFLog(@"短信验证发送dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,@"") params:dt viewcontrllerEmpty:nil success:^(id response) {
        LFLog(@"短信验证发送:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"]) {
//            self.send_id = [NSString stringWithFormat:@"%@",response[@"data"][@"send_id"]];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.userInteractionEnabled = NO;
            hud.mode = MBProgressHUDModeCustomView;
            UIImage *im = [[UIImage imageNamed:@"MBlogo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImageView *imageview = [[UIImageView alloc]initWithImage:im];
            hud.customView = imageview;
            hud.opacity = 0.5;
            hud.removeFromSuperViewOnHide = YES;
            hud.detailsLabelText = NSLocalizedString(response[@"msg"], @"HUD title");
            [hud hide:YES afterDelay:2.f];
        }
        if (success) {
            success(response);
        }

    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void) commitVerificationCode:(NSString *)code
                    phoneNumber:(NSString *)phoneNumber
                           zone:(NSString *)zone
                         success:(void (^)(id response))success failure:(void (^)(NSError *error))failure{
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]init];
    if (phoneNumber) {
        [dt setObject:phoneNumber forKey:@"mobile"];
    }
    if (code) {
        [dt setObject:code forKey:@"code"];
    }
    if (self.send_id) {
        [dt setObject:self.send_id forKey:@"send_id"];
    }
    LFLog(@"短信验证dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,@"") params:dt viewcontrllerEmpty:nil success:^(id response) {
        LFLog(@"短信验证:%@",response);
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
@end
