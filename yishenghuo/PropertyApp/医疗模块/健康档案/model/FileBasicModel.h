//
//  FileBasicModel.h
//  PropertyApp
//
//  Created by admin on 2018/8/25.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileBasicModel : NSObject
@property (nonatomic, copy) NSString *hp_sex;/** 性别*/
@property (nonatomic, copy) NSString *hp_linktelp;/** 联系人电话*/
@property (nonatomic, copy) NSString *hr_name;/** 姓名*/
@property (nonatomic, copy) NSString *hr_idno;/**身份证号 */
@property (nonatomic, copy) NSString *hp_telp;/** 本人电话*/
@property (nonatomic, copy) NSString *hp_workCompany;/**工作单位 */
@property (nonatomic, copy) NSString *hp_birthday;/** 出生日期*/
@property (nonatomic, copy) NSString *hp_PermanentType;/** 常住类型*/
@property (nonatomic, copy) NSString *hp_nation;/** 民族*/
@property (nonatomic, copy) NSString *hp_bloodType;/**血型 */
@property (nonatomic, copy) NSString *hp_bloodRH;/**RH血型 */
@property (nonatomic, copy) NSString *hp_education;/**文化程度 */
@property (nonatomic, copy) NSString *hp_profession;/** 职业*/
@property (nonatomic, copy) NSString *hp_marital;/** 婚姻状况*/
@property (nonatomic, copy) NSString *hp_medicalExpense;/** 医疗费用*/
@property (nonatomic, copy) NSString *hp_drugAllergy;/** 药物过敏史*/
@property (nonatomic, copy) NSString *hp_exposure;/** 暴露史*/
@property (nonatomic, copy) NSString *hp_Disability;/** 残疾情况*/
@property (nonatomic, copy) NSString *hp_historyDisease;/**既往史疾病 */
@property (nonatomic, copy) NSString *hp_historyDisease_year_1;/** 年*/
@property (nonatomic, copy) NSString *hp_historyDisease_month_1;/** 月*/
@property (nonatomic, copy) NSString *health_operation_ishave;/** 既往史手术是否存在*/
@property (nonatomic, copy) NSString *health_operation_1_name;/**既往史手术 */
@property (nonatomic, copy) NSString *health_operation_1_date;/**既往史手术1时间 */
@property (nonatomic, copy) NSString *health_operation_2_name;/**既往史手术2 */
@property (nonatomic, copy) NSString *health_operation_2_date;/** 既往史手术2时间*/
@property (nonatomic, copy) NSString *health_trauma_1_name;/** 既往史外伤*/
@property (nonatomic, copy) NSString *health_trauma_2_name;/** */
@property (nonatomic, copy) NSString *health_trauma_1_date;/** */
@property (nonatomic, copy) NSString *health_trauma_2_date;/** */
@property (nonatomic, copy) NSString *health_trauma_ishave;/** 既往史外伤是否存在*/
@property (nonatomic, copy) NSString *health_transfusion_1_name;/** 既往史输血*/
@property (nonatomic, copy) NSString *health_transfusion_2_name;/** */
@property (nonatomic, copy) NSString *health_transfusion_1_date;/** */
@property (nonatomic, copy) NSString *health_transfusion_2_date;/** */
@property (nonatomic, copy) NSString *health_transfusion_ishave;/**既往史输血是否存在 */
@property (nonatomic, copy) NSString *familyDisease_father;/** 家族史父亲*/
@property (nonatomic, copy) NSString *familyDisease_mather;/**家族史母亲 */
@property (nonatomic, copy) NSString *familyDisease_sister;/** 家族史兄弟姐妹*/
@property (nonatomic, copy) NSString *familyDisease_son;/**家族史子女 */
@property (nonatomic, copy) NSString *heredopathia_ishave;/** 遗传病史是否有病*/
@property (nonatomic, copy) NSString *heredopathia_name;/** 遗传病史名称*/
@property (nonatomic, copy) NSString *Kitchenexhaus;/** 厨房排风设施*/
@property (nonatomic, copy) NSString *FuelType;/** 燃料类型*/
@property (nonatomic, copy) NSString *water;/** 饮水*/
@property (nonatomic, copy) NSString *Toilet;/** 厕所*/
@property (nonatomic, copy) NSString *corral;/** 禽畜栏*/
@property (nonatomic, copy) NSString *hp_addr;/** 现住址*/
@property (nonatomic, copy) NSString *hp_Permanent_address;/** 户籍地址*/
@property (nonatomic, copy) NSString *hp_Town_name;/** 乡镇（街道）名称*/
@property (nonatomic, copy) NSString *hp_committee_name;/** 村（居）委会名称*/
@property (nonatomic, copy) NSString *hp_Archiving;/**建档人 */
@property (nonatomic, copy) NSString *hp_Archiving_unit;/** 建档单位*/
@property (nonatomic, copy) NSString *hp_doctor;/** 责任医生*/
@property (nonatomic, copy) NSString *hp_created_date;/**建档日期 */
@end
