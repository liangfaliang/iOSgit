//
//  NSURLSessionWrapperOperation.h
//  博地商户端
//
//  Created by yabei on 16/7/6.
//  Copyright © 2016年 com.bodi.merchant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSessionWrapperOperation : NSOperation

+ (instancetype)operationWithURLSessionTask:(NSURLSessionTask*)task;

@end
