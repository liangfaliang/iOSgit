//
//  TagModel.h
//  AppProject
//
//  Created by admin on 2018/5/23.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagModel : NSObject<NSCoding>
@property (nonatomic, copy) NSString *id; /**< id*/
@property (nonatomic, copy) NSString *tag; /**< 名字 */
@property (nonatomic, copy) NSString *isSelect; /**< 是否选中 默认0 未选中 */
@end
