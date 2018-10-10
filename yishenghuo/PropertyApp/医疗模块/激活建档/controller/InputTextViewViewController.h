//
//  InputTextViewViewController.h
//  PropertyApp
//
//  Created by admin on 2018/7/27.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"

@interface InputTextViewViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,copy)NSString *textviewtext;
@property(nonatomic,copy)void (^selectBlock)(NSString *text);
@end
