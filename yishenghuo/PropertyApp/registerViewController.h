//
//  registerViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/9/14.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"
#import "LFLUibutton.h"
@interface registerViewController : BaseViewController
@property(nonatomic,strong)LFLUibutton *sumbtn;
@property(nonatomic,strong)UIImageView *rightImage;
@property(nonatomic,strong)NSMutableString *str;

@property(nonatomic,strong)NSMutableString *strID;
@property(nonatomic,assign)BOOL isAtt;//是否增加认证
@end
