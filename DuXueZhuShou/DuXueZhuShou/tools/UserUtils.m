//
//  UserUtils.m
//  AppProject
//
//  Created by admin on 2018/5/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "UserUtils.h"
#import "WKViewViewController.h"
//#import "JPUSHService.h"
//#import <UMAnalytics/MobClick.h>//友盟统计

@implementation UserUtils
+(instancetype)shareUserUtils{
    
    return [[self alloc]init];
    
}

//分配内存创建对象都会调用此方法
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static UserUtils *account ;
    static dispatch_once_t once;
    //如果有三个线程同时调用此方法,一次只能有一个线程调用
    dispatch_once(&once, ^{
        account = [super allocWithZone:zone];
    });
    return account;
}




#pragma mark 保存用户信息
+(void)saveUserInfo:(id)dict{
    NSData *data = nil;
    if ([dict isKindOfClass:[NSDictionary class]]) {
        data =  [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    }else if ([dict isKindOfClass:[UserModel class]]){
        UserModel *model = (UserModel *)dict;
        NSDictionary *dt = [model mj_keyValues];
        data =  [NSJSONSerialization dataWithJSONObject:dt options:NSJSONWritingPrettyPrinted error:nil];
    }else{
        LFLog(@"保存失败！")
        return;
    }
    [UserDefault setObject:data forKey:USERInfoKey];
    [UserDefault synchronize];
}
#pragma mark 获取用户信息
+(UserModel *)getUserInfo{
    NSData *data = [UserDefault objectForKey:USERInfoKey];
    if (data.length) {
        UserModel *mo = [UserModel mj_objectWithKeyValues:data];
        if (mo.token && mo.token.length) {
            return mo;
        }
    }
    return nil;
}
#pragma mark获取用户角色
+(UserRoleStyle )getUserRole{
    if ([self getUserInfo] && [self getUserInfo].type >= 0) {
        
//
//#ifdef DEBUG
//        return [UserDefault objectForKey:@"role"] ? [[UserDefault objectForKey:@"role"] integerValue] : [self getUserInfo].type;
//#else
        return [self getUserInfo].type;
        //do sth.
//#endif
//        return UserStyleInstructor;
//        return UserStyleStudent;
    }
    return  UserStyleNone;
}
#pragma mark 退出登录
+(void)RemoveUserInfo{
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,LogOutUrl) params:nil viewcontrllerEmpty:nil success:^(id response) {
        LFLog(@"退出登录:%@",response);
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
        }
    } failure:^(NSError *error) {
    }];
    [UserDefault removeObjectForKey:USERInfoKey];
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
//字符串转时间戳 如：2017-4-10 17:15:10
+ (NSString *)getTimeStrWithString:(NSString *)str dateFormat:(NSString *)dateFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:dateFormat ? dateFormat :@"yyyy-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}
+ (NSDate *)getDateWithString:(NSString *)str{
    return [NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
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
#pragma mark 图片上传
+(void)postPicture:(id )body type:(NSString *)type success:(void (^)(id response))success failure:(void (^)(NSError *error))failure{
    NSString *url = nil;
    if ([body isKindOfClass:[NSArray class]]) {
        if ([body count] > 1) {
            url = PictureUploadAllUrl;
        }else{
            url = PictureUploadUrl;
        }
    }else {
        if (failure) {
            NSError *error = nil;
            failure(error);
        }
        return;
    }
    NSMutableDictionary *dt = [NSMutableDictionary dictionary];
    if (type) {
        [dt setObject:type forKey:@"type"];
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,url) params:dt body:body success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }] ;

}
////更新用户信息
//+(void)postUserInfo:(UserModel * )model ViewController:(BaseViewController *)vc success:(void (^)(id response))success failure:(void (^)(NSError *error))failure{
//    NSMutableDictionary *dt = [NSMutableDictionary dictionary];
//    if (model.token) {
//        [dt setObject:model.token forKey:@"token"];
//    }
//    if (model.avatar && ![model.avatar isValidUrl]) {
//        [dt setObject:model.avatar forKey:@"avatar"];
//    }
////
//    NSArray *keyArr = @[@"name",@"provinceId",@"cityId",@"company",@"position",@"intro",@"email",@"tags"];
//    for (NSString *key in keyArr) {
//        id value = [model valueForKey:key];
//        if (!value) {
//            continue;
//        }
//        NSString *va = nil;
//        if (![value isKindOfClass:[NSString class]]) {
//            va = [NSString stringWithFormat:@"%@",value];
//        }else{
//            va =value;
//        }
//        NSString *tem = key;
//        if ([tem isEqualToString:@"provinceId"]) {
//            tem = @"province";
//        }
//        if ([tem isEqualToString:@"cityId"]) {
//            tem = @"city";
//        }
//        if (va && va.length) {
//            [dt setObject:va forKey:tem];
//        }else{
//            [dt setObject:@"" forKey:tem];
//        }
//    }
//    LFLog(@"提交dt:%@",dt);
//    [LFLHttpTool post:NSStringWithFormat(EnergyBaseUrl,UserInfoUpdateUrl) params:dt success:^(id response) {
//        if (vc) {
//            [vc dismissTips];
//        }
//
//        LFLog(@"用户信息：%@",response);
//        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
//        if ([str isEqualToString:@"1"]) {
//            if (response[@"data"]) {
//                [UserUtils saveUserInfo:response[@"data"]];//保存用户数据
//            }
//
//        }else{
//            if (vc) {
//                [vc presentLoadingTips:response[@"msg"]];
//            }
//
//        }
//        if (success) {
//            success(response);
//        }
//
//    } failure:^(NSError *error) {
//        if (vc) {
//            [vc dismissTips];
//            [vc presentLoadingTips:@"请求失败~"];
//        }
//        if (failure) {
//            failure(error);
//        }
//        LFLog(@"error：%@",error);
//    }];
//}
////获取最新用户信息
+(void)postGetUserInfo:(BasicViewController *)vc success:(void (^)(id response))success failure:(void (^)(NSError *error))failure{
    UserModel *model = [UserUtils getUserInfo];
    if (!model.token){
        return;
    }
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,UserGetInfoByTokenUrl) params:nil viewcontrllerEmpty:vc  success:^(id response) {
        LFLog(@"获取最新用户信息：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([str isEqualToString:@"1"]) {
            if (response[@"data"]) {
                NSMutableDictionary *mdt = [model mj_keyValues];
                [mdt addEntriesFromDictionary:response[@"data"]];
                [UserUtils saveUserInfo:mdt];//保存用户数据
            }
        }else{
            if (vc) {
                [vc presentLoadingTips:response[@"msg"]];
            }
        }
        if (success) {
            success(response);
        }

    } failure:^(NSError *error) {
        if (vc) {
            [vc dismissTips];
            [vc presentLoadingTips:@"请求失败~"];
        }
        if (failure) {
            failure(error);
        }
        LFLog(@"error：%@",error);
    }];
}


