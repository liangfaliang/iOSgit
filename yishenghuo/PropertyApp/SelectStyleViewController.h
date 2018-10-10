//
//  SelectStyleViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/2.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectStyleViewController : BaseViewController
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger tag;
@property(nonatomic,copy)NSString *userMoney;//账户余额
@end
