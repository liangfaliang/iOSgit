//
//  businessModel.h
//  PropertyApp
//
//  Created by admin on 2018/8/25.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface businessModel : NSObject
@property (nonatomic, copy) NSString *shop_id; /** 姓名  */
@property (nonatomic, copy) NSString *shop_name; /** 头像 */
@property (nonatomic, copy) NSString *category_name; /** 背景色 */
@property (nonatomic, copy) NSString *province; /** 背景色 */
@property (nonatomic, copy) NSString *city; /** 头像 */
@property (nonatomic, copy) NSString *district; /** 姓名  */
@property (nonatomic, copy) NSString *shop_address; /** 头像 */
@property (nonatomic, copy) NSString *shop_price; /** 背景色 */
@property (nonatomic, copy) NSString *rank; /** 背景色 */
@property (nonatomic, copy) NSString *coordinate_x; /** 头像 */
@property (nonatomic, copy) NSString *coordinate_y; /** 头像 */
@property (nonatomic, strong) NSArray *imgurl; /** 头像 */
@end
