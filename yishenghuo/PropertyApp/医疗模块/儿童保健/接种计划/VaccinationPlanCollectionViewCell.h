//
//  VaccinationPlanTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/23.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VaccinationPlanCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UITableView *tabview;
@property(nonatomic,strong)UIView *reserveView;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UILabel *headerLb;
@property(nonatomic,strong)UILabel *footerLb;
@property(nonatomic,copy)void(^block)();
-(void)setBlock:(void (^)())block;
@end
