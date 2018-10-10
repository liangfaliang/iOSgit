//
//  ShopAppraiseViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/19.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"
#import "ShopDoodsDetailsViewController.h"
@interface ShopAppraiseViewController : BaseViewController
@property(nonatomic,strong)NSString *goods_id;
@property(nonatomic,strong)ShopDoodsDetailsViewController *main;
@property(nonatomic,strong)UIButton *selectBtn;
#pragma mark 选择按钮
-(void)segmentclick:(UIButton *)seg;
@end
