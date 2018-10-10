//
//  QueryResultViewController.h
//  shop
//
//  Created by 梁法亮 on 16/6/27.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryResultViewController : BaseViewController

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)NSString *privincestr;

@property(nonatomic,strong)NSString *citystr;

@property(nonatomic,strong)NSString *numstr;

@property(nonatomic,strong)NSString *countstr;
@property(nonatomic,strong)NSString *numengine;
@end
