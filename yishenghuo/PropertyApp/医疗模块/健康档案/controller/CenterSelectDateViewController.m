//
//  CenterSelectDateViewController.m
//  PropertyApp
//
//  Created by admin on 2018/7/26.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "CenterSelectDateViewController.h"
#import "MHDatePicker.h"
@interface CenterSelectDateViewController ()<MHSelectPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backviewTop;

@end

@implementation CenterSelectDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationBarTitle = @"选择建档日期";
    self.backviewTop.constant = NaviH;
    UITapGestureRecognizer *itemTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Tapclick)];
    [self.backView addGestureRecognizer:itemTap];
    self.timeLb.text = @"请选择";
}

- (void)Tapclick {
     MHDatePicker*selectTimePicker = [[MHDatePicker alloc] init];
    selectTimePicker.Displaystr =@"yyyy-MM-dd";
    selectTimePicker.delegate = self;
    selectTimePicker.datePickerMode = UIDatePickerModeDate;
}
#pragma mark - 时间回传值
- (void)timeString:(NSString *)timeString
{
    long time;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromdate=[format dateFromString:timeString];
    time= (long)[fromdate timeIntervalSince1970];
    self.timeLb.text = timeString;
    if (self.SelectBlock) {
        self.SelectBlock(timeString,[NSString stringWithFormat:@"%ld",time]);
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
