//
//  ShopListingViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/10/28.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
//动画效果的枚举
typedef enum : NSUInteger {
    ShopListstoreDescUrl,
    ShopListstoreAscUrl,
    ShopListprice_desclistUrl,
    ShopListprice_asclistUrl,
    ShopListis_hotlistUrl
    
} ShopListType;
@interface ShopListingViewController : BaseViewController
@property(nonatomic,strong)NSMutableArray * listArr;
@property(nonatomic,strong)NSString *category_id;
@property(nonatomic,strong)NSString *keywords;
@property(nonatomic,strong)NSString *natitle;
@end
