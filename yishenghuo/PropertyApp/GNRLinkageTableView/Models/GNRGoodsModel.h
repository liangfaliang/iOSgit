//
//  GNRGoodsModel.h
//  外卖
//
//  Created by LvYuan on 2017/5/2.
//  Copyright © 2017年 BattlePetal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNRGoodsModel : NSObject
@property (nonatomic, strong)NSString * shop_id;/** */
@property (nonatomic, strong)NSString * goods_id;/** */
@property (nonatomic, strong)NSString * goods_name;/** */
@property (nonatomic, strong)NSString * goods_price;/** */
@property (nonatomic, strong)NSString * sales_volume;/** 销量*/
@property (nonatomic, strong)NSString * stock;/** 库存*/
@property (nonatomic, strong)NSString * imgurl;/** */
@property (nonatomic, strong)NSString * goods_number;/** 购物车内商品数量*/
@property (nonatomic, assign)float shouldPayMoney;

@end
