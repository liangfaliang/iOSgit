//
//  ItemViewController.h
//  shop
//
//  Created by wwzs on 16/4/12.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ItemViewControllerDelegate;
@interface ItemViewController : BaseViewController

@property (strong,nonatomic)UITableView *tableView;
//项目
@property (strong,nonatomic)NSMutableArray *itemArr;


//声明代理
@property(nonatomic,assign)id<ItemViewControllerDelegate> delegate;
@end
//声明协议方法
@protocol ItemViewControllerDelegate <NSObject>
@optional
- (void)itemString:(NSString *)string;

@end
