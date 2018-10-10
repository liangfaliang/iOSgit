//
//  SendExpressViewController.m
//  shop
//
//  Created by 梁法亮 on 16/8/25.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "SendExpressViewController.h"
#import "HCScanQRViewController.h"
#import "SelectExpressViewController.h"
#import "NSString+YTString.h"
@interface SendExpressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UITableView *tableveiw;
@property(nonatomic,strong)NSMutableArray *timeArray;
@property(nonatomic,strong)NSMutableArray *placeArray;
//数据请求对象
@property(nonatomic,strong)NSMutableArray *requestArr;
@property(nonatomic,strong)UITextField *tfexpress;
@property(nonatomic,strong)UITextField *tfphone;

@property(nonatomic,strong)UIButton *saoyisaoBtn;
@property(nonatomic,strong)UIButton *photoBtn;
@property(nonatomic,strong)UIImageView *imageveiw;

@property(nonatomic,strong)UILabel *infoLb;
@property(nonatomic,strong)UIView *footview;

@property(nonatomic,assign)BOOL isSubbtn;


@end

@implementation SendExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.navigationBarTitle = @"快递代收";
    self.isSubbtn = YES;
    [self createFootview];
    [self creatableveiw];
    
    [self UploadDatalateTimeandLocation];
    
}
- (NSMutableArray *)requestArr
{
    if (_requestArr == nil) {
        _requestArr = [[NSMutableArray alloc]init];
    }
    return _requestArr;
}

-(NSMutableArray *)timeArray{
    
    if (_timeArray == nil) {
        _timeArray = [[NSMutableArray alloc]init];
    }
    
    return _timeArray;
}
-(NSMutableArray *)placeArray{
    
    if (_placeArray == nil) {
        _placeArray = [[NSMutableArray alloc]init];
    }
    
    return _placeArray;
}

-(void)createFootview{
    
    
    self.footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 200)];
    UIButton *subButton = [[UIButton alloc]init];
    [subButton setImage:[UIImage imageNamed:@"tijiao_kuaiditongzhi"] forState:UIControlStateNormal];
    [subButton addTarget:self action:@selector(subButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.footview addSubview: subButton];
    [subButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.footview.mas_centerX);
        make.centerY.equalTo(self.footview.mas_centerY);
    }];
    
}

//提交按钮
-(void)subButtonClick:(UIButton *)btn{
    
    if (![userDefaults objectForKey:NetworkReachability]) {
        [self presentLoadingTips:@"网络貌似掉了~~"];
        return;
    }
    
    
    //判断是否登录
    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {            
        }];
        return;
    }
    if (!self.isSubbtn) {
        
        [self createAlertion:@"提示" str:@"暂不支持此收件人电话"];
        return;
    }
    if (self.tfexpress.text.length == 0) {
        [self.tfexpress becomeFirstResponder];
        [self presentLoadingTips:@"请输入快递单号~~"];
    }else if (self.tfphone.text.length == 0){
        [self.tfphone becomeFirstResponder];
        [self presentLoadingTips:@"请输入收件人电话~~"];
    }else if (![self.tfphone.text isValidateMobile]){
        [self.tfphone becomeFirstResponder];
        [self presentLoadingTips:@"请输入收件人正确的电话~~"];
    }else{
        [self presentLoadingTips];
        [self submitUploadDatalate];
    }
    
    
}

