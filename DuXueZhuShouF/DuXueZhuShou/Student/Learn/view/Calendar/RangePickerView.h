//
//  RangePickerViewController.h
//  FSCalendar
//
//  Created by dingwenchao on 5/8/16.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
@interface RangePickerView : UIView
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(RangePickerView);
@property (strong, nonatomic) FSCalendar *calendar;
@property(nonatomic,copy)void (^clickBlock)(NSDate *beginDate,NSDate *endDate);
// The start date of the range
@property (strong, nonatomic) NSDate *date1;
// The end date of the range
@property (strong, nonatomic) NSArray *SigndateArr;
@property (strong, nonatomic) NSDate *date2;
@property (assign, nonatomic) BOOL isMany;//是否多选
@property (nonatomic,copy)void (^selectDateBlock) (NSArray<NSDate *> *dateArr);
-(void)refreshDate:(NSDate *)date1 date2:(NSDate *)date2;
@end
