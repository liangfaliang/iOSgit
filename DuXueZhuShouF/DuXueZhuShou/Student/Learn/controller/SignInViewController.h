//
//  SignInViewController.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/1.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BasicViewController.h"

@interface SignInViewController : BasicViewController
@property(nonatomic, copy)NSString *ID;
@property(nonatomic, copy)NSString *student_id;
@property(nonatomic, copy)NSString *date;
@property (nonatomic,copy)void (^successBlock)(void);
@end
