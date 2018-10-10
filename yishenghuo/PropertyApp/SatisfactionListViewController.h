//
//  SatisfactionListViewController.h
//  shop
//
//  Created by 梁法亮 on 16/9/12.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SatisfactionListViewController : BaseViewController
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *type_id;//满意度类型 0物业满意度（默认）；1医疗满意度；
@end
