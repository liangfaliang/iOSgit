//
//  ReviewTableViewCell.h
//  shop
//
//  Created by 梁法亮 on 16/7/28.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewModel.h"
typedef void(^praiseblock)(NSInteger str);
typedef void(^reviewblock)(NSInteger  str);
@interface ReviewTableViewCell : UITableViewCell
@property(nonatomic,assign)NSInteger index;
@property (retain, nonatomic) IBOutlet UIImageView *iconImage;
@property (retain, nonatomic) IBOutlet UILabel *nameLAbel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *praiseimage;
@property (retain, nonatomic) IBOutlet UILabel *praiseLabel;
@property (retain, nonatomic) IBOutlet UIImageView *reviewIamge;
@property (retain, nonatomic) IBOutlet UILabel *reviewLabel;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *contenH;

@property(nonatomic,strong)UIView *review;

@property(nonatomic,assign)CGFloat hh;

@property(nonatomic,strong)ReviewModel *model;

@property(nonatomic,copy)praiseblock praiseblock;
@property(nonatomic,copy)reviewblock reviewBlock;
@property(nonatomic,copy)reviewblock morebtnBlock;

-(void)setPraiseblock:(praiseblock)praiseblock;
-(void)setReviewBlock:(reviewblock)reviewBlock;
-(void)setMorebtnBlock:(reviewblock)morebtnBlock;
@end
