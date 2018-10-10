//
//  DescriptionTableViewCell.m
//  TsApartment
//
//  Created by 梁法亮 on 2018/7/5.
//  Copyright © 2018年 PmMaster. All rights reserved.
//

#import "DescriptionTableViewCell.h"

@implementation DescriptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageHeight.constant = (screenW - 50)/3;
    self.imageBackview.layer.masksToBounds = YES;
    for (int i = 0; i < 6; i ++) {
        NSString *imName = [NSString stringWithFormat:@"image%d",i+ 1];
        UIImageView * imageview = [self valueForKey:imName];
        if (imageview) {
            imageview.layer.masksToBounds = YES;
            imageview.layer.cornerRadius = 3;
            [imageview ddy_AddTapTarget:self action:@selector(iamgeClick:)];
        }
    }
}
-(void)setAmodel:(AnswerDetailModel *)Amodel{
    _Amodel  = Amodel;
    NSString *str  = [NSString stringWithFormat:@"%@\n%@",Amodel.title,[UserUtils getShowDateWithTime:Amodel.create_time dateFormat:@"yyyy.MM.dd HH:mm"]];
    if ([UserUtils getUserRole] == UserStyleTeacher) {
        self.timeLb.hidden = NO;
        self.timeLb.text = [UserUtils getShowDateWithTime:Amodel.create_time dateFormat:@"yyyy.MM.dd HH:mm"];
        str  = [NSString stringWithFormat:@"%@\n%@",Amodel.title,Amodel.full_name];
    }
    self.nameLb.attributedText = [self getAttribute:str title:Amodel.title];
    self.contentLb.text = Amodel.content;
    [self setImageArr:Amodel.images];

}

-(void)setImodel:(IgDetailModel *)Imodel{
    _Imodel =Imodel;
    self.nameLb.attributedText = nil;
    self.contentLb.text = Imodel.content;
    [self setImageArr:Imodel.images];
}
-(NSMutableAttributedString *)getAttribute:(NSString *)str title:(NSString *)title{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str] ;
    text.yy_lineSpacing = 10;
    text.yy_font = [UIFont systemFontOfSize:14];
    text.yy_color = JHmiddleColor;
    NSRange ran = [str rangeOfString:title];
    [text yy_setColor:JHdeepColor range:ran];
    [text yy_setFont:SYS_FONTBold(20) range:ran];
    return text;
}
-(void)setImageArr:(NSArray *)imageArr{
    if (!imageArr.count) {
        self.imageBackHeight.constant = 0;
    }else if (imageArr.count < 4){
        self.imageBackHeight.constant = (screenW - 50)/3 + 10;
    }else{
        self.imageBackHeight.constant = (screenW - 50)/3*2 + 20;
    }
    for (int i = 0; i < 6; i ++) {
        NSString *imName = [NSString stringWithFormat:@"image%d",i+ 1];
        UIImageView * imageview = [self valueForKey:imName];
        if (imageArr.count > i) {
            imageview.userInteractionEnabled = YES;
            if ([imageArr[i] isKindOfClass:[UIImage class]]) {
                imageview.image = imageArr[i];
            }else{
                [imageview sd_setImageWithURL:[NSURL URLWithString:imageArr[i]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            }
        }else{
            imageview.userInteractionEnabled = NO;
            imageview.image = nil;
        }
    }
}
- (void)iamgeClick:(UITapGestureRecognizer *)sender {
    NSMutableArray *modelArr = [NSMutableArray array];
    for (int i = 0; i < 6; i ++) {
        NSString *imName = [NSString stringWithFormat:@"image%d",i+ 1];
        UIImageView * imageview = [self valueForKey:imName];
        if (imageview.image) {
            YBImageBrowserModel *model = [YBImageBrowserModel new];
            model.image = imageview.image;
            model.sourceImageView = imageview;
            [modelArr addObject:model];
        }
    }
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataArray = modelArr;
    browser.currentIndex = sender.view.tag - 1;
    //展示
    [browser show];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)replyBtnClick:(id)sender {
    if (self.replyBtnBlock) {
        self.replyBtnBlock();
    }
}

@end
