//
//  PaymentListTableViewCell.m
//  PropertyApp
//
//  Created by admin on 2018/8/13.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "PaymentListTableViewCell.h"
#import "UIView+TYAlertView.h"
#import "PayTextView.h"
#import "PaymentDetailViewController.h"
@implementation PaymentListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    self.tf1.delegate = self;
    self.tf2.delegate = self;

}
-(void)setModel:(PayNewModel *)model{
    _model = model;
    if ([model.fc_type isEqualToString:@"dqsf"]) {
        [self hideSubViews:NO];
    }else{
        [self hideSubViews:YES];
    }
    self.tf1.text = model.textEle;
    self.tf2.text = model.textWater;
    NSArray *keyArr = @[@"cu_name",@"company",@"po_name",@"fr_period",@"hj"];
    for (int i = 1; i < 6; i ++) {
        NSString *name = [NSString stringWithFormat:@"lab%d",i];
        UILabel *lb = [self valueForKey:name];
        lb.text = [model valueForKey:keyArr[i-1]];
    }
}
-(void)hideSubViews:(BOOL)isH{
    if (!isH) {
        self.tf1Height.constant = 65;
        self.tf2Height.constant = 20;
        self.nameLb1.hidden = NO;
        self.nameLb2.hidden = NO;
        self.vline1.hidden = NO;
        self.vlin2.hidden = NO;
    }else{
        self.tf1Height.constant = 0;
        self.tf2Height.constant = 0;
        self.nameLb1.hidden = YES;
        self.nameLb2.hidden = YES;
        self.vline1.hidden = YES;
        self.vlin2.hidden = YES;
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    PayTextView *alertview = [PayTextView createViewFromNib];
    if (textField == self.tf2) {
        alertview.titleLb.text = @"预存水费";
        alertview.textF.placeholder = @"请输入预存水费";
        alertview.textF.keyboardType = UIKeyboardTypeNumberPad;
    }
    alertview.btnClickBlock = ^(BOOL isCancel, NSString *text) {
        if (!isCancel) {
            if (textField == self.tf2) {
                _model.textWater = text;
            }else{
                _model.textEle = text;
            }
            textField.text = text;
        }
    };
    [alertview showInWindow];
    alertview.superview.backgroundColor = JHColoralpha(0, 0, 0, 0.3);
//    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"购电金额" message:@""];
//    alertView.titleLable.textColor = JHmiddleColor;
//    alertView.messageLabel.textColor = JHmiddleColor;
//    alertView.buttonCancelBgColor = [UIColor whiteColor];
//    alertView.buttonDestructiveBgColor = [UIColor whiteColor];
//    alertView.buttonTextColor = JHMedicalColor;
//    alertView.backgroundColor = [UIColor whiteColor];
//    alertView.textFieldBorderColor = [UIColor whiteColor];
//    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"请输入账号";
//        UIView *vline = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(textField.frame), CGRectGetWidth(textField.frame), 1)];
//        vline.backgroundColor = [UIColor redColor];
//        [textField addSubview:vline];
//        [vline mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.offset(0);
//            make.left.offset(0);
//            make.right.offset(0);
//            make.height.offset(1);
//        }];
//        
//    }];
//    WEAKSELF;
//    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
//
//    }]];
//    
//    [alertView addAction:[TYAlertAction actionWithTitle:@"确认" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
//       
//    }]];
//    
//    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
//    alertController.backgroundColor =JHColoralpha(0, 0, 0, 0.3);
//    //alertController.alertViewOriginY = 60;
//    [[self viewController] presentViewController:alertController animated:YES completion:nil];
    return NO;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)detailClick:(id)sender {
    PaymentDetailViewController *detail = [[PaymentDetailViewController alloc]init];
    detail.model = _model;
    [[self viewController].navigationController pushViewController:detail animated:YES];
}

@end
