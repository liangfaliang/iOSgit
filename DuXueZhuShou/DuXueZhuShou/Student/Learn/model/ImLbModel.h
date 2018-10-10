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
@property (nonatomic, strong) NSDictionary *data; /** 头像 */
@property (nonatomic, assign) NSInteger isSelect; /** 头像 */


@property (nonatomic, copy) NSString *msg_type; /** 头像 */
@end
