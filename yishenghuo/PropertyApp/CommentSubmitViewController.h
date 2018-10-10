//
//  CommentSubmitViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 2017/11/22.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"

@interface CommentSubmitViewController : BaseViewController
@property(nonatomic,strong)NSString *detailid;
@property(nonatomic,copy)NSString *isCarnival;//是否嘉年华
@property(nonatomic,assign)BOOL isPerpher;//是否为周边商业
@property(nonatomic,copy)NSString *orid;
@end
