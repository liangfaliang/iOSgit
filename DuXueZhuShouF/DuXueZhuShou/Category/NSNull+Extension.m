//
//  NSNull+Extension.m
//  FineexFQXD2.0
//
//  Created by Dwt on 2017/4/15.
//  Copyright © 2017年 Dwt. All rights reserved.
//

#import "NSNull+Extension.h"
#import <objc/runtime.h>
static const char *phTextView = "extentionLength";
@implementation NSNull (Extension)


+ (void)load {
    
}


- (void)setLength:(NSNumber *)length {
    objc_setAssociatedObject(self, phTextView, length, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)length {
    return objc_getAssociatedObject(self, phTextView);
}




@end
