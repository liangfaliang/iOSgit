//
//  D0BBBSmodel.h
//  shop
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "JSONModel.h"

@interface D0BBBSmodel : JSONModel

@property (nonatomic,strong) NSString <Optional>* username;

@property (nonatomic,strong) NSString <Optional>* add_time;

@property (nonatomic,strong) NSString <Optional>* category;

@property (nonatomic,strong) NSString <Optional>* collect;

@property (nonatomic,strong) NSString <Optional>* content;

@property (nonatomic,strong) NSString <Optional>* comment;

@property (nonatomic,strong) NSString <Optional>* headimg;

@property (nonatomic,strong) NSString <Optional>* id;

@property (nonatomic,strong) NSString <Optional>* is_collect;


@property (nonatomic,strong) NSString <Optional>* title;

@property (nonatomic,strong) NSString <Optional>* uid;


@property (nonatomic,strong) NSString <Optional>* nocollect;
@property (nonatomic,strong) NSArray <Optional>* imgurl;

@end
