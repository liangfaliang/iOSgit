//
//  CommentListTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/11/22.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "CommentListTableViewCell.h"
#import "STPhotoBroswer.h"
@implementation CommentListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImage.layer.cornerRadius = 20;
    self.iconImage.layer.masksToBounds = YES;
    [self.likeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    self.likeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}
-(void)setPbmodel:(PBusyModel *)pbmodel{
    
    _pbmodel = pbmodel;
    self.nameLabel.text = pbmodel.user_name;
    self.timeLabel.text = pbmodel.add_time;
    self.contentLb.text = pbmodel.content;

    LFLog(@"rank:%f",[pbmodel.rank doubleValue]/5.0);
    self.xx_imageview.scale = [pbmodel.rank doubleValue]/5.0;
    self.xx_imageview.selImage = [UIImage imageNamed:@"xingxing_chense"];
    LFLog(@"xx_imageview.scale:%f",self.xx_imageview.scale);
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:pbmodel.headimage] placeholderImage:[UIImage imageNamed:@"yezhumorentouxiang"]];
    //pbmodel.agree_count
    if ([pbmodel.is_agree isEqualToString:@"1"]) {//0 未点赞  1已点赞
        [self.likeBtn setTitleColor:JHAssistRedColor forState:UIControlStateNormal];
        [self.likeBtn setImage:[UIImage imageNamed:@"dianznahong_zbsy"] forState:UIControlStateNormal];
    }else{
        [self.likeBtn setTitleColor:JHsimpleColor forState:UIControlStateNormal];
        [self.likeBtn setImage:[UIImage imageNamed:@"dainzanhui_zbsy"] forState:UIControlStateNormal];
    }
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%@   ",pbmodel.agree_count] forState:UIControlStateNormal];
    [self.likeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.likeBtn.imageView.image.size.width, 0, self.likeBtn.imageView.image.size.width)];
    [self.likeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.likeBtn.titleLabel.bounds.size.width, 0, -self.likeBtn.titleLabel.bounds.size.width)];
    [self.backImView removeAllSubviews];
    if (pbmodel.imgurl.count) {
        NSArray *imageArr = pbmodel.imgurl;
        CGFloat imgWidth = (SCREEN.size.width - 90)/3;
        for (int i = 0; i < (imageArr.count < 4 ?imageArr.count : 3); i ++) {
            UIImageView *imageView4 = [[UIImageView alloc]init];
            imageView4.contentMode = UIViewContentModeScaleAspectFill;
            imageView4.layer.masksToBounds = YES;
            imageView4.userInteractionEnabled = YES;
            imageView4.tag = i;
            [imageView4 sd_setImageWithURL:[NSURL URLWithString:imageArr[i]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRetryFailed];
            [self.backImView addSubview:imageView4];
            
            UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressImage:)];
            [imageView4 addGestureRecognizer:tapGesture];
            imageView4.frame = CGRectMake(i * (imgWidth + 10), 0, imgWidth, imgWidth);
            if (i == 2) {
                if (imageArr.count > 3) {
                    UILabel *numLb = [[UILabel alloc]init];
                    numLb.backgroundColor = [UIColor blackColor];
                    numLb.font =[UIFont systemFontOfSize:15];
                    numLb.textColor =[UIColor whiteColor];
                    numLb.text = [NSString stringWithFormat:@"%lu张",(unsigned long)imageArr.count];
                    [imageView4 addSubview:numLb];
                    [numLb mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.offset(0);
                        make.right.offset(0);
                    }];
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



-(void)setLikeblock:(commentLikeblockClick)likeblock{
    
    _likeblock = likeblock;
}
#pragma mark点击小图，展示大图
- (void)onPressImage:(UITapGestureRecognizer *)sender{
    UIImageView *imageview = (UIImageView *)sender.view;
    PBusyModel *model = self.pbmodel;
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
