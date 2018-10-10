//
//  VolunteerApplyViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/2.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "VolunteerApplyViewController.h"
#import "VolunteerApplyTableViewCell.h"
#import "ChangeUserInfoViewController.h"
#import "MHDatePicker.h"
#import "VolunteerSelectServeViewController.h"
#import "VolunteerOptionalViewController.h"
@interface VolunteerApplyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,MHSelectPickerViewDelegate>{
    UIView *footview;
}
@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic,strong)NSArray *array1;
@property (nonatomic,strong)NSArray *array2;
@property (nonatomic,strong)UIImage *iconim;
@property (nonatomic,strong)NSString *birth;
@property (nonatomic,strong)NSString *timestamp;

@property (nonatomic,strong)NSMutableArray *specialtyArr;
@property (nonatomic,strong)NSMutableArray *purposeArr;
@property (nonatomic,strong)NSMutableArray *areaArr;

@property (nonatomic,strong)NSMutableArray *specialtySelectArr;
@property (nonatomic,strong)NSMutableArray *purposeSelectArr;
@property (nonatomic,strong)NSMutableArray *areaSelectArr;
@property (nonatomic,strong)UITextField *tfname;
@property (nonatomic,strong)UITextField *tfnational;
@property (nonatomic,strong)UITextField *tfcard;
@property (nonatomic,strong)UITextField *tfaddress;
@property (nonatomic,strong)UITextField *tfphone;

@property (nonatomic,assign)BOOL isEdit;//是否可以编辑
@end

@implementation VolunteerApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"志愿者必填信息";
    self.array1 = @[@" 照片",@" 姓名",@" 性别",@" 民族",@" 出生年月",@" 身份证号",@" 家庭住址",@" 手机号码"];
    self.array2 = @[@" 个人专长",@" 服务意向",@" 服务区域"];
    self.isEdit = YES;
    
    [self createTableview];
    [self volunteersSelect];
    
}

-(NSMutableArray *)userInfoArr{
    
    if (_userInfoArr == nil) {
        _userInfoArr = [[NSMutableArray alloc]init];
    }
    return _userInfoArr;
}
-(NSMutableArray *)specialtyArr{
    
    if (_specialtyArr == nil) {
        _specialtyArr = [[NSMutableArray alloc]init];
    }
    return _specialtyArr;
}
-(NSMutableArray *)purposeArr{
    
    if (_purposeArr == nil) {
        _purposeArr = [[NSMutableArray alloc]init];
    }
    return _purposeArr;
}
-(NSMutableArray *)areaArr{
    
    if (_areaArr == nil) {
        _areaArr = [[NSMutableArray alloc]init];
    }
    return _areaArr;
}
-(NSMutableArray *)specialtySelectArr{
    
    if (_specialtySelectArr == nil) {
        _specialtySelectArr = [[NSMutableArray alloc]init];
    }
    return _specialtySelectArr;
}
-(NSMutableArray *)purposeSelectArr{
    
    if (_purposeSelectArr == nil) {
        _purposeSelectArr = [[NSMutableArray alloc]init];
    }
    return _purposeSelectArr;
}
-(NSMutableArray *)areaSelectArr{
    
    if (_areaSelectArr == nil) {
        _areaSelectArr = [[NSMutableArray alloc]init];
    }
    return _areaSelectArr;
}


