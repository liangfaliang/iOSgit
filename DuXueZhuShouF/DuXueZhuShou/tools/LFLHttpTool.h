//
//  LFLHttpTool.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/6.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFLHttpTool : NSObject
@property (nonatomic, assign) BOOL isCancelRepeat;//  是否设置页面返回取消重复的网络请求 默认yes


+ (LFLHttpTool *)sharedLFLHttpTool;
//get
+(void)get:(NSString *)url params:(NSDictionary *)params viewcontrllerEmpty:(UIViewController *)vc success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;


//图片上传
+(void)post:(NSString *)url params:(NSDictionary *)params body:(id )body success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

//post
+(void)post:(NSString *)url params:(NSDictionary *)params viewcontrllerEmpty:(UIViewController *)vc success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

#pragma mark - 忽略请求

/** 忽略请求，当请求的url和参数都是一样的时候，在短时间内不发起再次请求， 默认3秒 */
- (BOOL)ignoreRequestWithUrl:(NSString *)url params:(NSDictionary *)params;

/** 忽略请求，当请求的url和参数都是一样的时候，在短时间内不发起再次请求 */
- (BOOL)ignoreRequestWithUrl:(NSString *)url params:(NSDictionary *)params timeInterval:(NSTimeInterval)timeInterval;
/** 移除请求*/
- (void)removeRequestWithUrl:(NSString *)url params:(NSDictionary *)params;

#pragma mark - 取消之前的请求

/** 取消之前的同一个url的网络请求
 *  在failure分支中，判断如果是取消操作，那么不做任何处理
 *  在success和failure分支中，都要调用clearTaskSessionWithUrl:方法，进行内存释放
 */
- (void)cancelLastTaskSessionWithUrl:(NSString *)url currentTaskSession:(NSURLSessionTask *)task;

/** 清除url绑定的sessionTask */
- (void)clearTaskSessionWithUrl:(NSString *)url;

@end
