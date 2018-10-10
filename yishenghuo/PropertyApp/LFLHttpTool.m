//
//  LFLHttpTool.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/6.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "LFLHttpTool.h"
#import "AFNetworking.h"
#import "NSString+hash.h"
#import "BaseViewController.h"
#import "AppDelegate.h"
@implementation LFLHttpTool

+(void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id response))success failure:(void (^)(NSError *error))failure{
    [self get:url params:params viewcontrllerEmpty:nil success:success failure:failure];
}
+(void)get:(NSString *)url params:(NSDictionary *)params viewcontrllerEmpty:(UIViewController *)vc success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{

    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
//        [self presentLoadingTips:@"网络貌似掉了~~"];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//        hud.labelText = NSLocalizedString(@"网络貌似掉了~~", @"HUD loading title");
        hud.detailsLabelText = NSLocalizedString(@"网络貌似掉了~~", @"HUD title");
        [hud hide:YES afterDelay:2.f];
//        return;
    }
    __block UIViewController *board = vc;
    if (!board) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.tabbar) {
            board = [appDelegate.tabbar topVC:appDelegate.tabbar];
        }
    }

    if (board && [board isKindOfClass:[BaseViewController class]]) {
        BaseViewController *bvc = (BaseViewController *)board;
        if (bvc.isLoadEnd) bvc.isLoadEnd = @0;
    }
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];

    [mgr.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", @"application/javascript", @"text/js", nil];
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
//    NSString *sign = [self encryptParamsWithMd5:params];
//    
//    [params setObject:sign forKey:@"sign"];
    
    [mgr GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {//下载进度
        
        LFLog(@"downloadProgress：%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        LFLog(@"responseObject：%@",responseObject);
        if (board && [board isKindOfClass:[BaseViewController class]]) {
            BaseViewController *bvc = (BaseViewController *)board;
            if (bvc.isLoadEnd) bvc.isLoadEnd = @1;
        }
        if ([url rangeOfString:AccessBaseUrl].location != NSNotFound) {
            if (success) {//如果block有值
                success(responseObject);
            }
            return ;
        }
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject objectForKey:@"note"]) {
                if (!([responseObject[@"note"] isKindOfClass:[NSString class]] || [responseObject[@"note"] isKindOfClass:[NSNull class]])) {
                    if (success) {//如果block有值
                        success(responseObject);
                    }
                }else{
                    NSError *  error;
                    if (failure) {
                        failure(error);
                    }
                }
            }else if (responseObject[@"data"]) {
                if (!([responseObject[@"data"] isKindOfClass:[NSString class]] || [responseObject[@"data"] isKindOfClass:[NSNull class]])) {
                    if (success) {//如果block有值
                        success(responseObject);
                    }
                }else{
                    NSError *  error;
                    if (failure) {
                        failure(error);
                    }
                }
            }else{
                if (success) {//如果block有值
                    success(responseObject);
                }
            }

        }else{
            if (success) {//如果block有值
                success(responseObject);
            }
        }
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *operate_reward = nil;
            if (responseObject[@"operate_reward"] && [responseObject[@"operate_reward"] isKindOfClass:[NSString class]]) {
                operate_reward = responseObject[@"operate_reward"];
            }
            if (responseObject[@"expand"] && [responseObject[@"expand"] isKindOfClass:[NSDictionary class]]) {
                if (responseObject[@"expand"][@"operate_reward"] && [responseObject[@"expand"][@"operate_reward"] isKindOfClass:[NSString class]]) {
                    operate_reward = responseObject[@"expand"][@"operate_reward"];
                }
            }
            if (operate_reward) {
                if (operate_reward.length) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                    hud.userInteractionEnabled = NO;
                    hud.mode = MBProgressHUDModeText;
                    hud.opacity = 0.5;
                    hud.removeFromSuperViewOnHide = YES;
                    hud.yOffset = SCREEN.size.height * 0.118;
                    hud.detailsLabelFont =  [UIFont fontWithName:@"Helvetica-Bold" size:15];
                    hud.detailsLabelText = NSLocalizedString(operate_reward, @"HUD loading title");
                    [hud hide:YES afterDelay:2.0];
                }
                
            }
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (board && [board isKindOfClass:[BaseViewController class]]) {
            BaseViewController *bvc = (BaseViewController *)board;
            if (bvc.isLoadEnd) bvc.isLoadEnd = @2;
        }
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:NO];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeCustomView;
        UIImage *im = [[UIImage imageNamed:@"MBlogo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImageView *imageview = [[UIImageView alloc]initWithImage:im];
        hud.customView = imageview;
        hud.opacity = 0.5;
        hud.removeFromSuperViewOnHide = YES;
        hud.detailsLabelText = NSLocalizedString(@"请求失败！", @"HUD title");
        [hud hide:YES afterDelay:2.f];
        LFLog(@"error:%@",error);
        if (failure) {
            failure(error);
        }
    }];
    
  
    
    
}

