//
//  PaymentAlreadyTableViewCell.h
//  PropertyApp
//
//  Created by admin on 2018/8/13.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayNewModel.h"
@interface PaymentAlreadyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (retain, nonatomic) PayNewModel *model;
@end
