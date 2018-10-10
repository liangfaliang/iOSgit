//
//  DoodsDetailsViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/10/17.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^cartblockClick)(NSString *str );
@interface DoodsDetailsViewController : BaseViewController
@property(nonatomic,strong)NSString *goods_id;
@property(nonatomic,strong)NSString *totailPrice;//最新价格
@property(nonatomic,strong)UILabel *priceLb;
@property(nonatomic,copy)cartblockClick block;
@property(nonatomic,copy)void(^commentBlock)();
-(void)addCart;
-(void)setBlock:(cartblockClick)block;
-(void)UploadDatagoodsEvaluateList;//商品评论请求
-(void)UploadDatagoodsAddCart:(BOOL)isSettle iscart:(BOOL)iscart;//加购物车
-(void)tapClick:(UITapGestureRecognizer *)tap;//隐藏弹出层
@end
