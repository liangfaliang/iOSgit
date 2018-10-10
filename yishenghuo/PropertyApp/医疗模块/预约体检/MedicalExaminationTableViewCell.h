//
//  MedicalExaminationTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/12.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicalExaminationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLbWidth;

@property (weak, nonatomic) IBOutlet UILabel *numberLb;

@end
