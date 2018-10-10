

#import <Foundation/Foundation.h>

@interface NSString(YTString)

#pragma mark - 正则判断字符串是否是邮箱和手机号
//判断是否是邮箱
- (BOOL)isValidateID;

//判断是否是手机号
- (BOOL)isValidateMobile;

//- (BOOL)isValidUrl;

@end
