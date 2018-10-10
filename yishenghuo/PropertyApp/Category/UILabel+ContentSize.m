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
    if (self.text) {
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.text];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:Linespace];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self.text length])];
        [self setAttributedText:attributedString1];
        //设置行间距后适配高度显示
//        [self sizeToFit];
    }

}
+(UILabel *)initialization:(CGRect)frame font:(UIFont *)font textcolor:(UIColor *)textcolor numberOfLines:(NSInteger)numberOflines textAlignment:(NSTextAlignment)textalignment{
    UILabel *lb = [[UILabel alloc]init];
//    LFLog(@"NSStringFromCGRect:%@",NSStringFromCGRect(frame));
    if (!CGRectEqualToRect(CGRectZero, frame)) {
//        LFLog(@"frame:%@",NSStringFromCGRect(frame));
        lb.frame = frame;
    }
    if (font ) {
        lb.font = font;
    }
    if (textcolor ) {
        lb.textColor = textcolor;
    }
    if (numberOflines >= 0) {
        lb.numberOfLines = numberOflines;
    }
    if (textalignment ) {
        lb.textAlignment = textalignment;
    }
    return lb;
}
//-(void)setText:(NSString *)text{
//    
//    
//    if ([text isEqualToString: @"(null)"]) {
//        text = @"";
//    }
//    if (!text) {
//        text = @"";
//    }
//    LFLog(@"runtime监听：%@",text);
//    objc_setAssociatedObject(self, @"text", text, OBJC_ASSOCIATION_COPY_NONATOMIC);
//
//}
//-(NSString *)text{
//    
//    return objc_getAssociatedObject(self, @"text");
//}
@end
