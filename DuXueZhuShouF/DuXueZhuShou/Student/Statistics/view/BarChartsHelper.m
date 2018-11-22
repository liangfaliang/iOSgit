//
//  BarChartsHeloper.m
//  sanbanhuiHelper
//
//  Created by WorkMac on 2017/4/4.
//  Copyright © 2017年 BeijingKaiFengData. All rights reserved.
//
#import "BarChartsHelper.h"
#import "DuXueZhuShou-Swift.h"
#import "ChartDataFormatter.h"
@interface lineYDataFormatter : NSObject
<IChartValueFormatter>

@end
@implementation lineYDataFormatter
- (NSString *)stringForValue:(double)value entry:(ChartDataEntry *)entry dataSetIndex:(NSInteger)dataSetIndex viewPortHandler:(ChartViewPortHandler *)viewPortHandler
{
    if (value ==  0) {
        return @"";
    }else{
        return entry.data ? [NSString stringWithFormat:@"%.f",value] : [NSString stringWithFormat:@"%.f",value];
    }
}
@end

@interface BarChartsHelper ()
@property (nonatomic, strong) UIView *MaskView;
@property (nonatomic, strong) UILabel *markDataLB;
@property (nonatomic,strong) UILabel * markY;
@end
@implementation BarChartsHelper

