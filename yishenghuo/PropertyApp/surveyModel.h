//
//  surveyModel.h
//  shop
//
//  Created by 梁法亮 on 16/8/23.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "JSONModel.h"
@protocol SurOptionModel <NSObject>

@end
@interface surveyModel : JSONModel

@property(nonatomic,copy)NSString <Optional>*subject_id;

@property(nonatomic,copy)NSString <Optional>*subject_name;

@property(nonatomic,strong)NSMutableArray <SurOptionModel >* option;
@property(nonatomic,copy)NSString <Optional>*opinion;

@end
@interface SurOptionModel : JSONModel
@property(nonatomic,copy)NSString <Optional>*id;

@property(nonatomic,copy)NSString <Optional>*name;

@property(nonatomic,copy)NSString <Optional>*option;

@property(nonatomic,copy)NSString <Optional>*count;
@end
