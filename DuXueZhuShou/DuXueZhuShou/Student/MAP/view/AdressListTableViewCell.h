//
//  AdressListTableViewCell.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/31.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendSubmitModel.h"
@interface AdressListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *adressLb;
@property (retain, nonatomic)  placeModel *model;
@end
