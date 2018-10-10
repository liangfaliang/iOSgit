//
//  AritcleModel.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/5/10.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "JSONModel.h"

@interface AritcleModel : JSONModel
@property (nonatomic,strong) NSString <Optional>* user_name;//发帖人
@property (nonatomic,strong) NSString <Optional>* id;//发帖人id
@property (nonatomic,strong) NSString <Optional>* add_time;//添加时间

@property (nonatomic,strong) NSString <Optional>* is_agree;//自己是否点赞

@property (nonatomic,strong) NSString <Optional>* agree_count;//点赞数

@property (nonatomic,strong) NSString <Optional>* content;//内容

@property (nonatomic,strong) NSString <Optional>* comment_count;//评论数

@property (nonatomic,strong) NSString <Optional>* headimage;//发帖人头像
@property (nonatomic,strong) NSString <Optional>* is_comment;//自己是否评论
@property (nonatomic,strong) NSString <Optional>* reply;//是否可评论 0不可评论
@property (nonatomic,strong) NSArray <Optional>* sublevel;//二级评论
@end
