//
//  ShopCollectionViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/8.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^stroeBlock) (NSString *str);
typedef void(^shopBlock) (NSInteger index);
@interface ShopCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *shopDescLb;
@property (weak, nonatomic) IBOutlet UIButton *shopButton;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property(nonatomic,copy)stroeBlock block;
@property(nonatomic,copy)shopBlock shopblock;
-(void)setBlock:(stroeBlock)block;
-(void)setShopblock:(shopBlock)shopblock;
@end
