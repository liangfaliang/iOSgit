//
//  FSItem.m
//  FSGridLayoutDemo
//
//  Created by 冯顺 on 2017/6/10.
//  Copyright © 2017年 冯顺. All rights reserved.
//

#import "FSItem.h"
#import "MJExtension.h"
@implementation FSItem

- (NSMutableArray *)itemModels
{
    if (!_itemModels) {
        _itemModels = [NSMutableArray array];
    }
    return _itemModels;
}

+ (FSItem *)getItemWithModel:(FSBaseModel *)base
{
    FSItem *item = [FSItem new];
    item.orientation = base.orientation;
    item.space = base.space;
    for (NSDictionary *dic in base.children) {
        FSBaseModel *subBase = [FSBaseModel mj_objectWithKeyValues:dic];
        if (base.Margins) {
            subBase.Margins = base.Margins;
        }
        if (base.space) {
            subBase.space = base.space;
        }
        [item.itemModels addObject:subBase];
    }
    return item;
}
@end
