//
//  DetailsViewController.h
//  shop
//
//  Created by 梁法亮 on 16/5/11.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D0BBBSmodel.h"
#import "GovernmentModel.h"

@class DetailsViewController;
@protocol BBSPostDetailDelegate <NSObject>

- (void)BBSDeletePost:(GovernmentModel *)model isDelete:(BOOL)isDelete;

@end
@interface DetailsViewController : BaseViewController

@property(nonatomic,strong)GovernmentModel *model;
@property(nonatomic,strong)NSString *detailID;
@property(nonatomic,weak)id<BBSPostDetailDelegate> delegate;
@end
