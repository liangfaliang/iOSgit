//
//  InformationCycleCollectionViewCell.m
//  PropertyApp
//
//  Created by admin on 2018/7/25.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "InformationCycleCollectionViewCell.h"
#import "YYText.h"
@implementation InformationCycleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)labelSetText:(NSString *)title tag:(NSString *)tag index:(int)index{
    NSString *imName = [NSString stringWithFormat:@"label%d",index];
    if ([[UserModel shareUserModel] checkIsExistPropertyWithInstance:self verifyPropertyName:imName]) {
        YYLabel * lab = [self valueForKey:imName];
        if (title) {
            NSString *mstr = [NSString stringWithFormat:@"%@%@",tag ? [NSString stringWithFormat:@"  %@   ",tag] : @"",title];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:mstr];
            text.yy_font = [UIFont boldSystemFontOfSize:14];
            text.yy_color = JHsimpleColor;
            NSRange range =[[text string]rangeOfString:[NSString stringWithFormat:@" %@ ",tag]];
            [text yy_setColor:JHAssistRedColor range:range];
            [text yy_setFont:[UIFont systemFontOfSize:10] range:range];
            YYTextBorder *boder = [[YYTextBorder alloc]init];
            boder.strokeWidth = 1;
            boder.cornerRadius = 3;
            boder.strokeColor = JHAssistRedColor;;
            [text yy_setTextBorder:boder  range:range];
            lab.attributedText = text;
        }else{
            lab.attributedText = nil;
        }
    }else{
        LFLog(@"label不存在");
    }

}

@end
