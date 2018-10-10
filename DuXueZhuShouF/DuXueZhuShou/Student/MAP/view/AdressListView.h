//
//  AdressListView.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/31.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendSubmitModel.h"
@interface AdressListView : UIView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *tableview;
@property (copy,nonatomic) void(^cellClick)(placeModel *pmodel);
- (instancetype)initWithImageArray:(NSArray *)dataArray;
@end
