//
//  PlayVoiceTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "PlayVoiceTableViewCell.h"

@implementation PlayVoiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.playBtn.isEffective = YES;

}
- (IBAction)playBtnDownOutside:(id)sender {
    if (self.playBtnBlock) {
        self.playBtnBlock(NO);
    }
}
- (IBAction)playBtnInside:(id)sender {
    if (self.playBtnBlock) {
        self.playBtnBlock(NO);
    }
}
- (IBAction)playBtnDown:(id)sender {
    if (self.playBtnBlock) {
        self.playBtnBlock(YES);
    }
    
}
- (IBAction)deleteClick:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}
- (IBAction)replyClick:(id)sender {
    if (self.replyBlock) {
        self.replyBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
