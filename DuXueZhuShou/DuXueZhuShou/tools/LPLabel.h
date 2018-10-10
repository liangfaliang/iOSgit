//
//  LPLabel.h
//  label上画横线
//
//  Created by Li Pan on 14-6-30.
//  Copyright (c) 2014年 Pan Li. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, strikeThroughPosition) {
    strikeThroughCenter = 0,                  // 居中
    strikeThroughBottom = 1,        // 下
};
@interface LPLabel : UILabel

@property (assign, nonatomic) BOOL strikeThroughEnabled; // 是否画线

@property (strong, nonatomic) UIColor *strikeThroughColor; // 画线颜色
@property (nonatomic, assign) strikeThroughPosition strikePosition;//默认居中
@end
