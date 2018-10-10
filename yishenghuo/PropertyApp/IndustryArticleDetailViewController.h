//
//  IndustryArticleDetailViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/28.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndustryModel.h"
@interface IndustryArticleDetailViewController : BaseViewController
@property(nonatomic,strong)IndustryModel *model;
@property(nonatomic,strong)NSString *detailID;
@end
