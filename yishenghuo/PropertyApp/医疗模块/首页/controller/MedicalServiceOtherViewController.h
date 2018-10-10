//
//  MedicalServiceOtherViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/7/25.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, ServicetypeStyle) {
    ServiceStyleYun = 0,                  // 能源周刊
    ServiceStyleYing = 1,        // 能源思考
    ServiceStyleMan = 2,            // 能源书籍
};
@interface MedicalServiceOtherViewController : BaseViewController
@property (nonatomic, assign) ServicetypeStyle typeStyle;
@end
