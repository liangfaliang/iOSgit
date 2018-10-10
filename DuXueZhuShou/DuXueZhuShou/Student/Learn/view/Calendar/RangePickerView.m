//
//  RangePickerViewController.m
//  FSCalendar
//
//  Created by dingwenchao on 5/8/16.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import "RangePickerView.h"
#import "RangePickerCell.h"
#import "FSCalendarExtensions.h"
#define CalenderH 450
@interface RangePickerView () <FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>



@property (strong, nonatomic) UILabel *eventLabel;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSArray *monthArr;
@property (strong, nonatomic) NSArray *dayArr;
- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;

@end

@implementation RangePickerView
SYNTHESIZE_SINGLETON_FOR_CLASS(RangePickerView);
- (instancetype)init
{
    self = [super init];
    if (self) {
//        _isMany = YES;
        [self viewDidLoad];
        [self loadview];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        _isMany = YES;
        [self viewDidLoad];
        [self loadview];
        
    }
    return self;
}
-(void)refreshDate:(NSDate *)date1 date2:(NSDate *)date2{
    self.date1 = date1;
    self.date2 = date2;
    if (self.date1) [self.calendar deselectDate:self.date1];
    if (self.date2) [self.calendar deselectDate:self.date2];

//    [self configureVisibleCells];
    [self.calendar reloadData];
}

- (void)loadview
{
    _monthArr = [NSArray arrayWithObjects:
                @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                @"九月", @"十月", @"冬月", @"腊月", nil];
    
    _dayArr = [NSArray arrayWithObjects:
              @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
              @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
              @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    self.backgroundColor = [UIColor whiteColor];
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, CalenderH)];
    calendar.dataSource = self;
    calendar.delegate = self;
//    calendar.pagingEnabled = NO;
    calendar.allowsMultipleSelection = YES;
    calendar.rowHeight = 60;
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    [self addSubview:calendar];
    self.calendar = calendar;
    calendar.scrollDirection = FSCalendarScrollDirectionHorizontal;
    calendar.appearance.titleDefaultColor = [UIColor blackColor];
    calendar.appearance.headerTitleColor = [UIColor blackColor];
    calendar.appearance.titleFont = [UIFont systemFontOfSize:16];
    calendar.appearance.borderRadius = 0.1;
    calendar.appearance.selectionColor = JHAssistRedColor;
    calendar.allowsMultipleSelection = YES;
    
    calendar.swipeToChooseGesture.enabled = YES;
    
    calendar.today = nil; // Hide the today circle
    [calendar registerClass:[RangePickerCell class] forCellReuseIdentifier:@"cell"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    UIView *bottomview = [[UIView alloc]initWithFrame:CGRectMake(0, CalenderH, screenW, screenH - CalenderH)];
    [self addSubview:bottomview];
    [bottomview addGestureRecognizer:tap];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.calendar.frame = CGRectMake(0, 0, self.frame.size.width, CalenderH);

}
- (void)viewDidLoad
{

    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    // Uncomment this to perform an 'initial-week-scope'
    // self.calendar.scope = FSCalendarScopeWeek;
    
    // For UITest
    self.calendar.accessibilityIdentifier = @"calendar";
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}
//是否为同一天
- (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
//    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
//    NSDateComponents* comp1 = [self.gregorian components:unitFlags fromDate:date1];
//    NSDateComponents* comp2 = [self.gregorian components:unitFlags fromDate:date2];
//    return [comp1 day] == [comp2 day] && [comp1 month] == [comp2 month] && [comp1 year]  == [comp2 year];
    return [[self.dateFormatter stringFromDate:date1] isEqualToString:[self.dateFormatter stringFromDate:date2]];
}

#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:@"1970-01-01"];
//    return [NSDate date];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:12 toDate:[NSDate date] options:0];
}
- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    unsigned unitFlags =  NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *monthStr = [_monthArr objectAtIndex:localeComp.month-1];
    NSString *dayString = [_dayArr objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str;
    if ([dayString isEqualToString:@"初一"]) {
        chineseCal_str = monthStr;
    } else {
        chineseCal_str = dayString;
    }
    return chineseCal_str;
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @"今";
    }
    return nil;
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    RangePickerCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

