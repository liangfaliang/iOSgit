//
//  reviewDetailTableViewCell.h
//  shop
//
//  Created by 梁法亮 on 16/8/2.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewModel.h"
typedef void(^morepraiseblock)(NSInteger str);
typedef void(^morereviewblock)(NSInteger  str);
@interface reviewDetailTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *iconImage;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;

@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *praiseimage;
@property (retain, nonatomic) IBOutlet UILabel *praiseLabel;
@property (retain, nonatomic) IBOutlet UIImageView *reviewimage;
@property (retain, nonatomic) IBOutlet UILabel *reviewlabel;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *contenH;

@property(nonatomic,strong)UIView *review;
@property(nonatomic,strong)ReviewModel *model;

@property(nonatomic,copy)morepraiseblock praiseblock;
@property(nonatomic,copy)morereviewblock reviewBlock;

-(void)setPraiseblock:(morepraiseblock)praiseblock;
-(void)setReviewBlock:(morereviewblock)reviewBlock;
@end
