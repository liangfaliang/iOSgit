//
//  PromotionsTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/8/14.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromotionsTableViewCell : BasicTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconIm;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@end