//单柱
- (void)setBarChart:(BarChartView *)barChart xValues:(NSArray *)xValues yValues:(NSArray *)yValues barTitle:(NSString *)bar
{
    BarChartData *data = [self generateBarChartData:yValues title:bar barColor:[UIColor colorFromHexCode:@"FFB6C1"]];
    if (barChart.data) {
        barChart.data = data;
        return;
    }
    barChart.data = data;
    _months = xValues;
    barChart.noDataText = @"暂无数据";//没有数据时的文字提示
    barChart.chartDescription.enabled = NO;
    barChart.drawValueAboveBarEnabled = YES;//数值显示在柱形的上面还是下面
    //   barChart.drawh = NO;//点击柱形图是否显示箭头
    barChart.drawBarShadowEnabled = NO;//是否绘制柱形的阴影背景
    barChart.drawBordersEnabled = NO;
//    barChart.borderColor = [UIColor colorWithRGBHex:0xaaaaaa];
    //2.barChartView的交互设置
    barChart.scaleYEnabled = NO;//取消Y轴缩放
    barChart.doubleTapToZoomEnabled = NO;//取消双击缩放
    barChart.dragEnabled = YES;//启用拖拽图表
    barChart.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
    barChart.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    
//    [barChart setDescriptionText:@""];
    barChart.drawGridBackgroundEnabled = YES;
    barChart.gridBackgroundColor = [UIColor whiteColor];
    barChart.legend.enabled = NO;//不显示图例
    barChart.marker = [[ChartMarkerView alloc] init];
    
    //X轴设置
//    ChartXAxis *xAxis = barChart.xAxis;
//    xAxis.labelPosition = XAxisLabelPositionBottom;
//    xAxis.drawGridLinesEnabled = NO;
//    xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:xValues];
//    xAxis.labelFont = [UIFont systemFontOfSize:10];
//    xAxis.labelCount = xValues.count;
//    xAxis.labelRotationAngle = -40;
//    xAxis.yOffset = 10;
//    xAxis.drawAxisLineEnabled = YES;
    
    ChartXAxis *xAxis = barChart.xAxis;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.yOffset = 10;
    //    xAxis.labelFont = [UIFont systemFontOfSize:6];
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.axisMinimum = 0.0;
    xAxis.axisMaximum = 13.0;
    xAxis.granularity = 1.0;//粒度
    xAxis.valueFormatter = self;
    xAxis.labelCount = self.months.count ;
    
    //Y轴设置
    ChartYAxis *leftAxis = barChart.leftAxis;
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.drawGridLinesEnabled = YES;
    leftAxis.spaceTop = 0.1;
    leftAxis.axisMinimum = 0;
    leftAxis.labelFont = [UIFont systemFontOfSize:14];
    leftAxis.labelTextColor = JHdeepColor;
    barChart.rightAxis.enabled = NO;
    
    //设置图例
//    ChartLegend *legend = barChart.legend;
//
//    legend.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
//    legend.verticalAlignment = ChartLegendVerticalAlignmentBottom;
//    legend.orientation = ChartLegendOrientationHorizontal;
//    legend.drawInside = YES;
//    legend.direction = ChartLegendDirectionLeftToRight;
//    legend.form = ChartLegendFormSquare;
//    legend.formSize = 10;
//    legend.font = [UIFont systemFontOfSize:10];
//    legend.textColor = [UIColor colorFromHexCode:@"FFB6C1"];
//    legend.xOffset = -15;
    
    barChart.extraBottomOffset = 10;
    barChart.extraTopOffset = 10;
    barChart.fitBars = YES;
    

    xAxis.axisMinimum = data.xMin - 0.7f;
    xAxis.axisMaximum = data.xMax + 0.7f;
    //Y轴动画
    [barChart animateWithYAxisDuration:1.0];
}
- (BarChartData *)generateBarChartData:(NSArray *)yValues title:(NSString *)title barColor:(UIColor *)barColor
{
    if (!yValues.count) {
        return nil;
    }
    NSMutableArray *entries = [NSMutableArray array];
    NSMutableArray *colorArr = [NSMutableArray array];
    for (int i =0; i<yValues.count; i++) {
        BarChartDataEntry *barEntry = [[BarChartDataEntry alloc] initWithX:i y:[[yValues[i] isKindOfClass:[NSDictionary class]] ? yValues[i][Cyvalue] : yValues[i] doubleValue]];
        [entries addObject:barEntry];
        if ([yValues[i] isKindOfClass:[NSDictionary class]] && [yValues[i][Cpercent] length]) {
            barEntry.data = yValues[i][Cpercent];
        }
        [colorArr addObject:[UIColor colorFromHexCode:[yValues[i] isKindOfClass:[NSDictionary class]] ? yValues[i][Ccolor] : @"FFB6C1"]];
    }
    BarChartDataSet *set2 = [[BarChartDataSet alloc] initWithValues:entries label:title];
    set2.drawValuesEnabled = YES;//是否在柱形图上面显示数值
    set2.highlightEnabled = NO;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
    set2.colors = colorArr;

    BarChartData *data = [[BarChartData alloc] initWithDataSet:set2];
    data.barWidth = 0.5;
    
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    //自定义数据显示格式
    [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numFormatter setPositiveFormat:@"#0.00"];
//    ChartDefaultValueFormatter *formatter1 = [[ChartDefaultValueFormatter alloc] initWithFormatter:numFormatter];
    ChartDataFormatter * formatter = [[ChartDataFormatter alloc]init];
    [data setValueFormatter:formatter];
    [data setValueFont:[UIFont systemFontOfSize:13]];
    [data setValueTextColor:JHdeepColor];
    
    return data;
}
/**
 单个折线图的显示
 */
