//
//  WKViewViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 17/5/11.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "BasicViewController.h"

@interface WKViewViewController : BasicViewController
@property(nonatomic,strong)NSString *urlId;
@property(nonatomic,strong)NSString *Id;
@property(nonatomic,strong)NSString *urlStr;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *titleStr;
@property(nonatomic,assign)BOOL isShowLoginview;
@property(nonatomic,assign)BOOL isCollection;//是否收藏
@property(nonatomic,assign)BOOL isShare;//是否分享
@end
