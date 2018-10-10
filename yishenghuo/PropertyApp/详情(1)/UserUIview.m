//
//  UserUIview.m
//  shop
//
//  Created by 梁法亮 on 16/5/11.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "UserUIview.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "SDImageCache.h"
#import "NSString+selfSize.h"


@interface UserUIview ()
{
    CGRect myframe;
}
@end

@implementation UserUIview



-(void)awakeFromNib{
    [super awakeFromNib];
    self.imagebackview = [[UIView alloc]init];
    
    self.imagebackview.userInteractionEnabled = YES;
    self.praiseimage.userInteractionEnabled = YES;
    self.reviewImage.userInteractionEnabled = YES;
    [self addSubview:self.imagebackview];
    
    
}

-(void)setIndustryModel:(IndustryModel *)IndustryModel{
    
    _IndustryModel = IndustryModel;
    self.praiseLabel.text = [NSString stringWithFormat:@"%@",IndustryModel.like_count];
    self.reviewLabel.text = [NSString stringWithFormat:@"%@",IndustryModel.comment_count];
    self.praiseLabel.adjustsFontSizeToFitWidth = YES;
    self.reviewLabel.adjustsFontSizeToFitWidth = YES;
    [self.iconimage sd_setImageWithURL:[NSURL URLWithString:IndustryModel.headimage] placeholderImage:[UIImage imageNamed:@"placeholdertouxiang"]];
    
    UITapGestureRecognizer *praisetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(praiseclick:)];
    [self.praiseimage addGestureRecognizer:praisetap];
    
    UITapGestureRecognizer *reviewtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reviewclick:)];
    [self.reviewImage addGestureRecognizer:reviewtap];
    self.namelabel.text = IndustryModel.username;
    self.contenLabel.text =IndustryModel.content;
    CGSize titlesize = [IndustryModel.title selfadap:14 weith:20];
    if (self.titleHieght.constant < titlesize.height) {
        self.titleHieght.constant = titlesize.height + 2;
    }
    self.titleLabel.text = IndustryModel.title;
    CGSize h = [IndustryModel.content selfadaption:12];
    self.contentHeigth.constant = h.height + 3;
    self.timelabe.text = IndustryModel.add_time;
    if (![IndustryModel.is_like isEqualToString:@"0"]) {
        self.praiseimage.image = [UIImage imageNamed:@"dianzna123"];
    }else{
        
        self.praiseimage.image = [UIImage imageNamed:@"dianzanmoren"];
        
    }
    //图片
    if (IndustryModel.images.count > 0) {
        self.imagebackview.frame = CGRectMake(0, h.height + 54 + self.titleHieght.constant, SCREEN.size.width, (SCREEN.size.width-40)/2.0);
        
        self.timeH.constant = (SCREEN.size.width-40)/2.0 + self.titleHieght.constant;
        
        
        for (int i = 0; i < (IndustryModel.images.count<2?IndustryModel.images.count:2); i++) {
            
            NSString *urlimage = IndustryModel.images[i];
            
            UIImageView *imageV = [[UIImageView alloc]init];
            imageV.userInteractionEnabled = YES;
            imageV.backgroundColor = [UIColor grayColor];
            imageV.tag = 55 + i;
            imageV.frame = CGRectMake(15 + ((SCREEN.size.width-40)/2.0 + 10)  * i,0,(SCREEN.size.width-40)/2.0,(SCREEN.size.width-40)/2.0);
            [imageV sd_setImageWithURL:[NSURL URLWithString:urlimage] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error) {
                    imageV.userInteractionEnabled = NO;
                }else{
                    imageV.userInteractionEnabled = YES;
                }
            }];
            //            [imageV sd_setImageWithURL:[NSURL URLWithString:urlimage] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            imageV.layer.cornerRadius = 6.0;
            imageV.layer.masksToBounds = YES;
            [self.imagebackview addSubview:imageV];
            
            CustomButton *btn = [CustomButton buttonWithType:UIButtonTypeCustom];
            btn.frame = imageV.frame;
            [btn addTarget:self action:@selector(imageViewClick:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.tag2 = i;
            //                cell.tImageView.userInteractionEnabled = YES;
            [self.imagebackview addSubview:btn];
            //超过四张，在第四张右下角显示“共X张”
            if (i == 2  && IndustryModel.images.count >=3) {
                UILabel *lab = [[UILabel alloc]init];
                NSString *str = [NSString stringWithFormat:@"共%lu张",(unsigned long)IndustryModel.images.count];
                lab.font = [UIFont systemFontOfSize:10];
                CGSize labesize = [str boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
                lab.frame = CGRectMake((SCREEN.size.width-45)/4.0-labesize.width-5, (SCREEN.size.width-45)/4.0-labesize.height-4, labesize.width+4, labesize.height+4);
                lab.text = str ;
                lab.textAlignment = NSTextAlignmentCenter;
                lab.textColor = [UIColor whiteColor];
                lab.backgroundColor = [UIColor blackColor];
                [imageV addSubview:lab];
            }
        }
        
        
        
        
    }else{
        
        //        [self.imagebackview removeFromSuperview];
        [self.imagebackview removeAllSubviews];
        self.timeH.constant = 5;
        
    }
    
}
-(void)setModel:(D0BBBSmodel *)model{
    
    
    _model = model;
    self.praiseLabel.text = [NSString stringWithFormat:@"%@",model.collect];
    self.reviewLabel.text = [NSString stringWithFormat:@"%@",model.comment];
    self.praiseLabel.adjustsFontSizeToFitWidth = YES;
    self.reviewLabel.adjustsFontSizeToFitWidth = YES;
    [self.iconimage sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:@"placeholdertouxiang"]];
    
    UITapGestureRecognizer *praisetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(praiseclick:)];
    [self.praiseimage addGestureRecognizer:praisetap];
    
    UITapGestureRecognizer *reviewtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reviewclick:)];
    [self.reviewImage addGestureRecognizer:reviewtap];
    self.namelabel.text = model.username;
    self.contenLabel.text =model.content;
    CGSize titlesize = [model.title selfadap:14 weith:20];
    if (self.titleHieght.constant < titlesize.height) {
        self.titleHieght.constant = titlesize.height + 2;
    }
    LFLog(@"model.is_collect:%@",model.is_collect);
    self.titleLabel.text = model.title;
    CGSize h = [model.content selfadaption:12];
    self.contentHeigth.constant = h.height + 3;
    self.timelabe.text = model.add_time;
    if (![model.is_collect isEqualToString:@"0"]) {
        self.praiseimage.image = [UIImage imageNamed:@"dianzna123"];
    }else{
        
        self.praiseimage.image = [UIImage imageNamed:@"dianzanmoren"];
        
    }
    //图片
    if (model.imgurl.count > 0) {
        self.imagebackview.frame = CGRectMake(0, h.height + 54 + self.titleHieght.constant, SCREEN.size.width, (SCREEN.size.width-40)/2.0);
        
        self.timeH.constant = (SCREEN.size.width-40)/2.0 + self.titleHieght.constant;
        
        
        for (int i = 0; i < (self.model.imgurl.count<2?self.model.imgurl.count:2); i++) {
            
            NSString *urlimage = self.model.imgurl[i][@"imgurl"];
            
            UIImageView *imageV = [[UIImageView alloc]init];
            imageV.userInteractionEnabled = YES;
            imageV.backgroundColor = [UIColor whiteColor];
            imageV.tag = 55 + i;
            imageV.frame = CGRectMake(15 + ((SCREEN.size.width-40)/2.0 + 10)  * i,0,(SCREEN.size.width-40)/2.0,(SCREEN.size.width-40)/2.0);
            
            imageV.layer.cornerRadius = 6.0;
            imageV.layer.masksToBounds = YES;
            [self.imagebackview addSubview:imageV];
            
            CustomButton *btn = [CustomButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, imageV.width, imageV.height);
            [btn addTarget:self action:@selector(imageViewClick:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.tag2 = i;
            //                cell.tImageView.userInteractionEnabled = YES;
            [imageV sd_setImageWithURL:[NSURL URLWithString:urlimage] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error) {
                    btn.userInteractionEnabled = NO;
                }else{
                    btn.userInteractionEnabled = YES;
                }
            }];
           imageV.contentMode = UIViewContentModeScaleAspectFit;
            [imageV addSubview:btn];
            //超过四张，在第四张右下角显示“共X张”
            if (i == 2  && self.model.imgurl.count >=3) {
                UILabel *lab = [[UILabel alloc]init];
                NSString *str = [NSString stringWithFormat:@"共%lu张",(unsigned long)self.model.imgurl.count];
                lab.font = [UIFont systemFontOfSize:10];
                CGSize labesize = [str boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
                lab.frame = CGRectMake((SCREEN.size.width-45)/4.0-labesize.width-5, (SCREEN.size.width-45)/4.0-labesize.height-4, labesize.width+4, labesize.height+4);
                lab.text = str ;
                lab.textAlignment = NSTextAlignmentCenter;
                lab.textColor = [UIColor whiteColor];
                lab.backgroundColor = [UIColor blackColor];
                [imageV addSubview:lab];
            }
        }
        
        
        
        
    }else{
        
        //        [self.imagebackview removeFromSuperview];
        [self.imagebackview removeAllSubviews];
        self.timeH.constant = 5;
        
    }
}