//上传图片
+(void)post:(NSString *)url params:(NSDictionary *)params body:(id )body success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parmsMdt = [NSMutableDictionary dictionaryWithDictionary:params];
    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        //        [self presentLoadingTips:@"网络貌似掉了~~"];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        //        hud.labelText = NSLocalizedString(@"网络貌似掉了~~", @"HUD loading title");
        hud.detailsLabelText = NSLocalizedString(@"网络貌似掉了~~", @"HUD title");
        [hud hide:YES afterDelay:2.f];
        return;
    }
    if ([url rangeOfString:ZJShopBaseUrl].location != NSNotFound) {
        NSDictionary *version = @{@"version":APIversion,@"model":@"ios"};
        [parmsMdt setObject:version forKey:@"version"];
        NSString *timestamp = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
        [parmsMdt setObject:timestamp forKey:@"timestamp"];
        NSString *sign = [self encryptParamsWithMd5:parmsMdt];
        [parmsMdt setObject:sign forKey:@"sign"];
    }
    
    LFLog(@"参数mdt：%@",parmsMdt);
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [mgr setResponseSerializer:responseSerializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", @"application/javascript", @"text/js", nil];
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    [mgr setSecurityPolicy:securityPolicy];
    [mgr POST:url parameters:parmsMdt constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (body) {
            int i = 0;
            if ([body isKindOfClass:[NSArray class]]) {
                for (id  subs  in body) {
                    if ([subs isKindOfClass:[UIImage class]]) {
                        UIImage *image = (UIImage *)subs;
                        NSData *data = UIImageJPEGRepresentation(image,0.5);
                        NSInteger interval = [[NSDate date] timeIntervalSince1970];
                        NSString *imname = [NSString stringWithFormat:@"imgurl%ld_%d.jpg",(long)interval,i];
                        [formData appendPartWithFileData:data name:imname fileName:imname mimeType:@"image/jpeg"];
                    }else if ([subs isKindOfClass:[NSDictionary class]]){
                        NSDictionary *dic = (NSDictionary *)subs;
                        LFLog(@"FliePathKey:%@",dic);
                        if (dic[FliePathKey]) {
                            if ([dic[FliePathKey] containsString:@"/"]) {
                                NSError *error = nil;
                                LFLog(@"dic[FliePathKey]：%@",dic[FliePathKey]);
                                NSString *nameType = dic[FlieNameKey];
                                NSArray *typeArr = [nameType componentsSeparatedByString:@"."];
                                [formData appendPartWithFileURL:[NSURL fileURLWithPath:dic[FliePathKey]] name:nameType fileName:nameType mimeType:typeArr.lastObject error:&error];
                                LFLog(@"文件上传失败error：%@",error);
                            }else if([dic[FliePathKey] isEqualToString:ImagePathKey]){
                                UIImage *image = dic[FlieImageKey];
                                NSData *data = UIImageJPEGRepresentation(image,0.5);
                                NSInteger interval = [[NSDate date] timeIntervalSince1970];
                                NSString *imname = [NSString stringWithFormat:@"imgurl%ld_%d.jpg",(long)interval,i];
                                [formData appendPartWithFileData:data name:imname fileName:imname mimeType:@"image/jpeg"];
                            }else if([dic[FliePathKey] isEqualToString:ImageKey]){
                                LFLog(@"图片上传：%@",dic);
                                UIImage *image = dic[FlieImageKey];
                                NSData *data = UIImageJPEGRepresentation(image,0.5);
                                NSString *nameType = dic[ImageNameKey];
                                [formData appendPartWithFileData:data name:nameType fileName:nameType mimeType:@"image/jpeg"];
                                
                            }
                        }
                        
                    }
                    
                    i ++;
                }
            }else if ([body isKindOfClass:[NSDictionary class]]){
                
                
                [body enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[UIImage class]]) {
                        UIImage *image = (UIImage *) obj;
                        NSData *data = UIImageJPEGRepresentation(image,0.5);
                        NSInteger interval = [[NSDate date] timeIntervalSince1970];
                        NSString *imname = [NSString stringWithFormat:@"imgurl%ld_%d.jpg",(long)interval,i];
                        [formData appendPartWithFileData:data name:imname fileName:imname mimeType:@"image/jpeg"];
                        
                    }else if ([obj isKindOfClass:[NSArray class]]){
                        NSArray *imarr = obj;
                        int j = 0;
                        for (id  subs  in imarr) {
                            if ([subs isKindOfClass:[UIImage class]]) {
                                UIImage *image = (UIImage *)subs;
                                NSData *data = UIImageJPEGRepresentation(image,0.5);
                                NSInteger interval = [[NSDate date] timeIntervalSince1970];
                                NSString *imname = [NSString stringWithFormat:@"imgurl%ld_%d.jpg",(long)interval,i];
                                [formData appendPartWithFileData:data name:imname fileName:imname mimeType:@"image/jpeg"];
                                j ++;
                            }
                            
                            
                        }
                    }

                    
                }];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {//如果block有值
            success(responseObject);
        }
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *operate_reward = nil;
            if (responseObject[@"operate_reward"] && [responseObject[@"operate_reward"] isKindOfClass:[NSString class]]) {
                operate_reward = responseObject[@"operate_reward"];
            }
            if (responseObject[@"expand"] && [responseObject[@"expand"] isKindOfClass:[NSDictionary class]]) {
                if (responseObject[@"expand"][@"operate_reward"] && [responseObject[@"expand"][@"operate_reward"] isKindOfClass:[NSString class]]) {
                    operate_reward = responseObject[@"expand"][@"operate_reward"];
                }
            }
            if (operate_reward) {
                if (operate_reward.length) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                    hud.userInteractionEnabled = NO;
                    hud.mode = MBProgressHUDModeText;
                    hud.opacity = 0.5;
                    hud.removeFromSuperViewOnHide = YES;
                    hud.yOffset = SCREEN.size.height * 0.118;
                    hud.detailsLabelFont =  [UIFont fontWithName:@"Helvetica-Bold" size:15];
                    hud.detailsLabelText = NSLocalizedString(operate_reward, @"HUD loading title");
                    [hud hide:YES afterDelay:2.0];
                }
                
            }
            
        }
        

        NSLog(@"图片上传成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"图片上传失败%@",error);
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:NO];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.userInteractionEnabled = NO;
        UIImage *im = [[UIImage imageNamed:@"MBlogo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImageView *imageview = [[UIImageView alloc]initWithImage:im];
        hud.customView = imageview;
        hud.opacity = 0.5;
        hud.removeFromSuperViewOnHide = YES;
        hud.detailsLabelText = NSLocalizedString(@"上传失败！", @"HUD title");
        [hud hide:YES afterDelay:2.f];
        if (failure) {
            failure(error);
        }
    }];
    
    
}

