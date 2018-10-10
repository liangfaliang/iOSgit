//
//  AlertsButton.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/1.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "AlertsButton.h"

@implementation AlertsButton

-(instancetype)init{
    
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}
-(void)initialize{
    self.alertLabel =[[AlertLable alloc]init];
    self.alertLabel.backgroundColor = [UIColor redColor];
    self.alertLabel.textColor = [UIColor whiteColor];
    self.alertLabel.font = [UIFont systemFontOfSize:12];
    self.alertLabel.textAlignment = NSTextAlignmentCenter;
    self.alertLabel.adjustsFontSizeToFitWidth = YES;
    self.alertLabel.layer.cornerRadius = 7.5;
    self.alertLabel.layer.masksToBounds = YES;
    self.alertLabel.hidden = YES;
    [self addSubview:self.alertLabel];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat wid = [self.alertLabel.text selfadapUifont:self.alertLabel.font weith:20].width + 5;
    LFLog(@"alertLabel:%f",wid);
    if (wid < 15) {
        wid = 15;
    }else if (wid > 20){
        wid = 25;
    }
    [self.alertLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_right).offset(0);
        make.centerY.equalTo(self.mas_top).offset(0);
        if (!self.alertLabel.hidden) {
            make.width.offset(wid);
        }else{
            make.width.offset(15);
        }
        
        make.height.offset(15);
        //        make.height.equalTo(self.alertLabel.mas_width).multipliedBy(1);
    }];
    
    
    
}

-(void)setAlertLabel:(AlertLable *)alertLabel{
    
    _alertLabel = alertLabel;
    //    if ([_alertLabel.text isEqualToString:@"0"] || _alertLabel.text.length ==0) {
    //        _alertLabel.hidden = YES;
    //    }else{
    //        _alertLabel.hidden = NO;
    //    }
}

@end

