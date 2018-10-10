//
//  VehicleManagementViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/6/19.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "VehicleManagementViewController.h"
#import "VehicleTypeViewController.h"
#import "MHDatePicker.h"
#import "VehicleRecordViewController.h"
#import "NSString+YTString.h"
#import <QuartzCore/QuartzCore.h>
#import "YYLabel.h"
#import "YYText.h"
@interface VehicleManagementViewController ()<UITableViewDelegate,UITableViewDataSource,MHSelectPickerViewDelegate>{
    YYLabel *contentLabel;
    UIView *foootview;
    UIButton *submitBtn;
}
@property (nonatomic,strong)UITableView * tableView;
@property (strong,nonatomic)NSMutableArray *subViewArray;
@property (strong,nonatomic)NSMutableArray *typeArray;
@property (strong,nonatomic)NSArray *nameArray;
@property (strong,nonatomic)NSArray *placeholderArr;
@property (strong,nonatomic)NSDictionary *typeDt;//选中车辆类型信息
@property (strong, nonatomic) MHDatePicker *selectTimePicker;
@property (strong,nonatomic)NSString *AnnualTime;//年检时间
@property (strong,nonatomic)NSString *reserveTime;//年预约时间
@end

@implementation VehicleManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"车辆检测";
    self.nameArray = @[@"客户姓名",@"联系电话",@"车牌号码",@"车辆类型",@"年检日期",@"预约日期"];
    self.placeholderArr = @[@"请输入客户姓名",@"请输入手机号",@"请输入车牌号",@"请选择车辆类型",@"选择年检日期",@"请选择预约日期"];
    [self createUI];
    
    [self createbarItem];
    [self upDateVehicleImage];
    [self upDateVehicleType];
}
-(NSMutableArray *)typeArray{
    if (_typeArray == nil) {
        _typeArray = [[NSMutableArray alloc]init];;
    }
    return _typeArray;
}
-(NSMutableArray *)subViewArray{
    if (_subViewArray == nil) {
        _subViewArray = [[NSMutableArray alloc]init];;
    }
    return _subViewArray;
}
-(MHDatePicker *)selectTimePicker{
    if (_selectTimePicker == nil) {
        _selectTimePicker = [[MHDatePicker alloc]init];
        _selectTimePicker.delegate = self;
        _selectTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    return _selectTimePicker;
}
-(void)createbarItem{
    NSString *name = @"预约记录";
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [name selfadap:15 weith:20].width + 5, 44)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setTitleColor:JHMaincolor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBaritemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
-(void)rightBaritemClick{

    VehicleRecordViewController *list = [[VehicleRecordViewController alloc]init];
    [self.navigationController pushViewController:list animated:YES];
}
-(void)createUI{
    
    for (int i = 0; i < 6; i ++) {
        UITextField *tf = [[UITextField alloc]init];
        tf.placeholder = self.placeholderArr[i];
        tf.textAlignment = NSTextAlignmentRight;
        tf.font = [UIFont systemFontOfSize:15];
        tf.textColor = JHmiddleColor;
        if (i > 2) {
            tf.enabled = NO;
        }
        if (i == 1) {
            tf.keyboardType = UIKeyboardTypeNumberPad;
        }
        [self.subViewArray addObject:tf];
    }
    LFLog(@"self.subViewArray:%@",self.subViewArray);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = JHColor(222, 222, 222);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"iscell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];

    
    
    foootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 300)];

    submitBtn = [[UIButton alloc]init];
    [submitBtn setImage:[UIImage imageNamed:@"tijiaobuttun"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(employsubmitClick) forControlEvents:UIControlEventTouchUpInside];
    [foootview addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(70);
        make.centerX.equalTo(foootview.mas_centerX);
    }];
    
    

    self.tableView.tableFooterView = foootview;
    

    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 3;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *view = [[UIImageView alloc]init];
    view.image = [UIImage imageNamed:@"fengexiantongyong"];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //        NSString *CellIdentifier = @"iscell";
    //        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"creditcell%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc]init];
        label.textColor = JHColor(53, 53, 53);
        label.font = [UIFont systemFontOfSize:15];
        NSInteger row = indexPath.row;
        if (indexPath.section == 1) {
            row += 2;
        }else if (indexPath.section == 2){
            row += 5;
        }
        label.text = self.nameArray[row];
        CGSize lbsize = [label.text selfadaption:15];
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(10);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.width.offset(lbsize.width + 5);
            
        }];
        UITextField *tf = self.subViewArray[row];
        
        [cell.contentView addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.offset(-30);
            make.left.equalTo(label.mas_right).offset(10);
            
        }];
        
        if (indexPath.section == 2 || (indexPath.section == 1 && indexPath.row != 0)) {
            UIImageView *rightimage = [[UIImageView alloc]init];
            rightimage.image = [UIImage imageNamed:@"gerenzhongxinjiantou"];
            [cell.contentView addSubview:rightimage];
            [rightimage mas_makeConstraints:^(MASConstraintMaker *make) {                
                make.right.offset(-10);
                make.centerY.equalTo(cell.mas_centerY);
                
            }];
        }

    }
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            if (self.typeArray.count) {
                VehicleTypeViewController *type = [[VehicleTypeViewController alloc]init];
                type.typeArray = self.typeArray;
                [type setBlock:^(NSDictionary *typeDt) {
                    self.typeDt = typeDt;
                    UITextField *tf = self.subViewArray[3];
                    tf.text = typeDt[@"type_name"];
                }];
                [self.navigationController pushViewController:type animated:YES];
            }

        }else if(indexPath.row == 2){
            _selectTimePicker = nil;
            self.selectTimePicker.Logo = @"Annual";

        }
    }else if (indexPath.section == 2){

        _selectTimePicker = nil;
        self.selectTimePicker.Logo = @"reserve";

    
    }
}
#pragma mark - 时间回传值
- (void)timeString:(NSString *)timeString{
    
    long time;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:timeString];
    time= (long)[fromdate timeIntervalSince1970];
    NSNumber *longNumber = [NSNumber numberWithLong:time];
    UITextField *tf = nil;
    if ([_selectTimePicker.Logo isEqualToString:@"Annual"]) {
        
        self.AnnualTime = [longNumber stringValue];
        tf = self.subViewArray[4];
        
    }else{
        self.reserveTime = [longNumber stringValue];;
        tf = self.subViewArray[5];
    }
    if (tf) {
        tf.text = timeString;
    }
    
}
#pragma mark - 提交按钮
-(void)employsubmitClick{

    for (int i = 0 ; i < self.subViewArray.count; i ++ ) {
        UITextField *tf = self.subViewArray[i];
        if (tf.text.length == 0) {
            [self presentLoadingTips:self.placeholderArr[i]];
            return;
        }
        if (i == 1) {
            if (![tf.text isValidateMobile]){
                [self presentLoadingTips:@"请输入正确的手机号"];                
                return;
                
            }
        }
    }
    
    [self upDateInfo];
    
}
#pragma mark 图片
-(void)upDateVehicleImage{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    LFLog(@"图片dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,VehicleImageUrl) params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"图片：%@",response);
        if ([str isEqualToString:@"1"]) {
            if (response[@"data"]) {
                if ([response[@"data"][@"imgurl"] isKindOfClass:[NSString class]]) {
                    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:response[@"data"][@"imgurl"]] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        UIImageView *headerView = [[UIImageView alloc]init];
                        headerView.image = image;
                        headerView.frame = CGRectMake(0, 0, SCREEN.size.width, (image.size.height/image.size.width) * SCREEN.size.width);
                        UIImage *im = [UIImage imageNamed:@"yuyuejiantou"];
                        UIImageView *  animaIamge = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN.size.width/2 - im.size.width/2, headerView.height - 30, im.size.width, im.size.height)];
                        animaIamge.image = im;
                        [animaIamge.layer addAnimation:[self opacityForever_Animation:1] forKey:nil];
                        [headerView addSubview:animaIamge];
                        UIImageView * Iamgeview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lijiyuyue"]];
                        [headerView addSubview:Iamgeview];
                        [Iamgeview mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(headerView.mas_centerX);
                            make.bottom.equalTo(animaIamge.mas_top).offset(-10);
                        }];

                        self.tableView.tableHeaderView = headerView;
                    }];
                }
                if (contentLabel == nil) {
                    contentLabel = [[YYLabel alloc]init];
                    
                    [foootview addSubview:contentLabel];
                    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(submitBtn.mas_bottom).offset(0);
                        make.bottom.offset(0);
                        make.left.offset(10);
                        make.right.offset(-10);
                    }];
                }
                contentLabel.textColor = JHmiddleColor;
                NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@%@",response[@"data"][@"company"],response[@"data"][@"name"],response[@"data"][@"mobile"]]];
                text.yy_font = [UIFont boldSystemFontOfSize:13];
                NSString *attstring = [NSString stringWithFormat:@"%@",response[@"data"][@"mobile"]];
                NSRange range =[[text string]rangeOfString:attstring];
                text.yy_lineSpacing = 10;
                text.yy_color = JHmiddleColor;
                [text yy_setUnderlineStyle:NSUnderlineStyleSingle range:range];
                [text yy_setUnderlineColor:JHMaincolor range:range];
                [text yy_setColor:JHMaincolor range:range];
                [text yy_setTextHighlightRange:range//设置点击的位置
                                         color:JHMaincolor
                               backgroundColor:[UIColor whiteColor]
                                     tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                         NSString *tell = [NSString stringWithFormat:@"telprompt://%@",response[@"data"][@"mobile"]];
                                         NSURL *url = [NSURL URLWithString:tell];
                                         NSComparisonResult compare = [[UIDevice currentDevice].systemName compare:@"10.0"];
                                         if (compare == NSOrderedDescending || compare == NSOrderedSame) {
                                             [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                                         }else{
                                             [[UIApplication sharedApplication] openURL:url];
                                         }
                                     }];
                contentLabel.attributedText = text;
                contentLabel.font = [UIFont systemFontOfSize:12];
                contentLabel.numberOfLines = 2;
                contentLabel.textAlignment = NSTextAlignmentCenter;
                
            }


        }else{

            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark === 永久闪烁的动画 ======
-(CABasicAnimation *)opacityForever_Animation:(double)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}

