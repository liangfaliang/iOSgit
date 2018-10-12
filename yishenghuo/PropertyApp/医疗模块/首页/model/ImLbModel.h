//
//  ImLbModel.h
//  PropertyApp
//
//  Created by admin on 2018/7/25.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImLbModel : NSObject
@property (nonatomic, copy) NSString *name; /** 姓名  */
@property (nonatomic, copy) NSString *imgurl; /** 头像 */
@property (nonatomic, copy) NSString *backcolor; /** 背景色 */
@property (nonatomic, copy) NSString *backimage; /** 背景色 */
@property (nonatomic, copy) NSString *textcolor; /** 背景色 */
@property (nonatomic, copy) NSString *cornerRadius; /** 头像 */
@property (nonatomic, strong) NSNumber * height; /**高度 */
@property (nonatomic, strong) NSDictionary *data; /** 头像 */
@property (nonatomic, strong) NSArray <ImLbModel *> * child; /** 头像 */
@end
