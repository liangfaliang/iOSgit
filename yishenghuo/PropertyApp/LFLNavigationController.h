//
//  LFLNavigationController.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/4.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

//声明协议方法
@protocol LFLNavigationControllerDelegate <NSObject>
@optional
- (BOOL)navigationShouldPopOnBackButton;

@end
@interface LFLNavigationController : UINavigationController
@property(nonatomic,assign)id<LFLNavigationControllerDelegate> gobackdelegate;
@property(nonatomic,assign)BOOL isgoBack;

@end
