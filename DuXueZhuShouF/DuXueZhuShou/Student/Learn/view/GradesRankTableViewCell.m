//
//  GradesRankTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "GradesRankTableViewCell.h"

@implementation GradesRankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.temLb.layer.masksToBounds = YES;
}
-(void)setModel:(RankModel *)model{
    _model =model;
    if (model) {
        self.contentView.hidden = NO;
        NSArray *arr = @[lStringFor(model.name),lStringFor(model.campusName),lStringFor(model.className),lStringFor(model.rankName),lStringFor(model.score)];
        [self setlabels:arr];
        [self setLabelTextcolor:model.is_classmate ? JHMaincolor : nil];
    }else{
        self.contentView.hidden = YES;
    }
    if (model.isMy) {
        [self.rankBtn setImage:nil forState:UIControlStateNormal];
        [self.rankBtn setTitle:nil forState:UIControlStateNormal];
        self.label5.textColor = JHMaincolor;
        self.temLb.hidden = NO;
        self.temLb.text = model.rank;
        self.temLbWidth.constant = [self.temLb.text selfadap:15 weith:30].width + 15;
        self.temLb.layer.cornerRadius = self.temLbWidth.constant/2;
    }else{
        self.temLb.hidden = YES;
        if (model.rank.integerValue < 4) {
            [self.rankBtn setTitle:nil forState:UIControlStateNormal];
            [self.rankBtn setImage:[UIImage imageNamed:model.rank.integerValue == 1 ? @"jin" : (model.rank.integerValue == 2 ? @"yin": @"tong")] forState:UIControlStateNormal];
        }else{
            [self.rankBtn setImage:nil forState:UIControlStateNormal];
            [self.rankBtn setTitle:model.rank forState:UIControlStateNormal];
        }
    }

}

-(void)setLabelTextcolor:(UIColor *)color{
    if (color) {
        [self.rankBtn setTitleColor:color forState:UIControlStateNormal];
    }else{
        [self.rankBtn setTitleColor:JHmiddleColor forState:UIControlStateNormal];
    }
    for (int i = 0; i < 5; i ++) {
        NSString *labname = [NSString stringWithFormat:@"label%d",i+ 1];
        UILabel * lab = [self valueForKey:labname];
        if (color) {
            lab.textColor = color;
        }else{
            if ( i == 0 || i == 4) {
                lab.textColor = JHdeepColor;
            }else{
                lab.textColor = JHmiddleColor;
            }
        }
    }
}
-(void)setlabels:(NSArray *)titleArr{
    CGFloat width = 150;
    for (int i = 0; i < 5; i ++) {
        NSString *labname = [NSString stringWithFormat:@"label%d",i+ 1];
        UILabel * lab = [self valueForKey:labname];
        if (titleArr.count > i) {
            lab.text = titleArr[i];
            if (i > 0) {
                width += [lab.text selfadapUifont:lab.font weith:100].width;
            }
            
        }
    }
    CGFloat space = (screenW - width)/4 - 2;
    self.labSpace1.constant = space;
    self.labSpace2.constant = space;
    self.labSpace3.constant = space;
    self.labSpace4.constant = space;
}

@end
