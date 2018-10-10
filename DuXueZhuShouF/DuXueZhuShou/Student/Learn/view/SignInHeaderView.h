//
//  SignInHeaderView.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/1.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StuSignInModel.h"
@interface SignInHeaderView : UIView
+ (SignInHeaderView *)view;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
@property (weak, nonatomic) IBOutlet UIButton *descBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UIView *adressBackview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adressBackviewHeight;
@property (retain, nonatomic) StuSignInModel *model;
@end