//警告框
-(void)createAlertion:(NSString *)str1 str:(NSString *)str2{
    
    UIAlertController *alertcontro = [UIAlertController alertControllerWithTitle:str1 message:str2 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    [alertcontro addAction:okAction];
    
    [self presentViewController:alertcontro animated:YES completion:nil];
    
    
}

-(void)creatableveiw{
    
    self.tableveiw = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    self.tableveiw.delegate = self;
    self.tableveiw.dataSource = self;
    self.tableveiw.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableveiw.tableFooterView = self.footview;
    [self.tableveiw registerClass:[UITableViewCell class] forCellReuseIdentifier:@"sendattendcell"];
    [self.view addSubview:self.tableveiw];
    [self.tableveiw registerNib:[UINib nibWithNibName:@"ContingencyTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContingencyTableViewCell"];
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sendattendcell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *lb = [self.view viewWithTag:indexPath.section * 5 + indexPath.row + 200];
    if (lb == nil ) {
        lb = [[UILabel alloc]init];
        lb.font = [UIFont systemFontOfSize:15];
        lb.textColor = JHColor(53, 53, 53);
        
        lb.tag = indexPath.section * 5 + indexPath.row + 200;
        [cell.contentView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            
        }];
        
    }
    if (indexPath.section == 0) {
        
        
        if (indexPath.row == 0) {
            lb.text = @"快递信息";
            if (self.saoyisaoBtn == nil) {
                self.saoyisaoBtn = [[UIButton alloc]init];
                UIImage *ima = [UIImage imageNamed:@"saoyisao_kuaiditongzhi-"];
                [self.saoyisaoBtn setImage:ima forState:UIControlStateNormal];
                [self.saoyisaoBtn addTarget:self action:@selector(saoyisaoClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:self.saoyisaoBtn];
                [self.saoyisaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerY.equalTo(cell.contentView.mas_centerY);
                    make.right.offset(-10);
                    make.width.offset(ima.size.width);
                    make.height.offset(ima.size.height);
                    
                }];
                
            }
            if (self.tfexpress == nil) {
                self.tfexpress = [[UITextField alloc]init];
                _tfexpress.placeholder = @"请输入快递公司和单号，或者扫描条形码";
                _tfexpress.clearButtonMode = UITextFieldViewModeWhileEditing;
                _tfexpress.font = [UIFont systemFontOfSize:14];
                _tfexpress.textColor = JHColor(102, 102, 102);
                [cell.contentView addSubview:self.tfexpress];
                [self.tfexpress mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(lb.mas_right).offset(10);
                    make.top.offset(0);
                    make.bottom.offset(0);
                    make.right.equalTo(self.saoyisaoBtn.mas_left).offset(-10);
                    
                }];
            }
        }else{
            lb.text = @"包裹拍照";
            if (self.photoBtn == nil) {
                self.photoBtn = [[UIButton alloc]init];
                [self.photoBtn setImage:[UIImage imageNamed:@"xiangji_kuaiditongzhi"] forState:UIControlStateNormal];
                [self.photoBtn addTarget:self action:@selector(photoClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:self.photoBtn];
                [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerY.equalTo(cell.contentView.mas_centerY);
                    make.right.offset(-10);
                    
                    
                }];
                
            }
            
            
            if (_imageveiw == nil) {
                _imageveiw = [[UIImageView alloc]init];
                
                UIImage *image = [UIImage imageNamed:@"xiaoxiangpian"];
                _imageveiw.image = image;
                [cell.contentView addSubview:_imageveiw];
                [_imageveiw mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(lb.mas_right).offset(10);
                    make.width.offset(image.size.width);
                    make.height.offset(image.size.height);
                    make.centerY.equalTo(cell.contentView.mas_centerY);
                    
                }];
                
            }
            
            
        }
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            lb.text = @"收件人电话";
            
            if (self.tfphone == nil) {
                self.tfphone = [[UITextField alloc]init];
                _tfphone.delegate = self;
                _tfphone.clearButtonMode = UITextFieldViewModeWhileEditing;
                _tfphone.placeholder = @"请输入收件人手机号";
                _tfphone.font = [UIFont systemFontOfSize:14];
                _tfphone.textColor = JHColor(102, 102, 102);
                [cell.contentView addSubview:self.tfphone];
                [self.tfphone mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(lb.mas_right).offset(10);
                    make.top.offset(0);
                    make.bottom.offset(0);
                    make.right.offset(-10);
                    
                }];
            }
        }else{
            lb.text = @"业主信息";
            
            if (self.infoLb == nil) {
                self.infoLb = [[UILabel alloc]init];
                _infoLb.numberOfLines = 0;
                _infoLb.font = [UIFont systemFontOfSize:14];
                _infoLb.textColor = JHColor(102, 102, 102);
                [cell.contentView addSubview:self.infoLb];
                [self.infoLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(lb.mas_right).offset(10);
                    make.top.offset(0);
                    make.bottom.offset(0);
                    make.right.offset(-10);
                    
                }];
            }
        }
        
        
    }else{
        
        
        if (indexPath.row == 0) {
            
            lb.text = @"领取时间";
            if (self.timelb == nil) {
                _timelb = [[UILabel alloc]init];
                
                _timelb.font = [UIFont systemFontOfSize:14];
                _timelb.textColor = JHColor(102, 102, 102);
                _timelb.tag = 444 + indexPath.row;
                [cell.contentView addSubview:_timelb];
                [_timelb mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(lb.mas_right).offset(10);
                    make.top.offset(0);
                    make.bottom.offset(0);
                    make.right.offset(-10);
                    
                }];
                
                
            }
            if (self.timeArray.count) {
                _timelb.text = self.timeArray[0][@"content"];
            }
        }else{
            
            lb.text = @"领取地点";
            if (self.placeLb == nil) {
                _placeLb = [[UILabel alloc]init];
                
                _placeLb.font = [UIFont systemFontOfSize:14];
                _placeLb.textColor = JHColor(102, 102, 102);
                _placeLb.tag = 444 + indexPath.row;
                [cell.contentView addSubview:_placeLb];
                [_placeLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(lb.mas_right).offset(10);
                    make.top.offset(0);
                    make.bottom.offset(0);
                    make.right.offset(-10);
                    
                }];
                
            }
            if (self.placeArray.count) {
                _placeLb.text = self.placeArray[0][@"content"];
            }
            
        }
        
    }
    
    CGSize lbsize = [lb.text selfadaption:15];
    
    [lb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(lbsize.width + 5);
    }];
    
    return cell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        SelectExpressViewController *send = [[SelectExpressViewController alloc]init];
        if (indexPath.row == 0) {
            
            send.tag = 500;
            send.projectArray = self.timeArray;
            [self.navigationController pushViewController:send animated:YES];
            
        }else{
            
            send.tag = 501;
            send.projectArray = self.placeArray;
            [self.navigationController pushViewController:send animated:YES];
            
        }
    }
    
}

