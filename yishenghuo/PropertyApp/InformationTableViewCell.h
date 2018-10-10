//
//  InformationTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/19.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationTableViewCell : BasicTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconimage;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageAspect;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTop;

@end
