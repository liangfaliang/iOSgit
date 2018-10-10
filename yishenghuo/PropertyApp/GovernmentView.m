//
//  GovernmentView.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/11.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "GovernmentView.h"

@interface GovernmentView ()

@end

@implementation GovernmentView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.iconImage.layer.cornerRadius = 20;
    self.iconImage.layer.masksToBounds = YES;
    
}
-(void)setGovernmentModel:(GovernmentModel *)GovernmentModel{
    
    _GovernmentModel = GovernmentModel;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:GovernmentModel.headimage] placeholderImage:[UIImage imageNamed:@"yezhumorentouxiang"]];
    self.nameLabel.text = GovernmentModel.user_name;
    self.timeLabel.text = GovernmentModel.add_time;
    self.contentLb.text = GovernmentModel.content;
    self.contentHeight.constant = [GovernmentModel.content selfadap:14 weith:20].height +10;
    //GovernmentModel.agree_count
    if ([GovernmentModel.is_agree isEqualToString:@"1"]) {
        [self.likeBtn setImage:[UIImage imageNamed:@"dianzanhongse"] forState:UIControlStateNormal];
    }else{
        [self.likeBtn setImage:[UIImage imageNamed:@"dianzanmoren"] forState:UIControlStateNormal];
    }
    [self.likeBtn setTitle:[NSString stringWithFormat:@" %@",GovernmentModel.agree_count] forState:UIControlStateNormal];
    [self.backImview removeAllSubviews];
    if (GovernmentModel.imgurl.count) {
        NSArray *imageArr = GovernmentModel.imgurl;
        CGFloat imgWidth = (SCREEN.size.width - 40)/3;
        if (imageArr.count == 1) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.userInteractionEnabled = YES;
            imageView.tag = 0;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageArr[0]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRetryFailed];
            [self.backImview addSubview:imageView];
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
                imageView4.userInteractionEnabled = YES;
                imageView4.tag = i;
                imageView4.contentMode = UIViewContentModeScaleAspectFill;
                imageView4.layer.masksToBounds = YES;
                [imageView4 sd_setImageWithURL:[NSURL URLWithString:imageArr[i]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRetryFailed];
                [self.backImview addSubview:imageView4];
                
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
                imageView4.userInteractionEnabled = YES;
                imageView4.tag = i;
                imageView4.contentMode = UIViewContentModeScaleAspectFill;
                imageView4.layer.masksToBounds = YES;
                [imageView4 sd_setImageWithURL:[NSURL URLWithString:imageArr[i]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRetryFailed];
                [self.backImview addSubview:imageView4];
                
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
- (void)onPressImage:(UITapGestureRecognizer *)sender{
    if (_imblock) {
        _imblock(sender.view.tag);
    }
    
}
- (IBAction)likeclick:(id)sender {
    if (_likeblock) {
        _likeblock(0);
    }
}


-(void)setImblock:(imageblockClick)imblock{
    _imblock = imblock;
}
-(void)setLikeblock:(likeblockClick)likeblock
{
    _likeblock = likeblock;
}
@end
