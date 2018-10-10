//
//  D0BBsTableViewCell.m
//  shop
//
//  Created by 梁法亮 on 16/7/8.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "D0BBsTableViewCell.h"

#import "NSString+selfSize.h"

#import "CustomButton.h"
#import "CustomLabel.h"


#import "STImageVIew.h"
#import "STPhotoBroswer.h"

#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "SDImageCache.h"
#import "UIButton+WebCache.h"
@implementation D0BBsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.praise.userInteractionEnabled = YES;
    self.image1.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.image2.imageView.contentMode = UIViewContentModeScaleAspectFill;
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setIndustryModel:(IndustryModel *)IndustryModel{
    
    _IndustryModel = IndustryModel;
    self.hotHeigth.constant = 0;
    self.praiseLabel.text = [NSString stringWithFormat:@"%@",IndustryModel.like_count];
    self.commentLabel.text = [NSString stringWithFormat:@"%@",IndustryModel.comment_count];
    self.praiseLabel.adjustsFontSizeToFitWidth = YES;
    self.commentLabel.adjustsFontSizeToFitWidth = YES;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:IndustryModel.headimage] placeholderImage:[UIImage imageNamed:@"morentouxiang-zhijie"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(praiseclick:)];
    [self.praise addGestureRecognizer:tap];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",IndustryModel.nickname];
    self.contentLabe.text =IndustryModel.content;
    self.titleLabel.text = IndustryModel.title;
    CGSize h = [IndustryModel.content selfadaption:13];
    CGFloat heigth;
    if (h.height > 30) {
        heigth = 30;
    }else{
        heigth = h.height;
    }
    self.contentHeigth.constant = heigth;
//    [self.typeButton setTitle:IndustryModel.category forState:UIControlStateNormal];
    self.timeLabe.text = IndustryModel.add_time;
    if (![IndustryModel.is_like isEqualToString:@"0"]) {
        self.praise.image = [UIImage imageNamed:@"dianzna123"];
    }else{
        
        self.praise.image = [UIImage imageNamed:@"dianzanmoren"];
        
    }
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praisetest:)
    //                                                 name:model.id object:nil];
    //图片
    self.image1.userInteractionEnabled = NO;
    self.image2.userInteractionEnabled = NO;
    [self.image1 setBackgroundImage:nil forState:UIControlStateNormal];
    [self.image2 setBackgroundImage:nil forState:UIControlStateNormal];
    [self.image1 setImage:nil forState:UIControlStateNormal];
    [self.image2 setImage:nil forState:UIControlStateNormal];
    if (IndustryModel.images.count > 0) {
        
        for (int i = 0; i < (self.IndustryModel.images.count<2?self.IndustryModel.images.count:2); i++) {
            
            NSString *urlimage = self.IndustryModel.images[i];
            if (i == 0) {
                self.image1.userInteractionEnabled = YES;
                
                [self.image1 sd_setImageWithURL:[NSURL URLWithString:urlimage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error) {
                        self.image1.userInteractionEnabled = NO;
                    }else{
                        self.image1.userInteractionEnabled = YES;
                    }
                }];
                //                [self.image1 sd_setBackgroundImageWithURL:[NSURL URLWithString:urlimage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"shareImg"]];
            }else if (i == 1){
                self.image2.userInteractionEnabled = YES;
                [self.image2 sd_setImageWithURL:[NSURL URLWithString:urlimage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error) {
                        self.image2.userInteractionEnabled = NO;
                    }else{
                        self.image2.userInteractionEnabled = YES;
                    }
                }];
                //                [self.image1 sd_setBackgroundIm
                //            [self.image2 sd_setBackgroundImageWithURL:[NSURL URLWithString:urlimage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"shareImg"]];
            }        }
        
        
    }
}

