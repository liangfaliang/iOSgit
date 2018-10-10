//
//  DoctorScheduleCollectionViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/20.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "DoctorScheduleCollectionViewCell.h"

@implementation DoctorScheduleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setBackcolor:(NSString *)backcolor{
    _backcolor = backcolor;
    if ([backcolor isEqualToString:@"JHBorderColor"]) {
        self.contentView.backgroundColor = JHBorderColor;
        self.timeLb.textColor = JHdeepColor;
        self.weekLb.textColor = JHmiddleColor;
        self.statusLb.textColor = JHsimpleColor;
        self.numLB.textColor = JHsimpleColor;
    }else if ([backcolor isEqualToString:@"JHMedicalColor"] ){
        self.contentView.backgroundColor = JHMedicalColor;
        self.timeLb.textColor = [UIColor whiteColor];
        self.weekLb.textColor = [UIColor whiteColor];
        self.statusLb.textColor = [UIColor whiteColor];
        self.numLB.textColor = [UIColor whiteColor];
    }else{
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.timeLb.textColor = JHdeepColor;
        self.weekLb.textColor = JHmiddleColor;
        self.statusLb.textColor = [UIColor whiteColor];
        self.numLB.textColor = [UIColor whiteColor];
    }

}
@end
