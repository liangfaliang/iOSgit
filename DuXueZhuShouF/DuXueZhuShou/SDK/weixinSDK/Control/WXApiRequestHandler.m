//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//

#import "WXApi.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"



@implementation WXApiRequestHandler

#pragma mark - Public Methods


+ (void)jumpToBizPay:(NSDictionary *)dict{
    
    if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机未安装微信,请选择其他支付方式" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
 
        
    }else{
        LFLog(@"dict:%@",dict);
        //向微信注册
        BOOL sussecd = NO;
        if (dict[@"appid"]) {
           sussecd =  [WXApi registerApp:dict[@"appid"] enableMTA:YES];
        }
        if (sussecd) {
            NSMutableString *stamp  = [NSMutableString stringWithFormat:@"%@",[dict objectForKey:@"timestamp"]];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
            //日志输出
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        }else{
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接失败！请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    }
    
}
+ (BOOL)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
                      OpenID:(NSString *)openID
            InViewController:(UIViewController *)viewController {
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = scope; // @"post_timeline,sns"
    req.state = state;
    req.openID = openID;
    return [WXApi sendAuthReq:req
               viewController:viewController
                     delegate:[WXApiManager sharedManager]];
}

@end
