//
//  companyTableViewController.h
//  shop
//
//  Created by 梁法亮 on 16/4/8.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface companyTableViewController : BaseViewController

@property(nonatomic,strong)NSMutableArray *companyArray;

@property(nonatomic,strong)NSMutableString *str;
@property(nonatomic,strong)NSMutableString *strid;
@property(nonatomic,assign)NSInteger tag;
@property(nonatomic,strong)NSString *is_Sort;
@end