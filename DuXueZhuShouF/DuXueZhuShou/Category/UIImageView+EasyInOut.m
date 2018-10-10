//
//  UIImageView+EasyInOut.m
//  WTImageEasyInOut
//
//  Created by Dwt on 2017/2/15.
//  Copyright © 2017年 Dwt. All rights reserved.
//

#import "UIImageView+EasyInOut.h"

#import "NSNull+Extension.h"
#import "NSURL+DSpersonEx.h"
#if __has_include(<UIImageView+WebCache.h>)
#import <UIImageView+WebCache.h>
#else
#import "UIImageView+WebCache.h"
#endif


@implementation UIImageView (EasyInOut)

- (void)wt_setImageWithURL:(NSString *)ImageURL placeholderImage:(UIImage *)placeholderImage completed:(void (^)(UIImage *))completed{
    
    __weak typeof(self)weakSelf = self;
    if (lStringIsEmpty(ImageURL) && ImageURL.length != 0) {
        return;
    } else {
        self.image = placeholderImage;
    }
    [self sd_setImageWithURL:[NSURL URLWithString:ImageURL] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image && cacheType == SDImageCacheTypeNone) {
            CATransition *animation = [CATransition animation];
            animation.duration = 0.3;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            [weakSelf.layer addAnimation:animation forKey:nil];
        }
        
        if (completed) {
            completed(image);
        }
    }];
}

- (void)wt_setImageWithCorner:(CGFloat)corner url:(NSString *)url placeholderImage:(UIImage *)placeholderImage completed:(void (^)(UIImage *))completed{
    
    __weak typeof(self)weakSelf = self;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:corner] addClip];
    [self wt_setImageWithURL:url placeholderImage:placeholderImage completed:^(UIImage *image) {
        [image drawInRect:weakSelf.bounds];
        weakSelf.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (completed) {
            completed(image);
        }
    }];
}

- (void)wt_setCircleImageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholderImage completed:(void (^)(UIImage *))completed{
    
    [self wt_setImageWithCorner:(self.bounds.size.height * 0.5) url:url placeholderImage:placeholderImage completed:completed];
}


@end
