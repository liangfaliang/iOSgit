//
//  PersonalCenterViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/29.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "ShopOtherTableViewCell.h"
#import "ManageAddressViewController.h"
#import "validationNumViewController.h"
#import "ChangeUserInfoViewController.h"
#import "STPhotoBroswer.h"
@interface PersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>{
    
}
@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic,strong)NSArray *array1;
@property (nonatomic,strong)NSArray *array2;
@property (nonatomic,strong)NSMutableArray *officialArr;


@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"账户管理";
    self.array1 = @[@" 头像:",@" 用户名:",@" 昵称:",@" 性别:"];
    self.array2 = @[@" 地址管理",@" 账户安全"];
    [self createTableview];
    [self createFootview];
    
    
    
}

-(NSMutableArray *)officialArr{
    
    if (_officialArr == nil) {
        _officialArr = [[NSMutableArray alloc]init];
    }
    return _officialArr;
}


-(void)cancelClick:(UIButton *)btn{
    
    [[UserModel shareUserModel] removeAllUserInfo];
    [self showLogin:^(id response) {
    }];
    
    
}
-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height  + 50 - 70)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableview registerNib:[UINib nibWithNibName:@"ShopOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"SetupPageViewController"];
    [self.view addSubview:self.tableview];
    
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
    return 60;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetupPageViewController"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.MustImHeight.constant = 0;
    
    if (indexPath.section == 0) {
        
        cell.nameLabel.text = self.array1[indexPath.row];
        if ( self.officialArr.count )
        {
            cell.rigthtIm.hidden = NO;
            if (indexPath.row == 0) {
                UIImageView *iconview = [cell viewWithTag:22];
                if (iconview == nil) {
                    iconview = [[UIImageView alloc]init];
                    iconview.tag = 22;
                }
                NSString * url = [NSString stringWithFormat:@"%@",self.officialArr[0][@"headimage"]];
                [iconview sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"gerentouxiang"]];
                //                iconview.image = [UIImage imageNamed:@""];
                iconview.layer.cornerRadius = 30;
                iconview.layer.masksToBounds = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(LookIconImage:)];
                [iconview addGestureRecognizer:tap];
                [cell.contentView addSubview:iconview];
                iconview.userInteractionEnabled = YES;
                [iconview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.contentView.mas_centerY);
                    make.right.equalTo(cell.rigthtIm.mas_left).offset(-20);
                    make.width.offset(60);
                    make.height.offset(60);
                    
                }];
                
            }else if (indexPath.row == 1){
                cell.rigthtIm.hidden = YES;
                cell.contentLb.text =self.officialArr[0][@"name"];
            }else if (indexPath.row == 2){
                cell.contentLb.text =self.officialArr[0][@"nickname"];
            }else if (indexPath.row == 3){
                NSInteger sex = [self.officialArr[0][@"sex"] integerValue];
                if (sex == 0) {
                    cell.contentLb.text = @"保密";
                }else if (sex == 1) {
                    cell.contentLb.text = @"男";
                }else if (sex == 2) {
                    cell.contentLb.text = @"女";
                }
            }else{
                cell.contentLb.text = @"";
            }
        }else{
            
            cell.contentLb.text = @"";
        }
    }else if (indexPath.section == 1) {
        cell.rigthtIm.hidden = NO;
        cell.nameLabel.text = self.array2[indexPath.row];
        cell.contentLb.text = nil;
        if (indexPath.row == 1) {
            cell.contentLb.text = @"可修改密码";
        }
        
    }
    CGSize namesize = [cell.nameLabel.text selfadaption:15];
    cell.nameHeight.constant = namesize.width + 5;
    return cell;
}
//点击头像
-(void)LookIconImage:(UITapGestureRecognizer *)tap{
    
    LFLog(@"dianji");
    
    STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:@[self.officialArr[0][@"headimage"]] currentIndex:0];
    [broser show];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            ManageAddressViewController *add = [[ManageAddressViewController alloc]init];
            [self.navigationController pushViewController:add animated:YES];
            
        }else if (indexPath.row == 1){
            validationNumViewController *add = [[validationNumViewController alloc]init];
            [self.navigationController pushViewController:add animated:YES];
            
        }
        
        
    }else{
        if (indexPath.row == 0) {
            [self createAlertion];
        }else if (indexPath.row == 1) {
            [self presentLoadingTips:@"用户名不能修改呦"];
        }else  {
            ChangeUserInfoViewController *change = [[ChangeUserInfoViewController alloc]init];
            if (indexPath.row == 2){
                change.nameTitle = @"修改昵称";
                change.name = self.officialArr[0][@"nickname"];
                change.tag = 100;
            }else{
                ShopOtherTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                change.tag = 101;
                change.nameTitle = @"修改性别";
                change.name = cell.contentLb.text;
            }
            [self.navigationController pushViewController:change animated:YES];
            
        }
    }
}

//警告框
-(void)createAlertion{
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"图库", nil];
    [sheet showInView:self.view];
    
    
    
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
    NSString *mediaType = info[UIImagePickerControllerMediaType];
//    if ([mediaType isEqualToString:@"public.image"]) {  //判断是否为图片
//        UIImage *editimage = info[UIImagePickerControllerOriginalImage];
//        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//            UIImageWriteToSavedPhotosAlbum(editimage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        }
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//此方法就在UIImageWriteToSavedPhotosAlbum的上方
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"已保存");
}
#pragma mark 用户信息
-(void)UserInfoData{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    LFLog(@"用户信息:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,UserInfoUrl) params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"用户信息：%@",response);
        if ([str isEqualToString:@"1"]) {
            [self.officialArr removeAllObjects];
            [self.officialArr addObject:response[@"data"]];
            
            [self.tableview reloadData];
            NSDictionary *dict = response[@"data"];
            [UserModel saveUserInfo:dict];
            [Notification postNotificationName:USERInfoChange object:nil userInfo:dict[@"user"]];
            
        }else{
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark 头像上传
-(void)upDateIconimage:(UIImage *)image{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSData * data = UIImageJPEGRepresentation(image,0.3);
    NSString *aString = [data convertDataToHexStr];
    [dt setObject:aString forKey:@"headimage"];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,UserIconImageUrl) params:dt success:^(id response) {
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        LFLog(@"头像上传：%@",response);
        if ([str isEqualToString:@"1"]) {
            [self UserInfoData];
        }else{
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self UserInfoData];
}

@end
