//
//  GovernmentPostTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/11.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "GovernmentPostTableViewCell.h"

@implementation GovernmentPostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImage.layer.cornerRadius = 20;
    self.iconImage.layer.masksToBounds = YES;
     [self.likeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.reviewBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.categoryBtn setTitleColor:JHmiddleColor forState:UIControlStateNormal];
    self.likeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

-(void)setGovernmentModel:(GovernmentModel *)GovernmentModel{

    _GovernmentModel = GovernmentModel;
    self.nameLabel.text = GovernmentModel.user_name;
    self.timeLabel.text = GovernmentModel.add_time;
    self.contentLb.text = GovernmentModel.content;
   [self.iconImage sd_setImageWithURL:[NSURL URLWithString:GovernmentModel.headimage] placeholderImage:[UIImage imageNamed:@"yezhumorentouxiang"]];
    //GovernmentModel.agree_count
    if ([GovernmentModel.is_agree isEqualToString:@"1"]) {
        [self.likeBtn setImage:[UIImage imageNamed:@"dianzanhongse"] forState:UIControlStateNormal];
    }else{
        [self.likeBtn setImage:[UIImage imageNamed:@"dianzanmoren"] forState:UIControlStateNormal];
    }
    [self.likeBtn setTitle:GovernmentModel.agree_count forState:UIControlStateNormal];
    [self.reviewBtn setTitle:GovernmentModel.comment forState:UIControlStateNormal];
//    [self.categoryBtn setTitle:GovernmentModel.comment forState:UIControlStateNormal];
    NSString *category = [NSString stringWithFormat:@"来自 %@",GovernmentModel.cat_name];
    NSMutableAttributedString* htinstr = [[NSMutableAttributedString alloc]initWithString:category];
    
    NSString *str = @"";
    if (GovernmentModel.cat_name) {
        str = GovernmentModel.cat_name;
    }
    NSRange range =[[htinstr string]rangeOfString:str];

    [htinstr addAttribute:NSForegroundColorAttributeName value:JHAssistColor range:range];
    [htinstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    NSRange rangefrom =[[htinstr string]rangeOfString:@"来自 "];
    [htinstr addAttribute:NSForegroundColorAttributeName value:JHmiddleColor range:rangefrom];
    [htinstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:rangefrom];
//    if (GovernmentModel.cat_name) {
//         [self.categoryBtn setAttributedTitle:[category AttributedString:GovernmentModel.cat_name backColor:nil uicolor:JHAssistColor uifont:[UIFont systemFontOfSize:15]] forState:UIControlStateNormal];
//    }else{
    [self.categoryBtn setAttributedTitle:htinstr forState:UIControlStateNormal];
//    }
   
    [self.backImView removeAllSubviews];
    if (GovernmentModel.imgurl.count) {
        NSArray *imageArr = GovernmentModel.imgurl;
        CGFloat imgWidth = (SCREEN.size.width - 90)/3;
        if (imageArr.count == 1) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            imageView.tag = 0;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageArr[0]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRetryFailed];
            [self.backImView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
                make.top.offset(0);
                make.bottom.offset(0);
                make.width.equalTo(imageView.mas_height).multipliedBy(21/17);
            }];
            
            UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressImage:)];
            [imageView addGestureRecognizer:tapGesture];
        }else if (imageArr.count == 4){
            for (int i = 0; i < imageArr.count; i ++) {
                UIImageView *imageView4 = [[UIImageView alloc]init];
                imageView4.contentMode = UIViewContentModeScaleAspectFill;
                imageView4.layer.masksToBounds = YES;
                imageView4.userInteractionEnabled = YES;
                imageView4.tag = i;
                [imageView4 sd_setImageWithURL:[NSURL URLWithString:imageArr[i]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRetryFailed];
                [self.backImView addSubview:imageView4];
                
                UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressImage:)];
                [imageView4 addGestureRecognizer:tapGesture];
                if (i < 2) {
                    imageView4.frame = CGRectMake(i * (imgWidth + 10), 0, imgWidth, imgWidth);
                }else{
                    imageView4.frame = CGRectMake((i- 2) * (imgWidth + 10), imgWidth + 10, imgWidth, imgWidth);
                }
            }

        
        }else{
        
            for (int i = 0; i < (imageArr.count < 10 ?imageArr.count : 9); i ++) {
                UIImageView *imageView4 = [[UIImageView alloc]init];
                imageView4.contentMode = UIViewContentModeScaleAspectFill;
                imageView4.layer.masksToBounds = YES;
                imageView4.userInteractionEnabled = YES;
                imageView4.tag = i;
                [imageView4 sd_setImageWithURL:[NSURL URLWithString:imageArr[i]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRetryFailed];
                [self.backImView addSubview:imageView4];
                
                UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressImage:)];
                [imageView4 addGestureRecognizer:tapGesture];
                if (i < 3) {
                    imageView4.frame = CGRectMake(i * (imgWidth + 10), 0, imgWidth, imgWidth);
                }else if (i < 6){
                    imageView4.frame = CGRectMake((i - 3) * (imgWidth + 10), imgWidth + 10, imgWidth, imgWidth);
                }else{
                    imageView4.frame = CGRectMake((i - 6) * (imgWidth + 10), (imgWidth + 10) * 2, imgWidth, imgWidth);
                }
            }
        
        }
    }

}
- (IBAction)likeBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (_likeblock) {
        _likeblock(btn);
    }
    
}

- (IBAction)reviewBtnClick:(id)sender {
}

-(void)setLikeblock:(LikeblockClick)likeblock{

    _likeblock = likeblock;
    
}
#pragma mark点击小图，展示大图
- (void)onPressImage:(UITapGestureRecognizer *)sender{
    UIImageView *imageview = (UIImageView *)sender.view;
    GovernmentModel *model = self.GovernmentModel;
    NSArray *arr = model.imgurl;
    LFLog(@"%@",arr);
    if (arr.count > 0) {
        STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:arr currentIndex:imageview.tag];
        [broser show];
    }
    
//    if (_delegate && [_delegate respondsToSelector:@selector(onPressImageView:onDynamicCell:index:)]) {
//
//        [_delegate onPressImageView:imageview onDynamicCell:self index:imageview.tag];
//    }
    
}

@end