- (void)setLineChart:(LineChartView *)lineChart xValues:(NSArray *)xValues yValues:(NSArray *)yValues barTitle:(NSString *)bar{
    _months = xValues;
    lineChart.delegate = self;
    lineChart.chartDescription.enabled = NO;
    lineChart.dragEnabled = YES;
    [lineChart setScaleEnabled:YES];
    lineChart.pinchZoomEnabled = YES;
    lineChart.drawGridBackgroundEnabled = NO;
    lineChart.legend.enabled = NO;//不显示图例
    lineChart.noDataText = @"暂无数据";//没有数据时的文字提示
//    lineChart.xAxis.gridLineDashLengths = @[@10.0, @10.0];
//    lineChart.xAxis.gridLineDashPhase = 0.f;
    lineChart.xAxis.drawGridLinesEnabled = NO;//是否画网格线；
    lineChart.xAxis.labelPosition = XAxisLabelPositionBottom;
    lineChart.xAxis.granularity = 1;//粒度
    lineChart.xAxis.axisMinimum  = 0;//
    lineChart.xAxis.axisMaxLabels = self.months.count ? self.months.count: 1 ;
    lineChart.xAxis.valueFormatter = self;
    lineChart.xAxis.labelCount = self.months.count ;
    ChartYAxis *leftAxis = lineChart.leftAxis;
    [leftAxis removeAllLimitLines];
//    leftAxis.axisMaximum = 200.0;
    leftAxis.axisMinimum = 0.0;
//    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawZeroLineEnabled = NO;
//    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    lineChart.rightAxis.enabled = NO;

    //[_chartView.viewPortHandler setMaximumScaleY: 2.f];
    //[_chartView.viewPortHandler setMaximumScaleX: 2.f];
    XYMarkerView *marker = [[XYMarkerView alloc]
                            initWithColor: JHMaincolor
                            font: [UIFont systemFontOfSize:12.0]
                            textColor: UIColor.whiteColor
                            insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)
                            xAxisValueFormatter: lineChart.leftAxis.valueFormatter];
    marker.chartView = lineChart;
    marker.minimumSize = CGSizeMake(80.f, 40.f);
    lineChart.marker = marker;
//    lineChart.legend.form = ChartLegendFormLine;
    lineChart.data = [self getLineDataCount:yValues];

    [lineChart animateWithXAxisDuration:1];
}
- (LineChartData *)getLineDataCount:(NSArray *)yValues
{
    if (!yValues.count) {
        return nil;
    }
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (int i =0; i<yValues.count; i++) {
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[[yValues[i] isKindOfClass:[NSDictionary class]] ? yValues[i][Cyvalue] : yValues[i] doubleValue] icon: [UIImage imageNamed:@"icon"]];
        if ([yValues[i] isKindOfClass:[NSDictionary class]] && [yValues[i][Cpercent] length]) {
            entry.data = yValues[i][Cpercent];
        }
        [values addObject:entry];
    }
    LineChartDataSet *set1 = nil;
    set1 = [[LineChartDataSet alloc] initWithValues:values label:@""];

//    set1.lineDashLengths = @[@5.f, @2.5f];
//    set1.highlightLineDashLengths = @[@5.f, @2.5f];

    set1.circleRadius = 5.0f;//拐点半径
    [set1 setColor:JHMaincolor];
    [set1 setCircleColor:JHMaincolor];
    set1.drawCircleHoleEnabled = YES;
    set1.circleHoleRadius = 3.0f;//空心的半径
    set1.circleHoleColor = [UIColor whiteColor];//空心的颜色
    set1.lineWidth = 1.0;

    
//    set1.drawIconsEnabled = YES;//是否用图片
    set1.valueFont = [UIFont systemFontOfSize:9.f];
//    set1.formLineDashLengths = @[@5.f, @2.5f];
    set1.formLineWidth = 1.0;
    set1.formSize = 15.0;

    NSArray *gradientColors = @[
                                (id)JHColor(230, 241, 255).CGColor,
                                (id)JHColor(247, 250, 255).CGColor
                                ];
    CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
    
    set1.fillAlpha = 0.5f;
    set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
    set1.drawFilledEnabled = YES;
    
    CGGradientRelease(gradient);
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1 ];
    LineChartData *data =[[LineChartData alloc] initWithDataSets:dataSets];
    //自定义数据显示格式
     [data setValueFormatter:[[lineYDataFormatter alloc]init]];
    return  data;
}
//单柱和折线组合
- (void)setBarChart:(CombinedChartView *)combineChart lineValues:(NSArray *)lineValues xValues:(NSArray *)xValues yValues:(NSArray *)yValues lineTitle:(NSString *)lineTitle barTitle:(NSString *)barTitle
{
//    combineChart.descriptionText = @"";
    combineChart.pinchZoomEnabled = NO;
    combineChart.marker = [[ChartMarkerView alloc] init];
    combineChart.drawOrder = @[@0,@0,@2];//设置绘制顺序CombinedChartDrawOrderBar,CombinedChartDrawOrderLine
    combineChart.doubleTapToZoomEnabled = NO;//取消双击放大
    combineChart.scaleYEnabled = NO;
    combineChart.dragEnabled = YES;//启用拖拽图表
    combineChart.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
    combineChart.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    combineChart.drawValueAboveBarEnabled = YES;
    combineChart.highlightPerTapEnabled = NO;//取消单击高亮显示
    combineChart.highlightPerDragEnabled = NO;
    combineChart.drawGridBackgroundEnabled = YES;
    combineChart.gridBackgroundColor = [UIColor whiteColor];
    combineChart.drawBordersEnabled = NO;
    combineChart.userInteractionEnabled = NO;
    combineChart.rightAxis.enabled = NO;
    
    //X轴设置
    ChartXAxis *xAxis = combineChart.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:xValues];
    xAxis.labelFont = [UIFont systemFontOfSize:10];
    xAxis.labelCount = xValues.count;
    xAxis.labelRotationAngle = -40;
    xAxis.yOffset = 10;
    xAxis.drawAxisLineEnabled = YES;

    //左侧Y轴设置
    ChartYAxis *leftAxis = combineChart.leftAxis;
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.drawGridLinesEnabled = YES;
    
