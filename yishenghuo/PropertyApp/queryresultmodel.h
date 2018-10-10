//
//  queryresultmodel.h
//  shop
//
//  Created by 梁法亮 on 16/6/28.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "JSONModel.h"

@interface queryresultmodel : JSONModel

@property(nonatomic,strong)NSString <Optional>*date;
@property(nonatomic,strong)NSString <Optional>*area;

@property(nonatomic,strong)NSString <Optional>*code;
@property(nonatomic,strong)NSString <Optional>*fen;
@property(nonatomic,strong)NSString <Optional>*money;
@property(nonatomic,strong)NSString <Optional>*handled;
@property(nonatomic,strong)NSString <Optional>*act;


@end
