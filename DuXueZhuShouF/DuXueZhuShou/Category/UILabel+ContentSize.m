//
//  UILabel+ContentSize.m
//  jiaheyingyuan
//
//  Created by 超级中 on 15/11/1.
//  Copyright © 2015年 cn.yingyuan.www. All rights reserved.
//

#import "UILabel+ContentSize.h"
#import <objc/message.h>
@implementation UILabel (ContentSize)
+(void)load{
    
    //class_getMethodImplementation：获取方法的实现
    //class_getClassMethod：获取类方法
    //class_getInstanceMethod：获取对象方法
    //    class_getMethodImplementation(<#__unsafe_unretained Class cls#>, <#SEL name#>)
    //
    //    class_getInstanceMethod(<#__unsafe_unretained Class cls#>, <#SEL name#>)
    //
    /*
     参数1：获取哪个类
     参数2：获取方法编号
     
     */
//    Method imagenamed = class_getClassMethod([UIImage class], @selector(setText:));
//    
//    Method lflnamed = class_getClassMethod([UIImage class], @selector(LFl_setText:));
//    //交换方法的实现
//    method_exchangeImplementations(imagenamed, lflnamed);
}

+(void)LFl_setText:(NSString *)text{
    

    LFLog(@"runtime监听：%@",text);
//    objc_setAssociatedObject(self, @"text", text, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//-(NSString *)name{
//    
//    //获取关联的对象
//
//    return objc_getAssociatedObject(self, @"text");
//}

- (CGSize)contentSize {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    
    NSDictionary * attributes = @{NSFontAttributeName : self.font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize contentSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:attributes
                                                 context:nil].size;
    return contentSize;
}

-(void)NSParagraphStyleAttributeName:(CGFloat)Linespace{
    if (self.text || self.attributedText) {
        NSMutableAttributedString * attributedString1 = nil;
        if (self.attributedText) {
            attributedString1 = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        }else{
             attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.text];
        }
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:Linespace];
        paragraphStyle1.alignment = self.textAlignment;//设置对齐方式
        paragraphStyle1.lineBreakMode = self.lineBreakMode;
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.text length])];
        [self setAttributedText:attributedString1];
        //设置行间距后适配高度显示
//        [self sizeToFit];
    }

}
+(UILabel *)initialization:(CGRect)frame font:(UIFont *)font textcolor:(UIColor *)textcolor numberOfLines:(NSInteger)numberOflines textAlignment:(NSTextAlignment)textalignment{
    UILabel *lb = [[UILabel alloc]init];
    if (!CGRectEqualToRect(CGRectZero, frame)) {
        lb.frame = frame;
    }
    if (font ) {
        lb.font = font;
    }
    if (textcolor ) {
        lb.textColor = textcolor;
    }
    if (numberOflines >=0) {
        lb.numberOfLines = numberOflines;
    }
    if (textalignment ) {
        lb.textAlignment = textalignment;
    }
    return lb;
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copyText:));
}

- (void)attachTapHandler {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *g = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:g];
}

//  处理手势相应事件
- (void)handleTap:(UIGestureRecognizer *)g {
    [self becomeFirstResponder];
    
    UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyText:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:item]];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    
}

//  复制时执行的方法
- (void)copyText:(id)sender {
    //  通用的粘贴板
    UIPasteboard *pBoard = [UIPasteboard generalPasteboard];
    
    //  有些时候只想取UILabel的text中的一部分
    if (objc_getAssociatedObject(self, @"expectedText")) {
        pBoard.string = objc_getAssociatedObject(self, @"expectedText");
    } else {
        
        //  因为有时候 label 中设置的是attributedText
        //  而 UIPasteboard 的string只能接受 NSString 类型
        //  所以要做相应的判断
        if (self.text) {
            pBoard.string = self.text;
        } else {
            pBoard.string = self.attributedText.string;
        }
    }
}

- (BOOL)canBecomeFirstResponder {
    return [objc_getAssociatedObject(self, @selector(isCopyable)) boolValue];
}

- (void)setIsCopyable:(BOOL)number {
    objc_setAssociatedObject(self, @selector(isCopyable), [NSNumber numberWithBool:number], OBJC_ASSOCIATION_ASSIGN);
    [self attachTapHandler];
}

- (BOOL)isCopyable {
    return [objc_getAssociatedObject(self, @selector(isCopyable)) boolValue];
}

- (void)setLineBreakByTruncatingLastLineMiddle {
    
    if ( self.numberOfLines <= 0 ) {
        return;
    }
    NSArray *separatedLines = [self getSeparatedLinesArray];
    NSLog(@"separatedLines:%@",separatedLines);
    NSMutableString *limitedText = [NSMutableString string];
    if ( separatedLines.count >= self.numberOfLines ) {
        
        for (int i = 0 ; i < self.numberOfLines; i++) {
            if ( i == self.numberOfLines - 1) {
                UILabel *lastLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, MAXFLOAT)];
                lastLineLabel.font = self.font;
                lastLineLabel.text = separatedLines[self.numberOfLines - 1];
                
                NSArray *subSeparatedLines = [lastLineLabel getSeparatedLinesArray];
                NSString *lastLineText = [subSeparatedLines firstObject];
                NSInteger lastLineTextCount = lastLineText.length;
                [limitedText appendString:[NSString stringWithFormat:@"%@...",[lastLineText substringToIndex:lastLineTextCount]]];
            } else {
                [limitedText appendString:separatedLines[i]];
            }
        }

    } else {
        [limitedText appendString:self.text];
    }
    
    self.text = limitedText;
    
}

- (NSArray *)getSeparatedLinesArray {
    NSString *text = [self text];
    UIFont   *font = [self font];
    CGRect    rect = [self frame];
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines) {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}

@end
