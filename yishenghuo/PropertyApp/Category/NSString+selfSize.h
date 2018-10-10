//
//  NSString+selfSize.h
//  shop
//
//  Created by 梁法亮 on 16/6/22.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (selfSize)
-(CGSize )selfadaption:(CGFloat )font;
-(CGSize )selfadap:(CGFloat )font weith:(CGFloat)weith;
-(CGSize )selfadap:(CGFloat )font weith:(CGFloat)weith Linespace:(CGFloat )Linespace;
//去除html标签
-(NSString *)filterHTML;
//判断特殊字符
-(BOOL)isIncludeSpecialCharact;
-(CGSize )selfadapUifont:(UIFont * )uifont weith:(CGFloat)weith;
-(NSMutableAttributedString *)AttributedString:(NSString *)attstring backColor:(UIColor *)backColor uicolor:(UIColor *)color uifont:(UIFont *)font;
-(NSMutableAttributedString *)AttributedString:(NSString *)attstring allcolor:(UIColor *)allcolor backColor:(UIColor *)backColor uicolor:(UIColor *)color uifont:(UIFont *)font;
//获取指定高度文字的range
- (NSRange)getTwoTextRangeWith:(UIFont *)font width:(CGFloat)width height:(CGFloat)height;
//判断字符串是否为url
- (BOOL)isValidUrl;
@end
