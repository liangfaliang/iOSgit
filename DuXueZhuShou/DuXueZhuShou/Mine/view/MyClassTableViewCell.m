//
//  MyClassTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "MyClassTableViewCell.h"

@implementation MyClassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCellWithDict:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self setLabelValues:@[@"姓名",@"学号",@"所报科目"] textColor:@"666666"];
    }else{
        [self setLabelValues:@[lStringFor(dict[@"name"]),lStringFor(dict[@"number"]),lStringFor(dict[@"subject"])] textColor:@"333333"];
    }
}
-(void)setLabelValues:(NSArray *)nameArr textColor:(NSString *)textcolor{
    for (int i = 0; i < 3; i ++) {
        UILabel *lb = [self valueForKey:[NSString stringWithFormat:@"label%d",i + 1]];
        lb.textColor = [UIColor colorFromHexCode:textcolor];
        if (nameArr.count > i) {
            lb.text = nameArr[i];
        }else{
            lb.text = @"";
        }
        if (i  == 2) {
            [lb NSParagraphStyleAttributeName:5];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