+(void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    [self post:url params:params viewcontrllerEmpty:nil success:success failure:failure];
}

+(void)post:(NSString *)url params:(NSDictionary *)params viewcontrllerEmpty:(UIViewController *)vc success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parmsMdt = [NSMutableDictionary dictionaryWithDictionary:params];
    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        //        [self presentLoadingTips:@"网络貌似掉了~~"];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        //        hud.labelText = NSLocalizedString(@"网络貌似掉了~~", @"HUD loading title");
        hud.detailsLabelText = NSLocalizedString(@"网络貌似掉了~~", @"HUD title");
        [hud hide:YES afterDelay:2.f];
        return;
    }
    __block UIViewController *board = vc;
    if (!board) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.tabbar) {
            board = [appDelegate.tabbar topVC:appDelegate.tabbar];
        }
    }
    
    if (board && [board isKindOfClass:[BaseViewController class]]) {
        BaseViewController *bvc = (BaseViewController *)board;
        if (bvc.isLoadEnd) bvc.isLoadEnd = @0;
    }
    if ([url rangeOfString:ZJShopBaseUrl].location != NSNotFound) {
        NSDictionary *version = @{@"version":APIversion,@"model":@"ios"};
        [parmsMdt setObject:version forKey:@"version"];
        NSString *timestamp = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
        [parmsMdt setObject:timestamp forKey:@"timestamp"];
        NSString *sign = [self encryptParamsWithMd5:parmsMdt];
        [parmsMdt setObject:sign forKey:@"sign"];
    }

    LFLog(@"%@\n参数mdt：%@",url,parmsMdt);
