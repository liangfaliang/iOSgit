//
//  AddStuSubjectTableViewCell.h
//  DuXueZhuShou
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BasicTableViewCell.h"
#import "LbRightImLeftView.h"
#import "AddStuModel.h"
@interface AddStuSubjectTableViewCell : BasicTableViewCell <TFPickerDelegate>
@property (weak, nonatomic) IBOutlet LbRightImLeftView *selctView1;
@property (weak, nonatomic) IBOutlet LbRightImLeftView *selctView2;
@property (weak, nonatomic) IBOutlet LbRightImLeftView *selctView3;
@property (weak, nonatomic) IBOutlet LbRightImLeftView *selctView4;
@property(nonatomic, strong)NSMutableDictionary *subjectDt;
@property(nonatomic, retain)AddStuModel *model;
@end
