//
//  InforViewController.h
//  shop
//
//  Created by wwzs on 16/4/20.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, InfotypeStyle) {
    InfoStyleWenZhang = -1,
    InfoStyleWuYe = 0,                  //
    InfoStyleYiLiao = 1,        //
    InfoStyleShangYe = 2,            //
    InfoStyleSanJin = 3,
    InfoStyleYouJiao = 4
};
@interface InforViewController : BaseViewController
@property(nonatomic,strong)NSString *detailid;
@property(nonatomic,assign)InfotypeStyle type;

@end
