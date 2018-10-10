//
//  GovernmentCommentTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/11.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "GovernmentCommentTableViewCell.h"

@implementation GovernmentCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImage.layer.cornerRadius = 20;
    self.iconImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)setModel:(GoReviewModel *)model{

    _model = model;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.headimage] placeholderImage:[UIImage imageNamed:@"yezhumorentouxiang"]];
    self.nameLabel.text = model.user_name;
    self.timeLabel.text = model.add_time;
    if ([model.is_agree isEqualToString:@"1"]) {
        [self.lichBtn setImage:[UIImage imageNamed:@"dianzanhongse"] forState:UIControlStateNormal];
    }else{
        [self.lichBtn setImage:[UIImage imageNamed:@"dianzanmoren"] forState:UIControlStateNormal];
    }
    [self.lichBtn setTitle:[NSString stringWithFormat:@" %@",model.agree_count] forState:UIControlStateNormal];
    self.contentLb.text = model.comment_content;
    CGSize content = [model.comment_content selfadap:14 weith:60];
    self.contentLbHeight.constant = content.height +15;
    if (model.parent_info.count) {
        self.replyView.hidden = NO;
        [self.ReplyNameBtn setTitle:model.parent_info[@"user_name"] forState:UIControlStateNormal];
        self.ReplyContent.text = model.parent_info[@"comment_content"];
        CGSize replysize = [self.ReplyContent.text selfadap:14 weith:70];
        self.replyViewHeight.constant = replysize.height + 50 ;
    }else{
        self.contentLbBottom.constant = 10;
        self.replyView.hidden = YES;
    }
}
- (IBAction)likeClick:(id)sender {
    if (_likeblock) {
        _likeblock(0);
    }
    
}

-(void)setLikeblock:(likeblockClick)likeblock
{
    _likeblock = likeblock;
}

@end
