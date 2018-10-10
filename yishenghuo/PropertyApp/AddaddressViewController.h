//
//  AddaddressViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/1.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddaddressViewController : BaseViewController
@property(nonatomic,assign)BOOL isAdd;//是否从购物车跳转
@property(nonatomic,strong)NSString *address_id;
@property (nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSString *region;
@property(nonatomic,strong)NSString *regionid;
@end
