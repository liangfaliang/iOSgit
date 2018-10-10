//
//  ConfirmOrderViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/10/31.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmOrderViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableview;

@property(nonatomic,strong)NSDictionary *payDict;//支付方式
@property(nonatomic,strong)NSDictionary *expressDict;//配送方式
@property(nonatomic,strong)NSDictionary *couponDict;//优惠券
@property(nonatomic,strong)NSString *bill;//发票
@property(nonatomic,strong)NSDictionary *addressDict;//收货地址
@property(nonatomic,strong)NSString *rec_id;//商品id
@property(nonatomic,strong)NSString *shop_id;//店铺ID（商业街中店铺使用）
@property(nonatomic,strong)NSString *is_Integral;//是否为积分兑换
-(void)updateTableview;
-(void)UploadDatagoodsOderInfo;//订单信息数据请求
@end
