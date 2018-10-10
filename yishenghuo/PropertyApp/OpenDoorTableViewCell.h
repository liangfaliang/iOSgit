//
//  OpenDoorTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/17.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DWStepSlider.h"
@interface OpenDoorTableViewCell : UITableViewCell
@property (strong, nonatomic)  UILabel *nameLb;
//@property (strong, nonatomic)  DWStepSlider *dwslider;
@property (strong, nonatomic)  UIView *backView;
@property (strong, nonatomic)  NSDictionary *jsonDt;
@end
