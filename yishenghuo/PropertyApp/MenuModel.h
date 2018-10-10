//
//  MenuModel.h
//  shop
//
//  Created by 梁法亮 on 16/5/23.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "JSONModel.h"

@interface MenuModel : JSONModel

@property(nonatomic,strong)NSString <Optional>*id;
@property(nonatomic,strong)NSString <Optional>*name;
@property(nonatomic,strong)NSString <Optional>*detail;
@property(nonatomic,strong)NSString <Optional>*imgurl;
@property(nonatomic,strong)NSString <Optional>*imgurl3;
@property(nonatomic,strong)NSString <Optional>*imgurl2;
@property(nonatomic,strong)NSString <Optional>*keyword;
@end
