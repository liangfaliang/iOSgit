//
//  SelectViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 2017/5/13.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"
@protocol SelectViewControllerDelegate <NSObject>
@optional
- (void)SelectViewControllerDelegate:(NSString *)tyName tyId:(NSString *)tyId;

@end
@interface SelectViewController : BaseViewController
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)id<SelectViewControllerDelegate> delegate;
@end
