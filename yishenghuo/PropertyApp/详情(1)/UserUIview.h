//
//  UserUIview.h
//  shop
//
//  Created by 梁法亮 on 16/5/11.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D0BBBSmodel.h"
#import "IndustryModel.h"
#import "CustomButton.h"
#import "CustomLabel.h"
@interface UserUIview : UIView

typedef void(^iamageblockClick)(CustomButton * btn);
typedef void(^praiseblockClick)(NSString *str);
typedef void(^reviewblockClick)(NSString * str);
@property (retain, nonatomic) IBOutlet UIImageView *iconimage;
@property (retain, nonatomic) IBOutlet UILabel *namelabel;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *contenLabel;
@property (retain, nonatomic) IBOutlet UIImageView *praiseimage;
@property (retain, nonatomic) IBOutlet UILabel *praiseLabel;
@property (retain, nonatomic) IBOutlet UIImageView *reviewImage;
@property (retain, nonatomic) IBOutlet UILabel *reviewLabel;
@property(nonatomic,strong)UIView *imagebackview;
@property (retain, nonatomic) IBOutlet UILabel *timelabe;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *contentHeigth;
@property(nonatomic,strong) D0BBBSmodel *model;
@property(nonatomic,strong) IndustryModel *IndustryModel;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *timeH;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *titleHieght;
@property(nonatomic,copy)praiseblockClick praiseblock;
@property(nonatomic,copy)reviewblockClick reviewBlock;
@property(nonatomic,copy)iamageblockClick imageBlock;
-(void)setPraiseblock:(praiseblockClick)praiseblock;
-(void)setReviewBlock:(reviewblockClick)reviewBlock;
-(void)setImageBlock:(iamageblockClick)imageBlock;
@end
