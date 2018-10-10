//
//  MaintenanceRepairViewController.h
//  shop
//
//  Created by 梁法亮 on 16/8/12.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepairsMaintenanceRepairViewController : BaseViewController
@property(nonatomic,assign)NSInteger tag;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSArray *namearr;
@property(nonatomic,strong)NSArray *namekey;
@property(nonatomic,copy)void (^gobackBlock)();
@end
