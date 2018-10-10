//
//  ReviewModel.h
//  shop
//
//  Created by 梁法亮 on 16/7/28.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "JSONModel.h"

@interface ReviewModel : JSONModel
@property (nonatomic,strong) NSString <Optional>* content;

@property (nonatomic,strong) NSString <Optional>* comment_count;

@property (nonatomic,strong) NSString <Optional>* is_collect;

@property (nonatomic,strong) NSString <Optional>* parent_id;

@property (nonatomic,strong) NSString <Optional>* username2;

@property (nonatomic,strong) NSString <Optional>* userid;

@property (nonatomic,strong) NSString <Optional>* collect_count;

@property (nonatomic,strong) NSString <Optional>* id;

@property (nonatomic,strong) NSArray <Optional>* comment;


@property (nonatomic,strong) NSString <Optional>* add_time;

@property (nonatomic,strong) NSString <Optional>* username1;
@property (nonatomic,strong) NSString <Optional>* articleid;


//行业监管
@property (nonatomic,strong) NSString <Optional>* nickname;//昵称
@property (nonatomic,strong) NSString <Optional>* headimage;//头像

@end
