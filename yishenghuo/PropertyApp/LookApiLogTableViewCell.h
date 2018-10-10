//
//  LookApiLogTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2017/9/1.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookApiLogTableViewCell : UITableViewCell <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *numLb;
@property (weak, nonatomic) IBOutlet UITextView *urlLb;
@property (weak, nonatomic) IBOutlet UITextView *contentLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *urlLbHeight;

@end