-(void)cancelClick:(UIButton *)btn{
    
    [[UserModel shareUserModel] removeAllUserInfo];
    [self showLogin:^(id response) {
        
    }];
    
    
}
-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableview registerNib:[UINib nibWithNibName:@"VolunteerApplyTableViewCell" bundle:nil] forCellReuseIdentifier:@"VolunteerApplyTableViewCell0"];
    [self.tableview registerNib:[UINib nibWithNibName:@"VolunteerApplyTableViewCell" bundle:nil] forCellReuseIdentifier:@"VolunteerApplyTableViewCell1"];
    [self.view addSubview:self.tableview];
    
    footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 200)];
    footview.backgroundColor = [UIColor whiteColor];
    
    UIButton *subbtn = [[UIButton alloc]init];
    [subbtn setImage:[UIImage imageNamed:@"baocunxiayibu"] forState:UIControlStateNormal];
    [subbtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:subbtn];
    [subbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footview.mas_centerX);
        make.centerY.equalTo(footview.mas_centerY);
    }];
    if (self.userInfoArr.count) {
        if ([self.userInfoArr[0][@"vt_state"] isEqualToString:@"1"]) {
            self.isEdit = NO;//不可被编辑
            self.tableview.tableFooterView = nil;
            self.navigationBarTitle = @"个人信息";
        }else{
            self.tableview.tableFooterView = footview;
            
        }
    }else{
        self.tableview.tableFooterView = footview;
    }
    
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.array1.count;
    }
    return self.array2.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 100;
        }
    }
    return 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        VolunteerApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VolunteerApplyTableViewCell0"];
        
        //    ShopOtherTableViewCell *cell = [NSBundle ]
        if (!self.isEdit) {
            cell.contentLb.userInteractionEnabled = NO;
        }else{
            cell.contentLb.userInteractionEnabled = YES;
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *iconview = [cell viewWithTag:22];
        [iconview removeFromSuperview];
        cell.nameLabel.text = self.array1[indexPath.row];
        CGSize namesize = [cell.nameLabel.text selfadaption:15];
        cell.nameHeight.constant = namesize.width + 5;
        
        cell.rigthtIm.hidden = NO;
        cell.contentLb.textColor = JHColor(102, 102, 102);
        if (indexPath.row == 0) {
            
            if (iconview == nil) {
                iconview = [[UIImageView alloc]init];
                iconview.tag = 22;
                iconview.image = [UIImage imageNamed:@"gerentouxiang"];
            }
            
            //            iconview.layer.cornerRadius = 30;
            //            iconview.layer.masksToBounds = YES;
            [cell.contentView addSubview:iconview];
            [iconview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.equalTo(cell.rigthtIm.mas_left).offset(-20);
                make.width.offset(60);
                make.height.offset(60);
                
            }];
            cell.contentLb.userInteractionEnabled = NO;
            cell.contentLb.placeholder = @"";
            if (self.iconim) {
                iconview.image = self.iconim;
            }else if (self.userInfoArr.count) {
                [iconview sd_setImageWithURL:[NSURL URLWithString:self.userInfoArr[0][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"gerentouxiang"]];
            }
            
        }else if (indexPath.row == 1){//姓名
            cell.rigthtIm.hidden = YES;
            cell.contenRight.constant = 0;
            cell.contentLb.placeholder = @"请输入";
            if (self.tfname == nil) {
                self.tfname = cell.contentLb;
            }else{
                cell.contentLb = self.tfname;
            }
            
            if (self.userInfoArr.count) {
                cell.contentLb.text = self.userInfoArr[0][@"vt_name"];
            }
            
        }else if (indexPath.row == 2){//性别
            if (self.sexStr) {
                cell.contentLb.text =self.sexStr;
            }else if (self.userInfoArr.count) {
                cell.contentLb.text = self.userInfoArr[0][@"vt_sex"];
            }else{
                cell.contentLb.text = @"";
            }
            cell.contentLb.userInteractionEnabled = NO;
            cell.contentLb.placeholder = @"";
        }else if (indexPath.row == 3){//民族
            cell.rigthtIm.hidden = YES;
            cell.contenRight.constant = 0;
            cell.contentLb.placeholder = @"请输入";
            if (self.userInfoArr.count) {
                cell.contentLb.text = self.userInfoArr[0][@"vt_nation"];
            }
            if (self.tfnational == nil) {
                self.tfnational = cell.contentLb;
            }else{
                cell.contentLb = self.tfnational;
            }
            
        }else if (indexPath.row == 4){//出生年月
            if (self.birth) {
                cell.contentLb.text =self.birth;
            }else if (self.userInfoArr.count) {
                cell.contentLb.text = self.userInfoArr[0][@"vt_birthday"];
            }else{
                cell.contentLb.text = @"";
            }
            cell.contentLb.userInteractionEnabled = NO;
            cell.contentLb.placeholder = @"";
        }else if (indexPath.row == 5){//身份
            cell.rigthtIm.hidden = YES;
            cell.contenRight.constant = 0;
            cell.contentLb.placeholder = @"请输入";
            if (self.userInfoArr.count) {
                cell.contentLb.text = self.userInfoArr[0][@"vt_idcard"];
            }
            if (self.tfcard == nil) {
                self.tfcard = cell.contentLb;
            }else{
                cell.contentLb = self.tfcard;
            }
            
            
        }else if (indexPath.row == 6){//家庭住址
            cell.rigthtIm.hidden = YES;
            cell.contenRight.constant = 0;
            cell.contentLb.placeholder = @"请输入";
            if (self.userInfoArr.count) {
                cell.contentLb.text = self.userInfoArr[0][@"vt_address"];
            }
            if (self.tfaddress == nil) {
                self.tfaddress = cell.contentLb;
            }else{
                cell.contentLb = self.tfaddress;
            }
            
            self.tfaddress = cell.contentLb;
            
        }else if (indexPath.row == 7){//手机号码
            cell.rigthtIm.hidden = YES;
            cell.contenRight.constant = 0;
            NSString *modile = [userDefaults objectForKey:@"nameuser"];
            if (modile == nil) {
                modile = @"";
            }
            if (self.userInfoArr.count) {
                cell.contentLb.text = self.userInfoArr[0][@"vt_mobile"];
            }else{
                cell.contentLb.text = modile;
            }
            
            cell.contentLb.placeholder = @"请输入";
            if (self.tfphone == nil) {
                self.tfphone = cell.contentLb;
            }else{
                cell.contentLb = self.tfphone;
            }
            
        }else{
            cell.contentLb.text = @"";
            cell.contenRight.constant = 10;
            cell.contentLb.placeholder = @"";
            cell.contentLb.userInteractionEnabled = YES;
        }
        return cell;
        
    }else  {
        VolunteerApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VolunteerApplyTableViewCell1"];
        if (!self.isEdit) {
            cell.contentLb.userInteractionEnabled = NO;
        }else{
            cell.contentLb.userInteractionEnabled = YES;
            
        }
        //    ShopOtherTableViewCell *cell = [NSBundle ]
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *iconview = [cell viewWithTag:22];
        [iconview removeFromSuperview];
        cell.contentLb.userInteractionEnabled = NO;
        cell.rigthtIm.hidden = NO;
        cell.nameLabel.text = self.array2[indexPath.row];
        //        cell.contentLb.text = nil;
        CGSize namesize = [cell.nameLabel.text selfadaption:15];
        cell.nameHeight.constant = namesize.width + 5;
        NSArray *marray = [[NSArray alloc]init];
        if (indexPath.row == 0) {
            if (self.userInfoArr.count) {
                marray = self.userInfoArr[0][@"vt_expertise"];
            }else{
                marray = self.specialtySelectArr;
            }
            
        }else if (indexPath.row == 1){
            if (self.userInfoArr.count) {
                marray = self.userInfoArr[0][@"vt_intention"];
            }else{
                marray = self.purposeSelectArr;
            }
            
        }else if (indexPath.row == 2){
            if (self.userInfoArr.count) {
                marray = self.userInfoArr[0][@"vt_region"];
            }else{
                marray = self.areaSelectArr;
            }
        }
        NSMutableString *mstr = [[NSMutableString alloc]init];
        for (int i = 0; i < marray.count; i ++) {
            if (self.userInfoArr.count) {
                [mstr appendString:marray[i]];
            }else{
                [mstr appendString:marray[i][@"ep_name"]];
            }
            
            if (i < marray.count - 1) {
                [mstr appendString:@"-"];
            }
            
            
        }
        cell.contentLb.text = mstr;
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    if (self.isEdit) {
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                [self createAlertion];
                
            }else if (indexPath.row == 2){
                ChangeUserInfoViewController *add = [[ChangeUserInfoViewController alloc]init];
                add.tag = 90;
                add.nameTitle = @"选择性别";
                add.Block = ^(NSString *str){
                    self.sexStr = str;
                    NSIndexPath *index=[NSIndexPath indexPathForRow:2 inSection:0];//刷新
                    [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
                };
                [self.navigationController pushViewController:add animated:YES];
                
            }else if (indexPath.row == 4){
                MHDatePicker *date = [[MHDatePicker alloc]init];
                date.delegate = self;
                date.isBeforeTime = YES;
                date.datePickerMode = UIDatePickerModeDate;
                date.maxSelectDate = [NSDate date];
                date.Displaystr = @"yyyy年MM月dd日";
            }
            
            
        }else{
            VolunteerSelectServeViewController *select = [[VolunteerSelectServeViewController alloc]init];
            if (indexPath.row == 0) {
                select.dataArr = self.specialtyArr;
                select.nameTitle = @"个人专长";
                select.tag = 100;
            }else if (indexPath.row == 1) {
                select.tag = 101;
                select.dataArr = self.purposeArr;
                select.nameTitle = @"服务意向";
            }else  {
                select.tag = 102;
                select.dataArr = self.areaArr;
                select.nameTitle = @"服务区域";
            }
            select.Block = ^(NSInteger index, NSMutableArray *marray){
                if (index == 100) {
                    self.specialtySelectArr = marray;
                }else if (index == 101){
                    self.purposeSelectArr = marray;
                }else if (index == 102){
                    self.areaSelectArr = marray;
                }
                
                NSIndexPath *indexpath=[NSIndexPath indexPathForRow:index - 100 inSection:1];//刷新
                [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexpath,nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:select animated:YES];
        }
        
    }else{
        
        
    }
}

