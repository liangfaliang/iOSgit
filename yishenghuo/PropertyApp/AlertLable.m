//
//  AlertLable.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/7.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "AlertLable.h"

@implementation AlertLable

-(void)setTextnum:(NSString *)textnum{
    _textnum = textnum;
    self.text = textnum;
    if ([_textnum isEqualToString:@"0"] ||_textnum.length ==0) {
        self.hidden = YES;
    }else{
        if (self.superview) {
            //            LFLog(@"AlertLable:%f",[textnum selfadapUifont:self.font weith:20].width);
            CGFloat wid = [self.text selfadapUifont:self.font weith:20].width + 5;
            if (wid < 15) {
                wid = 15;
            }else if (wid > 20){
                wid = 20;
            }
            LFLog(@"alertLabel:%f",wid);
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.superview.mas_right).offset(0);
                make.centerY.equalTo(self.superview.mas_top).offset(0);
                make.height.offset(15);
                make.width.offset(wid);
            }];
            
        }
        self.hidden = NO;
    }
}

@end

