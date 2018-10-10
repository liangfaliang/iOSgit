//
//  SignInTableViewCell.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/1.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StuSignInModel.h"
@interface SignInTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *adressLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureHeight;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UIView *vlineTop;
@property (weak, nonatomic) IBOutlet UIView *vlineBottom;
@property (retain, nonatomic)  SignModel *model;

@end
