//
//  progressView.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/1/4.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface progressView : UIView
@property(nonatomic,strong)UIView *colorView;
@property(nonatomic,strong)UILabel *leftLb;
@property(nonatomic,strong)UILabel *rightLb;
@property(nonatomic,assign)CGFloat scale;
@end
