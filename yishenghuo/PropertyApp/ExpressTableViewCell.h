//
//  ExpressTableViewCell.h
//  shop
//
//  Created by 梁法亮 on 16/8/24.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expressmodel.h"
#import "MarqueeLabel.h"
#import "finishModel.h"

typedef void(^BtnBlock)(NSString *str);
@interface ExpressTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *pictureImage;

@property(nonatomic,strong)UILabel *typeLabel;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UILabel *infoLabel;
@property(nonatomic,strong)MarqueeLabel *notiLabel;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIButton *subBtn;
@property(nonatomic,strong)UIImageView *notiview;
@property(nonatomic,strong)Expressmodel *model;
@property(nonatomic,strong)finishModel *finishmodel;

@property(nonatomic,copy)BtnBlock Block;

-(void)setBlock:(BtnBlock)Block;
@end
