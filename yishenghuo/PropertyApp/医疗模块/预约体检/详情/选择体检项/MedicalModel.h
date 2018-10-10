//
//  MedicalModel.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/16.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ItemModel <NSObject>

@end
@interface MedicalModel : JSONModel
@property(nonatomic,copy)NSString <Optional>*name;
@property(nonatomic,copy)NSString <Optional>*desc;
@property(nonatomic,strong)NSMutableArray <ItemModel >* list;
@property(nonatomic,copy)NSString <Optional>*Allselect;//是否被选中
@end
@interface ItemModel : JSONModel
@property(nonatomic,copy)NSString <Optional>*id;
@property(nonatomic,copy)NSString <Optional>*name;
@property(nonatomic,copy)NSString <Optional>* price;//
@property(nonatomic,copy)NSString <Optional>*select;//是否被选中 1 选中
@property(nonatomic,copy)NSString <Optional>*isFree;//是否免费 1 免费
@end
