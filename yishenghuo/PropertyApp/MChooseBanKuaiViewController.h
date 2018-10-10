//
//  MChooseBanKuaiViewController.h
//  meitan
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 fanyang. All rights reserved.
//

#import "BaseViewController.h"
#import "HSDTagModel.h"
typedef enum {
    SelectPreschool = 0 , /** 幼教类型*/
    SelectReserveTime = 1 , /** 幼教类型*/
    SelectFileStandard = 2  /** 档案标准*/
}choose_type;

@interface MChooseBanKuaiViewController : BaseViewController
@property (nonatomic, assign) choose_type type;
@property (nonatomic, copy) void(^doneBlock)(HSDTagModel *model,id dict);
@property (nonatomic, assign) BOOL isMultiple;//是否为多选
@property (nonatomic, copy) NSString * codeid;
@property (nonatomic, copy) NSString * option_key;
@property (nonatomic, copy) NSString * rs_type;/*可预约建档时间,可预约接种时间,可预约体检时间,可预约建册时间*/
@end
