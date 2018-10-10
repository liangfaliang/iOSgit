//
//  HealthRecordHeaderview.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/19.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZImagePickerController.h"
@interface HealthRecordHeaderview : UIView <TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UIButton *upIconBtn;
@property (strong, nonatomic) UIImage *iconIm;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLbHeight;


@end
