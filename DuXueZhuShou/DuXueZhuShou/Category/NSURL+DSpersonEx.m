//
//  NSURL+DSpersonEx.m
//  FineexFQXD2.0
//
//  Created by Dwt on 2017/4/15.
//  Copyright © 2017年 FineEx. All rights reserved.
//

#import "NSURL+DSpersonEx.h"
#import <objc/runtime.h>



@implementation NSURL (DSpersonEx)

+ (void)load {
    Method one = class_getClassMethod(self, @selector(URLWithString:));
    Method two = class_getClassMethod(self, @selector(dsperson_URLWithString:));
    method_exchangeImplementations(one, two);
}

+ (id)dsperson_URLWithString:(id)URLString {
    URLString = lStringIsEmpty(URLString) ? @"": URLString;
    URLString = (NSString *)URLString;
    id result = [self dsperson_URLWithString:URLString];
    return result;
}
@end

