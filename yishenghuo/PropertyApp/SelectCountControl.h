//
//  SelectCountControl.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/10/18.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockClick) (BOOL isAdd);
@interface SelectCountControl : UIView<UITextFieldDelegate>

@property(nonatomic,strong)UIButton *minusBtn;
@property(nonatomic,strong)UIButton *addBtn;

@property(nonatomic,strong)UITextField *countLabel;
@property(assign,nonatomic)BOOL isClick;//是否可以点击
@property(nonatomic,copy)blockClick block;
-(void)setBlock:(blockClick)block;
@end
