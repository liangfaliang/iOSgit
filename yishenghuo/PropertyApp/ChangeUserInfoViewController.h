//
//  ChangeUserInfoViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/29.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeUserInfoViewController : BaseViewController
@property(nonatomic,strong)NSString *nameTitle;
@property(nonatomic,assign)NSInteger tag;
@property(nonatomic,strong)NSString *name;

@property (nonatomic,copy) void (^Block)(NSString *str);
@end
