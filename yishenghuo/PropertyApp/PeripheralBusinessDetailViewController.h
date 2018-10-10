//
//  PeripheralBusinessDetailViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 17/2/24.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeripheralBusinessDetailViewController : BaseViewController
@property(nonatomic,strong)NSString *detailid;
@property(nonatomic,strong)NSArray *LocationArr;
@property(nonatomic,copy)NSString *isCarnival;//是否嘉年华
@end
