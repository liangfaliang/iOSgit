//
//  ArticleDetailTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/5/2.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"
#import "AritcleModel.h"
@interface ArticleDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconIm;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UIButton *reviewBtn;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIView *conView;
@property (weak, nonatomic) IBOutlet UIView *reView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet YYLabel *reviewYYlb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentviewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conviewbottom;
@property(nonatomic,strong)AritcleModel *armodel;
@property(nonatomic,copy)void(^likeblock)();
-(void)setLikeblock:(void (^)())likeblock;
@end
