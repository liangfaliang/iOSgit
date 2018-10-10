//
//  ShopCartTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/1.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCartModel.h"
#import "SelectCountControl.h"
#import "GNRGoodsModel.h"
typedef void(^selectBlock) (BOOL seleted, NSString *str);
@interface ShopCartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *pictureIm;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet SelectCountControl *countView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBtnWidth;
@property(nonatomic,strong)GNRGoodsModel *bmodel;
@property(nonatomic,strong)ShopCartModel *model;
@property(nonatomic,copy)selectBlock selectblock;
-(void)setSelectblock:(selectBlock)selectblock;
@end
