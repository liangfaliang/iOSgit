//
//  MHDatePicker.h
//  MHDatePicker
//
//  Created by LMH on 16/03/12.
//  Copyright (c) 2015年 LMH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHSelectPickerView.h"
@protocol MHSelectPickerViewDelegate;
typedef void (^DataTimeSelect)(NSDate *selectDataTime);

@interface MHDatePicker : UIView
@property (strong, nonatomic) NSDate *maxSelectDate;
///优先级低于isBeforeTime
@property (strong, nonatomic) NSDate *minSelectDate;

@property (strong, nonatomic) NSDate *selectDate;
@property (strong, nonatomic) NSString *Logo;//标识
//显示时间模式

@property (strong, nonatomic) NSString *Displaystr;//默认yyyy-MM-dd HH:mm:ss
///是否可选择当前时间之前的时间,默认为NO
@property (nonatomic,assign) BOOL isBeforeTime;

///DatePickerMode,默认是DateAndTime
@property (assign, nonatomic) UIDatePickerMode datePickerMode;

- (void)didFinishSelectedDate:(DataTimeSelect)selectDataTime;



//声明代理
@property(nonatomic,assign)id<MHSelectPickerViewDelegate> delegate;
@end
//声明协议方法
@protocol MHSelectPickerViewDelegate <NSObject>
@optional
- (void)timeString:(NSString *)timeString;
- (void)timeString:(MHDatePicker *)datePicker timeString:(NSString *)timeString date:(NSDate *)date;
@end
