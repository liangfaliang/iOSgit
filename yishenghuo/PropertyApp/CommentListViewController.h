//
//  CommentListViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 2017/11/23.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"

@interface CommentListViewController : BaseViewController
@property(nonatomic,strong)NSString *detailid;
@property(nonatomic,strong)NSDictionary *countDt;//统计
@property(nonatomic,copy)NSString *isCarnival;//是否嘉年华
@property(nonatomic,copy)NSString *ws_worker;//是否维修工单评论
@property(nonatomic,copy)NSString *ws_type;
@property (nonatomic,strong)NSMutableArray *commentArr;//评论列表
@end
