//
//  GovernmentPostTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/11.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GovernmentModel.h"
typedef void(^LikeblockClick)(UIButton *sender );
@class GovernmentPostTableViewCell;
@protocol GovernmentPostDelegate <NSObject>
@optional
- (void)onPressImageView:(UIImageView *)imageView onDynamicCell:(GovernmentPostTableViewCell *)cell index:(NSInteger)index;

@end
@interface GovernmentPostTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIImageView *hotIm;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLbHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLbLeft;

@property (weak, nonatomic) IBOutlet UIView *backImView;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *reviewBtn;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;
@property(nonatomic,strong) GovernmentModel *GovernmentModel;
@property(nonatomic,weak)id<GovernmentPostDelegate> delegate;
@property(nonatomic,copy)LikeblockClick likeblock;
-(void)setLikeblock:(LikeblockClick)likeblock;
@end
