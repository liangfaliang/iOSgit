//
//  RangePickerCell.m
//  FSCalendar
//
//  Created by dingwenchao on 02/11/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import "RangePickerCell.h"
#import "FSCalendarExtensions.h"

@implementation RangePickerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        CALayer *selectionLayer = [[CALayer alloc] init];
//        selectionLayer.backgroundColor = [UIColor orangeColor].CGColor;
//        selectionLayer.actions = @{@"hidden":[NSNull null]}; // Remove hiding animation
//        [self.contentView.layer insertSublayer:selectionLayer below:self.titleLabel.layer];
//        self.selectionLayer = selectionLayer;
//
//        CALayer *middleLayer = [[CALayer alloc] init];
//        middleLayer.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3].CGColor;
//        middleLayer.actions = @{@"hidden":[NSNull null]}; // Remove hiding animation
//        [self.contentView.layer insertSublayer:middleLayer below:self.titleLabel.layer];
//        self.middleLayer = middleLayer;
//
//        // Hide the default selection layer
//        self.shapeLayer.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
//    CGFloat ww = (self.contentView.bounds.size.width > self.contentView.bounds.size.height ? self.contentView.bounds.size.height :self.contentView.bounds.size.width);
//    self.selectionLayer.frame = CGRectMake(0, 0, ww, ww);
//    self.middleLayer.frame = CGRectMake(0, 0, ww, ww);
//
//    self.selectionLayer.cornerRadius = ww/2;
//    self.selectionLayer.masksToBounds = YES;
//    self.middleLayer.cornerRadius = ww/2;
//    self.middleLayer.masksToBounds = YES;
}

@end
