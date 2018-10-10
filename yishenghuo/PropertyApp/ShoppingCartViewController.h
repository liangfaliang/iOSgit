//
//  ShoppingCartViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/1.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void	(^cartBlock)( NSArray * cartArr ,NSInteger count );
@interface ShoppingCartViewController : BaseViewController
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(ShoppingCartViewController);
@property(nonatomic,copy)cartBlock block;
-(void)UploadDataCartList;
-(void)setBlock:(cartBlock)block;
@end
