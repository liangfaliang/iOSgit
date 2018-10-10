//
//  NSAttributedString+utils.m
//  test
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 admin. All rights reserved.
//
static inline CGFLOAT_TYPE CGFloat_ceil(CGFLOAT_TYPE cgfloat) {
#if CGFLOAT_IS_DOUBLE
    return ceil(cgfloat);
#else
    return ceilf(cgfloat);
#endif
}
#import "NSAttributedString+utils.h"

@implementation NSAttributedString (utils)
-(CGSize )selfadaption:(CGFloat )weith{
//    NSMutableParagraphStyle * paragraphStyle1 = self.yy_attributes[NSParagraphStyleAttributeName];
//    return [self boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - weith, MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading context:nil].size;
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - weith, MAXFLOAT)];
    tempLabel.attributedText = self;
    tempLabel.numberOfLines = 0;
    [tempLabel sizeToFit];
    CGSize size = tempLabel.frame.size;
    size = CGSizeMake(CGFloat_ceil(size.width), CGFloat_ceil(size.height));
    return size;
    
}
- (NSAttributedString *)addSeeMoreButton:(YYLabel *)label  more:(NSString *)more moreColor:(UIColor *)morecolor before:(NSString *)before tapAction:(void (^)(UIView *containerView,NSAttributedString *text,NSRange range, CGRect rect))tapAction{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",before? before:@"",more ? more :@""]];
    if (tapAction) {
        YYTextHighlight *hi = [YYTextHighlight new];
        [hi setColor:self.yy_color ? self.yy_color :label.textColor];
        hi.tapAction = tapAction;
        [text yy_setTextHighlight:hi range:[text.string rangeOfString:more]];
    }
    
    [text yy_setColor: morecolor ? morecolor: [UIColor colorWithRed:0.000 green:0.449 blue:1.000 alpha:1.000] range:[text.string rangeOfString:more]];
    text.yy_font =self.yy_font ? self.yy_font :label.font;
    YYLabel *seeMore = [[YYLabel alloc]init];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:text.yy_font alignment:YYTextVerticalAlignmentCenter];
    label.truncationToken = truncationToken;
    return truncationToken;
}
@end
