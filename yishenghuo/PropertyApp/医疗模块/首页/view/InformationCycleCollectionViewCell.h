//
//  InformationCycleCollectionViewCell.h
//  PropertyApp
//
//  Created by admin on 2018/7/25.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYLabel.h"
@interface InformationCycleCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconIm;
@property (weak, nonatomic) IBOutlet YYLabel *label1;
@property (weak, nonatomic) IBOutlet YYLabel *label2;
-(void)labelSetText:(NSString *)title tag:(NSString *)tag index:(int)index;
@end
