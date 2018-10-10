//
//  GrabVolumeTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/1/4.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "progressView.h"
typedef void(^rushBlock) ();
@interface GrabVolumeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *leftBackview;
@property (weak, nonatomic) IBOutlet UIView *rightBackview;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
@property (weak, nonatomic) IBOutlet progressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *hourLb;
@property (weak, nonatomic) IBOutlet UILabel *minuteLb;
@property (weak, nonatomic) IBOutlet UILabel *secondLb;
@property (weak, nonatomic) IBOutlet UIImageView *leftTopImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imAcpect;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightViewWidth;
@property(nonatomic,copy)rushBlock block;
-(void)setBlock:(rushBlock)block;
@end
