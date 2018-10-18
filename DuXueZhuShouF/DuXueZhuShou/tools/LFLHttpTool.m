//
//  LFLHttpTool.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/6.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "LFLHttpTool.h"
#import "AFNetworking.h"
#import "NSString+Hash.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "NSString+Hash.h"
#import "NSURL+QueryDictionary.h"
@interface LFLHttpTool ()
@property (nonatomic, strong) NSMutableDictionary *requestTimeMDic;
@property (nonatomic, strong) NSMutableDictionary *cancelTaskMDic;
@end

@implementation LFLHttpTool
SYNTHESIZE_SINGLETON_FOR_CLASS(LFLHttpTool);
-(instancetype)init{
    if (self =[super init]) {
        _isCancelRepeat = YES;
    }
    return self;
}
+(void)get:(NSString *)url params:(NSDictionary *)params viewcontrllerEmpty:(UIViewController *)vc success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    LFLog(@"url:%@",url);
    //判断网络状态
    if (![UserDefault objectForKey:NetworkReachability]) {
        [AlertView showMsg:@"网络貌似掉了~~"];
        if (failure) {
            failure(nil);
        }
        return;
    }
    if (vc && [vc isKindOfClass:[BasicViewController class]]) {
        BasicViewController *bvc = (BasicViewController *)vc;
        if (bvc.isLoadEnd) bvc.isLoadEnd = @0;
    }
    LFLog(@"参数mdt：%@",params);
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
        if (vc && [vc isKindOfClass:[BasicViewController class]]) {
            BasicViewController *bvc = (BasicViewController *)vc;
            if (bvc.isLoadEnd) bvc.isLoadEnd = @1;
        }
        if (success) {//如果block有值
            success(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [AlertView showMsg:@"服务器繁忙~~"];
        if (failure) {
            failure(error);
        }
        if (vc && [vc isKindOfClass:[BasicViewController class]]) {
            BasicViewController *bvc = (BasicViewController *)vc;
            if (bvc.isLoadEnd) bvc.isLoadEnd = @2;
        }
    }];
    
  
    
    
}

