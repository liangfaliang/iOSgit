//
//  InsPunchViewSubmitController.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "InsPunchViewSubmitController.h"

@interface InsPunchViewSubmitController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTop;

@end

@implementation InsPunchViewSubmitController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.viewTop.constant = SAFE_NAV_HEIGHT + 20;
    self.navigationBarTitle = @"发表评论";
}
- (IBAction)submitClcik:(id)sender {
    if (!self.textView.text.length) {
        [self presentLoadingTips:@"请输入评价内容!"];
        return;
    }
    [self UpdateLoad];
}

#pragma mark 提交
-(void)UpdateLoad{
    NSMutableDictionary *dt = [NSMutableDictionary dictionary];
    if (self.OperateID) {
        [dt setObject:self.OperateID forKey:@"id"];
    }
    [dt setObject:self.textView.text forKey:@"comment"];
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP, OperationInsCommentUrl) params:dt viewcontrllerEmpty:self success:^(id response) {
        [self dismissTips];
        LFLog(@"tijaio:%@",response);
        NSNumber *code = @([response[@"code"] integerValue]);
        if (code.integerValue == 1) {
            if (self.successBlock) {
                self.successBlock();
            }
            [self performSelector:@selector(dismissView) withObject:nil afterDelay:2.];
        }
        [AlertView showMsg:response[@"msg"]];
        
    } failure:^(NSError *error) {
        [self dismissTips];
        LFLog(@"error：%@",error);
    }];
}

-(void)dismissView{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
