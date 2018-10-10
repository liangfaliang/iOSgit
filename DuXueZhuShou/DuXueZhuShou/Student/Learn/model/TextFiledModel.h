//
//  TextFiledModel.h
//  PropertyApp
//
//  Created by admin on 2018/7/20.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <Foundation/Foundation.h>
/**===================================================**/
static NSString *const Tkey = @"key";                   //信息
static NSString *const Tvalue = @"value";                     //数据
static NSString *const TidStr = @"idStr";
static NSString *const Timage = @"image";
static NSString *const Tname = @"name";
static NSString *const Tleftim = @"leftim";
static NSString *const Ttext = @"text";
static NSString *const Tplaceholder = @"placeholder";
static NSString *const Tenable = @"enable";
static NSString *const Tunedit = @"unedit";
static NSString *const Tprompt = @"prompt";
static NSString *const Trightim = @"rightim";
static NSString *const Tlabel = @"label";
static NSString *const Ttextcolor = @"textcolor";
static NSString *const TisSelect = @"isSelect";

static NSString *const SidStr = @"idStr";
static NSString *const Skey = @"key";
static NSString *const Sname = @"name";
static NSString *const Simage = @"image";
static NSString *const Ssection = @"section";
static NSString *const Schild = @"child";
static NSString *const Stfmodel = @"tfmodel";
static NSString *const SisSelect = @"isSelect";


@interface TextFiledModel : NSObject
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *leftim;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *enable;
@property (nonatomic, copy) NSString *unedit;//输入框是否可编辑 存在不可编辑
@property (nonatomic, copy) NSString *prompt;
@property (nonatomic, copy) NSString *rightim;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *textcolor;

@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger isSelect;

@end

@interface TextSectionModel : NSObject
@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *section;
@property (nonatomic, strong) NSArray *child;
@property (nonatomic, strong) TextFiledModel *tfmodel;
@property (nonatomic, assign) NSInteger isSelect;
@end

@interface IDnameModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDictionary *data;
@end
