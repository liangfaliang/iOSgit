//
//  InformationViewController.h
//  shop
//
//  Created by wwzs on 16/4/14.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InforViewController.h"
@interface InformationViewController : BaseViewController
@property(assign,nonatomic)NSInteger tag;
@property(nonatomic,strong)NSString *isPop;
@property(nonatomic,assign)InfotypeStyle type;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *titleStr;

@end