#pragma mark 车辆类型
-(void)upDateVehicleType{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    LFLog(@"车辆类型dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,VehicleTypeUrl) params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"车辆类型：%@",response);
        if ([str isEqualToString:@"1"]) {
            [self.typeArray removeAllObjects];
            for (NSDictionary *dic in response[@"data"]) {
                [self.typeArray addObject:dic];
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self upDateVehicleImage];
                        [self upDateVehicleType];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

#pragma mark 提交
-(void)upDateInfo{
    [self presentLoadingTips];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSArray *parameterArr = @[@"user_name",@"mobile",@"plate_number"];
    for (int i = 0 ; i < parameterArr.count; i ++ ) {
        UITextField *tf = self.subViewArray[i];
        [dt setObject:tf.text forKey:parameterArr[i]];
    }
    if (self.typeDt) {
        [dt setObject:self.typeDt[@"type_id"] forKey:@"vehicle_type"];
    }
    if (self.AnnualTime) {
        [dt setObject:self.AnnualTime forKey:@"inspection_date"];
    }
    if (self.reserveTime) {
        [dt setObject:self.reserveTime forKey:@"reserve_date"];
    }
    LFLog(@"车辆提交dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,VehicleInfoSubmitUrl) params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"车辆提交：%@",response);
        [self dismissTips];
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"提交成功"];
            [self performSelector:@selector(rightBaritemClick) withObject:nil afterDelay:.2];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"提交失败，网络错误！"];
    }];
    
    
}

@end
