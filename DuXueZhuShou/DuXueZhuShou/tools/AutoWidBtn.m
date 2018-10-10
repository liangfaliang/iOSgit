//
//  AutoWidBtn.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/17.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AutoWidBtn.h"

@implementation AutoWidBtn
//-(CGSize)intrinsicContentSize{
//    return CGSizeZero;
//}
- (CGSize)intrinsicContentSize
{
//    LFLog(@"titleLabel:%@",NSStringFromCGRect(self.titleLabel.frame));
//    LFLog(@"imageView:%@",NSStringFromCGRect(self.imageView.frame));
    CGSize s = [super intrinsicContentSize];
    CGFloat wid = s.width;
    if (wid == 30) {
        CGFloat labWid = [self.titleLabel.text selfadapUifont:self.titleLabel.font weith:30].width;
        CGFloat imWid = self.imageView.image.size.height < s.height ? self.imageView.image.size.width : (self.imageView.image.size.height/s.height * self.imageView.image.size.width);
        wid = (labWid > 0 ? labWid + 2 : 0) + imWid;
    }
    return CGSizeMake(wid + self.titleEdgeInsets.left + self.titleEdgeInsets.right ,
                      s.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
    
}
-(void)layoutSubviews{
    [super layoutSubviews];

}
-(void)updateConstraints{
    [super updateConstraints];

//    CGFloat imageWith = self.imageView.frame.size.width;
//    CGFloat labelWidth = self.titleLabel.frame.size.width;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
