//
//  BusinessHomeTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/8/15.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XX_image.h"
#import "businessModel.h"
#import "GNRGoodsModel.h"
@interface BusinessHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet XX_image *xx_image;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *adressLb;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIView *imageBackview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBackviewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagebackviewTop;
@property (weak, nonatomic) IBOutlet UIButton *image1;
@property (weak, nonatomic) IBOutlet UIButton *image2;
@property (weak, nonatomic) IBOutlet UIButton *image3;
@property (nonatomic,retain)businessModel *bmodel;
@property (nonatomic,copy) void (^imageclickBlock)(NSInteger index);
-(void)setImageArr:(NSArray *)imageArr;
-(void)setViewHideen:(BOOL)ishiden;
@end
