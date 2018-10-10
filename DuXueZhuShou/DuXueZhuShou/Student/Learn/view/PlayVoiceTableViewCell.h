//
//  PlayVoiceTableViewCell.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayVoiceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playBtnHeight;

@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *playIm;
@property (copy,nonatomic)void (^playBtnBlock)(BOOL isDown);
@property (copy,nonatomic)void (^deleteBlock)(void);
@property (copy,nonatomic)void (^replyBlock)(void);
@end
