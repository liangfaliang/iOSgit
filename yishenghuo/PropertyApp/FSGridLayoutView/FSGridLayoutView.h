//
//  FSGridLayoutView.h
//  GridLayoutDemo
//
//  Created by huim on 2017/6/9.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FSGridLayoutView;
@protocol FSGridLayoutViewDelegate <NSObject>
@optional
-(void)FSGridLayouClickCell:(FSGridLayoutView *)flview itemDt:(NSDictionary *)itemDt;
-(void)FSGridLayouClickCell:(NSDictionary *)itemDt;
@end

@interface FSGridLayoutView : UIView
@property (nonatomic, strong) id json;
@property (nonatomic, strong) NSDictionary *jsonDict;
@property(nonatomic,weak)id<FSGridLayoutViewDelegate> delegate;
+ (CGFloat)GridViewHeightWithJsonStr:(id)json;
@end
