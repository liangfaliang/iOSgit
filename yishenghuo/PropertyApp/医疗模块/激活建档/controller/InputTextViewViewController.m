//
//  InputTextViewViewController.m
//  PropertyApp
//
//  Created by admin on 2018/7/27.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "InputTextViewViewController.h"

@interface InputTextViewViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textviewTop;

@property (weak, nonatomic) IBOutlet UILabel *descLb;

@end

@implementation InputTextViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationBarTitle = self.titleStr;
    self.textviewTop.constant = NaviH + 20;
    if ([self.titleStr isEqualToString:@"过敏史"]) {
        self.textview.placeholder  = @"请说明曾经的过敏历史情况";
        self.textview.text = self.textviewtext;
        NSString *str = @"说明：过敏主要指青霉素、磺胺、链霉素过敏，如有其它药物或者食物等其它物质 （如花粉、酒精、油漆等）过敏，请写明过敏物质名称";
        self.descLb.attributedText = [str AttributedString:@"说明：" backColor:nil uicolor:JHdeepColor uifont:[UIFont systemFontOfSize:15]];
        
    }else if ([self.titleStr isEqualToString:@"其他说明"]) {
        self.textview.placeholder  = @"请输入";
        self.textview.text = self.textviewtext;
        
    }
    
}


- (IBAction)btnClick:(id)sender {
    if (self.selectBlock) {
        self.selectBlock(self.textview.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