//警告框
-(void)createAlertion{
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"图库", nil];
    [sheet showInView:self.view];
    
    
    
}

#pragma mark - 时间回传值
- (void)timeString:(NSString *)timeString
{
    LFLog(@"%@",timeString);
    self.birth = timeString;
    //    NSIndexPath *index=[NSIndexPath indexPathForRow:4 inSection:0];//刷新
    //    [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableview reloadData];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日"];
    NSDate *fromdate=[format dateFromString:timeString];
    NSTimeInterval longNumber= [fromdate timeIntervalSince1970];
    
    self.timestamp = [NSString stringWithFormat:@"%d",(int)longNumber];
    LFLog(@"longNumber:%d",(int)longNumber);
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 2)return;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self alertController:@"提示" prompt:@"此应用没有权限访问您的照片或视频，您可以在”隐私设置“中启用访问" sure:@"确定" cancel:@"取消" success:^{
            
        } failure:^{
            
        }];
        return;
    }
    UIImagePickerController *pic = [[UIImagePickerController alloc]init];
    pic.delegate = self;
    //    [pic setDelegate:self];
    //允许编辑图片
    pic.allowsEditing = YES;
    
    
    if (buttonIndex == 0) {
        
        pic.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }else{
        
        pic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    
    //显示控制器
    [self presentViewController:pic animated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *editimage = info[UIImagePickerControllerOriginalImage];
    NSString *mediaType = info[UIImagePickerControllerMediaType];
//    if ([mediaType isEqualToString:@"public.image"]) {  //判断是否为图片
//        
//        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//            UIImageWriteToSavedPhotosAlbum(editimage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        }
//        
//    }
    editimage = [editimage fixOrientation];
    UIImageView *iconview = [self.view viewWithTag:22];
    iconview.image = editimage;
    self.iconim = editimage;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//此方法就在UIImageWriteToSavedPhotosAlbum的上方
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"已保存");
}
#pragma mark 保存 下一步
-(void)submitClick:(UIButton *)btn{
    
    
    if (self.iconim == nil) {
        [self presentLoadingTips:@"请选取您的个人照片"];
        return;
    }
    
    if (_tfname.text.length == 0) {
        [self presentLoadingTips:@"请输入您的姓名"];
        return;
        
    }
    if (self.sexStr.length == 0) {
        [self presentLoadingTips:@"请选择您的性别"];
        return;
        
    }
    if (_tfnational.text.length == 0) {
        [self presentLoadingTips:@"请输入您的民族"];
        return;
        
    }
    if (self.birth.length == 0) {
        [self presentLoadingTips:@"请选择您的出生日期"];
        return;
        
    }
    if (_tfcard.text.length == 0) {
        [self presentLoadingTips:@"请输入您的身份证号"];
        return;
        
    }
    if (_tfaddress.text.length == 0) {
        [self presentLoadingTips:@"请输入您的家庭住址"];
        return;
        
    }
    if (_tfphone.text.length == 0) {
        [self presentLoadingTips:@"请输入您的手机号"];
        return;
        
    }
    if (self.specialtySelectArr.count == 0) {
        [self presentLoadingTips:@"请选择您的个人专长"];
        return;
    }
    if (self.purposeSelectArr== 0) {
        [self presentLoadingTips:@"请选择您的服务意向"];
        return;
    }
    if (self.areaSelectArr== 0) {
        [self presentLoadingTips:@"请选择您的服务区域"];
        return;
    }
    LFLog(@"specialtySelectArr:%@",self.specialtySelectArr);
    NSData * data = UIImageJPEGRepresentation(self.iconim,0.5);
    
    NSString *aString = [data convertDataToHexStr];
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]init];
    [dt setObject:_tfname.text forKey:@"vt_name"];
    
    if ([self.sexStr isEqualToString:@"男"]) {
        [dt setObject:@"1" forKey:@"vt_sex"];
    }else{
        [dt setObject:@"2" forKey:@"vt_sex"];
    }
    
    
    [dt setObject:self.timestamp forKey:@"vt_birthday"];
    [dt setObject:_tfaddress.text forKey:@"vt_address"];
    [dt setObject:_tfnational.text forKey:@"vt_nation"];
    [dt setObject:_tfcard.text forKey:@"vt_idcard"];
    [dt setObject:_tfphone.text forKey:@"vt_mobile"];
    [dt setObject:aString forKey:@"imgurl"];
    
    NSMutableString *mstr1 = [[NSMutableString alloc]init];
    for (int i = 0; i < self.specialtySelectArr.count; i ++) {
        [mstr1 appendString:self.specialtySelectArr[i][@"ep_id"]];
        if (i < self.specialtySelectArr.count - 1) {
            [mstr1 appendString:@","];
        }
    }
    [dt setObject:mstr1 forKey:@"vt_expertise"];
    
    NSMutableString *mstr2 = [[NSMutableString alloc]init];
    for (int i = 0; i < self.purposeSelectArr.count; i ++) {
        [mstr2 appendString:self.purposeSelectArr[i][@"ep_id"]];
        if (i < self.purposeSelectArr.count - 1) {
            [mstr2 appendString:@","];
        }
    }
    [dt setObject:mstr2 forKey:@"vt_intention"];
    
    NSMutableString *mstr3 = [[NSMutableString alloc]init];
    for (int i = 0; i < self.areaSelectArr.count; i ++) {
        [mstr3 appendString:self.areaSelectArr[i][@"ep_id"]];
        if (i < self.areaSelectArr.count - 1) {
            [mstr3 appendString:@","];
        }
    }
    [dt setObject:mstr3 forKey:@"vt_region"];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }else{
        [self showLogin:^(id response) {
            
        }];
    }
    
    [self presentLoadingStr:@"请稍后"];
    [self volunteersSaveInformation:dt];
    
}
#pragma mark 志愿者选项
-(void)volunteersSelect{
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,volunteersSelectUrl) params:nil success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        //        LFLog(@"志愿者选项：%@",response);
        if ([str isEqualToString:@"1"]) {
            [self.specialtyArr removeAllObjects];
            [self.purposeArr removeAllObjects];
            [self.areaArr removeAllObjects];
            NSArray *expertise = response[@"data"][@"expertise"];
            NSArray *area = response[@"data"][@"area"];
            NSArray *intention = response[@"data"][@"intention"];
            
            if (expertise.count) {
                for (NSDictionary *dt in expertise) {
                    [self.specialtyArr addObject:dt];
                }
            }
            if (area.count) {
                for (NSDictionary *dt in area) {
                    [self.areaArr addObject:dt];
                }
            }
            if (intention.count) {
                for (NSDictionary *dt in intention) {
                    [self.purposeArr addObject:dt];
                }
            }
            [self.tableview reloadData];
            
            
        }else{
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
        
    } failure:^(NSError *error) {
        LFLog(@"error:%@",error);
    }];
    
    
}

