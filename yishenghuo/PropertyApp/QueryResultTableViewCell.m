//
//  QueryResultTableViewCell.m
//  shop
//
//  Created by 梁法亮 on 16/6/27.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "QueryResultTableViewCell.h"

#import "NSString+selfSize.h"

@implementation QueryResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(queryresultmodel *)model{

    _model = model;
     NSString *fen = [NSString stringWithFormat:@"记分：%@",model.fen];
     NSString *money = [NSString stringWithFormat:@"罚款：%@",model.money];
    NSString *result = @"未知";
    if ([model.handled isEqualToString:@"0"]) {
        result = @"未处理";
    }else if ([model.handled isEqualToString:@"1"]){
        result = @"处理";
    }
    
    self.timelabel.text = model.date;
    self.timeLbheight.constant = (([self.timelabel.text selfadap:15 weith:30].height + 10)) > 30 ? ([self.timelabel.text selfadap:15 weith:30].height + 10):30;
    self.actionlabel.text = model.act;
    self.actionLbheight.constant = (([self.actionlabel.text selfadap:15 weith:30].height + 10)) > 30 ? ([self.actionlabel.text selfadap:15 weith:30].height + 10):30;
    self.placelabel.text = model.area;
    self.placeLbheight.constant = (([self.placelabel.text selfadap:18 weith:30].height + 10)) > 40 ? ([self.placelabel.text selfadap:18 weith:30].height + 10):40;
    self.pointslabel.attributedText = [fen AttributedString:model.fen backColor:nil uicolor:[UIColor redColor] uifont:[UIFont systemFontOfSize:15]];
    self.finelabel.attributedText = [money AttributedString:model.money backColor:nil uicolor:[UIColor redColor] uifont:[UIFont systemFontOfSize:15]];
    self.fineLbWidth.constant = [money selfadap:15 weith:30].width + 5;
    self.resultlabel.text = result;
//    self.backview.frame = CGRectMake(0, 0, SCREEN.size.width, 200);
    
}


@end
