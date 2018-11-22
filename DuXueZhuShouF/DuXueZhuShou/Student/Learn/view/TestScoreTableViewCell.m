//
//  TestScoreTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/1.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "TestScoreTableViewCell.h"
#import "GradesRankViewController.h"
@implementation TestScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLb.font = SYS_FONTBold(17);
    //添加点击手势
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction)];
    [_gradeView addGestureRecognizer:click];
}
-(void)setModel:(StuScoreListModel *)model{
    _model = model;
    self.nameLb.text = model.name;
    self.timeLb.text = [NSString stringWithFormat:@"测试时间:%@",model.date];
    self.contentLb.text = [NSString stringWithFormat:@"测试说明:%@",model.explain];
    NSArray *nameArr = @[model.subject ,@"班级",model.campus,@"全校"];
    NSArray *valueArr = @[lStringFormart(@"%@分\n", model.score),
                          lStringFormart(@"%@名\n", model.class_ranking),
                          lStringFormart(@"%@名\n", model.campus_ranking),
                          lStringFormart(@"%@名\n", model.school_ranking)];
    NSMutableArray *marr = [NSMutableArray array];
    for (int i = 0 ; i < nameArr.count; i ++) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:lStringFormart(@"%@%@",valueArr[i],nameArr[i])];
        text.yy_font = SYS_FONTBold(16);
        text.yy_color = JHMaincolor;
        text.yy_lineSpacing = 5;
        text.yy_alignment = NSTextAlignmentCenter;
        NSRange ran = [text.string rangeOfString:nameArr[i]];
        [text yy_setFont:SYS_FONT(14) range:ran];
        [text yy_setColor:JHmiddleColor range:ran];
        [marr addObject:text];
    }
    [self setBackViewSubviews:marr];
}
-(void)setBackViewSubviews:(NSArray <NSAttributedString *> *)titleArr{
    for (int i = 0; i < titleArr.count; i ++) {
        UILabel *lb = nil;
        if (_backView.subviews.count > i) {
            lb = _backView.subviews[i];
        }else{
            lb = [UILabel initialization:CGRectZero font:[UIFont systemFontOfSize:15] textcolor:JHmiddleColor numberOfLines:0 textAlignment:NSTextAlignmentCenter];
            [_backView addSubview:lb];
        }
        lb.attributedText = titleArr[i];
    }

}
-(void)layoutSubviews{
    [super layoutSubviews];
    int i = 0;
    CGFloat width = screenW / (_backView.subviews.count ? _backView.subviews.count : 1);
    for (UIView *subview in _backView.subviews) {
        subview.frame = CGRectMake(i * width, 0, width, _backView.height_i);
        i ++;
    }
}
- (void)clickAction{
    GradesRankViewController *vc = [[GradesRankViewController alloc]init];
    vc.ID = self.model.ID;
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

@end
