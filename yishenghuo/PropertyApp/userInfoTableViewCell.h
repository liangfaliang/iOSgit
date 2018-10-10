//
//  userInfoTableViewCell.h
//  shop
//
//  Created by 梁法亮 on 16/5/11.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface userInfoTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *iconLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabe;
@property (retain, nonatomic) IBOutlet UILabel *imageLabe;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLbWidth;

@end
