//
//  HouserTableViewCell.h
//  shop
//
//  Created by 梁法亮 on 16/7/19.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"
@interface HouserTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *iconimage;
@property (retain, nonatomic) IBOutlet UILabel *titlelable;
@property (retain, nonatomic) IBOutlet UILabel *locationlabel;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *titleheigth;
@property (weak, nonatomic) IBOutlet YYLabel *signYYlb;

@end
