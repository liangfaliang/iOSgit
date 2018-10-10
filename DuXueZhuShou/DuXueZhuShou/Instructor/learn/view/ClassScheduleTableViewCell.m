//
//  ClassScheduleTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/15.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ClassScheduleTableViewCell.h"

@implementation ClassScheduleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tfOutClass.delegate = self;
    self.tfInClass.delegate = self;
    self.tfMin.delegate = self;
    [self.tfMin addTarget:self action:@selector(tfMinDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.PunchBtn setImage:[UIImage imageNamed:@"choosed"] forState:UIControlStateSelected];
}
-(void)setModel:(ScheduleModel *)model{
    _model = model;
    self.weekLb.text = model.week;
    self.tfInClass.text = model.lesson_start_time;
    self.tfOutClass.text = model.lesson_end_time;
    self.tfMin.text = model.minimum_time;
    self.PunchBtn.selected = !model.sign_out;
}
-(void)tfMinDidChange :(UITextField *)TextField{
    if (self.model.lesson_end_time.length) {
        NSArray *IntemArr = [self.model.lesson_start_time componentsSeparatedByString:@":"];
        NSInteger Intotal = [IntemArr.firstObject integerValue]*60 + [IntemArr.lastObject integerValue];
        NSArray *OuttemArr = [self.model.lesson_end_time componentsSeparatedByString:@":"];
        NSInteger Outtotal = [OuttemArr.firstObject integerValue]*60 + [OuttemArr.lastObject integerValue];
        if ([TextField.text integerValue] > Outtotal - Intotal) {
            TextField.text = nil;
            [AlertView showMsg:@"最低学习时长不得大于上课到下课之间的总时长"];
            return;
        }
    }
    if (self.model) self.model.minimum_time = TextField.text;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.tfInClass || textField == self.tfOutClass) {
        if (textField == self.tfOutClass && !self.model.lesson_start_time.length) {
            [AlertView showMsg:@"请先选择上课时间！"];
            return NO;
        }
        [self endEditing:YES];
        UIViewController *vc = [self viewController];
        PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:vc.view.bounds];
        picker.tag = textField == self.tfInClass ? 1 : 2;
        picker.inter =1;
        picker.titlestr = @"";
        picker.arrayType = GenderArray;
        picker.delegate = self;
        for (int k = 0 ; k < 24; k ++) {
            [picker.provinceArr addObject:[NSString stringWithFormat:@"%02d",k]];
        }
        [vc.view addSubview:picker];
        return NO;
    }
    if (!self.model.lesson_start_time.length) {
        [AlertView showMsg:@"请先选择上课时间！"];
        return NO;
    }
    if (self.model.sign_out == 1 && !self.model.lesson_end_time.length) {
        [AlertView showMsg:@"请先选择下课时间！"];
        return NO;
    }
    return YES;
}
#pragma mark -------- TFPickerDelegate
-(void)PickerSelectorIndixString:(id)picker str:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    PickerChoiceView *pickerview = (PickerChoiceView *)picker;
    [pickerview.cityArr removeAllObjects];
    for (int k = 0 ; k < 59; k ++) {
        [pickerview.cityArr addObject:[NSString stringWithFormat:@"%02d",k]];
    }
//    [picker reloadcomment:1];

}

- (void)provinceSelectorIndixString:(PickerChoiceView *)picker str:(NSString *)pricent city:(NSString *)city{
    LFLog(@"%@=====%@",pricent,city);
    NSString *str = [NSString stringWithFormat:@"%@:%@",pricent,city];
    if (picker.tag == 1) {
        self.tfInClass.text = str;
        self.model.lesson_start_time = str;
    }else{
        NSArray *temArr = [self.model.lesson_start_time componentsSeparatedByString:@":"];
        NSInteger Intotal = [temArr.firstObject integerValue]*60 + [temArr.lastObject integerValue];
        NSInteger Outtotal = [pricent integerValue]*60 + [city integerValue];
        if (Outtotal <= Intotal) {
            [AlertView showMsg:@"下课时间必须大于上课时间！"];
            return;
        }
        self.model.lesson_end_time = str;
        self.tfOutClass.text = str;
        self.PunchBtn.selected = NO;
        self.model.sign_out = 1;
    }
}
- (IBAction)btnClick:(UIButton *)sender {
    if (!self.model.lesson_start_time.length) {
        [AlertView showMsg:@"请先选择上课时间！"];
        return ;
    }
    sender.selected = ! sender.selected;
    if (sender.selected) {
        self.model.lesson_end_time = nil;
        self.tfOutClass.text = nil;
    }
    self.model.sign_out = !sender.selected;
    if (self.PunchBtnBlock) {
        self.PunchBtnBlock(sender.selected);
    }
}

@end
