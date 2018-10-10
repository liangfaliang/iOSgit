//
//  PayModel.h
//  PropertyApp
//
//  Created by 梁法亮 on 17/3/14.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "JSONModel.h"
@protocol PayinfoModel
@end
@interface PayModel : JSONModel
@property (nonatomic,strong) NSString <Optional>* le_name;

@property (nonatomic,strong) NSString <Optional>* le_name1;

@property (nonatomic,strong) NSString <Optional>* tel;

@property (nonatomic,strong) NSString <Optional>* poid;
@property (nonatomic,strong) NSString <Optional>* po_name;
@property (nonatomic,strong) NSString <Optional>* sp_spua;
@property (strong, nonatomic) NSArray<PayinfoModel>* note;
@end


@interface PayinfoModel : JSONModel
@property (nonatomic,strong) NSString <Optional>* frid;

@property (nonatomic,strong) NSString <Optional>* it_name;

@property (nonatomic,strong) NSString <Optional>* fr_pric;

@property (nonatomic,strong) NSString <Optional>* fr_unit;
@property (nonatomic,strong) NSString <Optional>* fr_beginT;

@property (nonatomic,strong) NSString <Optional>* fr_endT;

@property (nonatomic,strong) NSString <Optional>* fr_amou;
@property (nonatomic,strong) NSString <Optional>* isSelect;
@end



