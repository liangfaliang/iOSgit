//
//  ShopOrderDetailsViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/14.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopOrderDetailsViewController : BaseViewController
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSString *orderid;
@property(nonatomic,strong)NSString *is_Integral;//是否为积分兑换
@end
