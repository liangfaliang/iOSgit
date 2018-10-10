//
//  MedicalHomeCollectionViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/7/24.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicalHomeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet UIImageView *iconIm;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *descLb;
@property (weak, nonatomic) IBOutlet UIButton *yuyueBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@end
