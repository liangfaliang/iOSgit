//
//  ArticleDetailTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/5/2.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ArticleDetailTableViewCell.h"

@implementation ArticleDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.reviewYYlb.numberOfLines = 0;
    self.selectionStyle= UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)morebtnClick:(id)sender {
    LFLog(@"查看更多");
}

-(void)setArmodel:(AritcleModel *)armodel{
    _armodel = armodel;
    self.nameLb.text = armodel.user_name;
    self.contentLb.text = armodel.content;
    [self.iconIm sd_setImageWithURL:[NSURL URLWithString:armodel.headimage] placeholderImage:[UIImage imageNamed:@""]];
    self.timeLb.text = armodel.add_time;
    [self.reviewBtn setTitle:[NSString stringWithFormat:@"   %@",armodel.comment_count] forState:UIControlStateNormal];
    self.contentviewHeight.constant = [self.contentLb.text selfadap:15 weith:70].height + 50;
    if ([armodel.is_agree isEqualToString:@"1"]) {
        [self.praiseBtn setImage:[UIImage imageNamed:@"dianzanxuanzhong_sim"] forState:UIControlStateNormal];
    }else{
        [self.praiseBtn setImage:[UIImage imageNamed:@"dianzan_sim"] forState:UIControlStateNormal];
    }
    NSArray *sublevelArr = armodel.sublevel;
    if (sublevelArr && sublevelArr.count) {
        NSMutableArray *conArr = [[NSMutableArray alloc]init];
        int i = 0;
        for (NSDictionary *subDt in sublevelArr) {
            if (i < 4) {
                NSString *user_name = subDt[@"user_name"];
                NSString *user_name2 = subDt[@"user_name2"];
                NSString *temstr = nil;
                if (user_name2 && user_name2.length) {
                    temstr = [NSString stringWithFormat:@"%@ 回复 %@%@",user_name,user_name2,subDt[@"content"]];
                }else{
                    temstr = [NSString stringWithFormat:@"%@：%@",user_name,subDt[@"content"]];
                }
                [conArr addObject:temstr];
            }
            i ++;
        }
        NSMutableString *mstr = [NSMutableString string];
        NSMutableArray *arr = [NSMutableArray array];
        NSMutableArray *textArr = [NSMutableArray array];
        for (int i = 0; i < conArr.count; i ++) {
            [arr addObject:[NSNumber numberWithInteger:mstr.length]];
            NSString *str = conArr[i];
            NSRange ran = [str getTwoTextRangeWith:[UIFont systemFontOfSize:15] width:80 height:40];
            NSString *text = nil;
            if (ran.length < str.length) {
                ran.length = ran.length - 3;
                text = [NSString stringWithFormat:@"%@...",[str substringWithRange:ran]];
            }else{
                text = [str substringWithRange:ran];
            }
            LFLog(@"%@ text:%@",NSStringFromRange(ran),text);
            LFLog(@"%@ text:%@",NSStringFromRange(ran),text);
            [mstr appendString:text];
            if (i < conArr.count) {
                [mstr appendString:@"\n"];
            }
            [textArr addObject:text];
        }
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:mstr];
        text.yy_font = [UIFont boldSystemFontOfSize:15];
        text.yy_color = JHmiddleColor;
        text.yy_lineSpacing = 5;
        for (int i = 0; i < sublevelArr.count; i ++) {
            if (i < 4) {
                NSDictionary *subDt = sublevelArr[i];
                NSString *user_name = subDt[@"user_name"];
                NSString *user_name2 = subDt[@"user_name2"];
                NSInteger location = [arr[i] integerValue];
                NSRange range = NSMakeRange(location, [user_name length]);
                [text yy_setColor:JHMedicalColor range:range];
                if (user_name2 && user_name2.length) {
                    NSRange ran = NSMakeRange(location, [user_name length] + 8);
                    [text yy_setColor:JHsimpleColor range:ran];
                }
                NSRange range1 = NSMakeRange(location, [textArr[i] length]);;
                [text yy_setTextHighlightRange:range1 color:nil backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    LFLog(@"text:%@ %d",NSStringFromRange(range),i);
                } longPressAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    
                }];
            }
            
        }
        self.reviewYYlb.attributedText = text;
        
        if (sublevelArr.count > 4) {
            self.moreBtn.hidden = NO;
            self.moreBtnHeight.constant = 30;
        }else{
            self.moreBtn.hidden = YES;
            self.moreBtnHeight.constant = 0;
        }
        self.conviewbottom.constant = 10;
        self.reView.hidden = NO;
    }else{
        self.conviewbottom.constant = 0;
        self.reView.hidden = YES;
    }
}
- (IBAction)praiseClick:(id)sender {
    if (_likeblock) {
        _likeblock();
    }
}
-(void)setLikeblock:(void (^)())likeblock{
    _likeblock = likeblock;
}
@end
