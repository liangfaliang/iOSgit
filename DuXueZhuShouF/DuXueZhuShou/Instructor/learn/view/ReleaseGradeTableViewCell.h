//
//  ReleaseGradeTableViewCell.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/16.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReleaseGradeTableViewCell : UITableViewCell <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UILabel *numLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;
@end
