//
//  ArticleListTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/28.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ArticleListTableViewCell.h"

@implementation ArticleListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat xx = 0;
    for (int i = 0; i < 3; i ++) {
        UIImageView *imview = [[UIImageView alloc]initWithFrame:CGRectMake(xx, 0, (screenW - 20)/3 - 3, self.imView.height)];
        imview.contentMode = UIViewContentModeCenter;
        imview.layer.masksToBounds = YES;
        [self.imView addSubview:imview];
        xx +=(screenW - 20)/3;
    }
}
-(void)setimviewSubview:(NSArray *)imarr{
    int i = 0;
    for (UIImageView *imview in self.imView.subviews) {
        if (imarr.count > i ) {
            if ([imarr[i] isKindOfClass:[NSString class]]) {
                NSString *url = imarr[i];
                [imview sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            }else if ([imarr[i] isKindOfClass:[UIImage class]]){
                imview.image = imarr[i];
            }
        }
        i ++;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
