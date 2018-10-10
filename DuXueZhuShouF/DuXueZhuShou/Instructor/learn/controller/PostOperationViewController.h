//
//  PostOperationViewController.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/10.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BasicViewController.h"

@interface PostOperationViewController : BasicViewController
@property (nonatomic,copy)void (^successBlock)(void);
@end
