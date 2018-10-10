//
//  ImageLabelCollectionViewCell.h
//  TsApartment
//
//  Created by admin on 2018/6/15.
//  Copyright © 2018年 PmMaster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImLbModel.h"
@interface ImageLabelCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconIm;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTop;
@property (retain, nonatomic)  ImLbModel *model;
@end