//    float yMin = [[yValues valueForKeyPath:@"@min.floatValue"] floatValue];
//    float yMax = [[yValues valueForKeyPath:@"@max.floatValue"] floatValue];
//    if (yMin<0) {
//        yMin = yMin*1.3;
//    }else
//        yMin = yMin*0.8;
//    
//    if (yMax>=0) {
//        yMax = yMax*1.3;
//    }else
//        yMax = 0;
//    leftAxis.axisMinimum = yMin;
//    leftAxis.axisMaximum = yMax;
    
    //右侧Y轴
//    ChartYAxis *rightAxis = combineChart.rightAxis;
//    rightAxis.labelPosition = YAxisLabelPositionOutsideChart;
//    rightAxis.drawGridLinesEnabled = NO;
//    float y1Min = [[lineValues valueForKeyPath:@"@min.floatValue"] floatValue];
//    float y1Max = [[lineValues valueForKeyPath:@"@max.floatValue"] floatValue];
//    if (y1Min<0) {
//        y1Min = y1Min*1.3;
//    }else
//        y1Min = y1Min*0.8;
//    
//    if (y1Max>=0) {
//        y1Max = y1Max*1.3;
//    }else
//        y1Max = 0;
//    rightAxis.axisMinimum = y1Min;
//    rightAxis.axisMaximum = y1Max;
//    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
//    //自定义数据显示格式
//    [numFormatter setNumberStyle:NSNumberFormatterPercentStyle];
//    [numFormatter setPositiveFormat:@"#%/100"];
//    
//    ChartDefaultAxisValueFormatter *formatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:numFormatter];
//    rightAxis.valueFormatter = formatter;
    //设置图例
    ChartLegend *legend = combineChart.legend;
    legend.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
    legend.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    legend.orientation = ChartLegendOrientationHorizontal;
    legend.drawInside = YES;
    legend.direction = ChartLegendDirectionLeftToRight;
    legend.form = ChartLegendFormSquare;
    legend.formSize = 10;
    legend.font = [UIFont systemFontOfSize:10];
    legend.textColor = [UIColor colorFromHexCode:@"FFB6C1"];
    legend.xOffset = -15;
    
    CombinedChartData *data = [[CombinedChartData alloc] init];
//    data.lineData = [self generateLineData:lineValues lineTitle:lineTitle lineColor:[UIColor colorWithRGBHex:0xffc12d]];
    
    data.barData = [self generateBarChartData:yValues title:barTitle barColor:[UIColor colorFromHexCode:@"FFB6C1"]];
    combineChart.data = data;
    
    xAxis.axisMinimum = data.xMin - 0.7f;
    xAxis.axisMaximum = data.xMax + 0.7f;
    combineChart.extraBottomOffset = 30;
    combineChart.extraTopOffset = 30;
    [combineChart animateWithYAxisDuration:1.0];
}

