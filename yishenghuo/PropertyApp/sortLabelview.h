//
//  sortLabelview.h
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/19.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sortLabelviewDelegate <NSObject>

-(void)sortLabelviewSelectSort:(NSString *)sort isSelect:(BOOL)isSelect;
@optional
-(void)sortLabelviewMoreBtnClick:(UIButton *)btn;
@end

@interface sortLabelview : UIView
@property(nonatomic,strong)NSMutableArray *sortArray;
@property(nonatomic,strong)UIButton *moreBtn;
@property(nonatomic,assign)CGFloat Heigth;
@property(nonatomic,assign)CGFloat BtnHeight;//btn高度
@property(nonatomic,strong)UIColor *titleColor;//字体颜色
@property(nonatomic,strong)UIColor *titleSelctColor;//字体选中颜色
@property(nonatomic,strong)UIColor *btnBackColor;//btn背景色颜色
@property(nonatomic,strong)UIColor *btnBoderColor;//btn背景色颜色
@property(nonatomic,assign)CGFloat BtnCornerRadius;//btn圆角半径
@property(nonatomic,assign)BOOL isMoreBtn;
@property(nonatomic,assign)BOOL isBoder;
- (void)initWithsortArray:(NSMutableArray *)sortArray currentIndex:(NSInteger)index sortH:(CGFloat)sortH font:(CGFloat)font;
@property(weak,nonatomic) id <sortLabelviewDelegate>delegate;
@end
