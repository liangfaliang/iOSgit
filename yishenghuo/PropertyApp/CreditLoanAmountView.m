//
//  CreditLoanAmountView.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/5/10.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "CreditLoanAmountView.h"
#include <math.h>
@implementation CreditLoanAmountView


-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.oneYearBtn setTitleColor:JHColor(0, 169, 224) forState:UIControlStateSelected];
    [self.towYearBtn setTitleColor:JHColor(0, 169, 224) forState:UIControlStateSelected];
    [self.threeYaerBtn setTitleColor:JHColor(0, 169, 224) forState:UIControlStateSelected];
    [self.MonthlyBtn setTitleColor:JHColor(0, 169, 224) forState:UIControlStateSelected];
    [self.YearBtn setTitleColor:JHColor(0, 169, 224) forState:UIControlStateSelected];
    self.oneYearBtn.layer.cornerRadius = 3;
    self.towYearBtn.layer.cornerRadius = 3;
    self.threeYaerBtn.layer.cornerRadius = 3;
    self.MonthlyBtn.layer.cornerRadius = 3;
    self.YearBtn.layer.cornerRadius = 3;
    
    self.oneYearBtn.layer.borderColor = [JHmiddleColor CGColor];
    self.towYearBtn.layer.borderColor = [JHmiddleColor CGColor];
    self.threeYaerBtn.layer.borderColor = [JHmiddleColor CGColor];
    self.MonthlyBtn.layer.borderColor = [JHmiddleColor CGColor];
    self.YearBtn.layer.borderColor = [JHmiddleColor CGColor];
    
    self.oneYearBtn.selected = YES;
    self.oneYearBtn.layer.borderColor = [JHColor(0, 169, 224) CGColor];
    self.MonthlyBtn.selected = YES;
    self.MonthlyBtn.layer.borderColor = [JHColor(0, 169, 224) CGColor];
    [self.slider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    self.limitLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size:21];
    
    UIImage *thumbImageNormal = [UIImage imageNamed:@"huadongquan"];
    [self.slider setThumbImage:thumbImageNormal forState:UIControlStateNormal];
    
    //设置结点左边背景
    UIImage *trackLeftImage = [[UIImage imageNamed:@"chengsetiao"]resizableImageWithCapInsets:UIEdgeInsetsZero];
    [self.slider setMinimumTrackImage:trackLeftImage forState:UIControlStateNormal];
    
    //设置结点右边背景
    UIImage *trackRightImage = [[UIImage imageNamed:@"qiansetiao"]resizableImageWithCapInsets:UIEdgeInsetsZero];
    [self.slider setMaximumTrackImage:trackRightImage forState:UIControlStateNormal];
    
}
- (IBAction)termBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    for (int i = 0; i < 3; i ++) {
        UIButton *allbt = [self viewWithTag:11 + i];
        if (allbt.tag != btn.tag) {
            allbt.selected = NO;
            allbt.layer.borderColor = [JHColor(51, 51, 51) CGColor];
            
        }
    }
    btn.selected = YES;
    btn.layer.borderColor = [JHColor(0, 169, 224) CGColor];
    if (self.termBlock) {
        self.termBlock(btn);
    }
    [self valueChange:self.slider];
}
- (IBAction)mannerBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    for (int i = 0; i < 2; i ++) {
        UIButton *allbt = [self viewWithTag:14 + i];
        if (allbt.tag != btn.tag) {
            allbt.selected = NO;
            allbt.layer.borderColor = [JHColor(51, 51, 51) CGColor];
            
        }
    }
    btn.selected = YES;
    btn.layer.borderColor = [JHColor(0, 169, 224) CGColor];
    if (self.mannerBlock) {
        self.mannerBlock(btn);
    }
    [self valueChange:self.slider];
}
-(void)valueChange:(UISlider *)sender{

    long value = sender.value * 250000 + 50000;
    self.limitLabel.text  = [NSString stringWithFormat:@"￥%ld.00",value];
    NSInteger yearCount = 1;
    for (int i = 0; i < 3; i ++) {
        UIButton *allbt = [self viewWithTag:11 + i];
        if (allbt.selected) {
            yearCount = allbt.tag - 10;
        }
    }
    double sum = 0;
    if (self.MonthlyBtn.selected) {
        sum = value * (1 + 0.08 * yearCount);
    }else if (self.YearBtn.selected){
        
        double Number = 12.0;
        LFLog(@"value:%f",Number);
        double interest = ((double)((value * (double)(0.08/Number) * pow((1 + (double)(0.08/Number)),Number))/((pow((1 + (double)(0.08/Number)),Number)) - 1)) * Number) - value;//每年的利息
        sum = interest * yearCount + value;
    }
    self.interestLb.text  = [NSString stringWithFormat:@"￥%.2f",sum];
}

@end
