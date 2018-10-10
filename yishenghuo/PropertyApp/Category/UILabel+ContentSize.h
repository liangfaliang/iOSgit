//
//  UILabel+ContentSize.h
//  jiaheyingyuan
//
//  Created by 超级中 on 15/11/1.
//  Copyright © 2015年 cn.yingyuan.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ContentSize)
+(UILabel *)initialization:(CGRect)frame font:(UIFont *)font textcolor:(UIColor *)textcolor numberOfLines:(NSInteger)numberOflines textAlignment:(NSTextAlignment)textalignment;
- (CGSize)contentSize;
-(void)NSParagraphStyleAttributeName:(CGFloat)Linespace;
@end
