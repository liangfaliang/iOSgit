//
//  FileCenterModel.h
//  PropertyApp
//
//  Created by admin on 2018/7/26.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileCenterModel : NSObject
@property (nonatomic, copy) NSString *hr_deid;/** 部门ID*/
@property (nonatomic, copy) NSString *hr_comno;/** 建档机构ID号*/
@property (nonatomic, copy) NSString *hr_name;/** 姓名*/
@property (nonatomic, copy) NSString *hr_addr;/**现住地址 */
@property (nonatomic, copy) NSString *hr_domicileP;/** 户籍地址*/
@property (nonatomic, copy) NSString *hr_telp;/** 联系方式*/
@property (nonatomic, copy) NSString *hr_reserveDate;/**预约时间 */
@property (nonatomic, copy) NSString *hr_idno;/**身份证号 */


//孕妇建册
@property (nonatomic, copy) NSString *reserveWay;/**0（安卓）,1(苹果) */
@property (nonatomic, copy) NSString *gr_type;/** 预约分类*/
@property (nonatomic, copy) NSString *hp_no;/** 院内档案编号*/
@property (nonatomic, copy) NSString *gr_name;/** 姓名*/
@property (nonatomic, copy) NSString *gr_addr;/**现住地址 */
@property (nonatomic, copy) NSString *gr_domicileP;/** 户籍地址*/
@property (nonatomic, copy) NSString *gr_telp;/** 联系方式*/
@property (nonatomic, copy) NSString *gr_reserveDate;/**预约时间 */
@property (nonatomic, copy) NSString *gr_idno;/**身份证号 */
@property (nonatomic, copy) NSString *gr_deid;/** 部门ID*/
@property (nonatomic, copy) NSString *gr_comno;/** 建档机构ID号*/
@end
