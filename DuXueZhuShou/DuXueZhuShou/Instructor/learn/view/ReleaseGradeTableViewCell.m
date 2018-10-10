//
//  ReleaseGradeTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/16.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ReleaseGradeTableViewCell.h"

@implementation ReleaseGradeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.backView setViewBorderColor:JHBorderColor borderWidth:1];
    self.textview.delegate = self;
}

#pragma mark TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    CGFloat length = textView.text.length;
    if (length > 200) {//3行了  两行52 三行70
        while (length > 200) {
            textView.text = [textView.text substringToIndex:[textView.text length]-1];
            length = textView.text.length;
        }
    }
    self.numLb.text = [NSString stringWithFormat:@"%d/200",200 - (int)length];
}

@end
