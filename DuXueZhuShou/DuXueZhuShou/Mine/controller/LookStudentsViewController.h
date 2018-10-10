//
//  LookStudentsViewController.h
//  DuXueZhuShou
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BasicViewController.h"

@interface LookStudentsViewController : BasicViewController
@property (nonatomic,copy)void (^successBlock)(void);
@property (nonatomic,strong)NSDictionary *stuDt;
@property (nonatomic,copy)NSString *class_id;
@end
