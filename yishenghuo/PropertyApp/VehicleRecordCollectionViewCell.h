//
//  VehicleRecordCollectionViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2017/6/20.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VehicleRecordCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *brandLb;
@property (weak, nonatomic) IBOutlet UILabel *AnnualLb;
@property (weak, nonatomic) IBOutlet UILabel *reserveLb;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;

@end
