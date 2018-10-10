//
//  JWTextCell.h
//  应用教程
//
//  Created by 黄金卫 on 16/4/10.
//  Copyright © 2016年 黄金卫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"
@interface JWTextCell : UICollectionViewCell

@property (nonatomic, copy) NSString  * placeHolderImageName;

@property (nonatomic, strong) YYLabel * labelView;


@end