#pragma mark 扫一扫
-(void)saoyisaoClick:(UIButton *)btn{
    HCScanQRViewController *scan = [[HCScanQRViewController alloc]init];
    //调用此方法来获取二维码信息
    [scan successfulGetQRCodeInfo:^(NSString *QRCodeInfo) {
        self.tfexpress.text = QRCodeInfo;
    }];
    [self.navigationController pushViewController:scan animated:YES];
    
}
#pragma mark 拍照
-(void)photoClick:(UIButton *)btn{
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"图库", nil];
    [sheet showInView:self.view];
    
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 2)return;
    
    UIImagePickerController *pic = [[UIImagePickerController alloc]init];
    pic.delegate = self;
    
    //允许编辑图片
    pic.allowsEditing = NO;
    
    
    if (buttonIndex == 0) {
        
        pic.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }else{
        
        pic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    
    //显示控制器
    [self presentViewController:pic animated:YES completion:nil];
}

#pragma mark  图片选择成功的方法

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    UIImage *editimage = info[UIImagePickerControllerOriginalImage];
    NSString *mediaType = info[UIImagePickerControllerMediaType];
//    if ([mediaType isEqualToString:@"public.image"]) {  //判断是否为图片
//        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//            UIImageWriteToSavedPhotosAlbum(editimage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        }
//    }
    editimage = [editimage fixOrientation];
    self.imageveiw.image = editimage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

//此方法就在UIImageWriteToSavedPhotosAlbum的上方
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"已保存");
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *footview = [[UIView alloc]init];
    footview.backgroundImage = [UIImage imageNamed:@"caitiao"];
    
    
    return footview;
}
-(NSMutableAttributedString *)AttributedString:(NSString *)allstr attstring:(NSString *)attstring{
    NSMutableAttributedString* htinstr = [[NSMutableAttributedString alloc]initWithString:allstr];
    NSString *str = attstring;
    NSRange range =[[htinstr string]rangeOfString:str];
    [htinstr addAttribute:NSForegroundColorAttributeName value:JHColor(102, 102, 102) range:range];
    [htinstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    return htinstr;
    
}
#pragma mark UITextFieldDelegate协议方法

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if (textField == _tfphone) {
        if (_tfphone.text.length >=10 && _tfphone.text.length <=11) {
            NSString *num = [NSString stringWithFormat:@"%@%@",_tfphone.text,string];
            
            [self UploadDatalatePhoneForInfo:num];
        }
        
        
        
    }
    
    
    return YES;
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (textField == _tfphone) {
        
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }else if(textField.text.length == 11){
            [self.view endEditing:YES];
            
        }else{
            
            
            
        }
    }
    
}

