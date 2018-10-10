//
//  PaymentListTableViewCell.h
//  PropertyApp
//
//  Created by admin on 2018/8/13.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayNewModel.h"
@interface PaymentListTableViewCell : UITableViewCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;

@property (weak, nonatomic) IBOutlet UILabel *lab5;
@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tf1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tf2Height;
@property (weak, nonatomic) IBOutlet UITextField *tf2;
@property (weak, nonatomic) IBOutlet UILabel *nameLb1;
@property (weak, nonatomic) IBOutlet UILabel *nameLb2;
@property (weak, nonatomic) IBOutlet UIView *vline1;
@property (weak, nonatomic) IBOutlet UIView *vlin2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailBtnHeight;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@property (retain, nonatomic) PayNewModel *model;
-(void)hideSubViews:(BOOL)isH;
@end
