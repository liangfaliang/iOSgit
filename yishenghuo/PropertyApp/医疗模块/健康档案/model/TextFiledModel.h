//
//  TextFiledModel.h
//  PropertyApp
//
//  Created by admin on 2018/7/20.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextFiledModel : NSObject
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *enable;
@property (nonatomic, copy) NSString *prompt;
@property (nonatomic, copy) NSString *rightim;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *textcolor;
@property (nonatomic, copy) NSString *selectBtn;

@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger isSelect;
@end

@interface TextSectionModel : NSObject
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *section;
@property (nonatomic, strong) NSArray *child;
@end

