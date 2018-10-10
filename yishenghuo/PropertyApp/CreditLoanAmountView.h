//
//  CreditLoanAmountView.h
//  PropertyApp
//
//  Created by 梁法亮 on 17/5/10.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CALayer+CALayer_XibCgcolor.h"
@interface CreditLoanAmountView : UIView
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *oneYearBtn;
@property (weak, nonatomic) IBOutlet UIButton *towYearBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeYaerBtn;
@property (weak, nonatomic) IBOutlet UIButton *MonthlyBtn;
@property (weak, nonatomic) IBOutlet UIButton *YearBtn;
@property (weak, nonatomic) IBOutlet UILabel *interestLb;

@property(nonatomic,copy)void (^termBlock)(UIButton *btn) ;
@property(nonatomic,copy)void (^mannerBlock)(UIButton *btn) ;
@end


