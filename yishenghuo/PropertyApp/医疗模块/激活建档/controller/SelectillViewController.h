//
//  SelectillViewController.h
//  PropertyApp
//
//  Created by admin on 2018/7/27.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"

@interface SelectillViewController : BaseViewController
@property(nonatomic,copy)void (^selectBlock)(NSString *text);
@property (strong, nonatomic)  UITextView *textview;
@property (retain, nonatomic)  NSString *illtext;
@property (retain, nonatomic)  NSMutableArray *selectNameArr;
@end
