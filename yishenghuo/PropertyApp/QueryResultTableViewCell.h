//
//  QueryResultTableViewCell.h
//  shop
//
//  Created by 梁法亮 on 16/6/27.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "queryresultmodel.h"

@interface QueryResultTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIView *backview;

@property (retain, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLbheight;
@property (retain, nonatomic) IBOutlet UILabel *actionlabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionLbheight;
@property (retain, nonatomic) IBOutlet UILabel *pointslabel;
@property (retain, nonatomic) IBOutlet UILabel *finelabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fineLbWidth;
@property (retain, nonatomic) IBOutlet UILabel *resultlabel;
@property (retain, nonatomic) IBOutlet UILabel *placelabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeLbheight;

@property(nonatomic,strong)queryresultmodel *model;
@end