//    AFSecurityPolicy *securityPolicy=[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    [securityPolicy setAllowInvalidCertificates:YES];
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"somooc-106" ofType:@"cer"];
//    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
//    NSSet * certSet = [[NSSet alloc] initWithObjects:cerData, nil];
//    [securityPolicy setPinnedCertificates:certSet];
//    [securityPolicy setValidatesDomainName:NO];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [mgr.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    [mgr POST:url parameters:parmsMdt progress:^(NSProgress * _Nonnull uploadProgress) {
//        LFLog(@"uploadProgress:%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (board && [board isKindOfClass:[BaseViewController class]]) {
            BaseViewController *bvc = (BaseViewController *)board;
            if (bvc.isLoadEnd) bvc.isLoadEnd = @1;
        }
        if (success) {//如果block有值
            success(responseObject);
        }
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *operate_reward = nil;
            if (responseObject[@"operate_reward"] && [responseObject[@"operate_reward"] isKindOfClass:[NSString class]]) {
                operate_reward = responseObject[@"operate_reward"];
            }
            if (responseObject[@"expand"] && [responseObject[@"expand"] isKindOfClass:[NSDictionary class]]) {
                if (responseObject[@"expand"][@"operate_reward"] && [responseObject[@"expand"][@"operate_reward"] isKindOfClass:[NSString class]]) {
                    operate_reward = responseObject[@"expand"][@"operate_reward"];
                }
            }
            if (operate_reward) {
                if (operate_reward.length) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                    hud.userInteractionEnabled = NO;
                    hud.mode = MBProgressHUDModeText;
                    hud.opacity = 0.5;
                    hud.removeFromSuperViewOnHide = YES;
                    hud.yOffset = SCREEN.size.height * 0.118;
                    hud.detailsLabelFont =  [UIFont fontWithName:@"Helvetica-Bold" size:15];
                    hud.detailsLabelText = NSLocalizedString(operate_reward, @"HUD loading title");
                    [hud hide:YES afterDelay:2.0];
                }
                
            }
            
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (board && [board isKindOfClass:[BaseViewController class]]) {
            BaseViewController *bvc = (BaseViewController *)board;
            if (bvc.isLoadEnd) bvc.isLoadEnd = @2;
        }
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:NO];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.userInteractionEnabled = NO;
        UIImage *im = [[UIImage imageNamed:@"MBlogo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImageView *imageview = [[UIImageView alloc]initWithImage:im];
        hud.customView = imageview;
        hud.opacity = 0.5;
        hud.removeFromSuperViewOnHide = YES;
        hud.detailsLabelText = NSLocalizedString(@"请求失败！", @"HUD title");
        [hud hide:YES afterDelay:2.f];
        if (failure) {
            failure(error);
        }
    }];
   
}




+(NSString *)encryptParamsWithMd5:(NSDictionary *)params
{
    
    NSString *sign = @"";
//    LFLog(@"paramsmdt：%@",params);
    NSArray *sortedKeys = [[params allKeys] sortedArrayUsingSelector: @selector(compare:)];
//    NSArray *sortArray = [sortedKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//      return [obj1 compare:obj2 options:NSNumericSearch];
//    }];
    for (int i = 0; i <= sortedKeys.count; i++) {
        if (i == sortedKeys.count) {
            sign = [NSString stringWithFormat:@"%@%@",sign,LFLsecretKey];
        } else {
            NSString *key = sortedKeys[i];
            if ([params[key] isKindOfClass:[NSString class]]) {
                NSString *value = params[key];
                if (value.length > 0) {
                    sign = [sign stringByAppendingFormat:@"%@=%@&",key,params[key]];
                }
            }
        }
    }
        LFLog(@"sign:%@",sign);
    return [sign md5String].uppercaseString;
}

+(void)testGet:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id response))success failure:(void (^)(NSError *errorerror))failure
{
    //判断网络状态
    if (![userDefaults objectForKey:NetworkReachability]) {
        //        [self presentLoadingTips:@"网络貌似掉了~~"];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        //        hud.labelText = NSLocalizedString(@"网络貌似掉了~~", @"HUD loading title");
        hud.detailsLabelText = NSLocalizedString(@"网络貌似掉了~~", @"HUD title");
        [hud hide:YES afterDelay:2.f];
        //        return;
    }

    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    //    [mgr.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [mgr GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {//如果block有值
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
   
    
}



@end
