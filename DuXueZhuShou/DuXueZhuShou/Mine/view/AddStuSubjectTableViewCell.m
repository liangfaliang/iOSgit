
//
//  AddStuSubjectTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AddStuSubjectTableViewCell.h"

@implementation AddStuSubjectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    for (int i = 0; i < 4; i ++) {
        LbRightImLeftView *lb = [self valueForKey:[NSString stringWithFormat:@"selctView%d",i + 1]];
        lb.titleLb.text = @"无";
        [lb ddy_AddTapTarget:self action:@selector(cleckTap:)];
    }
    [self getData:nil];
}
-(void)setModel:(AddStuModel *)model{
    _model = model;
    for (int i = 0; i < 4; i ++) {
        LbRightImLeftView *lb = [self valueForKey:[NSString stringWithFormat:@"selctView%d",i + 1]];
        NSString *key = lStringFormart(@"subject_%d",i);
        if ([self.model valueForKey:key]) {
            NSArray *valueArr = self.subjectDt[key];
            for (NSDictionary *temdt in valueArr) {
                if ([[self.model valueForKey:key] isEqualToString:lStringFor(temdt[@"id"])]) {
                    lb.titleLb.text = temdt[@"name"];
                    break;
                }
            }
            
        }
    }
}
LazyLoadDict(subjectDt)
- (void)cleckTap:(UITapGestureRecognizer *)tap {
    LFLog(@"%ld",tap.view.tag);
    if (self.subjectDt.count) {
        [self showPickerview:tap.view.tag values:self.subjectDt[lStringFormart(@"subject_%ld",tap.view.tag - 1)]];
    }else{
        [self getData:^(NSMutableDictionary *arr) {
            [self showPickerview:tap.view.tag values:self.subjectDt[lStringFormart(@"subject_%ld",tap.view.tag - 1)]];
        }];
    }
}

-(void)showPickerview:(NSInteger )tag values:(NSArray *)valuesArr{
    if (valuesArr.count) {
        UIViewController *vc = [self viewController];
        PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:vc.view.bounds];
        picker.tag = tag;
        picker.inter = 2;
        picker.delegate = self;
        picker.titlestr = @"";
        picker.arrayType = HeightArray;
        for (NSDictionary *temdt  in valuesArr) {
            [picker.typearr addObject:temdt[@"name"]];
        }
        [vc.view addSubview:picker];
    }

}
#pragma mark -------- TFPickerDelegate

- (void)PickerSelectorIndixString:(id)picker str:(NSString *)str row:(NSInteger)row isType:(NSInteger)isType{
    PickerChoiceView *pickerview  = (PickerChoiceView *)picker;
    NSString *key = lStringFormart(@"subject_%ld",pickerview.tag - 1);
    NSArray *valueArr = self.subjectDt[key];
    for (NSDictionary *temdt in valueArr) {
        if ([str isEqualToString:temdt[@"name"]]) {
            [self.model setValue:lStringFor(temdt[@"id"]) forKey:key];
        }
    }
    LbRightImLeftView *lb = [self viewWithTag:pickerview.tag];
    lb.titleLb.text = str;
    
}
#pragma mark - 获取列表
- (void)getData:(void (^)(NSMutableDictionary *arr))result{
    [LFLHttpTool post:NSStringWithFormat(SERVER_IP,InsClassSubjectUrl) params:nil viewcontrllerEmpty:nil success:^(id response) {
        LFLog(@"获取列表:%@",response);
        NSInteger code = [response[@"code"] integerValue];
        if (code == 1) {
            self.subjectDt = [NSMutableDictionary dictionaryWithDictionary:response[@"data"]];
            if (result) {
                result(self.subjectDt);
            }
            if (_model) {
                [self setModel:_model];
            }
        }else{
            [AlertView showMsg:response[@"msg"]];
        }
    } failure:^(NSError *error) {
    }];
    
}
@end
