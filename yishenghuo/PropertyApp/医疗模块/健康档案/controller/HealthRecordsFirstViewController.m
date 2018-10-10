//
//  HealthRecordsFirstViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/19.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "HealthRecordsFirstViewController.h"
#import "HealthRecordHeaderview.h"
#import "ActivateFileViewController.h"
#import "ServiceCenterFileViewController.h"
#import "MyAppointmentViewController.h"
#import "SMSSDK.h"

@interface HealthRecordsFirstViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UIButton *footer;
}
@property (nonatomic,strong)HealthRecordHeaderview *header;
@property (nonatomic,strong)UICollectionView * collectionview;
@property (nonatomic, strong) NSMutableArray *menuArr;
@end

@implementation HealthRecordsFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.header];
    footer = [[UIButton alloc]initWithFrame:CGRectMake(0, screenH - 50, screenW, 50)];
    footer.backgroundColor = JHColor(133, 195, 98);
    [footer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footer addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footer];
    if (self.isYun) {
        self.navigationBarTitle = @"建册预约";
    }else{
        if (self.isSecond) {
            self.navigationBarTitle = @"档案认证";
            //        [self createCollectionview];
        }else{
            self.navigationBarTitle = @"服务中心建档";
            //        [self createBarItem];
        }

    }
    [footer setTitle:@"下一步" forState:UIControlStateNormal];
    [self createUI];
    
}
-(void)createBarItem{
    UIBarButtonItem *rightbar = [[UIBarButtonItem alloc]initWithTitle:@"我的预约" style:UIBarButtonItemStyleDone target:self action:@selector(myappoontment)];
    rightbar.tintColor = JHMedicalColor;
    self.navigationItem.rightBarButtonItem = rightbar;
}
-(NSMutableArray *)menuArr{
    if (!_menuArr) {
        _menuArr = [NSMutableArray array];
    }
    return _menuArr;
}
#pragma mark 我的预约
-(void)myappoontment{
    [self.navigationController pushViewController:[[MyAppointmentViewController alloc]init] animated:YES];
}
-(void)createUI{
    NSArray *placeholderArr = nil;
    NSArray *namearr = nil;
    if (self.isYun) {
        placeholderArr = @[@"必填",@"请输入17位档案号"];
        namearr = @[@"姓      名      ",@"档案号"];
    }else{
        if (self.isSecond) {
            placeholderArr = @[@"                     必填",@"                     必填",@"                     必填",@""];
            namearr = @[@"姓      名      ",@"身份证号",@"手机号码",@""];
        }else{
            placeholderArr = @[@"                     必填",@"                     必填"];
            namearr = @[@"姓      名      ",@"身份证号"];
        }
    }

    
    for (int i = 0; i < namearr.count; i ++) {
        UIImageView *view1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, self.header.height + 20 + i *65 + NaviH, SCREEN.size.width - 40, 50)];
        view1.userInteractionEnabled = YES;
        //        view1.image = [UIImage imageNamed:@"shurukuang"];
        view1.backgroundColor = JHColor(235, 238, 237);
        view1.layer.masksToBounds = YES;
        view1.layer.borderColor = [JHBorderColor CGColor];
        view1.layer.borderWidth = 1;
        view1.layer.cornerRadius = 5;
        view1.contentMode =  UIViewContentModeScaleToFill;
        [self.view addSubview:view1];
        UITextField *tf = [[UITextField alloc]init];
        tf.tag = 500 + i;
        tf.placeholder = placeholderArr[i];
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        tf.font = [UIFont systemFontOfSize:14];
        if (i < 3) {
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
            lb.text = namearr[i];
            lb.textColor = JHdeepColor;
            lb.font = [UIFont systemFontOfSize:15];
            tf.leftView = lb;
            tf.leftViewMode = UITextFieldViewModeAlways;
        }else{
            UIButton *codeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
            [codeBtn setTitle:@"获取手机验证码" forState:UIControlStateNormal];
            codeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            codeBtn.backgroundColor = JHBorderColor;
            codeBtn.layer.cornerRadius = 15;
            codeBtn.layer.masksToBounds = YES;
            [codeBtn setTitleColor:JHmiddleColor forState:UIControlStateNormal];
            [codeBtn addTarget:self action:@selector(VerificationClick:) forControlEvents:UIControlEventTouchUpInside];
            tf.rightView = codeBtn;
            tf.rightViewMode = UITextFieldViewModeAlways;
        }
        if (i > 0) {
            tf.keyboardType = UIKeyboardTypeNumberPad;
        }
        //        tf.backgroundColor = [UIColor redColor];
        [view1 addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.offset(0);
            make.bottom.offset(0);
            make.right.offset(-10);
        }];
