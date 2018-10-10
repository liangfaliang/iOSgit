//
//  MineHeaderView.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/9.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZImagePickerController.h"
@interface MineHeaderView : UIView <TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconIm;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *gardeLb;
+ (MineHeaderView *)view;
@end
