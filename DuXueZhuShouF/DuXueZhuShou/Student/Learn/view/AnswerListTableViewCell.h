//
//  AnswerListTableViewCell.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerDetailModel.h"
#import "RecordManage.h"
@interface AnswerListTableViewCell : UITableViewCell <RecordPlayDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *contenLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIView *imageBackview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBackviewHeight;
@property (weak, nonatomic) IBOutlet UIButton *image1;
@property (weak, nonatomic) IBOutlet UIButton *image2;
@property (weak, nonatomic) IBOutlet UIButton *image3;
@property (weak, nonatomic) IBOutlet UIView *audioBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioBackViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioBackViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *secondLb;
@property (copy, nonatomic)void (^replyBtnBlock)(void);
@property (nonatomic,retain)ReplyModel *rmodel;
@end
