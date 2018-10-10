//
//  NSData+string.m
//  shop
//
//  Created by 梁法亮 on 16/8/25.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "NSData+string.h"

@implementation NSData (string)
//十六进制nsdata转nsstring
- (NSString *)convertDataToHexStr {
    if (!self || [self length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[self length]];
    
    [self enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}
@end
