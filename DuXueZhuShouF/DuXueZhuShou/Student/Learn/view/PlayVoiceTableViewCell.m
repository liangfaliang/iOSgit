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
-(void)playVoice:(NSString *)url{
    [RecordManage sharedRecordManage].delegate = self;
    [[RecordManage sharedRecordManage] p_musicPlayerWithURL:[NSURL URLWithString:url]];
}
-(void)startPlayWithplayer:(AVPlayer *)player{
    [self.playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
}
-(void)FinishedPlayWithplayer{
    [self.playBtn setImage:[UIImage imageNamed:@"ting"] forState:UIControlStateNormal];
}
-(void)failurePlayWithplayer:(NSString *)errorDes{
    [self.playBtn setImage:[UIImage imageNamed:@"ting"] forState:UIControlStateNormal];
}
@end
