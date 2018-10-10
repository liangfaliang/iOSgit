//
//  ShopCartModel.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/22.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "JSONModel.h"

@interface ShopCartModel : JSONModel
@property(nonatomic,strong)NSString <Optional>*goods_name;

@property(nonatomic,strong)NSArray <Optional>*goods_attr;

@property(nonatomic,strong)NSString <Optional>*parent_id;

@property(nonatomic,strong)NSString <Optional>*rec_type;

@property(nonatomic,strong)NSString <Optional>*goods_img;

@property(nonatomic,strong)NSString <Optional>*subtotal;

@property(nonatomic,strong)NSString <Optional>*is_gift;

@property(nonatomic,strong)NSString <Optional>*goods_price;

@property(nonatomic,strong)NSString <Optional>*goods_id;

@property(nonatomic,strong)NSString <Optional>*goods_number;

@property(nonatomic,strong)NSString <Optional>*original_img;

@property(nonatomic,strong)NSString <Optional>*pid;

@property(nonatomic,strong)NSString <Optional>*can_handsel;


@property(nonatomic,strong)NSString <Optional>*goods_sn;

@property(nonatomic,strong)NSString <Optional>*is_shipping;
@property(nonatomic,strong)NSString <Optional>*extension_code;

@property(nonatomic,strong)NSString <Optional>*goods_attr_id;

@property(nonatomic,strong)NSString <Optional>*market_price;


@property(nonatomic,strong)NSString <Optional>*is_real;

@property(nonatomic,strong)NSString <Optional>*rec_id;
@property(nonatomic,strong)NSDictionary <Optional>*img;

@property(nonatomic,strong)NSString <Optional>*select;//是否被选中


@end
