//
//  PreschoolModel.h
//  PropertyApp
//
//  Created by admin on 2018/8/14.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreschoolModel : NSObject
@property (nonatomic,copy) NSString * en_type;/* 类型 */
@property (nonatomic,copy) NSString * name;/*  */
@property (nonatomic,copy) NSString * sex;/*  */
@property (nonatomic,copy) NSString * birthday;/*  */
@property (nonatomic,copy) NSString * medical_history;/* 有无过敏、特殊病史 */
@property (nonatomic,copy) NSString * father_name;/* 父亲姓名 */
@property (nonatomic,copy) NSString * father_mobile;/* 父亲联系方式 */
@property (nonatomic,copy) NSString * father_work;/* 父亲工作单位 */
@property (nonatomic,copy) NSString * mother_name;/*  母亲姓名 */
@property (nonatomic,copy) NSString * mother_work;/* 母亲工作单位*/
@property (nonatomic,copy) NSString * mother_mobile;/* 母亲联系方式 */
@property (nonatomic,copy) NSString * home_address;/* 家庭住址 */
@property (nonatomic,copy) NSString * remarks;/* 备注 */

@end
