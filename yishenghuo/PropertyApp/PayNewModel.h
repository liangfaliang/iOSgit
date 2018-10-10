//
//  PayNewModel.h
//  PropertyApp
//
//  Created by admin on 2018/8/13.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayNewModel : NSObject
@property (nonatomic,copy) NSString * fc_type;
@property (nonatomic,copy) NSString * cu_name;
@property (nonatomic,copy) NSString * po_name;
@property (nonatomic,copy) NSString * cuid;
@property (nonatomic,copy) NSString * em_MaxElecPurchase;
@property (nonatomic,copy) NSString * poid;
@property (nonatomic,copy) NSString * company;
@property (nonatomic,copy) NSString * fr_period;
@property (nonatomic,copy) NSString * hj;
@property (nonatomic,copy) NSString * frids;
@property (nonatomic,copy) NSString * max_amou;
@property (nonatomic,strong) NSArray * dqfy;

//已支付
@property (nonatomic,copy) NSString * fa_month;
@property (nonatomic,copy) NSString * fa_total;
@property (nonatomic,copy) NSString * fa_date;
@property (nonatomic,copy) NSString * faid;

@property (nonatomic, assign) NSInteger isSelect;
@property (nonatomic,copy) NSString * textEle;
@property (nonatomic,copy) NSString * textWater;
@end
