//
//  VolunteerOptionalViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/6.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "VolunteerOptionalViewController.h"
#import "VolunteerApplyTableViewCell.h"
#import "HPTextViewInternal.h"
#import "VolunteerSubmitViewController.h"
@interface VolunteerOptionalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic,strong)NSArray *array1;
@end

@implementation VolunteerOptionalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBarTitle = @"志愿者补充信息";
    self.array1 = @[@" 毕业院校：",@" 学       历：",@" 专         业：",@" 工作单位：",@" 职         称：",@" 志愿服务经历："];
    [self createTableview];

}
-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height  + 50 - 70)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableview registerNib:[UINib nibWithNibName:@"VolunteerApplyTableViewCell" bundle:nil] forCellReuseIdentifier:@"VolunteerApplyTableViewCell0"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"optioncell"];
    [self.view addSubview:self.tableview];
    
    UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 200)];
    footview.backgroundColor = [UIColor whiteColor];
    self.tableview.tableFooterView = footview;
    UIButton *subbtn = [[UIButton alloc]init];
    subbtn.tag = 11;
    [subbtn setImage:[UIImage imageNamed:@"zhiyuanzhexiayibu"] forState:UIControlStateNormal];
    [subbtn addTarget:self action:@selector(nextsubmitClick:) forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:subbtn];
    [subbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footview.mas_centerX);
        make.centerY.equalTo(footview.mas_centerY);
    }];
    
    UIButton *nextsubbtn = [[UIButton alloc]init];
    nextsubbtn.tag = 12;
    [nextsubbtn setImage:[UIImage imageNamed:@"tiaoguociye"] forState:UIControlStateNormal];
    [nextsubbtn addTarget:self action:@selector(nextsubmitClick:) forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:nextsubbtn];
    [nextsubbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footview.mas_centerX);
        make.top.equalTo(subbtn.mas_bottom).offset(10);
    }];
    
}
//下一步
-(void)nextsubmitClick:(UIButton *)btn{
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]init];
    if (btn.tag == 11) {
        NSArray *kayarr = @[@"vt_school",@"vt_education",@"vt_specialty",@"vt_company",@"vt_title",@"vt_experience",@"",@"",];
        for (int i = 0; i < self.array1.count; i ++) {
            UITextField *tf = [self.view viewWithTag:i + 100];
            if (tf.text.length > 0) {
                [dt setObject:tf.text forKey:kayarr[i]];
            }
        }
    }

    [dt setObject:@"1" forKey:@"vt_state"];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }else{
        [self showLogin:^(id response) {
        }];
    }
    LFLog(@"dt:%@",dt);
    VolunteerSubmitViewController *sub = [[VolunteerSubmitViewController alloc]init];
    sub.dict = dt;
    [self.navigationController pushViewController:sub animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.array1.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
      if (indexPath.row == self.array1.count - 1) {
            return 100;
        }
    
    return 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *namelb =[[UILabel alloc]init];
    namelb.textColor = JHdeepColor;
    namelb.font = [UIFont systemFontOfSize:15];
    namelb.text = self.array1[indexPath.row];
    if (indexPath.row < self.array1.count - 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"optioncell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *subview in cell.contentView.subviews) {
            if ([subview isKindOfClass:[UILabel class]]) {
                [subview removeFromSuperview];
            }
        }
        
        [cell.contentView addSubview:namelb];
        [namelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.width.offset([namelb.text selfadap:15 weith:20].width + 5);
        }];

        UITextField *tf = [cell.contentView viewWithTag:indexPath.row + 100];
        if (tf == nil) {
            tf = [[UITextField alloc]init];
            tf.tag = indexPath.row + 100;
            tf.font = [UIFont systemFontOfSize:14];
            tf.textColor = JHmiddleColor;
            tf.placeholder = @"请输入";
        }
        [cell.contentView addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(namelb.mas_right).offset(10);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.offset(-10);
            
        }];
        
        
        
        
        return cell;

    }else{
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"optioncell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *subview in cell.contentView.subviews) {
            if ([subview isKindOfClass:[UILabel class]]) {
                [subview removeFromSuperview];
            }
        }
        [cell.contentView addSubview:namelb];
        [namelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.height.offset(30);
            make.width.offset(SCREEN.size.width - 20);
            make.top.offset(0);
        }];

        
        HPTextViewInternal *tf = [cell.contentView viewWithTag:indexPath.row + 100];
        if (tf == nil) {
            tf = [[HPTextViewInternal alloc]init];
            tf.tag = indexPath.row + 100;
            tf.font = [UIFont systemFontOfSize:13];
            tf.textColor = JHmiddleColor;
            tf.backgroundColor = JHbgColor;
            tf.placeholder = @"请输入";
        }
        [cell.contentView addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(namelb.mas_bottom).offset(0);
            make.bottom.offset(-10);
            make.right.offset(-10);
            make.left.offset(10);
            
        }];
        
        
        
        
        return cell;

    
    }
}
#pragma mark 志愿者信息提交
-(void)volunteersSaveInformation:(NSDictionary *)dict{
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,volunteersConfirmUrl) params:dict success:^(id response) {
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"志愿者信息提交：%@",response);
        if ([str isEqualToString:@"1"]) {
            
            [self presentLoadingTips:@"申请成功"];
            [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.0];
        }else{
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
        
    } failure:^(NSError *error) {
        [self dismissTips];
    }];
    
    
}

@end
