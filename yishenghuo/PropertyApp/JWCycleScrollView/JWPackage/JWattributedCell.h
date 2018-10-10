//
//  JWattributedCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/21.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWattributedCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lflb0;
@property (weak, nonatomic) IBOutlet UILabel *lflb1;
@property (weak, nonatomic) IBOutlet UILabel *rightlb0;
@property (weak, nonatomic) IBOutlet UILabel *rightlb1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lf0width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lf1width;

@end
