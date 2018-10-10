//
//  TextFiledLableTableViewCell.h
//  PropertyApp
//
//  Created by admin on 2018/7/20.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFiledModel.h"
@interface TextFiledLableTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UITextField *textfiled;
@property (copy, nonatomic)void (^TextChangeBlock)(NSString *text);
@property (copy, nonatomic)void (^selectBtnBlock)(NSInteger index);
@property (retain,nonatomic)TextFiledModel *model;
@property (copy,nonatomic)NSString *rightim;
@property (strong,nonatomic)UIImageView *rightView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLbLeft;
@property (nonatomic, strong) UIView *selectTimeView;
- (void)setRightim:(NSString *)rightim rView:(id )rView;
@end
