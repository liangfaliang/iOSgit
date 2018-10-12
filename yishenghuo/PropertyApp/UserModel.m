//
//  UserModel.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/9/19.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "UserModel.h"
#import "JPUSHService.h"
#import <BmobSDK/Bmob.h>
#import "UMMobClick/MobClick.h"//友盟统计
#import "MJExtension.h"
@implementation UserModel
+(instancetype)shareUserModel{
    return [[self alloc]init];
}

//分配内存创建对象都会调用此方法
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static UserModel *account ;
    static dispatch_once_t once;
    
    //如果有三个线程同时调用此方法,一次只能有一个线程调用
    dispatch_once(&once, ^{
        account = [super allocWithZone:zone];
    });
    return account;
    
}

+(BOOL)Certification{
    NSString *  coid = [userDefaults objectForKey:@"coid"];//认证时保存的信息
    if (coid && [coid isKindOfClass:[NSString class]]  && coid.length > 0) {
        return YES;
    }
    return NO;
    
}

+(BOOL)online{
//    NSInteger  loginTime = [[userDefaults objectForKey:@"appisLogin"] integerValue];
//    NSInteger interval = [[NSDate date] timeIntervalSince1970];
//    if ((interval - loginTime) > 1800) {//设置间隔时间为一小时
//        return NO;
//    }
//    LFLog(@"islogin:%ld",(interval - loginTime));
//    if ([islogin isEqualToString:@"1"]) {
//        return YES;
//    }
    NSString *  useruid = [userDefaults objectForKey:@"useruid"];//登陆时保存的信息
    LFLog(@"useruid:%@",useruid);
    if (useruid && [useruid isKindOfClass:[NSString class]] && useruid.length > 0) {
        return YES;
    }
    return NO;
  
}
#pragma mark 业主信息
-(void)sendTobox{
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    
    NSDictionary *dt = @{@"userid":uid};
    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"3") params:dt success:^(id response) {
        
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            NSDictionary *dict = response[@"note"][0];

            //保存业主信息到沙盒
            [self SaveOwnerInfo:dict];

            [self USERInfoNotifitaion:@"succeed"];
            
        }else{
            NSLog(@"业主信息：%@",response[@"err_no"]);
            [self removeUserInfo];//清除业主信息
            [self USERInfoNotifitaion:@"failed"];
            
        }
        
        
    } failure:^(NSError *error) {
        [self USERInfoNotifitaion:@"failed"];
    }];
}
//保存业主信息
-(void)SaveOwnerInfo:(NSDictionary *)dict{
    [UserDefault setObject:dict[@"cardId"] forKey:@"cardId"];
    [UserDefault setObject:dict[@"City"] forKey:@"City"];
    [UserDefault setObject:dict[@"company"] forKey:@"company"];
    [UserDefault setObject:dict[@"le_name"] forKey:@"le_name"];
    [UserDefault setObject:dict[@"name"] forKey:@"name"];
    [UserDefault setObject:dict[@"coid"] forKey:@"coid"];
    [UserDefault setObject:dict[@"leid"] forKey:@"leid"];
    [UserDefault setObject:dict[@"time"] forKey:@"time"];
    [UserDefault setObject:dict[@"uid"] forKey:@"uid"];
    [UserDefault setObject:dict[@"isdefault"] forKey:@"isdefault"];
    [UserDefault setObject:dict[@"Province"] forKey:@"Province"];
    [UserDefault setObject:dict[@"mobile"] forKey:@"mobile"];
    
    NSArray *arr = dict[@"note"];
    if (arr.count > 0) {
        NSDictionary *dict1 = arr[0];
        
        LFLog(@"mobile:%@",dict);
        
        [UserDefault setObject:dict1[@"po_name"] forKey:@"po_name"];
        [UserDefault setObject:dict1[@"poid"] forKey:@"poid"];
        [UserDefault setObject:dict1[@"pid"] forKey:@"pid"];
        
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dictn = arr[i];
            [UserDefault setObject:dictn[@"po_name"] forKey:[NSString stringWithFormat:@"po_name_%d",i]];
            [UserDefault setObject:dictn[@"poid"] forKey:[NSString stringWithFormat:@"poid_%d",i]];
            [UserDefault setObject:dictn[@"pid"] forKey:[NSString stringWithFormat:@"pid_%d",i]];
        }
        [UserDefault setObject:[NSString stringWithFormat:@"%lu",(unsigned long)arr.count] forKey:@"PropertyCount"];
    }
    
    //同步保存
    [UserDefault synchronize];
}
//发送业主信息通知
-(void)USERInfoNotifitaion:(NSString *)state{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:USERInfo object:nil userInfo:@{@"login":state}];
    
}
//发送登陆通知
-(void)updateNotifitaion{


    [[NSNotificationCenter defaultCenter] postNotificationName:USERNotifiLogin object:nil userInfo:@{@"login":@"succeed"}];
}
//发送清除通知
-(void)updateClearNotifitaion{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:USERNotifiCancel object:nil userInfo:@{@"login":@"failure"}];

}
-(void)infosendTobox{
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    
    NSDictionary *dt = @{@"userid":uid};
    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"54") params:dt success:^(id response) {
        
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            if (![response[@"note"][@"worker"] isKindOfClass:[NSNull class]]) {
                NSDictionary *dt = response[@"note"][@"worker"];
                [UserDefault setObject:dt[@"Province"] forKey:@"workerProvince"];
                [UserDefault setObject:dt[@"City"] forKey:@"workerCity"];
                [UserDefault setObject:dt[@"le_name"] forKey:@"workerle_name"];
                [UserDefault setObject:dt[@"leid"] forKey:@"workerleid"];
                [UserDefault setObject:dt[@"name"] forKey:@"workername"];
                [UserDefault setObject:dt[@"company"] forKey:@"workercompany"];
                [UserDefault setObject:dt[@"coid"] forKey:@"workercoid"];
                [UserDefault setObject:dt[@"usid"] forKey:@"workerusid"];
                [UserDefault setObject:dt[@"is_express"] forKey:@"workeris_express"];
                [UserDefault setObject:dt[@"us_db"] forKey:@"workerus_db"];
                [UserDefault synchronize];
                [self updateNotifitaion];
            }else{
                [UserDefault removeObjectForKey:@"workerProvince"];
                [UserDefault removeObjectForKey:@"workerCity"];
                [UserDefault removeObjectForKey:@"workerle_name"];
                [UserDefault removeObjectForKey:@"workerleid"];
                [UserDefault removeObjectForKey:@"workername"];
                [UserDefault removeObjectForKey:@"workercompany"];
                [UserDefault removeObjectForKey:@"workercoid"];
                [UserDefault removeObjectForKey:@"workerusid"];
                [UserDefault removeObjectForKey:@"workeris_express"];
                
            }
            
        }else{
            
            
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
}
#pragma mark 保存用户信息
+(void)saveUserInfo:(NSDictionary *)dict{
    
    [UserDefault setObject:dict[@"rank_name"] forKey:@"userrank_name"];
    [UserDefault setObject:dict[@"id"]forKey:@"id"];
    [UserDefault setObject:dict[@"collection_num"] forKey:@"usercollection_num"];
    [UserDefault setObject:dict[@"email"] forKey:@"useremail"];
    [UserDefault setObject:dict[@"name"] forKey:@"usernamec"];
    [UserDefault setObject:dict[@"nickname"] forKey:@"usernickname"];
    [UserDefault setObject:dict[@"headimage"] forKey:@"userheadimage"];
    [UserDefault setObject:dict[@"sex"] forKey:@"usersex"];
    
    
    [UserDefault synchronize];
    
    
}
#pragma mark 清除所有信息
-(void)removeAllUserInfo{

    [UserDefault setObject:@"0" forKey:@"appisLogin"];
    [UserDefault removeObjectForKey:@"usersid"];
    [UserDefault removeObjectForKey:@"userrank_name"];
    [UserDefault removeObjectForKey:@"id"];
    [UserDefault removeObjectForKey:@"usercollection_num"];
    [UserDefault removeObjectForKey:@"useremail"];
    [UserDefault removeObjectForKey:@"usernamec"];
    [UserDefault removeObjectForKey:@"session"];
    [UserDefault removeObjectForKey:@"usernickname"];
    [UserDefault removeObjectForKey:@"userheadimage"];
    [UserDefault removeObjectForKey:@"usersex"];
    [UserDefault removeObjectForKey:@"namepass"];
    [UserDefault removeObjectForKey:@"useruid"];
    [UserDefault synchronize];
    [self removeUserInfo];
    [self removeWorkUserInfo];
    [UserDefault synchronize];
    //设置推送tag
    __autoreleasing NSMutableSet *tags = [NSMutableSet set];
    //    [self setTags:&tags addTag:@""];
    //    __autoreleasing NSString *alias = [NSString stringWithFormat:@"%@",dict[@"session"][@"uid"]];//别名
    [JPUSHService setTags:tags alias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    [MobClick profileSignOff];//友盟统计注销账号
    
}
- (void)setTags:(NSMutableSet **)tags addTag:(NSString *)tag {
    //  if ([tag isEqualToString:@""]) {
    // }
    LFLog(@"tag:%@",tag);
    [*tags addObject:tag];
}
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,tags, alias];
    NSLog(@"TagsAlias回调:%@", callbackString);
}
#pragma mark 清除业主信息
-(void)removeUserInfo{
    
    [UserDefault removeObjectForKey:@"cardId"];
    [UserDefault removeObjectForKey:@"City"];
    [UserDefault removeObjectForKey:@"company"];
    [UserDefault removeObjectForKey:@"le_name"];
    [UserDefault removeObjectForKey:@"name"];
    
    [UserDefault removeObjectForKey:@"coid"];
    [UserDefault removeObjectForKey:@"leid"];
    [UserDefault removeObjectForKey:@"time"];
    [UserDefault removeObjectForKey:@"uid"];
    
    [UserDefault removeObjectForKey:@"Province"];
    [UserDefault removeObjectForKey:@"po_name"];
    [UserDefault removeObjectForKey:@"poid"];
    [UserDefault removeObjectForKey:@"pid"];
    [UserDefault removeObjectForKey:@"mobile"];
    [UserDefault removeObjectForKey:@"isdefault"];
    NSInteger count = [[UserDefault objectForKey:@"PropertyCount"] integerValue];
    for (int i = 0; i < count; i ++) {
        [UserDefault removeObjectForKey:[NSString stringWithFormat:@"po_name_%d",i]];
        
    }
    
  [self updateClearNotifitaion];


}
#pragma mark 清除员工信息
-(void)removeWorkUserInfo{

    [UserDefault removeObjectForKey:@"workerProvince"];
    [UserDefault removeObjectForKey:@"workerCity"];
    [UserDefault removeObjectForKey:@"workerle_name"];
    [UserDefault removeObjectForKey:@"workerleid"];
    [UserDefault removeObjectForKey:@"workername"];
    [UserDefault removeObjectForKey:@"workercompany"];
    [UserDefault removeObjectForKey:@"workercoid"];
    [UserDefault removeObjectForKey:@"workerusid"];
    [UserDefault removeObjectForKey:@"workeris_express"];
    
   [self updateClearNotifitaion];
}
+ (NSString *)getShowDateWithTime:(NSString *)time dateFormat:(NSString *)dateFormat{
    NSDate *timeDate = [[NSDate alloc]initWithTimeIntervalSince1970:[time longLongValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat ? dateFormat :@"yyyy-MM-dd HH:mm:ss";
    NSString *timeStr = [dateFormatter stringFromDate:timeDate];
    return timeStr;
    
}
+ (NSString *)getShowDate:(NSDate *)date dateFormat:(NSString *)dateFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat ? dateFormat :@"yyyy-MM-dd HH:mm:ss";
    NSString *timeStr = [dateFormatter stringFromDate:date];
    return timeStr;
}
+(void)MakeTelephoneCall:(NSString *)tel{
    NSString *tell = [NSString stringWithFormat:@"telprompt://%@",tel?tel:@""];
    NSURL *url = [NSURL URLWithString:tell];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
}
#pragma mark 送积分
+(void)OperationToSendPoints:(NSString *)action{

    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary *dt = [NSMutableDictionary dictionary];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (action) {
        [dt setObject:action forKey:@"action"];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,OperationSendPoints) params:dt success:^(id response) {
        LFLog(@"送积分:%@",response);

    } failure:^(NSError *error) {

    }];
}

