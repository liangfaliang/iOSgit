//
//  GoodsReviewTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/10/20.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^imageBlock) (NSInteger index);
@interface GoodsReviewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UILabel *BusinessLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyTimeLb;

@property (weak, nonatomic) IBOutlet UILabel *replycount;
@property (weak, nonatomic) IBOutlet UIImageView *replyImage;

@property (weak, nonatomic) IBOutlet UIButton *likeView;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;

@property (weak, nonatomic) IBOutlet UIView *imageBackview;

@property (weak, nonatomic) IBOutlet UIButton *image1;
@property (weak, nonatomic) IBOutlet UIButton *image2;
@property (weak, nonatomic) IBOutlet UIButton *image3;
@property (weak, nonatomic) IBOutlet UIButton *image4;


@property (weak, nonatomic) IBOutlet UIView *xxBackview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xxbackWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xxbackHeight;//星星高度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeigth;//图片高度


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *businessHeight;
@property(nonatomic,copy)imageBlock block;
@property(nonatomic,copy)void(^likeBlock)();
-(void)setBlock:(imageBlock)block;
@end