#pragma mark - *************志愿者个人信息
- (void)requestVolunteerInfo{
    
    NSMutableDictionary *dt = [[NSMutableDictionary alloc]init];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }else{
        [self showLogin:^(id response) {
            if ([response isEqualToString:@"1"]) {
                [self requestVolunteerInfo];
            }
            
        }];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,volunteersInfoUrl) params:dt success:^(id response) {
        [_tableview.mj_header endRefreshing];
        LFLog(@"志愿者信息：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            if ([response[@"data"][@"vt_state"] isEqualToString:@"1"]) {
                self.isEdit = NO;//不可被编辑
                self.tableview.tableFooterView = nil;
                self.navigationBarTitle = @"个人信息";
            }else{
                self.tableview.tableFooterView = footview;
                
            }
            [self.userInfoArr removeAllObjects];
            [self.userInfoArr addObject:response[@"data"]];
            [self.tableview reloadData];
            LFLog(@"self.userInfoArr：%@",self.userInfoArr);
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self requestVolunteerInfo];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            self.tableview.tableFooterView = footview;
            //            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
    } failure:^(NSError *error) {
        LFLog(@"活动报名error：%@",error);
        [_tableview.mj_header endRefreshing];
    }];
    
}

#pragma mark 提交志愿者信息
-(void)volunteersSaveInformation:(NSDictionary *)dt{
    //    LFLog(@"dt:%@",dt);
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,volunteersSaveUrl) params:dt success:^(id response) {
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"志愿者信息提交：%@",response);
        if ([str isEqualToString:@"1"]) {
            VolunteerOptionalViewController *option = [[VolunteerOptionalViewController alloc]init];
            [self.navigationController pushViewController:option animated:YES];
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
    }];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

@end