#pragma mark - *************领取时间和地点*************
-(void)UploadDatalateTimeandLocation{
    NSString *usid = [UserDefault objectForKey:@"useruid"];
    if (usid == nil) {
        usid = @"";
    }
    LFLog(@"usid:%@",usid);
    NSDictionary *dt = @{@"userid":usid};
    
    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"55") params:dt success:^(id response) {
        [self.tableveiw.mj_header endRefreshing];
        [self.tableveiw.mj_footer endRefreshing];
        LFLog(@"response:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            [self.timeArray removeAllObjects];
            for (NSDictionary *dt in response[@"note"][@"time"]) {
                
                [self.timeArray addObject:dt];
                
            }
            [self.placeArray removeAllObjects];
            for (NSDictionary *dt in response[@"note"][@"address"]) {
                
                [self.placeArray addObject:dt];
                
            }
            _timelb.text = self.timeArray[0][@"content"];
            _placeLb.text = self.placeArray[0][@"content"];
            //            [self.tableveiw reloadData];
        }
        
        
    } failure:^(NSError *error) {
        [self.tableveiw.mj_header endRefreshing];
        [self.tableveiw.mj_footer endRefreshing];
    }];
    
    
}


#pragma mark - *************手机号获取用户信息*************
-(void)UploadDatalatePhoneForInfo:(NSString *)num{
    NSString *usid = [UserDefault objectForKey:@"useruid"];
    if (usid == nil) {
        usid = @"";
    }
    LFLog(@"usid:%@",usid);
    NSDictionary *dt = @{@"userid":usid,@"mobile":num};
    
    [LFLHttpTool post:NSStringWithFormat(ZJguokaihangBaseUrl,@"56") params:dt success:^(id response) {
        [self.tableveiw.mj_header endRefreshing];
        [self.tableveiw.mj_footer endRefreshing];
        LFLog(@"response:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            
            
            self.isSubbtn = YES;
            self.infoLb.text =[NSString stringWithFormat:@"%@\n%@", response[@"note"][@"name"], response[@"note"][@"address"]];
            
            //            [self.tableveiw reloadData];
        }else{
            self.isSubbtn = NO;
            self.infoLb.text = @"不是业主，暂无法发送快递";
        }
        
    } failure:^(NSError *error) {
        [self.tableveiw.mj_header endRefreshing];
        [self.tableveiw.mj_footer endRefreshing];
    }];
    
    
}



#pragma mark - *************提交*************
-(void)submitUploadDatalate{
    NSString *usid = [UserDefault objectForKey:@"useruid"];
    if (usid == nil) {
        usid = @"";
    }
    NSData * data = UIImageJPEGRepresentation(_imageveiw.image,0.75);
    
    NSString *aString = [data convertDataToHexStr];
    NSArray *array = [self.infoLb.text componentsSeparatedByString:@"\n"];
    
    NSString *phone =[UserDefault objectForKey:@"nameuser"];
    NSDictionary *dt = @{@"userid":usid,@"imgurl":aString,@"owner_mobile":self.tfphone.text,@"owner_name":array[0],@"owner_address":array[1],@"express_number":_tfexpress.text,@"express_company":@"中通",@"worker_mobile":phone,@"worker_address":self.placeLb.text,@"worker_time":self.timelb.text,};
    
    [LFLHttpTool post:NSStringWithFormat(ZJguokaihangBaseUrl,@"57") params:dt success:^(id response) {
        [self dismissTips];
        [self.tableveiw.mj_header endRefreshing];
        [self.tableveiw.mj_footer endRefreshing];
        LFLog(@"response:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            
            [self createAlertion:@"提示" str:@"发件成功"];
        }
        
    } failure:^(NSError *error) {
        [self dismissTips];
        [self.tableveiw.mj_header endRefreshing];
        [self.tableveiw.mj_footer endRefreshing];
    }];
    
    
}





@end
