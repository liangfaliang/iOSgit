//
//  AutoEdgBtn.m
//  DuXueZhuShou
//
//  Created by admin on 2018/9/5.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AutoEdgBtn.h"

@implementation AutoEdgBtn

- (CGSize)intrinsicContentSize
{
    CGSize s = [super intrinsicContentSize];
    CGFloat wid = s.width;
    return CGSizeMake(wid + self.titleEdgeInsets.left + self.titleEdgeInsets.right ,
                      s.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
    
}
@end
