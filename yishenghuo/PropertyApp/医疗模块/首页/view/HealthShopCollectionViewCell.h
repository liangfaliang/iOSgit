//
//  HealthShopCollectionViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/7/25.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeGoodModel.h"
@interface HealthShopCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *naneLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (retain, nonatomic)  MeGoodModel *model;
@end
