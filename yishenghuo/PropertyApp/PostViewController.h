//
//  PostViewController.h
//  shop
//
//  Created by 梁法亮 on 16/5/10.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SuccessblockClick)();

@interface PostViewController : BaseViewController

@property(nonatomic,strong)NSMutableDictionary *dit;

@property(nonatomic,copy)NSString *category;
@property(nonatomic,strong)UILabel *lab;
@property(nonatomic,copy)SuccessblockClick block;

-(void)setBlock:(SuccessblockClick)block;
@end