//双柱和折线组合
- (void)setCombineBarChart:(CombinedChartView *)combineChart xValues:(NSArray *)xValues lineValues:(NSArray *)lineValues barValues:(NSArray *)baValues{
    combineChart.delegate = self;
    yrMax = 0;
    _months = xValues;
    CombinedChartData *data = [[CombinedChartData alloc] init];
    data.lineData = [self generateLineData:lineValues];
    data.barData = [self generateCombineBarData:baValues];
//    combineChart.descriptionText = @"";
    combineChart.chartDescription.enabled = NO;
    
//    combineChart.chartDescription.enabled = NO;
    combineChart.drawGridBackgroundEnabled = NO;
    combineChart.drawBarShadowEnabled = NO;
    combineChart.highlightFullBarEnabled = YES;
    combineChart.drawOrder = @[
                             @(CombinedChartDrawOrderBar),
                             @(CombinedChartDrawOrderLine)
                             ];
    
    combineChart.delegate = self;
    combineChart.pinchZoomEnabled = NO;
    combineChart.marker = [[ChartMarkerView alloc] init];
//    combineChart.drawOrder = @[@0,@0,@2];//CombinedChartDrawOrderBar,CombinedChartDrawOrderLine
    combineChart.doubleTapToZoomEnabled = YES;//取消双击放大
    combineChart.scaleYEnabled = NO;
    combineChart.dragEnabled = YES;//启用拖拽图表
    combineChart.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
    combineChart.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    combineChart.drawValueAboveBarEnabled = YES;
//    combineChart.highlightPerTapEnabled = NO;//取消单击高亮显示
//    combineChart.highlightPerDragEnabled = NO;

    combineChart.gridBackgroundColor = [UIColor whiteColor];
    combineChart.drawBordersEnabled = NO;//添加边框
    
//    ChartXAxis *xAxis = combineChart.xAxis;
//    xAxis.labelPosition = XAxisLabelPositionBottom;
//    xAxis.drawGridLinesEnabled = NO;
//    xAxis.labelFont = [UIFont systemFontOfSize:10];
//    xAxis.labelCount = xValues.count ;
//    xAxis.labelRotationAngle = -40;
//    xAxis.yOffset = 10;
//    xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:xValues];
//    xAxis.drawAxisLineEnabled = YES;
    
    
    ChartXAxis *xAxis = combineChart.xAxis;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.yOffset = 10;
//    xAxis.labelFont = [UIFont systemFontOfSize:6];
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.axisMinimum = 0.0;
    xAxis.axisMaximum = 13.0;
    xAxis.granularity = 1.0;//粒度
    xAxis.valueFormatter = self;
    xAxis.labelCount = self.months.count ;

    //左侧Y轴设置
    ChartYAxis *leftAxis = combineChart.leftAxis;
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
//    leftAxis.axisMinimum = 0.0f;
    leftAxis.drawGridLinesEnabled = YES;

     //右侧Y轴
    if (lineValues.count) {
        ChartYAxis *rightAxis = combineChart.rightAxis;
        rightAxis.labelPosition = YAxisLabelPositionOutsideChart;
        rightAxis.drawGridLinesEnabled = NO;
        //    rightAxis.axisMinimum = 0.0f;
        
        rightAxis.axisMaximum = yrMax *1.3;
        NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
        //自定义数据显示格式
        [numFormatter setNumberStyle:NSNumberFormatterPercentStyle];
        [numFormatter setPositiveFormat:@"#%/100"];
        
        ChartDefaultAxisValueFormatter *formatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:numFormatter];
        rightAxis.valueFormatter = formatter;
    }
   


    
    //设置图例
    ChartLegend *legend = combineChart.legend;
    legend.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
    legend.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    legend.orientation = ChartLegendOrientationHorizontal;
    legend.drawInside = NO;
    legend.direction = ChartLegendDirectionLeftToRight;
    legend.form = ChartLegendFormSquare;
    legend.formSize = 10;
    legend.font = [UIFont systemFontOfSize:10];
    legend.textColor = [UIColor colorFromHexCode:@"FFB6C1"];
//    legend.xOffset = -15;
    
    //点击显示的label
    
