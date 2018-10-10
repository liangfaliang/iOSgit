//
//  SurveyTableViewCell.m
//  shop
//
//  Created by 梁法亮 on 16/8/22.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "SurveyTableViewCell.h"

@implementation SurveyTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.colorArr = @[JHColor(153, 184, 232),JHColor(254, 212, 135),JHColor(179, 232, 227),JHColor(153, 184, 232),JHColor(254, 212, 135),JHColor(179, 232, 227)];

    }

    return self;
}

-(void)setModel:(surveyModel *)model{

    _model = model;
    NSString *str = [NSString stringWithFormat:@"%ld.%@",(long)self.taga,model.subject_name];
    CGSize titlesize = [str selfadap:15 weith:20];
    CGFloat HH = 20;
    if (titlesize.height > HH) {
        HH = titlesize.height + 5;
    }
    self.titleLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN.size.width - 40, HH)];
    self.titleLb.font = [UIFont systemFontOfSize:15];
    self.titleLb.numberOfLines = 0;
    self.titleLb.textColor = JHdeepColor;
    
    [self.contentView addSubview:_titleLb];
    self.titleLb.text = str;
    if (_contentLb == nil) {
        _contentLb = [[UILabel alloc]initWithFrame:CGRectMake(20, HH + 15, SCREEN.size.width - 55, 0)];
        _contentLb.font = [UIFont systemFontOfSize:15];
        _contentLb.textColor = JHmiddleColor;
        _contentLb.numberOfLines = 0;
    }
    NSMutableString *mstr = [NSMutableString string];
    for (int i = 0; i < model.option.count; i ++) {
        SurOptionModel *opmodel  = model.option[i];
        [mstr appendFormat:@"%@",opmodel.option];
        if (i < model.option.count - 1) {
            [mstr appendString:@","];
        }else{
          [mstr appendString:@"; "];
        }
    }
    
    _contentLb.text = [NSString stringWithFormat:@"答：%@%@",mstr,model.opinion];
    _contentLb.frame = CGRectMake(20, HH + 15, SCREEN.size.width - 25, [_contentLb.text selfadap:15 weith:25].height + 10);
    [self.contentView addSubview:_contentLb];
//    for (int i = 0; i < model.option.count; i ++) {
//        SurOptionModel *opmodel = model.option[i];
//        UILabel *lb =[self.contentView viewWithTag:self.taga * 10 + i ];
//        if (lb == nil) {
//            lb = [[UILabel alloc]initWithFrame:CGRectMake(10, HH + 20 + i * 60, SCREEN.size.width - 40, 20)];
//            lb.tag = self.taga * 10 + i;
//            
//        }
//        lb.font = [UIFont systemFontOfSize:14];
//        lb.text = opmodel.name;
//        [self.contentView addSubview:lb];
//
//        
//        UIView *vw =[ self viewWithTag:self.taga * 10 + i + 4000];
//        if (vw == nil) {
//            vw = [[UIView alloc]init];
//            vw.tag = self.taga * 10 + i+ 4000;
//            vw.backgroundColor = [UIColor whiteColor];
//            vw.layer.borderColor = [JHColor(222, 222, 222) CGColor];
//            vw.layer.borderWidth = 1;
//            [self.contentView addSubview:vw];
//            [vw mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(lb.mas_bottom).offset(0);
//                make.left.offset(10);
//                make.height.offset(20);
//                make.width.offset(SCREEN.size.width - 60);
//                
//            }];
//            
//        }
//
//
//        
//        double count = [opmodel.count doubleValue];
//        double num = 0;
//        if (self.tetail > 0) {
//            num = ((double)count/(double)self.tetail);
//        }
//        CGFloat WW = (SCREEN.size.width - 60) * num;
//        UILabel *vwlb  =[ self viewWithTag:self.taga * 10 + i + 6000];
//        if (vwlb == nil) {
//            vwlb = [[UILabel alloc]init];
//            vwlb.tag = self.taga * 10 + i+ 6000;
//            vwlb.backgroundColor = self.colorArr[i];
//            [vw addSubview:vwlb];
//            [vwlb mas_makeConstraints:^(MASConstraintMaker *make) {
//                
//                make.left.offset(0);
//                make.top.offset(0);
//                make.bottom.offset(0);
//                make.width.offset(WW);
//                
//            }];
//        }
//
//        UILabel *conlb  =[ self viewWithTag:self.taga * 10 + i+ 8000];
//        if (conlb == nil) {
//            conlb = [[UILabel alloc]init];
//            conlb.tag = self.taga * 10 + i+ 8000;
//            conlb.font =[UIFont systemFontOfSize:12];
//            conlb.text = opmodel.count;
//            [self.contentView addSubview:conlb];
//            [conlb mas_makeConstraints:^(MASConstraintMaker *make) {
//                
//                make.right.offset(-10);
//                make.centerY.equalTo(vw.mas_centerY);
//                make.width.offset(20);
//                
//            }];
//
//        }
//
//    }



}


@end
