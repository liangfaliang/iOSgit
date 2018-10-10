//
//  TeacherCountViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/23.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "TeacherCountViewController.h"

@interface TeacherCountViewController ()
@property (weak, nonatomic) IBOutlet UIButton *AnswerBtn;
@property (weak, nonatomic) IBOutlet UIButton *ReplyBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTop;

@end

@implementation TeacherCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationBarTitle = @"统计";
    self.viewTop.constant = SAFE_NAV_HEIGHT + 20;
    self.AnswerBtn.titleLabel.numberOfLines =0;
    self.ReplyBtn.titleLabel.numberOfLines =0;
    [self getData];
}

#pragma mark - 获取列表
- (void)getData{
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,AnswerTeacherStatisticsUrl) params:nil viewcontrllerEmpty:self success:^(id response) {
        LFLog(@"获取列表:%@",response);
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1 && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
            [self.AnswerBtn setAttributedTitle:[self getAttString:response[@"data"][@"question_answer_number"] str:@"答案问题"] forState:UIControlStateNormal];
            [self.ReplyBtn setAttributedTitle:[self getAttString:response[@"data"][@"question_number"] str:@"回复数量"] forState:UIControlStateNormal];
        }else{
            [AlertView showMsg:response[@"msg"]];
        }
    } failure:^(NSError *error) {

    }];
    
}
-(NSMutableAttributedString *)getAttString:(NSString *)number str:(NSString *)str{
    NSString * question_answer_number = [NSString stringWithFormat:@"%@\n%@",number,str];
    NSMutableAttributedString *answer = [[NSMutableAttributedString alloc]initWithString:question_answer_number];
    answer.yy_font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
    answer.yy_color = JHdeepColor;
    answer.yy_lineSpacing = 15;
    answer.yy_alignment = NSTextAlignmentCenter;
    NSRange ran1 = [question_answer_number rangeOfString:str];
    [answer yy_setFont:[UIFont systemFontOfSize:15] range:ran1];
    [answer yy_setColor:JHmiddleColor range:ran1];
    return answer;
}
@end
