//
//  D0BBsTableViewCell.h
//  shop
//
//  Created by 梁法亮 on 16/7/8.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D0BBBSmodel.h"
#import "CustomButton.h"
#import "CustomLabel.h"
#import "IndustryModel.h"
#import "GovernmentModel.h"
typedef void(^blockClick)(NSString *str ,NSInteger index);
typedef void(^imageblockClick)(NSInteger index);

@interface D0BBsTableViewCell : UITableViewCell

@property(nonatomic,strong) D0BBBSmodel *model;
@property(nonatomic,strong) IndustryModel *IndustryModel;
@property(nonatomic,strong) GovernmentModel *GovernmentModel;
@property (retain, nonatomic) IBOutlet UIImageView *icon;

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabe;
@property (retain, nonatomic) IBOutlet UILabel *timeLabe;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIImageView *praise;
@property (retain, nonatomic) IBOutlet UIImageView *comment;
@property (retain, nonatomic) IBOutlet UILabel *commentLabel;
@property (retain, nonatomic) IBOutlet UILabel *praiseLabel;
@property (retain, nonatomic) IBOutlet UIButton *typeButton;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *contentHeigth;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *hotHeigth;
@property (weak, nonatomic) IBOutlet UIView *imageBackview;
@property (weak, nonatomic) IBOutlet UIButton *image1;
@property (weak, nonatomic) IBOutlet UIButton *image2;

@property(nonatomic,assign)NSInteger index;


@property(nonatomic,copy)blockClick block;
@property(nonatomic,copy)imageblockClick imageblock;
@property(nonatomic,copy)blockClick priseBlock;
-(void)setPriseBlock:(blockClick)priseBlock;
-(void)setBlock:(blockClick)block;
-(void)setImageblock:(imageblockClick)imageblock;

@end
