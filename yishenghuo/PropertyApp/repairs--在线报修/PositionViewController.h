//
//  PositionViewController.h
//  shop
//
//  Created by wwzs on 16/4/12.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PositionViewControllerDelegate;
@interface PositionViewController : BaseViewController

@property (strong,nonatomic)UITableView *tableView;
//项目
@property (strong,nonatomic)NSMutableArray *itemArr;
@property (strong,nonatomic)NSMutableArray *categoryDt;//报修分类


@property(nonatomic,assign)id<PositionViewControllerDelegate> delegate;
@end

@protocol PositionViewControllerDelegate <NSObject>
@optional
- (void)positionString:(id)string index:(NSInteger )index;

@end
