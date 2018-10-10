//
//  MedicalConfirmViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/18.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"

@interface MedicalConfirmViewController : BaseViewController
@property(nonatomic,copy)NSString *additional;
@property(nonatomic,strong)NSMutableArray *ItemArr;
@property(nonatomic,assign)double price;
@property (nonatomic,strong)NSDictionary *dataDt;//详情
@end
