//
//  reviewDetailTableViewCell.m
//  shop
//
//  Created by 梁法亮 on 16/8/2.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "reviewDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "SDImageCache.h"
#import "NSString+selfSize.h"
@implementation reviewDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.review = [[UIView alloc]init];
    
    [self.contentView addSubview:self.review];
    self.praiseimage.userInteractionEnabled = YES;
    self.reviewimage.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(ReviewModel *)model{
    _model = model;
    UITapGestureRecognizer *praisetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(praiseclick:)];
    
    [self.praiseimage addGestureRecognizer:praisetap];
    
    UITapGestureRecognizer *reviewtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reviewclick:)];
    [self.reviewimage addGestureRecognizer:reviewtap];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholdertouxiang"]];
    self.nameLabel.text = model.username1;
    self.contentLabel.text = model.content;
    CGSize H = [model.content selfadap:13 weith:20];
    self.contenH.constant = H.height;
    self.timeLabel.text = model.add_time;
    self.praiseLabel.text = model.collect_count;
    self.reviewlabel.text = model.comment_count;
    self.praiseLabel.adjustsFontSizeToFitWidth = YES;
    self.reviewlabel.adjustsFontSizeToFitWidth = YES;
    if (![model.is_collect isEqualToString:@"0"]) {
        self.praiseimage.image = [UIImage imageNamed:@"dianzna123"];
    }else{
        
        self.praiseimage.image = [UIImage imageNamed:@"dianzanmoren"];
        
    }
    //注册通知
    [Notification removeObserver:self];
    [Notification addObserver:self selector:@selector(praisetest:)
                                                 name:model.id object:nil];
    
    if (model.comment.count > 0) {
        
        //        NSMutableAttributedString *hintString =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"购买价格：%@元",self.price]];
        //        NSLog(@"hintString:%@",hintString);
        //        NSString *str = [NSString stringWithFormat:@"%@",self.price];
        //        NSRange range =[[hintString string]rangeOfString:str];
        //        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        //        _pricelabel.attributedText = hintString;
        [self.review removeAllSubviews];
        UIView *vline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 1)];
        vline.backgroundColor = JHColor(200, 199, 204);
        [self.review addSubview:vline];
        CGFloat heigth = 0;
        for (int i = 0; i < model.comment.count  ; i++) {
            NSDictionary *dt = model.comment[i];
            
            NSString *str = [NSString stringWithFormat:@"%@：%@",dt[@"username1"],dt[@"content"]];
            CGSize size = [str selfadaption:13];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 + heigth, SCREEN.size.width - 20, size.height)];
            NSMutableAttributedString *hintString =[[NSMutableAttributedString alloc]initWithString:str];
            
            NSString *username = [NSString stringWithFormat:@"%@",dt[@"username1"]];
            NSRange range =[[hintString string]rangeOfString:username];
            [hintString addAttribute:NSForegroundColorAttributeName value:JHMaincolor range:range];
            [hintString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
            lab.attributedText = hintString;
            lab.font = [UIFont systemFontOfSize:12];
            lab.numberOfLines = 0;
            
            heigth += size.height +10;
            [self.review addSubview:lab];
            
        }
        

            
            self.review.frame = CGRectMake(0, H.height + 70, SCREEN.size.width, heigth + 10);

    }else{
        
        self.review.frame = CGRectZero;
        [self.review removeAllSubviews];
        //        [self.review removeFromSuperview];
    }
}

//点赞
-(void)praiseclick:(UITapGestureRecognizer *)tap{
    
    if (_praiseblock) {
//        NSInteger praise = [self.praiseLabel.text integerValue];
//        praise ++;
//        self.praiseLabel.text = [NSString stringWithFormat:@"%d",(int)praise];
//        self.praiseimage.image = [UIImage imageNamed:@"dianzna123"];
        _praiseblock(0);
    }
    
}
//评论
-(void)reviewclick:(UITapGestureRecognizer *)tap{
    
    if (_reviewBlock) {
        _reviewBlock(0);
    }
    
}

-(void)setPraiseblock:(morepraiseblock)praiseblock{

    _praiseblock =praiseblock;
}

-(void)setReviewBlock:(morereviewblock)reviewBlock{

    _reviewBlock = reviewBlock;

}
@end
