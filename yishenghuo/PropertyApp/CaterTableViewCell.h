//
//  CaterTableViewCell.h
//  shop
//
//  Created by 梁法亮 on 16/10/20.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaterTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *iconimage;
@property (retain, nonatomic) IBOutlet UILabel *titlelable;
@property (retain, nonatomic) IBOutlet UILabel *locationlabel;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *titleheigth;
@property (retain, nonatomic) IBOutlet UILabel *cate_discount;
@end
