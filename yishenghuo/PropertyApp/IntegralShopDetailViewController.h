//
//  IntegralShopDetailViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 2017/11/8.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"

@interface IntegralShopDetailViewController : BaseViewController
@property(nonatomic,strong)NSString *goods_id;
@property(nonatomic,strong)NSString *totailPrice;//最新价格
@property(nonatomic,strong)UILabel *priceLb;
@property(nonatomic,copy)void(^commentBlock)();

-(void)UploadDatagoodsEvaluateList;//商品评论请求
-(void)tapClick:(UITapGestureRecognizer *)tap;//隐藏弹出层
@end
