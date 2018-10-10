//
//  GovernmentView.h
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/11.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GovernmentModel.h"
typedef void(^imageblockClick)(NSInteger index);
typedef void(^likeblockClick)(NSInteger index);
@interface GovernmentView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UIView *backImview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property(nonatomic,strong) GovernmentModel *GovernmentModel;
@property(nonatomic,copy)imageblockClick imblock;
@property(nonatomic,copy)likeblockClick likeblock;
-(void)setLikeblock:(likeblockClick)likeblock;
-(void)setImblock:(imageblockClick)imblock;
@end
