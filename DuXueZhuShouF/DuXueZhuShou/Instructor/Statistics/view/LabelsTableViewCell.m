//
//  LabelsTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "LabelsTableViewCell.h"

@implementation LabelsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.space = 0;
    self.margin = UIEdgeInsetsMake(0, 15, 0, 15);
    self.textFont = [UIFont systemFontOfSize:15];
    self.textColor = JHmiddleColor;
}

-(void)setBackViewSubviews:(NSArray *)titleArr{
    CGFloat wid = self.margin.left + self.margin.right;
    for (int i = 0; i < titleArr.count; i ++) {
        UILabel *lb = [_backView viewWithTag:i + 10];
        if (!lb) {
            lb = [UILabel initialization:CGRectZero font:self.textFont textcolor:self.textColor numberOfLines:0 textAlignment:NSTextAlignmentCenter];
            lb.tag = i+ 10;
            [_backView addSubview:lb];
        }
        if ([titleArr[i] isKindOfClass:[NSString class]]) {
            lb.text = titleArr[i];
            if (self.menuArr.count > i) {
                lb.width_i = [self.menuArr[i] selfadapUifont:lb.font weith:30].width + 2;
            }else{
                lb.width_i = [lb.text selfadapUifont:lb.font weith:30].width + 2;
            }
            

        }else if ([titleArr[i] isKindOfClass:[NSAttributedString class]]){
            lb.attributedText = titleArr[i];
            if (self.menuArr.count > i) {
                lb.width_i = [self.menuArr[i] selfadaption:30].width + 2;
            }else{
                lb.width_i = [lb.attributedText selfadaption:30].width + 2;
            }
            
        }
//        [lb sizeToFit];
        wid += lb.width_i;

    }
    if (titleArr.count > 1) {
        self.space = (screenW - wid)/(titleArr.count );
    }
    [self backViewlayoutSubviews];
}
-(void)backViewlayoutSubviews{
//    int i = 0;
    CGFloat xx = self.margin.left;
    for (int i = 0; i < 20; i ++) {
        UIView *subview = [_backView viewWithTag:i + 10];
        if (subview) {
            subview.frame = CGRectMake(xx, self.margin.top, subview.width_i, self.height_i);
            subview.width_i += self.space;
            xx += subview.width_i ;
        }else{
            break;
        }
    }
//    for (UIView *subview in _backView.subviews) {
//        subview.frame = CGRectMake(xx, self.margin.top, subview.width_i, self.height_i);
//        subview.width_i += self.space;
//        xx += subview.width_i ;
//        i ++;
//    }
}
@end
