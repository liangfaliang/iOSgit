//
//  PunchSubmitViewController.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/1.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BasicViewController.h"

@interface PunchSubmitViewController : BasicViewController
@property (nonatomic,assign) BOOL isAmend;//是否为补分 默认NO
@property (nonatomic,copy) NSString * ID;//
@property (nonatomic,copy)void (^successBlock)(void);
@end
