//
//  GovernmentCommentTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/11.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoReviewModel.h"
typedef void(^likeblockClick)(NSInteger index);
@interface GovernmentCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *lichBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLbHeight;
@property (weak, nonatomic) IBOutlet UIButton *ReplyNameBtn;
@property (weak, nonatomic) IBOutlet UILabel *ReplyContent;
@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLbBottom;
@property(nonatomic,copy)likeblockClick likeblock;
-(void)setLikeblock:(likeblockClick)likeblock;
@property(nonatomic,strong) GoReviewModel *model;
@end
