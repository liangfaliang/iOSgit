//
//  EditGroupViewController.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/14.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BasicViewController.h"

@interface EditGroupViewController : BasicViewController
@property(nonatomic, copy)NSString *titleStr;
@property(nonatomic, copy)NSString *ID;
@property (nonatomic,copy)void (^successBlock)(void);
@end
