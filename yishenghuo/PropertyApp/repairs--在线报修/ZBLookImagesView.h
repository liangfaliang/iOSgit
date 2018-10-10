//
//  ZBLookImagesView.h
//  XZBTest
//
//  Created by 肖志斌 on 16/4/20.
//  Copyright © 2016年 xzb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBLookImagesView : UIView


- (instancetype)initWithSupView:(UIView *)supView;
+ (instancetype)initWithSupView:(UIView *)supView;

- (void)sShow:(NSInteger )page;
- (void)sHiden;
/**
 *  传入img
 *
 *  @param dataArray 编辑的imgs
 */
- (void)sImageArray:(NSMutableArray *)dataArray;

@end