//    XYMarkerView *marker = [[XYMarkerView alloc]
//                            initWithColor: [UIColor colorWithWhite:180/255. alpha:1.0]
//                            font: [UIFont systemFontOfSize:12.0]
//                            textColor: UIColor.redColor
//                            insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)
//                            xAxisValueFormatter: combineChart.xAxis.valueFormatter];
//    marker.chartView = combineChart;
//    marker.minimumSize = CGSizeMake(80.f, 40.f);
//    combineChart.marker = marker;
    
    //设置滑动时候标签
    _markY = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    _markY.backgroundColor = [UIColor blackColor];
    _markY.alpha = 0.3;
    _markY.layer.cornerRadius = 3;
    _markY.layer.masksToBounds = YES;
    ChartMarkerView *markerY = [[ChartMarkerView alloc]init];
    markerY.offset = CGPointMake(-((combineChart.frame.size.width)/2), -(combineChart.frame.size.height));//设置markY不要滚出屏幕
    markerY.chartView = combineChart;
    combineChart.marker = markerY;
    [markerY addSubview:self.markY];
    
    _markDataLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    _markDataLB.font = [UIFont systemFontOfSize:13];
    _markDataLB.numberOfLines = 0;
    _markDataLB.textColor = [UIColor whiteColor];
    _markDataLB.adjustsFontSizeToFitWidth = YES;
    [_markY addSubview:_markDataLB];
    combineChart.data = data;
    combineChart.extraBottomOffset = 30;
    combineChart.extraTopOffset = 30;
    [combineChart animateWithYAxisDuration:1.0];
}
//生成线的数据
- (LineChartData *)generateLineData:(NSArray *)lineValues
{
    if (!lineValues.count) {
        return nil;
    }
    NSMutableArray *datasetArr = [NSMutableArray array];
    for (int j = 0; j < lineValues.count; j ++) {
        NSMutableArray *yVals = [[NSMutableArray alloc] init];
        
        for (NSArray *arr in lineValues[j][@"data"]) {
            if (arr.count > 1) {
                double xx = [arr[0] doubleValue];
                double val = [arr[1] doubleValue];
                if (val > yrMax) {
                    yrMax = val;
                }
                [yVals addObject:[[ChartDataEntry alloc] initWithX:xx y:val]];
            }
            
        }
        LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:yVals label:lineValues[j][@"name"]];
        set.axisDependency = AxisDependencyRight;
        [set setColor:[UIColor colorFromHexCode:lineValues[j][@"color"]]];
        [set setCircleColor:[UIColor colorFromHexCode:lineValues[j][@"color"]]];
        set.lineWidth = 2.0;
        set.circleRadius = 3.0;
        set.fillAlpha = 65/255.0;
        set.fillColor = [UIColor colorFromHexCode:lineValues[j][@"color"]];
        set.highlightColor = [UIColor colorFromHexCode:lineValues[j][@"color"]];
        set.drawCircleHoleEnabled = NO;
        set.mode = LineChartModeCubicBezier;//曲线模式
        set.drawValuesEnabled = NO;
        [datasetArr addObject:set];
        
    }
    
    LineChartData *lineData = [[LineChartData alloc] initWithDataSets:datasetArr];
    [lineData setValueFont:[UIFont systemFontOfSize:10]];
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    //自定义数据显示格式
    [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numFormatter setPositiveFormat:@"#0.00"];
    ChartDefaultValueFormatter *formatter = [[ChartDefaultValueFormatter alloc] initWithFormatter:numFormatter];
    [lineData setValueFormatter:formatter];
    return lineData;
}
//生成复杂的组合柱图的数据
- (BarChartData *)generateCombineBarData:(NSArray *)barValues{
    if (!barValues.count) {
        return nil;
    }
    NSMutableArray *datasetArr = [NSMutableArray array];
    NSMutableArray *colorArr = [NSMutableArray array];
    for (int j = 0; j < barValues.count; j ++) {
        NSMutableArray *yVals = [[NSMutableArray alloc] init];
        
        for (NSArray *arr in barValues[j][@"data"]) {
            if (arr.count > 1) {
                double xx = [arr[0] doubleValue];
                double val = [arr[1] doubleValue];
                [yVals addObject:[[BarChartDataEntry alloc] initWithX:xx y:val]];
            }
        }
        BarChartDataSet *dataSet1 = [[BarChartDataSet alloc]  initWithValues:yVals label:barValues[j][@"name"]];
        dataSet1.colors = @[[UIColor colorFromHexCode:barValues[j][@"color"]]];
        dataSet1.axisDependency = AxisDependencyLeft;
        dataSet1.drawValuesEnabled = NO;
        [datasetArr addObject:dataSet1];
        [colorArr addObject:[UIColor colorFromHexCode:barValues[j][@"color"]]];
    }
    float groupSpace = 0.06f;
    float barSpace = 0.02; // x2 dataset
    float barWidth = (1.0 - 0.06)/barValues.count - 0.02; // x2 dataset
    // (0.45 + 0.02) * 2 + 0.06 = 1.00 -> interval per "group"
    BarChartData *data = [[BarChartData alloc] initWithDataSets:datasetArr];
    [data setValueFont:[UIFont systemFontOfSize:10]];
    [data setValueTextColor:[UIColor colorFromHexCode:@"FFB6C1"]];
    data.barWidth = barWidth;
    [data groupBarsFromX:0.5 groupSpace:groupSpace barSpace:barSpace];
    
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    //自定义数据显示格式
    [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numFormatter setPositiveFormat:@"#0.00"];
    ChartDefaultValueFormatter *formatter = [[ChartDefaultValueFormatter alloc] initWithFormatter:numFormatter];
    [data setValueFormatter:formatter];
    return data;
}
#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    
    //    [_chartView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0];
    //[_chartView moveViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];
    //[_chartView zoomAndCenterViewAnimatedWithScaleX:1.8 scaleY:1.8 xValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];
    
    double x =entry.x;
    int TitleIndex = round(x) ;//四舍五入
    LFLog(@"entry:%f",entry.x);
    LFLog(@"TitleIndex:%d",TitleIndex);
