//
//  IntegralViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/9.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "IntegralViewController.h"
#import "UIView+RHGradientLayer.h"
#import "IntegralRecordViewController.h"
#import "GradeListViewController.h"
#import "WKViewViewController.h"
@interface IntegralViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTop;
@property (weak, nonatomic) IBOutlet UIImageView *iconIm;
@property (weak, nonatomic) IBOutlet UILabel *gradeLb;
@property (weak, nonatomic) IBOutlet UILabel *integralLb;
@property (weak, nonatomic) IBOutlet UIView *drawBackview;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;

@end

@implementation IntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationBarTitle = @"积分";
    self.viewTop.constant = SAFE_NAV_HEIGHT;
    [self configData];
    [self createBaritem];
}
-(void)configData{
    UserModel *model = [UserUtils getUserInfo];
    [self.iconIm sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    self.gradeLb.text = [NSString stringWithFormat:@"您现在的等级是%@",model.rank];
    self.nameLb.text = model.next_rank;
    NSString *integra = [NSString stringWithFormat:@"%@积分，距离%@还差%@积分",model.score,model.next_rank,model.next_rank_diff];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:integra];
    NSRange ran1 = [integra rangeOfString:model.score];
    NSRange ran2 ;
    ran2.location = [NSString stringWithFormat:@"%@积分，距离%@还差",model.score,model.next_rank].length ;
    ran2.length = model.next_rank_diff.length;
    [text yy_setColor:JHAssistRedColor range:ran1];
    [text yy_setColor:JHAssistRedColor range:ran2];
    self.integralLb.attributedText = text;
    UIView *progressView = [[UIView alloc]init];
    //    progressView.backgroundColor = JHColor(255, 98, 26);
    progressView.layer.cornerRadius = 2.5;
    progressView.layer.masksToBounds = YES;
    progressView.fromColor = @"f8c028";
    //    progressView.toColor = @"ff7837";
    [self.drawBackview addSubview:progressView];
    progressView.frame = CGRectMake(0, 0, 0, 5);
    CGFloat scale = model.next_rank_score.floatValue > 0 ? 1- model.next_rank_diff.floatValue/model.next_rank_score.floatValue : 0;
    [UIView animateWithDuration:2 * scale delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        progressView.frame = CGRectMake(0, 0, (screenW - 90) * scale, 5);
        progressView.toColor = @"ff7837";
    } completion:^(BOOL finished) {
        progressView.frame = CGRectMake(0, 0, (screenW - 90) * scale, 5);
    }];
    
}
-(void)createBaritem{
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"积分记录" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    rightBar.tintColor = JHMaincolor;
    self.navigationItem.rightBarButtonItem = rightBar;
    
}
#pragma mark  公开问答
-(void)rightClick{
    IntegralRecordViewController *record = [[IntegralRecordViewController alloc]init];
    [self.navigationController pushViewController:record animated:YES];
}
- (IBAction)gradeDescClick:(id)sender {
//    GradeListViewController *vc = [[GradeListViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    WKViewViewController *bord = [[WKViewViewController alloc]init];
    bord.titleStr = @"等级说明";
    bord.urlStr = NSStringWithFormat(SERVER_IP,NSStringWithFormat(HtmlDetailUrl, @"2"));
    [self.navigationController pushViewController:bord animated:YES];
}
- (IBAction)integralClick:(id)sender {
    WKViewViewController *bord = [[WKViewViewController alloc]init];
    bord.titleStr = @"积分规则";
    bord.urlStr = NSStringWithFormat(SERVER_IP,NSStringWithFormat(HtmlDetailUrl, @"3"));
    [self.navigationController pushViewController:bord animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