//        if (i == 0) tf.text = @"刘晓";
//        if (i == 1) tf.text = @"514878198808236454";
//        if (i == 2) tf.text = @"15828412777";
        
    }
    
}
#pragma mark 获取验证码
- (void)VerificationClick:(UIButton *)sender
{
    UITextField *tfphone = [self.view viewWithTag:502];
    if (tfphone.text.length != 11) {
        [self presentLoadingTips:tfphone.text.length ? @"请输入正确的手机号" :@"请输入手机号！"];
        [tfphone becomeFirstResponder];
        return;
    }
    sender.userInteractionEnabled = NO;
    [self presentLoadingTips];
    NSString *  purpose = @"search_archives";
    [[SMSSDK sharedSMSSDK] getVerificationCodeByMethod:purpose phoneNumber:tfphone.text zone:@"86" success:^(id response) {
        [self dismissTips];
        [sender setImage:nil forState:UIControlStateNormal];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            NSLog(@"SUCCEED!");
            __block int timeout=60; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                //隐藏图片
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [sender setTitle:@"获取手机验证码" forState:UIControlStateNormal];
                        sender.userInteractionEnabled = YES;
                    });
                }else{
                    
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //设置界面的按钮显示 根据自己需求设置
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:1];
                        [sender setTitle:[NSString stringWithFormat:@"%@秒重发",strTime] forState:UIControlStateNormal];
                        //                        [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                        [UIView commitAnimations];
                        sender.userInteractionEnabled = NO;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
            
        }else {
            sender.userInteractionEnabled = YES;
            [sender setTitle:@"重新获取" forState:UIControlStateSelected];
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        sender.userInteractionEnabled = YES;
        [self dismissTips];
        [self presentLoadingTips:@"请求失败！"];
        
    }] ;
    
}
-(HealthRecordHeaderview *)header{
    if (_header == nil) {
        _header = [[NSBundle mainBundle]loadNibNamed:@"HealthRecordHeaderview" owner:nil options:nil][0];
        _header.frame = CGRectMake(0, NaviH, SCREEN.size.width, 220);
//        if (self.iconIm) {
//            [_header.iconBtn setImage:self.iconIm forState:UIControlStateNormal];
//            _header.frame = CGRectMake(0, NaviH, SCREEN.size.width, 220);
//        }
//        if (self.isSecond) {
//            _header.frame = CGRectMake(0, NaviH, SCREEN.size.width, 190);
//            _header.titleLb.text = @"";
//            _header.titleLbHeight.constant = 10;
//        }
        
    }
    return _header;
}
- (void)nextClick{
    UITextField *tfname = [self.view viewWithTag:500];
    UITextField *tfcard = [self.view viewWithTag:501];
    UITextField *tfphone = [self.view viewWithTag:502];
    UITextField *tfcode = [self.view viewWithTag:503];
    if (!tfname.text.length) {
        [self presentLoadingTips:@"请输入姓名！"];
        [tfname becomeFirstResponder];
        return;
    }
    if (self.isYun) {
        if (tfcard.text.length != 17) {
            [self presentLoadingTips:tfcard.text.length ? @"请输入正确的档案号" :@"请输入档案号！"];
            [tfcard becomeFirstResponder];
            return;
        }
        ServiceCenterFileViewController * second = [[ServiceCenterFileViewController alloc]init];
        second.isYun = YES;
        second.model = [[FileCenterModel alloc]init];
        second.model.gr_name = tfname.text;
        second.model.hp_no = tfcard.text;
        second.iconIm = self.iconIm;
        second.model.reserveWay = @"1";
        second.model.gr_type = @"可预约建册时间";
        second.model.gr_name = tfname.text;
        [self.navigationController pushViewController:second animated:YES];
        
    }else{
        if (tfcard.text.length != 18) {
            [self presentLoadingTips:tfcard.text.length ? @"请输入正确的身份证号" :@"请输入身份证号！"];
            [tfcard becomeFirstResponder];
            return;
        }
        if (self.isSecond) {
            if (tfphone.text.length != 11) {
                [self presentLoadingTips:tfphone.text.length ? @"请输入正确的手机号" :@"请输入手机号！"];
                [tfphone becomeFirstResponder];
                return;
            }
            //        if (tfcode.text.length == 0) {
            //            [self presentLoadingTips:@"请输入验证码"];
            //            [tfcode becomeFirstResponder];
            //            return;
            //        }
            [self presentLoadingTips];
            [self commitVerificationCode:tfcode.text phoneNumber:tfphone.text name:tfname.text cardid:tfcard.text];
        }else{
            
            ServiceCenterFileViewController * second = [[ServiceCenterFileViewController alloc]init];
            second.model = [[FileCenterModel alloc]init];
            second.model.hr_name = tfname.text;
            second.model.hr_idno = tfcard.text;
            second.iconIm = self.iconIm;
            [self.navigationController pushViewController:second animated:YES];
        }
    }
    
}
- (void) commitVerificationCode:(NSString *)code phoneNumber:(NSString *)phoneNumber name:(NSString *)name cardid:(NSString *)cardid{
    NSString *uid = [UserDefault objectForKey:@"uid"];
    if (uid == nil) uid = @"";
    NSString *coid = @"53";
    if (coid == nil) coid = @"";
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    [dt setObject:coid forKey:@"coid"];
    [dt setObject:uid forKey:@"uid"];
    [dt setObject:@"1" forKey:@"iszb"];
    //    if (phoneNumber) [dt setObject:phoneNumber forKey:@"mobile"];
    //    if (code) [dt setObject:code forKey:@"code"];
    if (name) [dt setObject:name forKey:@"name"];
    if (cardid) [dt setObject:cardid forKey:@"idno"];
    //    if ([SMSSDK sharedSMSSDK].send_id) {
    //        [dt setObject:[SMSSDK sharedSMSSDK].send_id forKey:@"send_id"];
    //    }
    LFLog(@"短信验证dt:%@",dt);
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,ERPActivateFileQueryUrl) params:dt success:^(id response) {
        LFLog(@"短信验证:%@",response);
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            AcFileModel *model = [AcFileModel mj_objectWithKeyValues:response[@"data"]];
            ActivateFileViewController * second = [[ActivateFileViewController alloc]init];
            second.acmodel = model;
            [self.navigationController pushViewController:second animated:YES];
        }else {
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"请求失败！"];
    }];
    
}
-(void)createCollectionview{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((SCREEN.size.width-5)/self.menuArr.count, 90);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(20, self.header.height + NaviH, SCREEN.size.width - 40,screenH - 50 - self.header.height - NaviH) collectionViewLayout:flowLayout];
    self.collectionview.dataSource=self;
    self.collectionview.delegate=self;
    [self.collectionview setBackgroundColor:[UIColor clearColor]];
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"HealthViewCell"];
    [self.view addSubview:self.collectionview];
}

#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.menuArr.count;
}



//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"HealthViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    cell.layer.masksToBounds  = YES;
    cell.layer.cornerRadius = 5;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [JHBorderColor CGColor];
    UILabel *lab  = [[UILabel alloc]init];
    lab.text = self.menuArr[indexPath.row];
    lab.font = [UIFont systemFontOfSize:15];
    lab.textAlignment = NSTextAlignmentCenter;
    [lab setTextColor:JHdeepColor];
    [cell.contentView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [self.menuArr[indexPath.row] selfadap:15 weith:20];
    return CGSizeMake((size.width + 10) < 80 ? 80 : (size.width + 10), 30);
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = !cell.selected;
}

@end
