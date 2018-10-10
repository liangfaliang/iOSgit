//
//  FooterInputView.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/5/2.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FooterInputView : UIView<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *tf;
@property(nonatomic,strong)NSString *text;
@property(nonatomic,strong)NSMutableArray *btnArr;
@property(nonatomic,strong)NSMutableArray *btnSelectArr;
-(void)removeAllview;
@end
