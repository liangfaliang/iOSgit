//
//  PaymentListViewController.h
//  PropertyApp
//
//  Created by admin on 2018/8/13.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, PayMenttypeStyle) {
    PayMentStyleNew = 0,                  // 能源周刊
    PayMentStyleHalfYear = 1,        // 能源思考
    PayMentStyleYear = 2,           // 能源书籍
    PayMentStyleAlready = 3           // 能源书籍
};
@interface PaymentListViewController : BaseViewController
@property(nonatomic,assign)PayMenttypeStyle type;
@end
