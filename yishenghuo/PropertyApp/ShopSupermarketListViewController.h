//
//  ShopSupermarketListViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 2017/6/15.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"
#import "ShopListingViewController.h"
@interface ShopSupermarketListViewController : BaseViewController
@property(nonatomic,strong)NSMutableArray * listArr;
@property(nonatomic,strong)NSString *category_id;
@property(nonatomic,strong)NSString *keywords;
@property(nonatomic,strong)NSString *natitle;
@property(nonatomic,strong)UISearchBar *searchbar;//搜索
@end

