//
//  NSString+selfSize.m
//  shop
//
//  Created by 梁法亮 on 16/6/22.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "NSString+selfSize.h"
#import <CoreText/CoreText.h>
@implementation NSString (selfSize)

//自适应文字的size
-(CGSize )selfadaption:(CGFloat )font{
    
    UIFont *fontsize = [UIFont systemFontOfSize:font];
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:fontsize, NSFontAttributeName,nil];
    CGSize size = [self boundingRectWithSize:(CGSize){screenW - 40, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    return size;
    
}

-(CGSize )selfadap:(CGFloat )font weith:(CGFloat)weith{
    
    UIFont *fontsize = [UIFont systemFontOfSize:font];
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:fontsize, NSFontAttributeName,nil];
    CGSize size = [self boundingRectWithSize:(CGSize){screenW - weith, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    return size;
    
}
-(CGSize )selfadapUifont:(UIFont * )uifont weith:(CGFloat)weith{

    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:uifont, NSFontAttributeName,nil];
    CGSize size = [self boundingRectWithSize:(CGSize){screenW - weith, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    return size;
    
}

-(CGSize )selfadap:(CGFloat )font weith:(CGFloat)weith Linespace:(CGFloat )Linespace{
    
    UIFont *fontsize = [UIFont systemFontOfSize:font];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:Linespace];
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:fontsize, NSFontAttributeName,paragraphStyle1,NSParagraphStyleAttributeName,nil];
    CGSize size = [self boundingRectWithSize:(CGSize){screenW - weith, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    return size;
    
}
-(NSString *)filterHTML
{
    NSScanner * scanner = [NSScanner scannerWithString:self];
    NSString * text = nil;
    NSString *str = self;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        
        str = [str stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<P>" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"</P>" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"<BR>" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    return str;
}
//判断特殊字符
-(BOOL)isIncludeSpecialCharact{
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [self rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;//包含有特殊字符
}

-(NSMutableAttributedString *)AttributedString:(NSString *)attstring allcolor:(UIColor *)allcolor backColor:(UIColor *)backColor uicolor:(UIColor *)color uifont:(UIFont *)font{
    NSMutableAttributedString* htinstr = [[NSMutableAttributedString alloc]initWithString:self];
    NSString *str = attstring;
    NSRange range =[[htinstr string]rangeOfString:str];
    
    [htinstr addAttribute:NSForegroundColorAttributeName value:JHsimpleColor range:NSMakeRange(0, htinstr.length)];
    if (backColor) {
        [htinstr addAttribute:NSBackgroundColorAttributeName value:backColor range:range];
    }
    if (color) {
        [htinstr addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    if (font) {
        [htinstr addAttribute:NSFontAttributeName value:font range:range];
    }
    return htinstr;
    
}
-(NSMutableAttributedString *)AttributedString:(NSString *)attstring backColor:(UIColor *)backColor uicolor:(UIColor *)color uifont:(UIFont *)font {
    if (self && self.length && attstring) {
        NSMutableAttributedString* htinstr = [[NSMutableAttributedString alloc]initWithString:self];
        if (htinstr != nil) {
            NSString *str = attstring;
            NSRange range =[[htinstr string]rangeOfString:str];
            if (backColor) {
                [htinstr addAttribute:NSBackgroundColorAttributeName value:backColor range:range];
            }
            if (color) {
                [htinstr addAttribute:NSForegroundColorAttributeName value:color range:range];
            }
            if (font) {
                [htinstr addAttribute:NSFontAttributeName value:font range:range];
            }
            
//            [htinstr enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, htinstr.length) options:1 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
//                if ([value isKindOfClass:[UIFont class]]) {
//                    UIFont *ft = [UIFont systemFontOfSize:((UIFont *)value).pointSize -5];
//                    [htinstr addAttribute:NSFontAttributeName value:ft range:range];
//                }
//
//            }];
        
            
            return htinstr;
        }

    }
    return nil;

}
- (NSRange)getTwoTextRangeWith:(UIFont *)font width:(CGFloat)width height:(CGFloat)height{
    if (self.length) {
        NSMutableDictionary * attributes = [NSMutableDictionary dictionaryWithCapacity:5];
        [attributes setValue:font forKey:NSFontAttributeName];
        NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:self attributes:attributes];
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attributedString);
        UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - width, height)];
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), bezierPath.CGPath, NULL);
        CFRange range = CTFrameGetVisibleStringRange(frame);
        CFRelease(frame);
        CFRelease(framesetter);
        NSRange rg = NSMakeRange(range.location, range.length);
        return rg;
    }
    return NSMakeRange(0, 0);
}
//判断字符串是否为url
- (BOOL)isValidUrl
{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}
-(NSString *)SeparatorStr:(NSString *)str {
    if (str && str.length) {
        return [NSString stringWithFormat:@"%@%@%@",str,Separator,self];
    }else{
        return self;
    }
}
-(NSString *)getSecondFormUrl{
    NSRange range = [self rangeOfString:@"(?<=\\_).*?(?=\\.)" options:NSRegularExpressionSearch];
    NSLog(@"%@", [self substringWithRange:range]);
    return [self substringWithRange:range];
}
@end