#pragma mark  runtime跳转页面
-(UIViewController *)runtimePushviewController:(NSDictionary *)dict controller:(UIViewController *)vc{
    UIViewController *board  = nil;
//    NSString *keywords = [NSString stringWithFormat:@"%@",dict[@"type"]];
//    if ([keywords isEqualToString:@"runtime"]) {//runtime跳转
        // 类名
        NSString *class =[NSString stringWithFormat:@"%@", dict[@"ios_class"]];
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
        if ([dict[@"property"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *propertys = dict[@"property"];
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
        
        
//    }
    
    
    if (board) {
        [vc.navigationController pushViewController:board animated:YES];
    }
    return board;

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
#pragma mark - *************用户信息*************
+(void)UploadDataUserInfo:(void (^)(id response))result error:(void (^)(NSError *error))failerror{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,UserInfoUrl) params:dt success:^(id response) {
        LFLog(@"用户信息：%@",response);
        if (result) {
            result(response);
        }
    } failure:^(NSError *error) {
        if (failerror) {
            failerror(error);
        }
    }];
    
}
#pragma mark - *************门禁开门*************
+(void)AccessOpenDoor:(NSDictionary *)paramDt result:(void (^)(id response))result error:(void (^)(NSError *error))failerror{
//    NSDictionary *mdt = @{@"client_id":@"c8057e82a151cdbb77900b4ae6c567f12c7714c82b964bbe3721ae4e3fd7ac6a",
//                          @"client_secret":@"fdccf09451acdf5803327184798a725359e2ce2e22ac93a85790871200779c8e",
//                          @"redirect_uri":@"urn:ietf:wg:oauth:2.0:oob"
//                          };
    [UserModel AccessOpenDoorKey:paramDt result:^(id key) {
        LFLog(@"key:%@",key);
        NSMutableDictionary *dt = [NSMutableDictionary dictionaryWithDictionary:paramDt];
        [dt setObject:key[@"data"] forKey:@"key"];
        [dt setObject:key[@"access_token"] forKey:@"access_token"];
        [dt removeObjectForKey:@"client_id"];
        [dt removeObjectForKey:@"client_secret"];
        [dt removeObjectForKey:@"redirect_uri"];
        LFLog(@"开门dt：%@",dt);
        [LFLHttpTool post:NSStringWithFormat(AccessBaseUrl,AccessOpenUrl) params:dt success:^(id response) {
            LFLog(@"开门：%@",response);
            NSString *str = [NSString stringWithFormat:@"%@",response[@"retcode"]];
            if ([str isEqualToString:@"0"]) {
                if (result) {
                    result(response);
                }
            }else{
                NSDictionary * userInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:@"key获取失败" , NSLocalizedDescriptionKey,response[@"retmsg"],NSLocalizedFailureReasonErrorKey,nil];
                NSError * error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:4 userInfo:userInfo1];
                if (failerror) {
                    failerror(error);
                }
            }
            
        } failure:^(NSError *error) {
            NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"请求失败！",NSLocalizedFailureReasonErrorKey,nil];
            NSError * err = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:4 userInfo:userInfo];
            if (failerror) {
                failerror(err);
            }
        }];
    } error:^(NSError *error) {
        if (failerror) {
            failerror(error);
        }
    }];
}
#pragma mark - *************门禁开门Key*************
+(void)AccessOpenDoorKey:(NSDictionary *)paramDt result:(void (^)(id key))result error:(void (^)(NSError *error))failerror{
    NSDictionary *mdt = @{@"client_id":paramDt[@"client_id"],
                         @"client_secret":paramDt[@"client_secret"],
                         @"redirect_uri":paramDt[@"redirect_uri"],
                         @"device_id":paramDt[@"device_id"]
                         };
    [UserModel AccessGetAccessToken:mdt result:^(id Token) {
        LFLog(@"Token:%@",Token);
        NSMutableDictionary *dt = [NSMutableDictionary dictionaryWithDictionary:paramDt];
        [dt setObject:Token[@"access_token"] forKey:@"access_token"];
        [LFLHttpTool get:NSStringWithFormat(AccessBaseUrl,AccessGetKeyUrl) params:dt success:^(id response) {
            LFLog(@"开门KEY：%@",response);
            NSString *str = [NSString stringWithFormat:@"%@",response[@"retcode"]];
            if ([str isEqualToString:@"0"]) {
                if (result) {
                    NSMutableDictionary *mdt = [NSMutableDictionary dictionaryWithDictionary:response];
                    [mdt setObject:Token[@"access_token"] forKey:@"access_token"];
                    result(mdt);
                }
            }else{
                NSDictionary * userInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:@"key获取失败" , NSLocalizedDescriptionKey,response[@"retmsg"],NSLocalizedFailureReasonErrorKey,nil];
                NSError * error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:4 userInfo:userInfo1];
                if (failerror) {
                    failerror(error);
                }
            }
            
        } failure:^(NSError *error) {
            LFLog(@"error_key:%@",error);
            NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"请求失败！",NSLocalizedFailureReasonErrorKey,nil];
            NSError * err = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:4 userInfo:userInfo];
            if (failerror) {
                failerror(err);
            }
        }];
    } error:^(NSError *error) {
        if (failerror) {
            failerror(error);
        }
    }];
}
#pragma mark - *************获取门禁token*************
+(void)AccessGetAccessToken:(NSDictionary *)paramDt result:(void (^)(id Token))result error:(void (^)(NSError *error))failerror{
    NSDictionary *tokenDt = [UserDefault objectForKey:Access_TokenKey];
    if (tokenDt && tokenDt.count) {
        if (tokenDt[@"access_token"]) {
            NSInteger  loginTime = [tokenDt[@"time"] integerValue];
            NSInteger interval = [[NSDate date] timeIntervalSince1970];
            NSInteger  expires_in = 3600;
            if (tokenDt[@"expires_in"]) {
                expires_in = [tokenDt[@"expires_in"] integerValue];
            }
            if ((interval - loginTime) < expires_in) {//设置间隔时间为一小时
                if (result) {
                    result(tokenDt);
                }
                return;
            }
        }
        
    }
    [UserModel AccessGetCode:paramDt result:^(id code) {
        if ([code isKindOfClass:[NSDictionary class]] && code[@"code"] && [code[@"code"] length]) {
            NSString *codeStr = ((NSDictionary *)code)[@"code"];
            NSMutableDictionary *mdt = [NSMutableDictionary dictionaryWithDictionary:paramDt];
            [mdt setObject:@"authorization_code" forKey:@"grant_type"];
            [mdt setObject:codeStr forKey:@"code"];
            [LFLHttpTool post:NSStringWithFormat(AccessBaseUrl,AccessGetTokenUrl) params:mdt success:^(id response) {
                LFLog(@"门禁token：%@",response);
                if ([response isKindOfClass:[NSDictionary class]] && response[@"access_token"] && [response[@"access_token"] length]) {
                    NSInteger interval = [[NSDate date] timeIntervalSince1970];
                    NSMutableDictionary *mdt = [NSMutableDictionary dictionaryWithDictionary:response];
                    [mdt setObject:[NSString stringWithFormat:@"%ld",(long)interval] forKey:@"time"];
                    [UserDefault setObject:mdt forKey:Access_TokenKey];
                    if (result) {
                        result(response);
                    }
                }else{
                    NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:response[@"error_description"] , NSLocalizedDescriptionKey,response[@"error"],NSLocalizedFailureReasonErrorKey,nil];
                    NSError * error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:4 userInfo:userInfo];
                    if (failerror) {
                        failerror(error);
                    }
                }
                
            } failure:^(NSError *error) {
                NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"请求失败！",NSLocalizedFailureReasonErrorKey,nil];
                NSError * err = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:4 userInfo:userInfo];
                if (failerror) {
                    failerror(err);
                }
            }];
        }else{
            NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"code获取失败！",NSLocalizedFailureReasonErrorKey,nil];
            NSError * err = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:4 userInfo:userInfo];
            if (failerror) {
                failerror(err);
            }
        }
    } error:^(NSError *error) {
        if (failerror) {
            failerror(error);
        }
    }];

    
}
#pragma mark - *************获取门禁code*************
+(void)AccessGetCode:(NSDictionary *)paramDt result:(void (^)(id code))result error:(void (^)(NSError *error))failerror{
    NSDictionary *codeDt = [UserDefault objectForKey:Access_CodeKey];
    if (codeDt && codeDt.count) {
        if ([codeDt[@"code"] isKindOfClass:[NSString class]] && [codeDt[@"code"] length]) {
            NSInteger  loginTime = [codeDt[@"effectiveTime"] integerValue];
            NSInteger interval = [[NSDate date] timeIntervalSince1970];
            if ((interval - loginTime) < 3600) {//设置间隔时间为一小时
                if (result) {
                    result(codeDt);
                }
                return;
            }
        }
        
    }
    NSMutableDictionary *dt = [NSMutableDictionary dictionary];
    if (paramDt[@"client_id"]) {
        [dt setObject:paramDt[@"client_id"] forKey:@"client_id"];
    }
    if (paramDt[@"redirect_uri"]) {
        [dt setObject:paramDt[@"redirect_uri"] forKey:@"redirect_uri"];
    }
    [dt setObject:@"code" forKey:@"response_type"];
    [LFLHttpTool get:NSStringWithFormat(AccessBaseUrl,AccessGetCodeUrl) params:dt success:^(id response) {
        LFLog(@"门禁code：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"ref"]];
        if ([str isEqualToString:@"1"]) {
            NSInteger interval = [[NSDate date] timeIntervalSince1970];
            NSDictionary *codeDt = @{@"code":response[@"code"],@"effectiveTime":[NSString stringWithFormat:@"%ld",(long)interval]};
            [UserDefault setObject:codeDt forKey:Access_CodeKey];
            if (result) {
                result(response);
            }
        }else{
            NSDictionary * userInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:@"code创建失败" , NSLocalizedDescriptionKey,response[@"msg"],NSLocalizedFailureReasonErrorKey,nil];
            NSError * error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:4 userInfo:userInfo1];
            if (failerror) {
                failerror(error);
            }
        }
        
    } failure:^(NSError *error) {
        NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"请求失败！",NSLocalizedFailureReasonErrorKey,nil];
        NSError * err = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:4 userInfo:userInfo];
        if (failerror) {
            failerror(err);
        }
    }];
    
}

@end
