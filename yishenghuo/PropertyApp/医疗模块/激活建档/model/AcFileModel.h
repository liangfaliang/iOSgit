//
//  AcFileModel.h
//  PropertyApp
//
//  Created by admin on 2018/7/27.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AcFileModel : NSObject
@property (nonatomic, copy) NSString *archive_no; /**< 档案编号*/
@property (nonatomic, copy) NSString *name; /** 姓名  */
@property (nonatomic, copy) NSString *idcard; /** 身份证号 */
@property (nonatomic, copy) NSString *mobile; /**联系电话 */
@property (nonatomic, copy) NSString *birthday; /** 生日 */
@property (nonatomic, copy) NSString *sex; /**< 性别*/
@property (nonatomic, copy) NSString *abo_blood_type; /** ABO血型   */
@property (nonatomic, copy) NSString *rh_blood_type; /**< RH血型*/
@property (nonatomic, copy) NSString *chronic_disease; /** 慢性病  */
@property (nonatomic, copy) NSString *allergies; /** 过敏史 */
@property (nonatomic, copy) NSString *address; /**家庭住址 */
@property (nonatomic, copy) NSString *tel; /** 家庭电话 */
@property (nonatomic, copy) NSString *contact; /**< 紧急情况联系人*/
@property (nonatomic, copy) NSString *contact_tel; /** 紧急情况联系电话   */
@property (nonatomic, copy) NSString *organ_name; /**机构名称*/
@property (nonatomic, copy) NSString *organ_tel; /** 机构电话  */
@property (nonatomic, copy) NSString *doctor_nurse_name; /** 责任医生或护士 */
@property (nonatomic, copy) NSString *doctor_nurse_tel; /**责任医生或护士电话 */
@property (nonatomic, copy) NSString *comment; /** 其它说明 */
@property (nonatomic, copy) NSString *add_time; /** 建档时间   */
@end
