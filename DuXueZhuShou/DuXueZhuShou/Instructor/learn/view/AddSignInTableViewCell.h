//
//  AddSignInTableViewCell.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/14.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendSubmitModel.h"
@interface AddSignInTableViewCell : UITableViewCell <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UILabel *numLb;
@property (weak, nonatomic) IBOutlet UIButton *fixedBtn;
@property (weak, nonatomic) IBOutlet UIButton *freeBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *tfBrfore;
@property (weak, nonatomic) IBOutlet UITextField *tfAfter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomviewHeight;
@property (copy,nonatomic) void (^btnclickBlock)(NSInteger idx);
@property(nonatomic, retain)AttendSubmitModel *model;
@end
