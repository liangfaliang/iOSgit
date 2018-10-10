//
//  LFLHttpTool.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/6.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+hash.h"
@interface LFLHttpTool : NSObject

//get
+(void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;


//图片上传
+(void)post:(NSString *)url params:(NSDictionary *)params body:(id )body success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

//post
+(void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

//返回数据类型未知
+(void)testGet:(NSString *)url params:(NSMutableDictionary *)params success:(void (^)(id response))success failure:(void (^)(NSError *errorerror))failure;


+(void)get:(NSString *)url params:(NSDictionary *)params viewcontrllerEmpty:(UIViewController *)vc success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

//post
+(void)post:(NSString *)url params:(NSDictionary *)params viewcontrllerEmpty:(UIViewController *)vc success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

@end
