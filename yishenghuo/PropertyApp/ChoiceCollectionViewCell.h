//
//  ChoiceCollectionViewCell.h
//  shop
//
//  Created by 梁法亮 on 16/8/18.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoiceModel.h"
#import "YYLabel.h"
#import "YYText.h"
#import "HPGrowingTextView.h"
typedef void(^selectBlock)(NSString *str,NSInteger index ,NSString *is_radio);
@interface ChoiceCollectionViewCell : UICollectionViewCell
@property(nonatomic,assign)NSInteger item;
@property(nonatomic,strong)UIImageView *imageicon;
@property(nonatomic,strong)UIScrollView *scrollview;
@property(nonatomic,strong)YYLabel *titleLb;
@property(nonatomic,strong)UIButton *optionsImage1;
@property(nonatomic,strong)UIButton *optionsImage2;
@property(nonatomic,strong)UIButton *optionsImage3;
@property(nonatomic,strong)UIButton *optionsImage4;
@property(nonatomic,strong)ChoiceModel *model;
@property(nonatomic,strong)UIView *opinionView;
@property(nonatomic,strong)UILabel *opinionLb;
@property(nonatomic,strong)HPGrowingTextView *opinionText;
@property(nonatomic,strong)UIView *opinionVline;
@property(nonatomic,copy)selectBlock selectblock;
-(void)setSelectblock:(selectBlock)selectblock;
@end