//    _markTitleLB.text = self.months[TitleIndex];
    NSString *Xtext = self.months[TitleIndex];
    CombinedChartData *data = (CombinedChartData *)chartView.data;
    NSArray<id <IChartDataSet>> *arr = data.dataSets;
    NSMutableString *multStr = [[NSMutableString alloc]init];
    for (id <IChartDataSet> ic in arr)
    {
        [multStr appendString:@"\n"];
        NSString *labelText = ic.label;
        [multStr appendString:labelText];
        [multStr appendString:@":"];
        ChartDataEntry *Entry = [ic entryForIndex:TitleIndex -1];
        double yValue = Entry.y;
        NSString *yValueStr = [NSString stringWithFormat:@"%.1f",yValue];
        [multStr appendString:yValueStr];
        LFLog(@"Entry:%f",Entry.x);
//        NSArray<ChartDataEntry *> *chartdataEntryArr = [ic entriesForXValue:x];
//        for (ChartDataEntry * en in chartdataEntryArr)
//        {
//            double yValue = en.y;
//            NSString *yValueStr = [NSString stringWithFormat:@"%d",(int)yValue];
//            [multStr appendString:yValueStr];
//
//        }
//        _markDataLB.text = multStr;
    }
    _markDataLB.text = [NSString stringWithFormat:@"%@%@",Xtext,multStr];
    CGSize size = [_markDataLB.text selfadap:13 weith:screenW - 145];
    _markY.width_i = size.width + 10;
    _markY.height_i = size.height + 10;
    _markDataLB.frame = CGRectMake(5, 5, size.width, size.height);
    _markY.hidden = NO;
    ChartMarkerView *markerY = (ChartMarkerView *)chartView.marker;
    markerY.offset = CGPointMake(-(size.width + 10), -(size.height + 10));//设置markY不要滚出屏幕
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    _markY.hidden = YES;
}

#pragma mark - IAxisValueFormatter
- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    return self.months[(int)value % self.months.count];
}

@end
