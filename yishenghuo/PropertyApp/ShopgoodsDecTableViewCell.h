//
//  ShopgoodsDecTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/10/31.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^appraiseBlock) (NSString *str);
@interface ShopgoodsDecTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *numLabe;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLbWidth;

@property (weak, nonatomic) IBOutlet UIButton *appraiseBtn;
@property(nonatomic,copy)appraiseBlock block;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parameterHeight;
@property (weak, nonatomic) IBOutlet UILabel *parameterLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parameterLbRight;

-(void)setBlock:(appraiseBlock)block;
@end