//上传图片
+(void)post:(NSString *)url params:(NSDictionary *)params body:(id )body success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parmsMdt = [NSMutableDictionary dictionaryWithDictionary:params];
    //判断网络状态
    if (![UserDefault objectForKey:NetworkReachability]) {
        [AlertView showMsg:@"网络貌似掉了~~"];
        if (failure) {
            failure(nil);
        }
        return;
    }
    LFLog(@"URL:%@\n参数mdt：%@",url,parmsMdt);
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [mgr setResponseSerializer:responseSerializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", @"application/javascript", @"text/js", nil];
    [mgr.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 30.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [mgr.requestSerializer setValue:@"iphone" forHTTPHeaderField:@"XX-Device-Type"];
    [mgr.requestSerializer setValue:AppBuildVersion forHTTPHeaderField:@"XX-APP-VERSION"];
    UserModel *model = [UserUtils getUserInfo];
    if (model && model.token) {
        [mgr.requestSerializer setValue:model.token forHTTPHeaderField:@"XX-Token"];
    }
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    [mgr setSecurityPolicy:securityPolicy];
    [mgr POST:url parameters:parmsMdt constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (body) {
            
            if ([body isKindOfClass:[NSArray class]]) {
                int i = 0;
                for (id  subs  in body) {
                    if ([subs isKindOfClass:[UIImage class]]) {
                        UIImage *image = (UIImage *)subs;
                        NSData *data = UIImageJPEGRepresentation(image,0.5);
                        NSInteger interval = [[NSDate date] timeIntervalSince1970];
                        NSString *imname = [NSString stringWithFormat:@"imgurl%ld_%d.jpg",(long)interval,i];
                        if ([url rangeOfString:PictureUploadAllUrl].location != NSNotFound) {
                            [formData appendPartWithFileData:data name:@"images[]" fileName:imname mimeType:@"image/jpeg"];
                        }else{
                            [formData appendPartWithFileData:data name:@"file" fileName:imname mimeType:@"image/jpeg"];
                        }
                    }else if ([subs isKindOfClass:[NSString class]]){
                        LFLog(@"RecordAudioFilePath:%@",RecordAudioFilePath);
                        NSError *error;
//                        [formData appendPartWithFileURL:[NSURL fileURLWithPath:RecordAudioFilePath] name:@"video" fileName:@"xxx.mp3" mimeType:@"application/octet-stream" error:&error];
                        [formData appendPartWithFileURL:[NSURL fileURLWithPath:RecordAudioFilePath] name:@"file" error:&error];
                        LFLog(@"error:%@",error);
                    }
                    
                    i ++;
                }
            }else if ([body isKindOfClass:[NSString class]]){
                LFLog(@"RecordAudioFilePath:%@",RecordAudioFilePath);
                NSError *error;
                [formData appendPartWithFileURL:[NSURL URLWithString:RecordAudioFilePath] name:@"file" error:&error];
                LFLog(@"error:%@",error);
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {//如果block有值
            success(responseObject);
        }
        NSLog(@"图片上传成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"图片上传失败%@",error);
        [AlertView showMsg:@"服务器繁忙~~"];
        if (failure) {
            failure(error);
        }
    }];
    
    
}



+(void)post:(NSString *)url params:(NSDictionary *)params viewcontrllerEmpty:(UIViewController *)vc success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
   
    //判断网络状态
    if (![UserDefault objectForKey:NetworkReachability]) {
        [AlertView showMsg:@"网络貌似掉了~~"];
        if (failure) {
            failure(nil);
        }
        return;
    }
    if (vc && [vc isKindOfClass:[BasicViewController class]]) {
        BasicViewController *bvc = (BasicViewController *)vc;
        if (bvc.isLoadEnd) bvc.isLoadEnd = @0;
    }
    LFLHttpTool *httptool = [LFLHttpTool sharedLFLHttpTool];
    if (httptool.isCancelRepeat) {
        if ([httptool ignoreRequestWithUrl:url params:params]) {//忽略请求
            LFLog(@"请求被忽略 URL:%@\n参数mdt：%@",url,params);
            return;
        }
    }else{
        httptool.isCancelRepeat = YES;//每次不取消重复 重置为取消重复
    }

    NSMutableDictionary *parmsMdt = [NSMutableDictionary dictionaryWithDictionary:params];
    LFLog(@"URL:%@\n参数mdt：%@",url,parmsMdt);
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [mgr.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 30.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [mgr.requestSerializer setValue:@"iphone" forHTTPHeaderField:@"XX-Device-Type"];
    [mgr.requestSerializer setValue:AppBuildVersion forHTTPHeaderField:@"XX-APP-VERSION"];
    UserModel *model = [UserUtils getUserInfo];
    if (model && model.token) {
        [mgr.requestSerializer setValue:model.token forHTTPHeaderField:@"XX-Token"];
    }
    //加密
    NSInteger timeStamp = [[NSDate date]timeIntervalSince1970];
    [mgr.requestSerializer setValue:[NSString stringWithFormat:@"%ld",(long)timeStamp] forHTTPHeaderField:@"XX-CHECK-TIME"];
    NSString *mdstr = [NSString stringWithFormat:@"%@%@",[lStringFormart(@"%ld", (long)timeStamp) MD5ForLower32Bate].lowercaseString,MD5String];
    NSString *checkToken = [NSString stringWithFormat:@"%@%@",MD5Header,[mdstr MD5ForLower32Bate].lowercaseString];
    [mgr.requestSerializer setValue:checkToken forHTTPHeaderField:@"XX-CHECK-TOKEN"];
    
    NSURLSessionDataTask * task = [mgr POST:url parameters:parmsMdt progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [httptool removeRequestWithUrl:url params:params];
        if (vc && [vc isKindOfClass:[BasicViewController class]]) {
            BasicViewController *bvc = (BasicViewController *)vc;
            [bvc removeSessionDataTask:task];
            if (bvc.isLoadEnd) bvc.isLoadEnd = @1;
        }
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if ([code isEqualToString:@"10001"]) {
            [AlertView dismiss];
            if (vc) {
                [AlertView showMsg:responseObject[@"msg"]];
                LoginViewController *login = [LoginViewController sharedLoginViewController];
//                [login refresh];
                login.loginResultBlock = ^(NSInteger code) {
                    if (code ==1) {
                        NSMutableDictionary *pp = [NSMutableDictionary dictionaryWithDictionary:parmsMdt];
                        [self post:url params:pp viewcontrllerEmpty:vc success:^(id response) {
                            if (success) {//如果block有值
                                success(response);
                            }
                        } failure:^(NSError *error) {
                            if (failure) {
                                failure(error);
                            }
                        }];

                    }else{
//                        if (success) {//如果block有值
//                            success(responseObject);
//                        }
                    }
                };
                if (!vc.presentedViewController && !vc.isPresent && ![vc isKindOfClass:[LoginViewController class]]) {
                    vc.isPresent = YES;
                    [vc presentViewController:login animated:YES completion:^{
//                        vc.isPresent = NO;
                    }];
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

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [httptool removeRequestWithUrl:url params:params];
        if (vc && [vc isKindOfClass:[BasicViewController class]]) {
            BasicViewController *bvc = (BasicViewController *)vc;
            [bvc removeSessionDataTask:task];
            if (bvc.isLoadEnd) bvc.isLoadEnd = @2;
        }
        if (error.code != -999) {//-999 请求取消
            [AlertView showMsg:@"服务器繁忙~~"];
        }
        if (failure) {
            failure(error);
        }
    }];
    if (vc && [vc isKindOfClass:[BasicViewController class]]) {
        BasicViewController *bvc = (BasicViewController *)vc;
        [bvc addSessionDataTask:task];
    }
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
            sign = [NSString stringWithFormat:@"%@%@",sign,@"LFLsecretKey"];
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

- (BOOL)ignoreRequestWithUrl:(NSString *)url params:(NSDictionary *)params
{
    return [self ignoreRequestWithUrl:url params:params timeInterval:10];
}

- (BOOL)ignoreRequestWithUrl:(NSString *)url params:(NSDictionary *)params timeInterval:(NSTimeInterval)timeInterval
{
    NSString *requestStr = [NSString stringWithFormat:@"%@?%@", url, [params uq_URLQueryString]];
    NSString *requestMD5 = [requestStr md5String].uppercaseString;
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSNumber *lastTimeNum = [self.requestTimeMDic objectForKey:requestMD5];
    
    WEAKSELF;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 超过忽略时间后，将值清空
        [weakSelf.requestTimeMDic removeObjectForKey:requestMD5];
    });
    
    
    if (timeInterval < (nowTime - [lastTimeNum doubleValue])) {
        if (0.01 > [lastTimeNum doubleValue]) {
            [self.requestTimeMDic setObject:@(nowTime) forKey:requestMD5];
        }
        return NO;
    } else {
        return YES;
    }
}
- (void)removeRequestWithUrl:(NSString *)url params:(NSDictionary *)params
{
    NSString *requestStr = [NSString stringWithFormat:@"%@?%@", url, [params uq_URLQueryString]];
    NSString *requestMD5 = [requestStr md5String].uppercaseString;
    [self.requestTimeMDic removeObjectForKey:requestMD5];
}
- (void)cancelLastTaskSessionWithUrl:(NSString *)url currentTaskSession:(NSURLSessionTask *)task
{
    NSURLSessionTask *lastSessionTask = [self.cancelTaskMDic objectForKey:url];
    
    if (nil == lastSessionTask) {
        [self.cancelTaskMDic setObject:task forKey:url];
        
        return;
    }
    
    [lastSessionTask cancel];
}

- (void)clearTaskSessionWithUrl:(NSString *)url
{
    [self.cancelTaskMDic removeObjectForKey:url];
}




#pragma mark - Remove Unused Things


#pragma mark - Private Methods


#pragma mark - Getter Methods

- (NSMutableDictionary *)requestTimeMDic
{
    if (nil == _requestTimeMDic) {
        _requestTimeMDic = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    
    return _requestTimeMDic;
}

- (NSMutableDictionary *)cancelTaskMDic
{
    if (nil == _cancelTaskMDic) {
        _cancelTaskMDic = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    
    return _cancelTaskMDic;
}


@end
