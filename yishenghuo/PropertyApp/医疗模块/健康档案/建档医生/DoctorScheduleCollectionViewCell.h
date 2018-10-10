//
//  DoctorScheduleCollectionViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/20.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorScheduleCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *numLB;
@property (weak, nonatomic) IBOutlet UILabel *weekLb;
@property (copy, nonatomic) NSString *backcolor;
@end
