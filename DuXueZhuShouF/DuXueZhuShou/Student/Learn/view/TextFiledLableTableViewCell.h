//
//  TextFiledLableTableViewCell.h
//  PropertyApp
//
//  Created by admin on 2018/7/20.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFiledModel.h"
#import "AutoWidBtn.h"
#import "MyUITextField.h"
@interface TextFiledLableTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet AutoWidBtn *nameBtn;
//@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet MyUITextField *textfiled;
@property (copy, nonatomic)void (^TextChangeBlock)(NSString *text);
@property (copy, nonatomic)void (^nameBtnBlock)(void);
@property (copy, nonatomic)void (^contentLbBlock)(void);
@property (copy, nonatomic)void (^rightViewBlock)(void);
@property (retain,nonatomic)TextFiledModel *model;
@property (copy,nonatomic)NSString *rightim;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NameTfSpace;
@property (strong,nonatomic)UIImageView *rightView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLbLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLbRight;

- (void)setRightim:(NSString *)rightim rView:(id )rView;
@end