//图片点击
-(void)imageViewClick:(CustomButton *)btn{
    
    if ( _imageBlock) {
        _imageBlock(btn);
    }
    
}

-(void)setImageBlock:(iamageblockClick)imageBlock{
    
    _imageBlock = imageBlock;
    
}
-(void)setPraiseblock:(praiseblockClick)praiseblock{
    
    _praiseblock = praiseblock;
}

-(void)setReviewBlock:(reviewblockClick)reviewBlock{
    
    _reviewBlock = reviewBlock;
}

//点赞
-(void)praiseclick:(UITapGestureRecognizer *)tap{
    
    if (_praiseblock) {
        _praiseblock(nil);
    }
    
}
//评论
-(void)reviewclick:(UITapGestureRecognizer *)tap{
    
    if (_reviewBlock) {
        _reviewBlock(nil);
    }
    
}

//-(void)setFrame:(CGRect)frame{
//
//
//    myframe = frame;
//}
//-(id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        NSArray *nibs=[[NSBundle mainBundle]loadNibNamed:@"UserUIview" owner:nil options:nil];
//        self=[nibs objectAtIndex:0];
//
//        myframe = frame;
//    }
//    return self;
//}
//-(void)drawRect:(CGRect)rect
//{
//    self.frame = myframe;//关键点在这里
//    
//}
@end
