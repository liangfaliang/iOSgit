//
//  LFLTabbar.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/4.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonBlock)(NSUInteger index);

@interface LFLTabbar : UIView

@property(nonatomic,assign)BOOL isSelect;

//UITabBarItem的实质就是一个数据模型
@property(nonatomic,strong) UITabBarItem * item;

@property(nonatomic,copy)buttonBlock bolock;

-(void)setBolock:(buttonBlock)bolock;
@end
