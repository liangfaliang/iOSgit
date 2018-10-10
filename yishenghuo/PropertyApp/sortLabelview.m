//
//  sortLabelview.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/19.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "sortLabelview.h"
@interface sortLabelview (){
    NSInteger _index;
    CGFloat _sortH;
    CGFloat _font;
    int row;
}

@end
@implementation sortLabelview

-(instancetype)init{

    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}
-(void)initialization{
    self.BtnHeight = 24;
    self.isMoreBtn = YES;
    self.titleColor = JHmiddleColor;
    self.titleSelctColor = JHmiddleColor;
    self.isBoder = YES;
    self.BtnCornerRadius = 12;
    self.btnBoderColor = JHshopMainColor;
}
-(NSMutableArray *)sortArray{

    if (_sortArray == nil) {
        _sortArray = [[NSMutableArray alloc]init];
    }
    return _sortArray;
}
- (void)initWithsortArray:(NSMutableArray *)sortArray currentIndex:(NSInteger)index sortH:(CGFloat)sortH font:(CGFloat)font {
    LFLog(@"sortArray:%@",sortArray);
    self.layer.masksToBounds = YES;
    self.sortArray = sortArray;
    _index = index;
    _sortH = sortH;
    _font = font;
    self.backgroundColor =JHbgColor;
    if (sortArray.count) {
        [self createAllbtn];
    }else{
        [self removeAllSubviews];
        _Heigth = 0;
        self.height = 0;
    }
    

}
-(void)createAllbtn{

    CGFloat wieth = 0;
    CGFloat heigth = 10;
    _Heigth = 10;
    CGFloat totalwieth = 10;
    int count = 0;
    row = 0;
//    [self removeAllSubviews];
    for (UIButton *subview in self.subviews) {
        if (subview != self.moreBtn) {
            [subview removeFromSuperview];
        }
    }
    for (int i = 0; i < _sortArray.count; i++) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
        NSString *str =_sortArray[i];
        
        [button setTitle:str forState:UIControlStateNormal];
        CGSize size = [str selfadap:_font weith:20];
        button.titleLabel.font = [UIFont systemFontOfSize:_font];
        button.frame = CGRectMake(10 + count* 10 + wieth, heigth, size.width + 15, self.BtnHeight);
        NSString *str1 = [[NSString alloc]init];

        if (i < _sortArray.count-1) {
            
            str1 = _sortArray[i + 1];
        }
        
        CGSize size1 = [str1 selfadap:_font weith:20];
        CGFloat space = 0;
        if (self.isMoreBtn) {//是否显示更多
            if (row == 1) {
                if (self.moreBtn == nil) {
                    self.moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 50, heigth, 40, 25)];
                    [self.moreBtn setImage:[UIImage imageNamed:@"gengduo_shaixuan"] forState:UIControlStateNormal];
                    [self.moreBtn setImage:[UIImage imageNamed:@"shouqi"] forState:UIControlStateSelected];
                    [self.moreBtn addTarget:self action:@selector(morebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    self.moreBtn.selected = NO;
                    //                self.moreBtn.backgroundColor = [UIColor redColor];
                    self.moreBtn.hidden = YES;
                    [self addSubview:self.moreBtn];
                    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.offset(-10);
                        make.bottom.equalTo(self.mas_bottom).offset(-_sortH + 25);
                    }];
                }
                if (!self.moreBtn.selected) {
                    space = 50;
                }
            }
            if (self.moreBtn && self.moreBtn.selected) {
                if (i == _sortArray.count-2) {
                    space = 50;
                }
                
            }
        }
        if (totalwieth + size1.width +  (size1.width > 0 ? 15:0) + 20  + size.width + 15< self.frame.size.width -20 - space) {
            
            wieth  += size.width + 15;
            count ++;
        }else{
            row ++;
            heigth += _sortH;
            totalwieth = 10;
            wieth = 0;
            count = 0;
        }
        if (_index == i) {
            button.selected = YES;
            button.layer.borderColor = [self.btnBoderColor CGColor];
        }else{
            button.selected = NO;
            button.layer.borderColor = [JHBorderColor CGColor];
        }
        if (self.isBoder) {
            button.layer.borderWidth = 1;
        }else{
            button.layer.borderWidth = 0;
        }
        
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = self.BtnCornerRadius;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.titleSelctColor forState:UIControlStateSelected];
        [self addSubview:button];
        totalwieth =  count* 10 + wieth;
    }
    _Heigth = heigth +_sortH;
    [self layoutSubviews];

}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.isMoreBtn) {
        if (row > 0) {
            self.moreBtn.hidden = NO;
            if (self.moreBtn.selected) {
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, _Heigth);
            }else{
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, 10 + _sortH *2);
            }
        }else{
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, _Heigth);
            
        }
    }else{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, _Heigth);
    
    }
    

}
-(void)morebuttonClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    [self createAllbtn];
    [self layoutSubviews];
    if ([self.delegate respondsToSelector:@selector(sortLabelviewMoreBtnClick:)]) {
        [self.delegate sortLabelviewMoreBtnClick:btn];
    }
//    [self createAllbtn];
    
}
-(void)buttonClick:(UIButton *)btn{

    if (btn.selected) {
        btn.layer.borderColor = [JHColor(240, 240, 240) CGColor];
        btn.selected = NO;
        _index = 0;
        [self createAllbtn];
        if ([self.delegate respondsToSelector:@selector(sortLabelviewSelectSort:isSelect:)]) {
            [self.delegate sortLabelviewSelectSort:_sortArray[0] isSelect:YES];
        }
    }else{
        [_sortArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([btn.titleLabel.text isEqualToString:obj]) {
                _index = idx;
            }
        }];
        btn.selected = YES;
        btn.layer.borderColor = [self.btnBoderColor CGColor];
        for (UIButton *subview in self.subviews) {
            if (subview != self.moreBtn) {
                if (subview != btn) {
                    subview.layer.borderColor = [JHBorderColor CGColor];
                    subview.selected = NO;
                }
            }
        }
        if ([self.delegate respondsToSelector:@selector(sortLabelviewSelectSort:isSelect:)]) {
            [self.delegate sortLabelviewSelectSort:btn.titleLabel.text isSelect:btn.selected];
        }

    }




}
@end
