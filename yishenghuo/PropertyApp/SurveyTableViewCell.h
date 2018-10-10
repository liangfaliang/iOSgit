//
//  SurveyTableViewCell.h
//  shop
//
//  Created by 梁法亮 on 16/8/22.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "surveyModel.h"
@interface SurveyTableViewCell : UITableViewCell

@property(nonatomic,assign)NSInteger tetail;
@property(nonatomic,assign)NSInteger taga;
@property(nonatomic,strong)surveyModel *model;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UILabel *contentLb;
@property(nonatomic,strong)NSArray *colorArr;
@end
