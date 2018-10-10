//
//  NSAttributedString+utils.h
//  test
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YYText.h"
@interface NSAttributedString (utils)
-(CGSize )selfadaption:(CGFloat )weith;
- (NSAttributedString *)addSeeMoreButton:(YYLabel *)label  more:(NSString *)more moreColor:(UIColor *)morecolor before:(NSString *)before tapAction:(void (^)(UIView *containerView,NSAttributedString *text,NSRange range, CGRect rect))tapAction;
@end
