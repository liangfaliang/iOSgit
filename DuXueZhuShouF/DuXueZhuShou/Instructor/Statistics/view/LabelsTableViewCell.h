//
//  LabelsTableViewCell.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (assign,nonatomic) CGFloat space;
@property (assign,nonatomic) UIEdgeInsets margin;
@property (strong,nonatomic) UIColor *textColor;
@property (strong,nonatomic) UIFont *textFont;
@property (strong,nonatomic) NSArray *menuArr;
-(void)setBackViewSubviews:(NSArray *)titleArr;
@end
