//
//  finishModel.h
//  shop
//
//  Created by 梁法亮 on 16/8/25.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "JSONModel.h"

@interface finishModel : JSONModel
@property(nonatomic,copy)NSString <Optional>*id;

@property(nonatomic,copy)NSString <Optional>*owner_mobile;

@property(nonatomic,copy)NSString <Optional>*owner_name;

@property(nonatomic,copy)NSString <Optional>*owner_address;

@property(nonatomic,copy)NSString <Optional>*express_number;

@property(nonatomic,copy)NSString <Optional>*express_company;

@property(nonatomic,copy)NSString <Optional>*express_img;

@property(nonatomic,copy)NSString <Optional>*add_time;

@property(nonatomic,copy)NSString <Optional>*worker_mobile;

@property(nonatomic,copy)NSString <Optional>*worker_address;

@property(nonatomic,copy)NSString <Optional>*worker_time;

@property(nonatomic,copy)NSString <Optional>*confirm_time;
@end
