//
//  AnswerListTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AnswerListTableViewCell.h"
#import "UIButton+WebCache.h"
#import "AskQuestionViewController.h"
#import "RecordManage.h"
@implementation AnswerListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.timeLb.userInteractionEnabled = YES;
    self.nameLb.adjustsFontSizeToFitWidth = YES;
    self.imageBackview.layer.masksToBounds = YES;
    self.audioBackView.layer.masksToBounds = YES;
    [self.timeLb ddy_AddTapTarget:self action:@selector(TimeClickTap)];
    for (int i = 0; i < 3; i ++) {
        NSString *imName = [NSString stringWithFormat:@"image%d",i+ 1];
        UIButton * imageview = [self valueForKey:imName];
        if (imageview) {
            imageview.layer.masksToBounds = YES;
            imageview.layer.cornerRadius = 3;
            [imageview addTarget:self action:@selector(iamgeClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (NSArray *)getSeparatedLinesArray:(NSString *)text font:(UIFont *)font width:(CGFloat )width{

    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);

    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}
-(void)TimeClickTap{
    if ([self.rmodel.level isEqualToString:@"1"]) {
        AskQuestionViewController *vc = [[AskQuestionViewController alloc]init];
        vc.ID = self.rmodel.ID;
        vc.answer_type = @"2";
        BasicViewController *bord = (BasicViewController *)[self viewController];
        vc.successBlock = ^{
            [bord UpData];
        };
        [bord.navigationController pushViewController:vc animated:YES];
    }
}
-(void)setRmodel:(ReplyModel *)rmodel{
    _rmodel = rmodel;
    self.nameLb.text = [NSString stringWithFormat:@"%@:",rmodel.name];
    self.contenLb.text = rmodel.content;
    CGFloat space = 105;
    NSArray *linesArr = [self getSeparatedLinesArray:self.contenLb.text font:self.contenLb.font width:screenW - space];
    NSString * timeStr = [NSString stringWithFormat:@"%@%@",(rmodel.level ? [rmodel.level isEqualToString:@"1"] : [rmodel.can_answer isEqualToString:@"1"]) ? @" 回复 ":@"" , [UserUtils getShowDateWithTime:rmodel.create_time dateFormat:@"yyyy.MM.dd HH:mm"] ];
    NSMutableAttributedString *text = [timeStr AttributedString:@" 回复 " backColor:nil uicolor:JHMaincolor uifont:[UIFont systemFontOfSize:15]];

    self.timeLb.attributedText = text;
    CGFloat lastWid = [linesArr.lastObject selfadapUifont:self.contenLb.font weith: space].width;
    CGFloat timeWid = [self.timeLb.attributedText selfadaption:space].width;

    if (rmodel.images.count) {
        self.imageBackviewHeight.constant = (screenW - 135)/3;
    }else{
        self.imageBackviewHeight.constant = 0;
    }
    for (int i = 0; i < 3; i ++) {
        NSString *imName = [NSString stringWithFormat:@"image%d",i+ 1];
        UIButton * imageview = [self valueForKey:imName];
        if (rmodel.images.count > i) {
            [imageview sd_setBackgroundImageWithURL:[NSURL URLWithString:rmodel.images[i]] forState:UIControlStateNormal];
        }else{
            [imageview setImage:nil forState:UIControlStateNormal];
        }
    }
    if (rmodel.url.length) {
        self.audioBackViewHeight.constant = 40;
        self.secondLb.text = [NSString stringWithFormat:@"%@\"",[rmodel.url getSecondFormUrl]];
    }else{
        self.secondLb.text = nil;
        self.audioBackViewHeight.constant = 0;
    }
    if (self.audioBackViewHeight.constant == 0 && self.imageBackviewHeight.constant == 0) {
        if (timeWid + lastWid + 10 > screenW - space) {
            self.contenLb.text = [NSString stringWithFormat:@"%@\n",self.contenLb.text];
        }
        [self.contenLb NSParagraphStyleAttributeName:5];
        self.audioBackViewBottom.constant = 10;
    }else{
        self.audioBackViewBottom.constant = 37;
    }
    
}
- (void)iamgeClick:(UIButton *)sender {
    NSMutableArray *modelArr = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        NSString *imName = [NSString stringWithFormat:@"image%d",i+ 1];
        UIButton * imageview = [self valueForKey:imName];
        if (_rmodel.images.count > i) {
            YBImageBrowserModel *model = [YBImageBrowserModel new];
            model.url = [NSURL URLWithString:self.rmodel.images[i]];
            model.sourceImageView = imageview.imageView;
            [modelArr addObject:model];
        }
    }
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataArray = modelArr;
    browser.currentIndex = sender.tag - 1;
    //展示
    [browser show];
}
- (IBAction)playBtnClick:(id)sender {
    if (self.rmodel && self.rmodel.url.length) {
        [[RecordManage sharedRecordManage] p_musicPlayerWithURL:[NSURL URLWithString:_rmodel.url]];
    }
}

@end
