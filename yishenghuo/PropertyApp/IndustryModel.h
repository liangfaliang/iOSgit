//
//  IndustryModel.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/28.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "JSONModel.h"

@interface IndustryModel : JSONModel
@property (nonatomic,strong) NSString <Optional>* open_type;//打开方式  0正常打开   1 webview
@property (nonatomic,strong) NSString <Optional>* link;//webview 链接
@property (nonatomic,strong) NSString <Optional>* username;//

@property (nonatomic,strong) NSString <Optional>* add_time;//添加时间

@property (nonatomic,strong) NSString <Optional>* category;//

@property (nonatomic,strong) NSString <Optional>* like_count;//点赞数

@property (nonatomic,strong) NSString <Optional>* content;//文章内容

@property (nonatomic,strong) NSString <Optional>* comment_count;//评论数

@property (nonatomic,strong) NSString <Optional>* headimage;//作者头像

@property (nonatomic,strong) NSString <Optional>* id;//文章id

@property (nonatomic,strong) NSString <Optional>* is_like;//是否点赞

@property (nonatomic,strong) NSString <Optional>* nickname;//作者昵称

@property (nonatomic,strong) NSString <Optional>* title;//文章标题

@property (nonatomic,strong) NSString <Optional>* article_id;//文章id


@property (nonatomic,strong) NSString <Optional>* notlike_count;//踩次数
@property (nonatomic,strong) NSArray <Optional>* images;//文章图片


@end
