//
//  MyFileModel.h
//  PropertyApp
//
//  Created by admin on 2018/7/23.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyFileReModel : NSObject
@property (nonatomic, copy) NSString *tr_name; /**< 档案编号*/
@property (nonatomic, copy) NSString *tr_InterfaceID; /** 姓名  */
@property (nonatomic, copy) NSString *time; /** 身份证号 */
@property (nonatomic, copy) NSString *tr_imgurl; /** 头像 */

@end

@interface MyFileModel : NSObject
@property (nonatomic, copy) NSString *hp_no; /**< 档案编号*/
@property (nonatomic, copy) NSString *hp_name; /** 姓名  */
@property (nonatomic, copy) NSString *cardid; /** 身份证号 */
@property (nonatomic, copy) NSString *mobile; /**联系电话 */
@property (nonatomic, copy) NSString *imgurl; /** 头像 */
@property (nonatomic, copy) NSString *sex; /**< 性别*/
@property (nonatomic, copy) NSString *hp_recodate; /** 建档时间   */

@end
