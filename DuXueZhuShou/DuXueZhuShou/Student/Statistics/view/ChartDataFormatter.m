//
//  ChartDataFormatter.m
//  DuXueZhuShou
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ChartDataFormatter.h"

@implementation ChartDataFormatter
- (NSString *)stringForValue:(double)value entry:(ChartDataEntry *)entry dataSetIndex:(NSInteger)dataSetIndex viewPortHandler:(ChartViewPortHandler *)viewPortHandler
{
    if (value ==  0) {
        return @"";
    }else{
//        NSNumberFormatter *moneyFormatter = [[NSNumberFormatter alloc] init];
//        moneyFormatter.positiveFormat = @"###,##0";
//        NSString *formatString = [moneyFormatter stringFromNumber:[NSNumber numberWithDouble:value]];
        return entry.data ? [NSString stringWithFormat:@"%@(%.f%%)",entry.data,value] : [NSString stringWithFormat:@"%.f",value];
    }
}
@end
