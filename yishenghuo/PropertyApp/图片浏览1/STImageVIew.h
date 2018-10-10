//
//  PayViewController.h
//  shop
//
//  Created by FGH on 16/4/13.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBCycleView.h"
@protocol STImageViewDelegate;
@interface STImageVIew : UIImageView
@property (nonatomic, weak)id<STImageViewDelegate>delegate;
@property (nonatomic,strong)TBCycleView *cycleView;
- (void)resetView;
-(void)setScaleImgV;
@end
@protocol STImageViewDelegate <NSObject>

- (void)stImageVIewSingleClick:(STImageVIew *)imageView;
-(void)instend;
@end
