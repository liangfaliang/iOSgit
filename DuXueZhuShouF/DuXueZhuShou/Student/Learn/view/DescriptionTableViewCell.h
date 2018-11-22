//
//  DescriptionTableViewCell.h
//  TsApartment
//
//  Created by 梁法亮 on 2018/7/5.
//  Copyright © 2018年 PmMaster. All rights reserved.
//

#import "BasicTableViewCell.h"
#import "AnswerDetailModel.h"
@interface DescriptionTableViewCell : BasicTableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *namelbBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLbHeight;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet YYLabel *nameLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLbRight;

@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UIView *imageBackview;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UIImageView *image6;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBackHeight;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyBtnHeight;
@property (copy, nonatomic)void (^replyBtnBlock)(void);
@property(nonatomic, strong)AnswerDetailModel *Amodel;
@property(nonatomic, strong)IgDetailModel *Imodel;
-(void)setNamelbText:(NSString *)text;
-(void)setNamelbattributedText:(NSAttributedString *)text;
-(void)setImageArr:(NSArray *)imageArr;
-(NSMutableAttributedString *)getAttribute:(NSString *)str title:(NSString *)title;
@end
