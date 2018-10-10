//
//  GovernmentPostDetailViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/11.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GovernmentModel.h"

@class GovernmentPostDetailViewController;
@protocol GovernmentPostDetailDelegate <NSObject>

- (void)GovernmentDeletePost:(GovernmentModel *)model isDelete:(BOOL)isDelete;

@end

@interface GovernmentPostDetailViewController : BaseViewController
@property(nonatomic,strong)GovernmentModel *model;
@property(nonatomic,strong)NSString *detailID;
@property(nonatomic,weak)id<GovernmentPostDetailDelegate> delegate;
@end
