//
//  AddaddressViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/1.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "AddaddressViewController.h"
#import "addressViewController1.h"
#import "SelectAddressViewController.h"
#import "ConfirmOrderViewController.h"
#import "ShoppingCartViewController.h"
@interface AddaddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *namearr;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *addressArr;

@property(nonatomic,assign)BOOL isBack;
@end

@implementation AddaddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.namearr = @[@"收货人：",@"电话号码：",@"所在地区：",@"详细地址："];
    self.isBack = NO;
    [self createTableview];
    [self UploadDataRegionList];
    if (self.address_id) {
        [self UploadDataEditaddress];
        self.navigationBarTitle = @"编辑地址";
    }else{
    self.navigationBarTitle = @"添加地址";
    }
}
-(NSMutableArray *)addressArr{
    if (_addressArr == nil) {
        _addressArr = [[NSMutableArray alloc]init];
    }
    return _addressArr;
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height  + 50)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"addcell"];
    [self.view addSubview:self.tableview];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.namearr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return SCREEN.size.height - self.namearr.count * 50 - 100;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footview = [[UIView alloc]init];
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];

//    if (self.address_id) {
//    [submitBtn setTitle:@"保存地址" forState:UIControlStateNormal];
//    }else{
//     [submitBtn setTitle:@"添加地址" forState:UIControlStateNormal];
//    }
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"denglukuang"] forState:UIControlStateNormal];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [submitBtn setTintColor:[UIColor whiteColor]];
    [submitBtn addTarget:self action:@selector(addresssubmitClick:) forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.centerY.equalTo(footview.mas_centerY);
        make.height.offset(40);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapclick:)];
    [footview addGestureRecognizer:tap];

    return footview;
}
-(void)addresssubmitClick:(UIButton *)btn{
    
    UITextView *tfname = [self.view viewWithTag:200];
    UITextView *tfphone = [self.view viewWithTag:201];
    UITextView *tfaddress = [self.view viewWithTag:203];
    
    
    if (tfname.text.length == 0) {
        [tfname becomeFirstResponder];
        [self presentLoadingTips:@"请输入联系人姓名"];
    }else if (tfphone.text.length == 0){
        [tfphone becomeFirstResponder];
         [self presentLoadingTips:@"请输入联系人手机号"];
        
    }else if (!self.regionid) {
        [self presentLoadingTips:@"请选择所在区域"];
    }else if (tfaddress.text.length == 0){
        [tfaddress becomeFirstResponder];
        [self presentLoadingTips:@"请输入详细地址"];
        
    }else {
        [self presentLoadingTips:@"请稍后~~"];
        if (self.address_id) {
            [self UploadDataEditRegion:tfname.text phone:tfphone.text address:tfaddress.text];
        }else{
            [self UploadDataAddRegion:tfname.text phone:tfphone.text address:tfaddress.text];
        }
        
    }
    
}

-(void)tapclick:(UIGestureRecognizer *)tap{
    
    [self.view endEditing:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addcell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *namelabel = [cell.contentView viewWithTag:indexPath.row + 100];
    if (namelabel == nil) {
        namelabel = [[UILabel alloc]init];
        namelabel.tag = indexPath.row + 100;
        namelabel.text = self.namearr[indexPath.row];
        namelabel.textColor = JHColor(51, 51, 51);
        namelabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:namelabel];
        [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.width.offset([namelabel.text selfadaption:15].width + 5);
        }];
    }
    if (indexPath.row != 2) {
        UITextField *tf = [cell.contentView viewWithTag:indexPath.row + 200];
        if (tf == nil) {
            tf = [[UITextField alloc]init];
            tf.tag = indexPath.row + 200;
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            tf.font = [UIFont systemFontOfSize:14];
            tf.textColor = JHColor(102, 102, 102);
            tf.placeholder = indexPath.row == 0 ? @"请输入姓名" :(indexPath.row == 1 ? @"请输入电话号码" :@"请输入详细地址");
            [cell.contentView addSubview:tf];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-10);
                make.left.equalTo(namelabel.mas_right);
                make.top.offset(0);
                make.bottom.offset(0);
            }];
        }
        if (self.addressArr.count) {
            NSDictionary *dt = self.addressArr[0];
            if (indexPath.row == 0) {
                tf.text = dt[@"consignee"];
            }else if (indexPath.row == 1){
                tf.text = dt[@"mobile"];
            
            }else if (indexPath.row == 3){
                tf.text = dt[@"address"];
                
            }
        }
    }else{
        UILabel *loactionlabel = [cell.contentView viewWithTag:11];
        if (loactionlabel == nil) {
            loactionlabel = [[UILabel alloc]init];
            loactionlabel.tag = 11;
            loactionlabel.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:loactionlabel];
            [loactionlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-30);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.left.equalTo(namelabel.mas_right);
            }];
        }
        loactionlabel.textColor = JHdeepColor;
        if (self.region) {
            loactionlabel.text = self.region;
        }else{
            
            if (self.addressArr.count) {
                NSDictionary *dt = self.addressArr[0];
                loactionlabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",dt[@"country_name"],dt[@"province_name"],dt[@"city_name"],dt[@"district_name"]];
                self.regionid = [NSString stringWithFormat:@"%@,%@,%@,%@",dt[@"country"],dt[@"province"],dt[@"city"],dt[@"district"]];
            }else{
                loactionlabel.textColor = JHColor(200, 200, 200);
                loactionlabel.text = @"请选择";
            }
        
        }
        
        UIImageView *rightimage = [cell.contentView viewWithTag:12];
        if (rightimage == nil) {
            rightimage = [[UIImageView alloc]init];
            rightimage.tag = 12;
            rightimage.image = [UIImage imageNamed:@"gerenzhongxinjiantou"];
            [cell.contentView addSubview:rightimage];
            [rightimage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-10);
                make.centerY.equalTo(cell.contentView.mas_centerY);

            }];
        }
    
    }
    

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count) {
        if (indexPath.row == 2) {
            addressViewController1 * add = [[addressViewController1 alloc]init];
            add.dataArray = self.dataArray;
            self.isBack = YES;
            [self.navigationController pushViewController:add animated:YES];
        }

    }else{
        [self presentLoadingTips:@"请稍后再试~"];
    
    }

}

