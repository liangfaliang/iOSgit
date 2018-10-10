//
//  SelectorCustomView.h
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/24.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectorCustomViewDelegate <NSObject>

-(void)SelectorCustomViewSelectBtnClick:(CGFloat )index titleName:(NSString *)titleName;
@end
@interface SelectorCustomView : UIView
@property(nonatomic,strong)NSArray *subArray;
@property(nonatomic,strong)UIButton *SelectBtn;
@property(nonatomic,assign)NSInteger selectIndex;
@property(weak,nonatomic) id <SelectorCustomViewDelegate>delegate;
- (void)initWithsubArray:(NSArray *)subArray currentIndex:(NSInteger)index lineColor:(UIColor  *)lineColor font:(CGFloat)font selectColor:(UIColor  *)selectColor Color:(UIColor  *)Color;
@end