#pragma mark - FSCalendarDelegate

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did deselect date %@",[self.dateFormatter stringFromDate:date]);
    if (self.isMany) {
        for (NSDate *temDate in self.SigndateArr) {
            if ([self isSameDay:temDate date2:date]) {
                return monthPosition == FSCalendarMonthPositionCurrent;
            }
        }
        return NO;
    }
    return monthPosition == FSCalendarMonthPositionCurrent;
}
-(UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date{
    if (self.isMany) {
        for (NSDate *temDate in self.SigndateArr) {
            if ([self isSameDay:temDate date2:date]) {
                return JHMaincolor;
            }
        }
    }
    return nil;
}
-(UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date{
    if (self.isMany) {
        for (NSDate *temDate in self.SigndateArr) {
            if ([self isSameDay:temDate date2:date]) {
                return [UIColor whiteColor];
            }
        }
    }
    return nil;
}
-(UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleDefaultColorForDate:(NSDate *)date{
    if (self.isMany) {
        for (NSDate *temDate in self.SigndateArr) {
            if ([self isSameDay:temDate date2:date]) {
                return [UIColor whiteColor];
            }
        }
    }
    return nil;
}
- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return YES;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    if (!self.isMany) {
        NSArray *arrSelect = [calendar selectedDates];
        for (NSDate *Sedate in arrSelect) {
            if (Sedate == date) {
                [calendar selectDate:date];
            }else{
                [calendar deselectDate:Sedate];
            }
        }
        [self removeFromSuperview];
    }
//    NSArray *arrSelect = [calendar selectedDates];
//    for (NSDate *Sedate in arrSelect) {
//        if (Sedate == date) {
//            [calendar deselectDate:date];
//        }
//    }
//    if (!self.isMany) {
//        if (self.date1 ) [calendar deselectDate:self.date1];
//        self.date1 = date;
//        [self removeFromSuperview];
//        if (self.clickBlock) self.clickBlock(date, self.date2);
//    }else{
//        if (calendar.swipeToChooseGesture.state == UIGestureRecognizerStateChanged) {
//            // If the selection is caused by swipe gestures
//
//            if (!self.date1) {
//                self.date1 = date;
//            } else {
//                if (self.date2) {
//                    [calendar deselectDate:self.date2];
//                }
//                self.date2 = date;
//            }
//        } else {
//            if (self.date2) {
//                [calendar deselectDate:self.date1];
//                [calendar deselectDate:self.date2];
//                self.date1 = date;
//                self.date2 = nil;
//            } else if (!self.date1) {
//                self.date1 = date;
//            } else {
//                self.date2 = date;
//            }
//        }
//
//    }

//    [self configureVisibleCells];

    
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did deselect date %@",[self.dateFormatter stringFromDate:date]);
//    [self configureVisibleCells];
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @[[UIColor orangeColor]];
    }
    return @[appearance.eventDefaultColor];
}

#pragma mark - Private methods

- (void)configureVisibleCells
{
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}

- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position
{
    RangePickerCell *rangeCell = cell;
    if (position != FSCalendarMonthPositionCurrent) {
        rangeCell.middleLayer.hidden = YES;
        rangeCell.selectionLayer.hidden = YES;
        return;
    }
    if (self.isMany) {
        if (self.date1 && self.date2) {
            // The date is in the middle of the range
            BOOL isMiddle = [date compare:self.date1] != [date compare:self.date2];
            rangeCell.middleLayer.hidden = !isMiddle;
        } else {
            rangeCell.middleLayer.hidden = YES;
        }
        BOOL isSelected = NO;
        isSelected |= self.date1 && [self.gregorian isDate:date inSameDayAsDate:self.date1];
        isSelected |= self.date2 && [self.gregorian isDate:date inSameDayAsDate:self.date2];
        rangeCell.selectionLayer.hidden = !isSelected;
    }else{
        rangeCell.middleLayer.hidden = YES;
        BOOL isSelected = NO;
        isSelected |= self.date1 && [self.gregorian isDate:date inSameDayAsDate:self.date1];
        rangeCell.selectionLayer.hidden = !isSelected;
    }

}
-(void)tapClick{
    [self removeFromSuperview];

}
-(void)didMoveToSuperview{
    if (self.superview == nil) {
        if (self.selectDateBlock) {
            self.selectDateBlock([self.calendar selectedDates]);
        }
    }
}
@end
