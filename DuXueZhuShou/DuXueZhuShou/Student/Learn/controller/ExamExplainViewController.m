//
//  ExamExplainViewController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ExamExplainViewController.h"

@interface ExamExplainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *descLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desclbTop;

@end

@implementation ExamExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationBarTitle = @"考试说明";
    self.view.backgroundColor = [UIColor whiteColor];
    self.desclbTop.constant = SAFE_NAV_HEIGHT + 15;
    self.descLb.text = self.explain;
    [self.descLb NSParagraphStyleAttributeName:10];
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
