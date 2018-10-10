//
//  GNRShopHeader.m
//  外卖
//
//  Created by LvYuan on 2017/5/3.
//  Copyright © 2017年 BattlePetal. All rights reserved.
//

#import "GNRShopHeader.h"

@implementation GNRShopHeader

- (void)layoutSubviews{
//    _logoImgV.layer.cornerRadius = _logoImgV.bounds.size.height/2.0;
//    _logoImgV.layer.borderColor = [UIColor whiteColor].CGColor;
//    _logoImgV.layer.borderWidth = 1;
//    _logoImgV.layer.masksToBounds = YES;
}

+ (GNRShopHeader *)header{
    return [[[NSBundle mainBundle]loadNibNamed:@"GNRShopHeader" owner:self options:nil]firstObject];;
}

-(void)setHeaderData:(NSDictionary *)dict{
    [self.logoImgV sd_setImageWithURL:[NSURL URLWithString:[dict[@"imgurl"] count] ? dict[@"imgurl"][0] : @""] placeholderImage:nil];
    self.nameL.text = dict[@"shop_name"];
    self.addressL.text = dict[@"shop_address"];
    self.rankLb.text = [NSString stringWithFormat:@"%@分",dict[@"rank"]];
    self.telL.text = [NSString stringWithFormat:@"%@-%@ 营业",dict[@"start_time"] ? dict[@"start_time"] :@"08:00",dict[@"end_time"] ? dict[@"end_time"] :@"22:00"];
    self.priceLb.text = [NSString stringWithFormat:@"%@/人",dict[@"shop_price"]];
    self.xx_image.scale = [dict[@"rank"] doubleValue]/5.0;
    self.xx_image.selImage = [UIImage imageNamed:@"xingxing_chense"];
}
@end
