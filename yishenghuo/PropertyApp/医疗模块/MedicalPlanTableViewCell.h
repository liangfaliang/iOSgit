//
//  MedicalPlanTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/11.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"
#import "DottedView.h"
@interface MedicalPlanTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *weekLb;
@property (weak, nonatomic) IBOutlet UIButton *laveTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *yuyueBtn;
@property (weak, nonatomic) IBOutlet UIView *vline;
@property (weak, nonatomic) IBOutlet DottedView *dashedView;
@property (weak, nonatomic) IBOutlet YYLabel *yyLb;
@property (weak, nonatomic) IBOutlet UIImageView *redIm;

@end
