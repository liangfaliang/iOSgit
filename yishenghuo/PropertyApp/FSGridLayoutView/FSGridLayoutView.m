//
//  FSGridLayoutView.m
//  GridLayoutDemo
//
//  Created by huim on 2017/6/9.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "FSGridLayoutView.h"

//#import <Masonry.h>
//#import <UIImageView+AFNetworking.h>
#import "FSTapGestureRecognizer.h"
#import "FSBaseModel.h"
#import "FSItem.h"
#import "UIView+FSEqualMargin.h"
#import "NSString+YTString.h"
#define DebugLog(...) NSLog(__VA_ARGS__)

@implementation FSGridLayoutView

#pragma mark Setter

-(void)setJson:(id)json{
    FSBaseModel *baseModel = [FSBaseModel mj_objectWithKeyValues:json];
    DebugLog(@"共有--%lu行",(unsigned long)baseModel.images.count);
    [FSGridLayoutView getRowsTotalHeight:baseModel];
    NSMutableArray *rows = [NSMutableArray array];
    for (NSDictionary *dic in baseModel.images) {
        FSBaseModel *base = [FSBaseModel mj_objectWithKeyValues:dic];
        if (base.height) {
            [rows addObject:base];
        }
    }
    [self setupRowsViewWithArr:rows];
}
- (void)setJsonStr:(NSString *)jsonStr
{
    FSBaseModel *baseModel = [FSBaseModel mj_objectWithKeyValues:jsonStr];
    DebugLog(@"共有--%lu行",(unsigned long)baseModel.images.count);
    [FSGridLayoutView getRowsTotalHeight:baseModel];
    NSMutableArray *rows = [NSMutableArray array];
    for (NSDictionary *dic in baseModel.images) {
        FSBaseModel *base = [FSBaseModel mj_objectWithKeyValues:dic];
        if (base.height) {
            [rows addObject:base];
        }
    }
    [self setupRowsViewWithArr:rows];
}

+ (CGFloat)GridViewHeightWithJsonStr:(id)json
{

    FSBaseModel *baseModel = [FSBaseModel mj_objectWithKeyValues:json];
    LFLog(@"jsondt:%@",json);
    return [FSGridLayoutView getRowsTotalHeight:baseModel];
}

#pragma mark ----
//创建row
- (void)setupRowsViewWithArr:(NSMutableArray *)rows
{
    CGFloat row_H = 0;
    int i = 0;
    for (FSBaseModel *base in rows) {
        UIImageView *rowView = [[UIImageView alloc]init];
        rowView.backgroundColor = [FSGridLayoutView randomColor];
        [self addSubview:rowView];
        
        double linspace = 0;
        if (base.Margins > 0 && base.Margins < SCREEN.size.width) {
            if (i == 0 || i == base.images.count -1) {
                if (base.Margins) {
                    row_H += base.Margins ;
                }
            }
            linspace = base.Margins;
            
        }
        [rowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(row_H);
//            make.left.right.mas_equalTo(self);
            make.left.offset(linspace);
            make.right.offset(-linspace);
            make.height.mas_equalTo(base.height);
        }];
        row_H += base.height;
        if ( i < base.images.count -1) {
            if (base.space > 0 && base.space < SCREEN.size.width) {
               row_H += base.space;
            }
        }
        i ++;
        
        [self setupItemViewWithItemModel:[FSItem getItemWithModel:base] parentView:rowView];
    }
}

//创建item
- (void)setupItemViewWithItemModel:(FSItem *)item parentView:(UIImageView *)parentView
{
    parentView.userInteractionEnabled = YES;
    CGFloat totalWeight = 0;
    double space = 0;
    double Margins = 0;
    int i = 0;
    for (FSBaseModel *subBase in item.itemModels) {
        totalWeight += subBase.weight;
        if (i < item.itemModels.count -1) {
            space += subBase.space;
        }
        Margins = subBase.Margins;
        i ++;
    }
    double multip = space/(SCREEN.size.width - Margins*2);
    if (item.itemModels.count > 1) {
        multip = multip/(double)(item.itemModels.count -1) *0.5;
    }else{
        multip =0;
    }
    NSMutableArray *subViews = [NSMutableArray array];
    for (FSBaseModel *subBase in item.itemModels) {
        UIImageView *itemView = [[UIImageView alloc]init];
        itemView.backgroundColor = [FSGridLayoutView randomColor];
        [parentView addSubview:itemView];
        if ([item.orientation isEqualToString:@"h"]) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(parentView).multipliedBy(subBase.weight/totalWeight - multip);
                make.top.bottom.mas_equalTo(parentView);
            }];
        }else{
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(parentView).multipliedBy(subBase.weight/totalWeight- multip);
                make.left.right.mas_equalTo(parentView);
            }];
        }
        
        [subViews addObject:itemView];
        
        if (subBase.children) {//数据有children，就一直分割下去
            [self setupItemViewWithItemModel:[FSItem getItemWithModel:subBase] parentView:itemView];
        }
        
        if (subBase.image) {//有image就显示，代表分割到底了
            itemView.userInteractionEnabled = YES;
            if (![subBase.image isValidUrl]) {
                itemView.image = [UIImage imageNamed:subBase.image];
            }else{
                [itemView sd_setImageWithURL:[NSURL URLWithString:subBase.image] placeholderImage:[UIImage imageNamed:@""]];//placeholderImage
            }
            FSTapGestureRecognizer *itemTap = [[FSTapGestureRecognizer alloc]initWithTarget:self action:@selector(itemTap:)];
            itemTap.param = subBase.image;
            itemTap.dataDt = subBase.data;
            [itemView addGestureRecognizer:itemTap];
        }
        
        itemView.layer.borderColor = JHBorderColor.CGColor;
        itemView.layer.borderWidth = 0.5f;
    }
    [item.orientation isEqualToString:@"h"]?[parentView distributeSpacingHorizontallyWith:subViews space:item.space]:[parentView distributeSpacingVerticallyWith:subViews];
}

//获得整个FSGridLayoutView的高度
+ (CGFloat)getRowsTotalHeight:(FSBaseModel *)baseModel
{
    CGFloat height = 0;
    int i = 0;
    for (NSDictionary *dic in baseModel.images) {
        FSBaseModel *subBase = [FSBaseModel mj_objectWithKeyValues:dic];
        if (subBase.height) {
            height += subBase.height ;
        }
        if (i == 0 || i < baseModel.images.count -1) {
            if (subBase.space) {
                height += subBase.space ;
            }
        }
        if (i == 0 || i == baseModel.images.count -1) {
            if (subBase.Margins) {
                height += subBase.Margins ;
            }
        }
        i ++;
    }
    return height;
}

#pragma mark Tap
- (void)itemTap:(id)sender
{
    FSTapGestureRecognizer *tap = (FSTapGestureRecognizer *)sender;
    DebugLog(@"点击了--%@",tap.param);
    if (_delegate &&[_delegate respondsToSelector:@selector(FSGridLayouClickCell:itemDt:)]) {
        [self.delegate FSGridLayouClickCell:self itemDt:tap.dataDt];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(FSGridLayouClickCell:)]) {
        [self.delegate FSGridLayouClickCell:tap.dataDt];
    }
}

+ (UIColor*) randomColor{
//    NSInteger r = arc4random() % 255;
//    NSInteger g = arc4random() % 255;
//    NSInteger b = arc4random() % 255;
//    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
    return [UIColor whiteColor];
}

@end