-(void)setGovernmentModel:(GovernmentModel *)GovernmentModel{
    
    _GovernmentModel = GovernmentModel;
    self.hotHeigth.constant = 0;
    self.praiseLabel.text = [NSString stringWithFormat:@"%@",GovernmentModel.agree_count];
    self.commentLabel.text = [NSString stringWithFormat:@"%@",GovernmentModel.comment];
    self.praiseLabel.adjustsFontSizeToFitWidth = YES;
    self.commentLabel.adjustsFontSizeToFitWidth = YES;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:GovernmentModel.headimage] placeholderImage:[UIImage imageNamed:@"placeholdertouxiang"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(praiseclick:)];
    [self.praise addGestureRecognizer:tap];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 在",GovernmentModel.user_name];
    self.contentLabe.text =GovernmentModel.content;
    self.titleLabel.text = GovernmentModel.title;
    CGSize h = [GovernmentModel.content selfadaption:13];
    CGFloat heigth;
    if (h.height > 30) {
        heigth = 30;
    }else{
        heigth = h.height;
    }
    self.contentHeigth.constant = heigth;
    [self.typeButton setTitle:GovernmentModel.cat_name forState:UIControlStateNormal];
    self.timeLabe.text = GovernmentModel.add_time;
    if (![GovernmentModel.is_agree isEqualToString:@"0"]) {
        self.praise.image = [UIImage imageNamed:@"dianzna123"];
    }else{
        
        self.praise.image = [UIImage imageNamed:@"dianzanmoren"];
        
    }
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praisetest:)
    //                                                 name:model.id object:nil];
    //图片
    self.image1.userInteractionEnabled = NO;
    self.image2.userInteractionEnabled = NO;
    [self.image1 setBackgroundImage:nil forState:UIControlStateNormal];
    [self.image2 setBackgroundImage:nil forState:UIControlStateNormal];
    [self.image1 setImage:nil forState:UIControlStateNormal];
    [self.image2 setImage:nil forState:UIControlStateNormal];
    if (GovernmentModel.imgurl.count > 0) {
        
        for (int i = 0; i < (self.model.imgurl.count<2?self.model.imgurl.count:2); i++) {
            
            NSString *urlimage = self.model.imgurl[i][@"imgurl"];
            if (i == 0) {
                self.image1.userInteractionEnabled = YES;
                
                [self.image1 sd_setImageWithURL:[NSURL URLWithString:urlimage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error) {
                        self.image1.userInteractionEnabled = NO;
                    }else{
                        self.image1.userInteractionEnabled = YES;
                    }
                }];
                //                [self.image1 sd_setBackgroundImageWithURL:[NSURL URLWithString:urlimage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"shareImg"]];
            }else if (i == 1){
                self.image2.userInteractionEnabled = YES;
                [self.image2 sd_setImageWithURL:[NSURL URLWithString:urlimage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error) {
                        self.image2.userInteractionEnabled = NO;
                    }else{
                        self.image2.userInteractionEnabled = YES;
                    }
                }];
                //                [self.image1 sd_setBackgroundIm
                //            [self.image2 sd_setBackgroundImageWithURL:[NSURL URLWithString:urlimage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"shareImg"]];
            }
        }
        
        
    }
}
-(void)setModel:(D0BBBSmodel *)model{

    _model = model;
      self.hotHeigth.constant = 0;
    self.praiseLabel.text = [NSString stringWithFormat:@"%@",model.collect];
    self.commentLabel.text = [NSString stringWithFormat:@"%@",model.comment];
    self.praiseLabel.adjustsFontSizeToFitWidth = YES;
    self.commentLabel.adjustsFontSizeToFitWidth = YES;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:@"placeholdertouxiang"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(praiseclick:)];
    [self.praise addGestureRecognizer:tap];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 在",model.username];
    self.contentLabe.text =model.content;
    self.titleLabel.text = model.title;
    CGSize h = [model.content selfadaption:13];
    CGFloat heigth;
    if (h.height > 30) {
        heigth = 30;
    }else{
        heigth = h.height;
    }
      self.contentHeigth.constant = heigth;
    [self.typeButton setTitle:model.category forState:UIControlStateNormal];
    self.timeLabe.text = model.add_time;
    if (![model.is_collect isEqualToString:@"0"]) {
        self.praise.image = [UIImage imageNamed:@"dianzna123"];
    }else{
    
     self.praise.image = [UIImage imageNamed:@"dianzanmoren"];
    
    }

//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praisetest:)
//                                                 name:model.id object:nil];
    //图片
    self.image1.userInteractionEnabled = NO;
    self.image2.userInteractionEnabled = NO;
    [self.image1 setBackgroundImage:nil forState:UIControlStateNormal];
    [self.image2 setBackgroundImage:nil forState:UIControlStateNormal];
    [self.image1 setImage:nil forState:UIControlStateNormal];
    [self.image2 setImage:nil forState:UIControlStateNormal];
    if (model.imgurl.count > 0) {
        
        for (int i = 0; i < (self.model.imgurl.count<2?self.model.imgurl.count:2); i++) {
            
            NSString *urlimage = self.model.imgurl[i][@"imgurl"];
            if (i == 0) {
                self.image1.userInteractionEnabled = YES;
                
                [self.image1 sd_setImageWithURL:[NSURL URLWithString:urlimage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error) {
                        self.image1.userInteractionEnabled = NO;
                    }else{
                        self.image1.userInteractionEnabled = YES;
                    }
                }];
//                [self.image1 sd_setBackgroundImageWithURL:[NSURL URLWithString:urlimage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"shareImg"]];
            }else if (i == 1){
                self.image2.userInteractionEnabled = YES;
                [self.image2 sd_setImageWithURL:[NSURL URLWithString:urlimage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error) {
                        self.image2.userInteractionEnabled = NO;
                    }else{
                        self.image2.userInteractionEnabled = YES;
                    }
                }];
                //                [self.image1 sd_setBackgroundIm
//            [self.image2 sd_setBackgroundImageWithURL:[NSURL URLWithString:urlimage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"shareImg"]];
            }
        }
        

    }
}

- (IBAction)buttonClick:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if (_block) {
        _block(btn.titleLabel.text,self.index);
    }
}

- (IBAction)imageBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (_imageblock) {
        _imageblock(btn.tag - 5);
    }

}

-(void)setBlock:(blockClick)block{

    _block = block;
}


-(void)setImageblock:(imageblockClick)imageblock{

    _imageblock = imageblock;

}

-(void)praiseclick:(UITapGestureRecognizer *)tap{

    if (_priseBlock) {

        if (self.model) {
            _priseBlock(self.model.id,self.index);
        }else if(self.IndustryModel){
        _priseBlock(self.IndustryModel.id,self.index);
        }else{
        _priseBlock(self.GovernmentModel.id,self.index);
        }
        
    }

}

-(void)setPriseBlock:(blockClick)priseBlock{

    _priseBlock = priseBlock;

}

-(void)praisetest:(NSNotification*)notify{

    self.praise.image = [UIImage imageNamed:@"dianzna123"];
    NSInteger praise = [self.praiseLabel.text integerValue];
    praise ++;
    self.praiseLabel.text = [NSString stringWithFormat:@"%d",(int)praise];
    NSLog(@"notify:%@",notify);
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}

@end
