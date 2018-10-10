//
//  GoReviewModel.h
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/11.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "JSONModel.h"

@interface GoReviewModel : JSONModel
@property (nonatomic,strong) NSString <Optional>* comment_id;//评论ID

@property (nonatomic,strong) NSString <Optional>* article_id;//帖子ID

@property (nonatomic,strong) NSString <Optional>* comment_content;//评论内容

@property (nonatomic,strong) NSString <Optional>* add_time;//评论时间

@property (nonatomic,strong) NSString <Optional>* user_name;//用户名称

@property (nonatomic,strong) NSString <Optional>* headimage;//用户头像

@property (nonatomic,strong) NSString <Optional>* is_admin;//是否为管理员

@property (nonatomic,strong) NSString <Optional>* is_agree;//是否点赞

@property (nonatomic,strong) NSDictionary <Optional>* parent_info;//评论回复

@property (nonatomic,strong) NSString <Optional>* reply;//是否可评论
@property (nonatomic,strong) NSString <Optional>* agree_count;//点赞数
@property (nonatomic,strong) NSString <Optional>* articleid;


@end
