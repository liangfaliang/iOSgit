//
//  AskQuestionViewController.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BasicViewController.h"

@interface AskQuestionViewController : BasicViewController
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *answer_type;
@property (nonatomic,copy)void (^successBlock)(void);
@end
