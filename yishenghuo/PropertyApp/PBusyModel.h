//
//  PBusyModel.h
//  PropertyApp
//
//  Created by 梁法亮 on 2017/11/22.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "JSONModel.h"

@interface PBusyModel : JSONModel
@property (nonatomic,strong) NSString <Optional>* user_name;//发帖人
@property (nonatomic,strong) NSString <Optional>* comment_id;//发帖人id
@property (nonatomic,strong) NSString <Optional>* add_time;//添加时间

@property (nonatomic,strong) NSString <Optional>* is_agree;//自己是否点赞

@property (nonatomic,strong) NSString <Optional>* agree_count;//点赞数

@property (nonatomic,strong) NSString <Optional>* content;//内容

@property (nonatomic,strong) NSString <Optional>* comment;//评论数

@property (nonatomic,strong) NSString <Optional>* headimage;//发帖人头像

@property (nonatomic,strong) NSString <Optional>* id;//文章ID
//
@property (nonatomic,strong) NSString <Optional>* is_comment;//自己是否评论

@property (nonatomic,strong) NSString <Optional>* is_admin;//是否为管理员

@property (nonatomic,strong) NSString <Optional>* title;//标题

@property (nonatomic,strong) NSString <Optional>* rank;//星星

@property (nonatomic,strong) NSString <Optional>* ip_address;//评论人ip

@property (nonatomic,strong) NSArray <Optional>* imgurl;//
@property (nonatomic,strong) NSDictionary <Optional>* share;//分享
@property (nonatomic,strong) NSString <Optional>* reply;//是否可评论 0不可评论
@end
