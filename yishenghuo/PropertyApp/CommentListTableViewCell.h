//
//  CommentListTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2017/11/22.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XX_image.h"
#import "PBusyModel.h"
typedef void(^commentLikeblockClick)(UIButton *sender );
@interface CommentListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet XX_image *xx_imageview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLbHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLbLeft;

@property (weak, nonatomic) IBOutlet UIView *backImView;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property(nonatomic,copy) PBusyModel *pbmodel;
@property(nonatomic,copy)commentLikeblockClick likeblock;
-(void)setLikeblock:(commentLikeblockClick)likeblock;
-(void)setPbmodel:(PBusyModel *)pbmodel;
@end
