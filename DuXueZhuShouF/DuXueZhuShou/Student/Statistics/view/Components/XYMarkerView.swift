//
//  XYMarkerView.swift
//  ChartsDemo
//  Copyright © 2016 dcg. All rights reserved.
//

import Foundation
import Charts

open class XYMarkerView: BalloonMarker
{
    @objc open var xAxisValueFormatter: IAxisValueFormatter?
    fileprivate var yFormatter = NumberFormatter()
    
    @objc public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets,
                xAxisValueFormatter: IAxisValueFormatter)
    {
        super.init(color: color, font: font, textColor: textColor, insets: insets)
        self.xAxisValueFormatter = xAxisValueFormatter
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 1
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        
        if entry.data != nil && entry.data is String {
            setLabel( (entry.data as! String))
        }else{
            setLabel(  xAxisValueFormatter!.stringForValue(entry.y, axis: nil) + "," +  yFormatter.string(from: NSNumber(floatLiteral: entry.y))! + "")
        }
        
    }
    
}
