//
//  SelectorCustomView.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/24.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "SelectorCustomView.h"
#import "IndexBtn.h"
@interface SelectorCustomView (){
    NSInteger _index;
    UIColor  *_lineColor;
    UIColor  *_selectColor;
    UIColor  *_Color;
    CGFloat _font;
    UIView  *_vline;
    int row;
    NSMutableArray  *_btnArray;
}

@end
@implementation SelectorCustomView
//-(NSMutableArray *)subArray{
//
//    if (_subArray == nil) {
//        _subArray = [[NSMutableArray alloc]init];
//    }
//    return _subArray;
//}
- (void)initWithsubArray:(NSArray *)subArray currentIndex:(NSInteger)index lineColor:(UIColor  *)lineColor font:(CGFloat)font selectColor:(UIColor  *)selectColor Color:(UIColor  *)Color {
    self.layer.masksToBounds = YES;
    self.subArray = subArray;
    if (index) {
        _index = index;
    }else{
        _index = 0;
    }
    if (lineColor) {
        _lineColor = lineColor;
    }else{
        _lineColor = [UIColor blackColor];
    }
    
    if (Color) {
        _Color = Color;
    }else{
        _Color = JHdeepColor;
    }
    if (selectColor) {
        _selectColor = selectColor;
    }else{
        _selectColor = _Color;
    }
    if (font) {
        _font = font;
    }else{
        _font = 15;
    }
    
    [self CreateSubViews];
    
}
-(void)CreateSubViews{
    _btnArray = [NSMutableArray array];
    if (self.subArray.count) {
        CGFloat wid = self.bounds.size.width / self.subArray.count;
        for (int i = 0; i < self.subArray.count; i ++) {
            IndexBtn *subBtn = [[IndexBtn alloc]initWithFrame:CGRectMake(i * wid, 0, wid, self.bounds.size.height - 2)];
            subBtn.index = i;
            [subBtn addTarget:self action:@selector(subBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [subBtn setTitle:self.subArray[i] forState:UIControlStateNormal];
            [subBtn setTitleColor:_Color forState:UIControlStateNormal];
            [subBtn setTitleColor:_selectColor forState:UIControlStateSelected];
            subBtn.titleLabel.font = [UIFont systemFontOfSize:_font];
            [self addSubview:subBtn];
            if (i == _index) {
                subBtn.selected = YES;
                self.SelectBtn = subBtn;
            }
            
            //            [vline mas_makeConstraints:^(MASConstraintMaker *make) {
            //                make.bottom.offset(0);
            //                make.height.offset(2);
            //                make.centerX.equalTo(subBtn.mas_centerX);
            //                make.width.offset([subBtn.titleLabel.text selfadap:_font weith:20].width + 5);
            //            }];
            [_btnArray addObject:subBtn];
            
        }
        NSString *str = self.subArray[0];
        
        _vline  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [str selfadap:_font weith:20].width + 10, 2)];
        _vline.center = CGPointMake(wid/2 * (_index + 1), self.bounds.size.height - 1);
        _vline.backgroundColor = _lineColor;
        
        [self addSubview:_vline];
        
    }
    
}

-(void)subBtnClick:(IndexBtn *)btn{
    self.SelectBtn.selected = NO;
    btn.selected = YES;
    self.SelectBtn = btn;
    
    _vline.width = [btn.titleLabel.text selfadap:_font weith:20].width + 10;
    _vline.center = CGPointMake(btn.centerX, self.bounds.size.height - 1);
    _selectIndex = btn.index ;
    LFLog(@"btn.titleLabel.text:%@  _selectIndex:%ld",btn.titleLabel.text,(long)_selectIndex);
    if ([self.delegate respondsToSelector:@selector(SelectorCustomViewSelectBtnClick:titleName:)]) {
        [self.delegate SelectorCustomViewSelectBtnClick:self.selectIndex titleName:btn.titleLabel.text];
    }
    
}
-(void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    if (_selectIndex < _btnArray.count) {
        for (int i = 0; i < _btnArray.count; i++) {
            if (_selectIndex == i) {
                IndexBtn *btn = _btnArray[i];
                [self subBtnClick:btn];
            }
            
        }
    }
    
}

@end

