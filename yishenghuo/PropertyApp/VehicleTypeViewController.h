//
//  VehicleTypeViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 2017/6/19.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^backBlock)(NSDictionary *typeDt);
@interface VehicleTypeViewController : BaseViewController
@property(nonatomic,copy)backBlock block;
@property (strong,nonatomic)NSArray *typeArray;
-(void)setBlock:(backBlock)block;
@end
