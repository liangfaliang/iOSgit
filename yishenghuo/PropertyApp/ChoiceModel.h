//
//  ChoiceModel.h
//  shop
//
//  Created by 梁法亮 on 16/8/18.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "JSONModel.h"
//#import "OptionModel.h"
@protocol OptionModel <NSObject>

@end
@interface ChoiceModel : JSONModel

@property(nonatomic,copy)NSString <Optional>*subject_id;

@property(nonatomic,copy)NSString <Optional>*subject_name;

@property(nonatomic,copy)NSString <Optional>*is_radio;//是否单选1 
@property(nonatomic,assign)NSInteger opinion;
@property(nonatomic,strong)NSMutableArray <OptionModel >* option;
@property(nonatomic,copy)NSString <Optional>*opinioncontent;//输入意见
@property(nonatomic,assign)NSInteger is_required;//意见是否必填 1必填
//@property(nonatomic,copy)NSMutableArray <Optional>* optionmode;
@end

@interface OptionModel : JSONModel
@property(nonatomic,copy)NSString <Optional>*id;

@property(nonatomic,copy)NSString <Optional>*name;

@property(nonatomic,copy)NSString <Optional>*option;
@property(nonatomic,assign)NSInteger opinion;//是否显示意见
@property(nonatomic,copy)NSString <Optional>*is_check;
@property(nonatomic,copy)NSString <Optional>*isopion;//输入意见
@end
