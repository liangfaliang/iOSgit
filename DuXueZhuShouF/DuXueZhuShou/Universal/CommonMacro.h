//
//  CommonMacro.h
//  SmarkPark
//
//  Created by Dwt on 2018/5/25.
//  Copyright © 2018年 PmMaster. All rights reserved.
//

#ifndef CommonMacro_h
#define CommonMacro_h


// ===================== 弱指针 =====================
#define WeakSelf(type) __weak typeof(type) weak##type = type
#define WEAKSELF typeof(self) __weak weakSelf = self
#define STRONGSELF typeof(self) __strong self = weakSelf;

// ===================== 链接字符串 ===================
#define ConnectString(str) [NSString stringWithFormat:@"%@", @#str]
#define NSStringWithFormat(a,b) [NSString stringWithFormat:@"%@%@",a,b]
// ===================== 系统相关 =====================
#define APP_DELEGATE() ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_IOS_7 (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) ? YES : NO)
#define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 7)
#define IsIOS8 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 8.0)
#define IsIOS9 (([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] >= 9.0) && [[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]<10.0)
#define IsIOS10 ([[[UIDevice currentDevice] systemVersion] compare:@"10" options:NSNumericSearch] != NSOrderedAscending)

// ==================== App Version ====================
#define AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define AppBuildVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
//手机序列号
#define Device_UUID [[UIDevice currentDevice].identifierForVendor UUIDString]
/** documentPath */
#define DocumentPath  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject
/** cachesPath */
#define CachesPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject]
/** librabyPath */
#define LibraryPath [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)lastObject]
/** tmpPath */
#define TmpPath NSTemporaryDirectory()
//当前版本
//该应用程序版本
#define versionKey  @"CFBundleVersion"
#define currentVerson [NSBundle mainBundle].infoDictionary[versionKey]

#define lastVersion [[NSUserDefaults standardUserDefaults] objectForKey:versionKey]
#define NSStringWithFormat(a,b) [NSString stringWithFormat:@"%@%@",a,b]
// ===================== 尺寸相关 =====================
#define SCREEN [[UIScreen mainScreen] bounds]
#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
#define KeyWindow [UIApplication sharedApplication].keyWindow
#define SYS_FONT(x) [UIFont systemFontOfSize:x]
#define SAFE_NAV_HEIGHT (screenH > 736 ? 88 : 64)
#define SAFE_BOTTOM_HEIGHT (screenH > 736 ? 83.0 : 49.0)
#define SYS_FONTBold(x) [UIFont fontWithName:@"Helvetica-Bold" size:x]


// ===================== 颜色相关 =====================
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//颜色
#define JHColoralpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define JHColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define JHRandomColor JHColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))
#define JHMaincolor JHColor(57, 149, 255)//主色 3995FF
#define JHAssistColor JHColor(254, 213, 33)//辅助色
#define JHAssistRedColor JHColor(255, 79, 0)//辅助色
#define JHshopMainColor JHColor(255, 79, 0)//商城主色
#define JHMedicalColor JHColor(168, 208, 83)//医疗主色//(94, 178, 48)
#define JHMedicalAssistColor JHColor(253, 161, 0)//医疗辅助色
#define JHBorderColor JHColor(229, 229, 229)
#define JHbgColor JHColor(240, 240, 240)

#define JHmiddleColor JHColor(102, 102, 102)
#define JHdeepColor JHColor(51, 51, 51)
#define JHsimpleColor JHColor(151, 151, 151)

// ===================== 懒加载 =====================
#define LazyLoadArray(obj)\
-(NSMutableArray *)obj{\
if (_##obj == nil) {\
_##obj = [[NSMutableArray alloc]init];\
}\
return _##obj;\
}

#define LazyLoadDict(obj)\
-(NSMutableDictionary *)obj{\
if (_##obj == nil) {\
_##obj = [[NSMutableDictionary alloc]init];\
}\
return _##obj;\
}

//占位图
#define PlaceholderImage [UIImage imageNamed:@"placeholderImage"]

//打印日志
#ifdef DEBUG
#define LFLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define LFLog(...)
#endif
//
#ifdef DEBUG
#define  NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#else
#define NSLog( ... )
#endif

#define lStringFor(str) [NSString stringWithFormat:@"%@",str]
#define lStringFormart(...) [NSString stringWithFormat:__VA_ARGS__]
#define DataKey(str) [NSString stringWithFormat:@"Key_%ld",(long)str]
#define DataPage(str) [NSString stringWithFormat:@"page_%ld",(long)str]
#define DataMore(str) [NSString stringWithFormat:@"more_%ld",(long)str]

//字符串是否为空
#define lStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define lArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define lDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

//偏好
#define UserDefault [NSUserDefaults standardUserDefaults]//沙盒
#define Notification [NSNotificationCenter defaultCenter]//通知
//网络监控问题
#define NetworkReachability @"NetworkReachability"
#define NetworkReachabilityUnknown @"NetworkReachabilityUnknown"
#define NetworkReachabilityNotReachable @"NetworkReachabilityNotReachable"
#define NetworkReachabilityWWAN @"NetworkReachabilityWWAN"
#define NetworkReachabilityWIFI @"NetworkReachabilityWIFI"
#define NetworkNotification @"NetworkNotification"

#define USERInfoKey @"USERInfoKey"
//保存位置信息
#define CityInfo @"CityInfo"
//录音文件地址
#define RecordAudioFile @"RRecord.wav"
#define RecordAudioFilePath [DocumentPath stringByAppendingString:[NSString stringWithFormat:@"/%@",RecordAudioFile]]

//分隔符
#define Separator @"@@"

//图片选择最大张数
#define selectPicMaxNum 3
#endif /* CommonMacro_h */