#pragma mark - *************添加地址*************
-(void)UploadDataAddRegion:(NSString *)name phone:(NSString *)phone address:(NSString *)address{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dtict = [[NSMutableDictionary alloc]init];
    if (session) {
        [dtict setObject:session forKey:@"session"];
    }
    NSArray *addressarr = [NSArray array];
    if (self.regionid) {
        addressarr = [self.regionid componentsSeparatedByString:@","];
    }else{
        return;
    }
    NSString *email = [NSString stringWithFormat:@"%@@qq.com",phone];
    NSDictionary *dt = @{@"consignee":name,@"mobile":phone,@"tel":phone,@"address":address,@"country":addressarr[0],@"province":addressarr[1],@"city":addressarr[2],@"district":addressarr[3],@"email":email};
    [dtict setObject:dt forKey:@"address"];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,AddAddressUrl) params:dtict success:^(id response) {
        LFLog(@"添加地址：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            self.isAdd = NO;
            [self presentLoadingTips:@"添加成功"];
            [self performSelector:@selector(delayed) withObject:nil afterDelay:2.0];
            
        }else{
            
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];

        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
-(void)delayed{
    NSArray *vcarray = self.navigationController.viewControllers;
    for (UIViewController *vc in vcarray) {
        if ([vc isKindOfClass:[SelectAddressViewController class]]) {
            SelectAddressViewController *select =(SelectAddressViewController *)vc;
            
            [self.navigationController popToViewController:select animated:YES];
            return;
        }
    }
    for (UIViewController *vc in vcarray) {
        if ([vc isKindOfClass:[ConfirmOrderViewController class]]) {
            ConfirmOrderViewController *con =(ConfirmOrderViewController *)vc;
            [con UploadDatagoodsOderInfo];
            [self.navigationController popToViewController:con animated:YES];
            return;
        }
    }

}
#pragma mark - *************地区列表*************

-(void)UploadDataRegionList{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,RegionListUrl) params:dt success:^(id response) {
        LFLog(@"地区列表：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            for (NSDictionary *dt in response[@"data"][@"regions"]) {
                [self.dataArray addObject:dt];
            }
            [self.tableview reloadData];
        }else{
            
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self UploadDataRegionList];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            [self.tableview reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark - *************编辑地址请求*************
-(void)UploadDataEditaddress{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.address_id,@"address_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,AddressEditUrl) params:dt success:^(id response) {
        LFLog(@"编辑地址：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        [self.addressArr removeAllObjects];
        if ([str isEqualToString:@"1"]) {
            [self.addressArr addObject:response[@"data"]];
            [self.tableview reloadData];
        }else{
            
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            [self.tableview reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark - *************编辑保存地址*************
-(void)UploadDataEditRegion:(NSString *)name phone:(NSString *)phone address:(NSString *)address{
    
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dtict = [[NSMutableDictionary alloc]init];
    if (session) {
        [dtict setObject:session forKey:@"session"];
    }
    [dtict setObject:self.address_id forKey:@"address_id"];
    NSArray *addressarr = [NSArray array];
    if (self.regionid) {
        addressarr = [self.regionid componentsSeparatedByString:@","];
    }else{
        return;
    }
    NSDictionary *dt = @{@"consignee":name,@"mobile":phone,@"tel":phone,@"address":address,@"country":addressarr[0],@"province":addressarr[1],@"city":addressarr[2],@"district":addressarr[3]};
    [dtict setObject:dt forKey:@"address"];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,AddressEditSaveUrl) params:dtict success:^(id response) {
        LFLog(@"添加地址：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            self.isAdd = NO;
            [self presentLoadingTips:@"添加成功"];
            [self performSelector:@selector(delayed) withObject:nil afterDelay:2.0];
            
        }else{
            
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!self.isBack) {
      if (self.isAdd) {
        NSArray *vcarray = self.navigationController.viewControllers;
        for (UIViewController *vc in vcarray) {
            if ([vc isKindOfClass:[ShoppingCartViewController class]]) {
                ShoppingCartViewController *select =(ShoppingCartViewController *)vc;
                
                [self.navigationController popToViewController:select animated:YES];
                return;
            }
        }
     }
        
   }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.isBack = NO;

}

@end
