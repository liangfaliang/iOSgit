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
}

-(void)setlabels:(NSArray *)titleArr{
    CGFloat width = 30;
    for (int i = 0; i < 4; i ++) {
        NSString *labname = [NSString stringWithFormat:@"label%d",i+ 2];
        UILabel * lab = [self valueForKey:labname];
        if (titleArr.count > i) {
            lab.text = titleArr[i];
            width += [lab.text selfadapUifont:lab.font weith:100].width;
            
        }
    }
    CGFloat space = (screenW - width)/3 - 2;
    self.labSpace1.constant = space;
    self.labSpace2.constant = space;
    self.labSpace3.constant = space;
    self.labSpace4.constant = space;
}

@end
