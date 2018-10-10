//
//  GNRShopHeader.h
//  外卖
//
//  Created by LvYuan on 2017/5/3.
//  Copyright © 2017年 BattlePetal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XX_image.h"
@interface GNRShopHeader : UIView
@property (weak, nonatomic) IBOutlet XX_image *xx_image;
@property (weak, nonatomic) IBOutlet UILabel *rankLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UIImageView *bg_image;

@property (weak, nonatomic) IBOutlet UIImageView *logoImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *telL;
@property (weak, nonatomic) IBOutlet UILabel *addressL;
+ (GNRShopHeader *)header;
-(void)setHeaderData:(NSDictionary *)dict;
@end
