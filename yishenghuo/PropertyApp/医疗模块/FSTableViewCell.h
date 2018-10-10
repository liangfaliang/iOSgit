//
//  FSTableViewCell.h
//  FSGridLayoutDemo
//
//  Created by 冯顺 on 2017/6/10.
//  Copyright © 2017年 冯顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSGridLayoutView.h"

@interface FSTableViewCell : UITableViewCell<FSGridLayoutViewDelegate>

@property (nonatomic, strong) FSGridLayoutView *layoutView;
@property (nonatomic, strong) id json;
@end