#pragma mark 清除所有信息
-(void)removeAllUserInfo{
//    [UserDefault setObject:@"0" forKey:@"appisLogin"];
//    [UserDefault removeObjectForKey:USERInfoKey];
//    [UserDefault synchronize];
//    //    [self removeUserInfo];
//    //    [self removeWorkUserInfo];
//    //设置推送tag
//    __autoreleasing NSMutableSet *tags = [NSMutableSet set];
//    //    [self setTags:&tags addTag:@""];
//    //    __autoreleasing NSString *alias = [NSString stringWithFormat:@"%@",dict[@"session"][@"uid"]];//别名
//    [JPUSHService setTags:tags alias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
//    [MobClick profileSignOff];//友盟统计注销账号
    
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

#pragma mark  runtime跳转页面
-(UIViewController *)runtimePushviewController:(NSDictionary *)dict controller:(UIViewController *)vc{
    UIViewController *board  = nil;
    //    if ([keywords isEqualToString:@"runtime"]) {//runtime跳转
    // 类名
    NSString *class =[NSString stringWithFormat:@"%@", dict[@"class"]];
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
//#pragma mark - *************用户信息*************
//+(void)UploadDataUserInfo:(void (^)(id response))result error:(void (^)(NSError *error))failerror{
//    NSDictionary * session =[userDefaults objectForKey:@"session"];
//    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
//    if (session) {
//        [dt setObject:session forKey:@"session"];
//    }
//    
//    [LFLHttpTool post:NSStringWithFormat(EnergyBaseUrl,@"") params:dt success:^(id response) {
//        LFLog(@"用户信息：%@",response);
//        if (result) {
//            result(response);
//        }
//    } failure:^(NSError *error) {
//        if (failerror) {
//            failerror(error);
//        }
//    }];
//    
//}
+(void)ShowImageView:(NSArray <UIImageView  *>*)imageViewArr imageUrlArr:(NSArray *)imageUrlArr index:(NSInteger )index{
    NSMutableArray *modelArr = [NSMutableArray array];
    for (int i = 0; i < (imageViewArr.count ? imageViewArr.count : imageUrlArr.count); i ++) {
        YBImageBrowserModel *model = [YBImageBrowserModel new];
        if (imageUrlArr.count > i) model.url = [NSURL URLWithString:imageUrlArr[i]];
        if (imageViewArr.count > i) {
            model.sourceImageView = imageViewArr[i];
            model.image = imageViewArr[i].image;
        }
        [modelArr addObject:model];
    }
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataArray = modelArr;
    browser.currentIndex = index;
    //展示
    [browser show];
}
#pragma mark - *************消息跳转*************
+(void)MessagePushContriller:(UIViewController *)vc type:(NSString *)type ID:(NSString *)Id push_data:(NSString *)push_data{
    if (type.integerValue < 3) {//1后台推送,2系统消息,3作业,4成绩,5答疑,6请假申请,7补分申请
        WKViewViewController *bord = [[WKViewViewController alloc]init];
        bord.titleStr = @"详情";
        bord.urlStr = NSStringWithFormat(SERVER_IP,NSStringWithFormat(HtmlDetailUrl, push_data));
        [vc.navigationController pushViewController:bord animated:YES];
    }else{
        UserUtils *util = [[UserUtils alloc]init];
        NSDictionary *iosClass = @{};
        if (type.integerValue == 3) {//作业
            if ([UserUtils getUserRole] == UserStyleStudent) {
                iosClass = @{@"class":@"PunchOperationDetailViewController",@"property":@{@"ID":push_data}};
            }else if ([UserUtils getUserRole] == UserStyleInstructor){
                iosClass = @{@"class":@"LookOperationViewController",@"property":@{@"OperateID":push_data}};
            }
        }else if (type.integerValue == 4){//成绩
            if ([UserUtils getUserRole] == UserStyleStudent) {
                iosClass = @{@"class":@"GradesRankViewController",@"property":@{@"ID":push_data}};
            }else if ([UserUtils getUserRole] == UserStyleInstructor){
                iosClass = @{@"class":@"EditGradeViewController",@"property":@{@"ID":push_data ,@"typeStyle":@"3"}};
            }
   
        }else if (type.integerValue == 5){//答疑
            if ([UserUtils getUserRole] == UserStyleStudent) {
                iosClass = @{@"class":@"AnswerDetailViewController",@"property":@{@"ID":push_data}};
            }else if ([UserUtils getUserRole] == UserStyleInstructor){
            }
            
        }else if (type.integerValue == 6){//请假申请
            iosClass = @{@"class":@"LeaveResultViewController",@"property":@{@"ID":push_data}};
        }else if (type.integerValue == 7){//补分申请
            if ([UserUtils getUserRole] == UserStyleStudent) {
                
            }else if ([UserUtils getUserRole] == UserStyleInstructor){
                iosClass = @{@"class":@"SupplyFractionApprovalViewController",@"property":@{@"ID":push_data}};
            }
        }
        [util runtimePushviewController:iosClass controller:vc];
    }
}
@end
