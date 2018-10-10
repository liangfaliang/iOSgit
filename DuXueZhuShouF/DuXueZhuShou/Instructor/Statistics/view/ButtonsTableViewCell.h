//
//  ButtonsTableViewCell.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (copy, nonatomic)  void (^clcikBlock)(NSInteger index);
@end
