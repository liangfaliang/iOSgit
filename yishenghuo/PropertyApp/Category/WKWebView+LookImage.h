//
//  WKWebView+LookImage.h
//  PropertyApp
//
//  Created by 梁法亮 on 17/3/13.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (LookImage)
-(NSArray *)getImageUrlByJS:(WKWebView *)wkWebView;
-(BOOL)showBigImage:(NSURLRequest *)request;
-(void)ImageAdaptiveIphone:(WKWebView *)wkWebView;//自适应图片
@end
