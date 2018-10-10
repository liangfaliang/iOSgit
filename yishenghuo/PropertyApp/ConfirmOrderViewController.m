//
//  ConfirmOrderViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/10/31.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "ShopAddressTableViewCell.h"
#import "ShopgoodsDecTableViewCell.h"
#import "ShopOtherTableViewCell.h"
#import "SelectAddressViewController.h"
#import "SelectStyleViewController.h"
#import "WXApiRequestHandler.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "AddaddressViewController.h"
#import "ShopNoPaymentViewController.h"
#import "ShopOderListViewController.h"
#import "YYLabel.h"
#import "YYText.h"
#import "MyCouponViewController.h"
#import "CouponExchangeViewController.h"
@interface ConfirmOrderViewController ()<UIActionSheetDelegate,UITextFieldDelegate>{
    UITextField *tfIntegral;//积分输入框
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UILabel *totalLabel;
@property(nonatomic,strong)NSString *shopmoney;//商品金额
@property(nonatomic,strong)NSString *IntegralPay;//积分抵消金额
@property(nonatomic,strong)NSMutableArray *payInfo;
@end

@implementation ConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.is_Integral) {
        self.navigationBarTitle = @"确认兑换";
    }else{
        self.navigationBarTitle = @"订单确认";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.IntegralPay = @"-￥0.00";
    [self createFootview];
    [self createTableview];
    [self UploadDatagoodsOderInfo:YES];
    [self setupRefresh];
    //添加键盘通知
    //    [Notification addObserver:self selector:@selector(orderkbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //    [Notification addObserver:self selector:@selector(orderkbWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//-(void)orderkbWillShow:(NSNotification *)noti{
//
//    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:3];
//    [self.tableview scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
//
//}
//
//-(void)orderkbWillHide:(NSNotification *)noti
//{
//
//    //    [self.tableview scrollRectToVisible:CGRectMake(0, 0, 1,1) animated:NO];
//}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
-(NSMutableArray *)payInfo{
    
    if (_payInfo == nil) {
        _payInfo = [[NSMutableArray alloc]init];
    }
    
    return _payInfo;
    
}
-(void)createFootview{
    UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN.size.height - 50, SCREEN.size.width, 50)];
    [self.view addSubview:footview];
    UIButton *subButton = [[UIButton alloc]init];
    if (self.is_Integral) {
        [subButton setTitle:@"确认兑换" forState:UIControlStateNormal];
    }else{
        [subButton setTitle:@"确认下单" forState:UIControlStateNormal];
    }
    [subButton addTarget:self action:@selector(sumOrderClick:) forControlEvents:UIControlEventTouchUpInside];
    subButton.backgroundColor = JHshopMainColor;
    [footview addSubview:subButton];
    [subButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.bottom.offset(0);
        make.top.offset(0);
        make.width.offset(150);
    }];
    self.totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, SCREEN.size.width - 240, 50)];
    self.totalLabel.text = @"￥0.0";
    self.totalLabel.textColor = [UIColor redColor];
    self.totalLabel.font = [UIFont systemFontOfSize:18];
    [footview addSubview:self.totalLabel];
    
    UILabel *payLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 50)];
    payLabel.textColor = JHColor(51, 51, 51);
    payLabel.text = @"应付款：";
    payLabel.font = [UIFont systemFontOfSize:18];
    //    payLabel.textAlignment = NSTextAlignmentRight;
    [footview addSubview:payLabel];
}
#pragma mark 提交订单
-(void)sumOrderClick:(UIButton *)btn{
    
    if (!self.payDict.count) {
        [self presentLoadingTips:@"请选择支付方式"];
        return;
    }
    if (!self.expressDict.count) {
        [self presentLoadingTips:@"请选择配送方式"];
        return;
    }
    if ([self.payDict[@"is_cod"] isEqualToString:@"1"] &&[self.expressDict[@"support_cod"] isEqualToString:@"0"]) {
        [self presentLoadingTips:@"您选择的快递方式不支持货到付款"];
        return;
    }
    if ([self.payDict[@"pay_code"] isEqualToString:@"balance"]) {
        if (self.dataArray[0][@"user_money"]) {
            CGFloat usermonery = [[NSString stringWithFormat:@"%@",self.dataArray[0][@"user_money"]] floatValue];
            NSArray *totalArr = [self.totalLabel.text componentsSeparatedByString:@"￥"];
            CGFloat total = [totalArr.lastObject floatValue];
            if (usermonery < total) {
                [self presentLoadingTips:@"余额不足!"];
                return;
            }
        }
    }
    [self presentLoadingTips];
    [self UploadDatagoodsOderSubmit];
}
-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, SCREEN.size.height -50 - 64)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"confirmCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"ShopAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopAddressTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"ShopgoodsDecTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopgoodsDecTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"ShopOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopOtherTableViewCell"];
    [self.view addSubview:self.tableview];
    //    UIView *ftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 200)];
    //    self.tableview.tableFooterView = ftview;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if (self.is_Integral) {
//        return 3;
//    }
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 2) {
        if (self.is_Integral) {
            return 0;
        }
        return 1;
    }else if (section == 3){
        return 4;
    }
    if (section == 0) {
        if (self.dataArray.count) {
            if (![self.dataArray[0][@"goods_list"]isKindOfClass:[NSString class]]) {
                NSArray *goodslist = self.dataArray[0][@"goods_list"];
                return goodslist.count + 1;
            }
        }
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 85;
        }
        return 100;
    }
    if (self.is_Integral) {
        if (indexPath.section == 3) {
            if (indexPath.row == 0 || indexPath.row == 1) {
                return 0;
            }
        }
    }
    return 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        if (self.is_Integral) {
            return 0.001;
        }
    }
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"ShopOtherTableViewCell%ld",(long)indexPath.section];
    ShopOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:@"ShopOtherTableViewCell" bundle:nil];
        
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        cell  = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.MustImHeight.constant = 0;
    NSArray * array = [[NSArray alloc]init];
    if (self.dataArray.count) {
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                ShopAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopAddressTableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (self.addressDict) {
                    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",self.addressDict[@"consignee"],self.addressDict[@"mobile"]];
                    cell.addLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",_addressDict[@"country_name"],_addressDict[@"province_name"],_addressDict[@"city_name"],_addressDict[@"district_name"],_addressDict[@"address"]];
                }else{
                    if (![self.dataArray[0][@"consignee"]isKindOfClass:[NSString class]]) {
                        NSDictionary *dt = self.dataArray[0][@"consignee"];
                        cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",dt[@"consignee"],dt[@"mobile"]];
                        cell.addLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",dt[@"country_name"],dt[@"province_name"],dt[@"city_name"],dt[@"district_name"],dt[@"address"]];
                    }else{
                        AddaddressViewController *address = [[AddaddressViewController alloc]init];
                        [self.navigationController pushViewController:address animated:YES];
                        
                    }
                    
                }
                
                return cell;
            }else{
                ShopgoodsDecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopgoodsDecTableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (![self.dataArray[0][@"goods_list"]isKindOfClass:[NSString class]]) {
                    NSArray *goodslist = self.dataArray[0][@"goods_list"];
                    cell.goodsName.text = goodslist[indexPath.row - 1][@"goods_name"];
                    cell.numLabe.text = [NSString stringWithFormat:@"×%@",goodslist[indexPath.row - 1][@"goods_number"]];
                    [cell.goodsImage sd_setImageWithURL:goodslist[indexPath.row - 1][@"img"][@"goods_img"] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                    NSArray *goods_attr = [NSArray array];
                    if ([goodslist[indexPath.row - 1][@"goods_attr"] isKindOfClass:[NSArray class]]) {
                        goods_attr = goodslist[indexPath.row - 1][@"goods_attr"];
                    }
                    
                    NSMutableString *mstr = [NSMutableString string];
                    if (goods_attr.count) {
                        for (int i = 0; i < goods_attr.count; i ++) {
                            [mstr appendFormat:@"%@ ", goods_attr[i][@"value"]];
                        }
                    }
                    if (self.is_Integral) {

                        cell.parameterLb.textColor = JHshopMainColor;
                        cell.parameterLb.font = [UIFont systemFontOfSize:15];
                        cell.parameterLb.text = [NSString stringWithFormat:@"%@积分",goodslist[indexPath.row - 1][@"integral"]];
                    }else{
                        cell.priceLabel.text = [NSString stringWithFormat:@"%@",goodslist[indexPath.row - 1][@"formated_subtotal"]];
                        cell.priceLbWidth.constant = [cell.priceLabel.text selfadapUifont:[UIFont fontWithName:@"Helvetica-Bold" size:14] weith:14].width + 5;
                        cell.priceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14] ;
                        cell.parameterLb.text = mstr;
                    }
                    
                    
                }
                return cell;
            }
        }else if (indexPath.section == 1){
            array = @[@"支付方式",@"配送方式",@"发票信息"];
            cell.nameLabel.text = array[indexPath.row];
            cell.contentLb.textColor = JHColor(51, 51, 51);
            //            if (indexPath.row == 0 || indexPath.row == 1) {
            //                cell.MustImHeight.constant = 35;
            //            }
            cell.rigthtIm.hidden = NO;
            if (indexPath.row == 0) {
                
                if (![self.dataArray[0][@"payment_list"]isKindOfClass:[NSString class]]) {
                    NSString *payid =[self.payDict objectForKey:@"pay_name"];
                    if (payid) {
                        cell.contentLb.text = payid;
                    }else{
                        cell.contentLb.text = nil;
                    }
                }else{
                    cell.contentLb.text = nil;
                }
                
            }else if (indexPath.row == 1){
                cell.contentLb.text = nil;
                if (![self.dataArray[0][@"shipping_list"]isKindOfClass:[NSString class]]) {
                    NSString *payid =[self.expressDict objectForKey:@"shipping_name"];
                    if (payid) {
                        cell.contentLb.text = payid;
                    }
                }
                
            }else if (indexPath.row == 2){
                if (self.bill) {
                    
                    cell.contentLb.text = self.bill;
                    
                }else{
                    cell.contentLb.text = nil;
                }
                
            }
            
        }else if  (indexPath.section == 3){
            array = @[@"商品金额",@"优惠券/优惠码",@"积分",@"运费"];
            cell.nameLabel.text = array[indexPath.row];
            cell.MustImHeight.constant = 0;
            cell.rigthtIm.hidden = YES;
            cell.contentLb.textColor = [UIColor redColor];
            if (indexPath.row == 0) {
                if (self.is_Integral) {
                    cell.contentLb.text = nil;
                    cell.nameLabel.text = nil;
                }else{
                    if (self.shopmoney) {
                        cell.contentLb.text = self.shopmoney;
                    }else{
                        cell.contentLb.text = nil;
                    }
                }
            }else if (indexPath.row == 1){
                if (self.is_Integral) {
                    cell.contentLb.text = nil;
                    cell.nameLabel.text = nil;
                }else{
                    cell.contentLb.textColor = JHmiddleColor;
                    if (self.couponDict) {
                        NSString *formated =[self.couponDict objectForKey:@"bonus_money_formated"];
                        if (formated) {
                            cell.contentLb.textColor = [UIColor redColor];
                            cell.contentLb.text = [NSString stringWithFormat:@"-%@",formated];
                        }else{
                            cell.contentLb.text = @"未使用";
                        }
                    }else{
                        cell.contentLb.text = @"未使用";
                    }
                    
                    cell.rigthtIm.hidden = NO;
                }
                
            }else if (indexPath.row == 3){
                if ([self.dataArray[0][@"shipping_list"] isKindOfClass:[NSArray class]]) {
                    NSString *payid = self.expressDict[@"format_shipping_fee"];
                    //                LFLog(@"payid：%@",payid);
                    if (payid) {
                        cell.contentLb.text = payid;
                    }else{
                        cell.contentLb.text = @"￥0.00";
                    }
                }
                
            }else if (indexPath.row == 2){
                if (self.is_Integral) {
                    if ([self.dataArray[0][@"total_integral"] isKindOfClass:[NSString class]]) {
                        NSString *total_integral =self.dataArray[0][@"total_integral"];
                        if (total_integral) {
                            cell.contentLb.text = [NSString stringWithFormat:@"%@积分",total_integral];
                        }
                    }
                }else{
                    if ([self.dataArray[0][@"your_integral"] isKindOfClass:[NSString class]]) {
                        NSString *your_integral =self.dataArray[0][@"your_integral"];
                        if (your_integral) {
                            NSString *namestr = [NSString stringWithFormat:@"%@ 共%@分",array[indexPath.row],your_integral];
                            cell.nameLabel.attributedText = [namestr AttributedString:[NSString stringWithFormat:@"共%@分",your_integral] backColor:nil uicolor:JHsimpleColor uifont:[UIFont systemFontOfSize:13]];
                        }
                    }
                    
                    cell.contentLb.text = self.IntegralPay;
                    if (tfIntegral == nil) {
                        tfIntegral = [[UITextField alloc]init];
                        tfIntegral.text = @"0";
                        tfIntegral.font = [UIFont systemFontOfSize:15];
                        tfIntegral.backgroundColor = JHBorderColor;
                        tfIntegral.keyboardType = UIKeyboardTypeNumberPad;
                        tfIntegral.delegate = self;
                        tfIntegral.textColor = JHmiddleColor;
                        tfIntegral.textAlignment = NSTextAlignmentCenter;
                        [tfIntegral addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
                        UILabel *leftlb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
                        leftlb.backgroundColor = [UIColor whiteColor];
                        leftlb.textColor = JHmiddleColor;
                        leftlb.text = @"使用";
                        leftlb.width = [leftlb.text selfadap:15 weith:20].width + 5;
                        leftlb.font = [UIFont systemFontOfSize:15];
                        tfIntegral.leftView = leftlb;
                        tfIntegral.leftViewMode=UITextFieldViewModeAlways;
                        UILabel *rightlb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
                        rightlb.backgroundColor = [UIColor whiteColor];
                        rightlb.textColor = JHmiddleColor;
                        rightlb.textAlignment = NSTextAlignmentRight;
                        rightlb.text = @"分";
                        rightlb.width = [rightlb.text selfadap:15 weith:20].width + 5;
                        rightlb.font = [UIFont systemFontOfSize:15];
                        tfIntegral.rightView = rightlb;
                        tfIntegral.rightViewMode=UITextFieldViewModeAlways;
                    }
                    [cell.contentLb addSubview: tfIntegral];
                    [tfIntegral mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.offset(100);
                        make.centerY.equalTo(cell.contentView.mas_centerY);
                        make.right.offset(-[self.IntegralPay selfadap:15 weith:20].width - 20);
                        make.height.offset(20);
                    }];
                    
                }
                
                
                
            }
            
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"confirmCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *lb = [cell.contentView viewWithTag:77];
            if (lb == nil) {
                lb = [[UILabel alloc]init];
                lb.tag = 77;
                [cell.contentView addSubview:lb];
                lb.textColor = JHColor(102, 102, 102);
                lb.text = @"订单备注：";
                lb.font = [UIFont systemFontOfSize:15];
                [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(10);
                    make.centerY.equalTo(cell.contentView.mas_centerY);
                    make.width.offset([lb.text selfadaption:15].width +5);
                    
                }];
            }
            UITextField *tf = [cell.contentView viewWithTag:78];
            if (tf == nil) {
                tf = [[UITextField alloc]init];
                tf.tag = 78;
                tf.placeholder = @"可不填";
                tf.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview: tf];
                [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lb.mas_right).offset(0);
                    make.centerY.equalTo(cell.contentView.mas_centerY);
                    make.right.offset(-10);
                }];
            }
            return cell;
        }
        
        CGSize namesize = [cell.nameLabel.text selfadaption:15];
        cell.nameHeight.constant = namesize.width + 5;
        if (cell.rigthtIm.hidden) {
            cell.contentRight.constant = 10;
        }else{
            cell.contentRight.constant = 30;
        }
    }
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIImageView *view = [[UIImageView alloc]init];
    view.image = [UIImage imageNamed:@"fengexiantongyong"];
    
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [self.view endEditing:YES];
    if (self.dataArray.count) {
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                SelectAddressViewController *add = [[SelectAddressViewController alloc]init];
                [self.navigationController pushViewController:add animated:YES];
            }else{
                //                if (self.dataArray.count) {
                //                    if (![self.dataArray[0][@"goods_list"]isKindOfClass:[NSString class]]) {
                //                        NSArray *goodslist = self.dataArray[0][@"goods_list"];
                //                        ShopOderListViewController *list = [[ShopOderListViewController alloc]init];
                //                        list.dataArray = [NSMutableArray arrayWithArray:goodslist];
                //                        [self.navigationController pushViewController:list animated:YES];
                //                    }
                //                }
                
            }
            
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                if (![self.dataArray[0][@"payment_list"]isKindOfClass:[NSString class]]) {
                    SelectStyleViewController *pay = [[SelectStyleViewController alloc]init];
                    pay.tag = 100;
                    if (self.dataArray[0][@"user_money"]) {
                        pay.userMoney = [NSString stringWithFormat:@"%@",self.dataArray[0][@"user_money"]];
                    }
                    NSArray *payArr = self.dataArray[0][@"payment_list"];
                    for (NSDictionary *dt in payArr) {
                        [pay.dataArray addObject:dt];
                    }
                    [self.navigationController pushViewController:pay animated:YES];
                }
            }else if (indexPath.row == 1){
                if (![self.dataArray[0][@"shipping_list"]isKindOfClass:[NSString class]]) {
                    SelectStyleViewController *pay = [[SelectStyleViewController alloc]init];
                    pay.tag = 101;
                    NSArray *payArr = self.dataArray[0][@"shipping_list"];
                    for (NSDictionary *dt in payArr) {
                        [pay.dataArray addObject:dt];
                    }
                    [self.navigationController pushViewController:pay animated:YES];
                }
                
            }else{
                SelectStyleViewController *pay = [[SelectStyleViewController alloc]init];
                pay.tag = 103;
                [self.navigationController pushViewController:pay animated:YES];
                
            }
            
        }else if (indexPath.section == 3){
            if (indexPath.row == 1) {
                if (self.dataArray[0][@"allow_use_bonus"]) {
                    if ([[NSString stringWithFormat:@"%@",self.dataArray[0][@"allow_use_bonus"]] isEqualToString:@"1"]) {
                        if ([self.dataArray[0][@"bonus"] isKindOfClass:[NSArray class]]) {
                            NSArray *bonusArr = self.dataArray[0][@"bonus"];
                            if (bonusArr.count) {
                                CouponExchangeViewController *cou = [[CouponExchangeViewController alloc]init];
                                cou.boundArr = bonusArr;
                                cou.titleStr = @"优惠券";
                                cou.isSelect = @"isSelect";
                                [self.navigationController pushViewController:cou animated:YES];
                                return;
                            }

                        }
                        [self presentLoadingTips:@"当前暂无可使用优惠券！"];

                    }else{
                        [self presentLoadingTips:@"当前不可使用优惠券！"];
                    }
                }
            }

            
        }
        
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == tfIntegral) {
        NSCharacterSet *cs;
        
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890\n"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入有效数字"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
            [alert show];
            
            return NO;
        }
    }
    
    //其他的类型不需要检测，直接写入
    return YES;
}
-(void)textFieldTextChange:(UITextField *)textField{
    
    if (textField == tfIntegral) {
        if (self.dataArray.count) {
            if (self.dataArray[0][@"order_max_integral"]) {
                CGFloat maxIntegral = [self.dataArray[0][@"order_max_integral"] integerValue];//最高使用积分
                CGFloat your_integral = [self.dataArray[0][@"your_integral"] integerValue];//共有积分
                
                CGFloat Integral = [textField.text floatValue];
                if (Integral > your_integral) {
                    [self presentLoadingTips:[NSString stringWithFormat:@"您共有%@积分",self.dataArray[0][@"your_integral"]]];
                    Integral = your_integral;
                    tfIntegral.text = [NSString stringWithFormat:@"%d",(int)Integral];
                    [self refreshIntegral:Integral];
                    return;
                }
                
                if (Integral > maxIntegral) {
                    [self presentLoadingTips:[NSString stringWithFormat:@"您最高可使用积分为%@",self.dataArray[0][@"order_max_integral"]]];
                    Integral = maxIntegral;
                    tfIntegral.text = [NSString stringWithFormat:@"%d",(int)Integral];
                    [self refreshIntegral:Integral];
                    return;
                }
                [self refreshIntegral:Integral];
            }
        }
    }
}
-(void)refreshIntegral:(CGFloat )Integral{
    
    CGFloat scale = [self.dataArray[0][@"integral_scale"] floatValue];//积分抵消比例
    if (scale > 0) {
        self.IntegralPay = [NSString stringWithFormat:@"-￥%.2f",Integral * scale];
        LFLog(@"IntegralPay:%@",self.IntegralPay);
        YYLabel *contentLb = (YYLabel *) tfIntegral.superview;
        contentLb.text = self.IntegralPay;
        [self updateTableview];
    }else{
        [self presentLoadingTips:@"数据错误!"];
    }
    
}
#pragma mark - *************商品订单请求*************
-(void)UploadDatagoodsOderInfo{
    [self UploadDatagoodsOderInfo:NO];
}
-(void)UploadDatagoodsOderInfo:(BOOL )isFirst{
    [self presentLoadingTips];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    LFLog(@"session：%@",session);
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (self.rec_id) {
        [dt setObject:self.rec_id forKey:@"rec_id"];
    }
    if (self.shop_id) {
        [dt setObject:self.shop_id forKey:@"shop_id"];
    }
    if (self.is_Integral) {
        [dt setObject:@"1"forKey:@"is_integral"];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,goodsOrderUrl) params:dt success:^(id response) {
        [self.tableview.mj_header endRefreshing];
        [self dismissTips];
        LFLog(@"订单信息：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        [self.dataArray removeAllObjects];
        if ([str isEqualToString:@"1"]) {
            
            [self.dataArray addObject:response[@"data"]];
            if (isFirst) {
                if ([self.dataArray[0][@"bonus"] isKindOfClass:[NSArray class]]) {
                    self.couponDict = self.dataArray[0][@"bonus"][0];
                }
            }

            if ([self.dataArray[0][@"goods_list"]isKindOfClass:[NSArray class]]) {
                
                double price = 0.0;
                NSArray *goodslist = self.dataArray[0][@"goods_list"];
                for (NSDictionary *dt in goodslist) {
                    price += [[dt[@"subtotal"] stringByReplacingOccurrencesOfString:@"￥" withString:@""] doubleValue];
                }
                self.shopmoney = [NSString stringWithFormat:@"￥%.2f",(double)price];
                LFLog(@"shopmoney:%@",self.shopmoney);
//                CGFloat scale = [self.dataArray[0][@"integral_scale"] floatValue];//积分抵消比例
//                if (scale > 0) {
//                    if (tfIntegral) {
//                        CGFloat Intergral = [tfIntegral.text floatValue];
//                        price -= Intergral * scale;
//                    }
//                    
//                }
//                self.totalLabel.text = [NSString stringWithFormat:@"￥%.2f",(double)price];
                [self updateTableview];
            }else{
                self.totalLabel.text = @"￥0.00";
            }
            self.tableview.hidden = NO;
            [self.tableview reloadData];
            
        }else{
            self.totalLabel.text = @"￥0.00";
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"10001"]) {
                AddaddressViewController *address = [[AddaddressViewController alloc]init];
                address.isAdd = YES;
                [self.navigationController pushViewController:address animated:YES];
            }else{
                
                NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
                if ([error_code isEqualToString:@"100"]) {
                    [self showLogin:^(id response) {
                    }];
                }
                [self presentLoadingTips:response[@"status"][@"error_desc"]];
            }
            self.tableview.hidden = YES;
            
        }
        [self.tableview reloadEmptyDataSet];
    } failure:^(NSError *error) {
        [self.tableview reloadEmptyDataSet];
        [self.tableview.mj_header endRefreshing];
        [self dismissTips];
    }];
    
    
}
#pragma mark - *************商品订单提交请求*************
-(void)UploadDatagoodsOderSubmit{
    [self presentLoadingTips];
    UITextField *tf = [self.view viewWithTag:78];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    LFLog(@"session：%@",session);
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    [dt setObject:self.payDict[@"pay_id"] forKey:@"pay_id"];
    [dt setObject:self.expressDict[@"shipping_id"] forKey:@"shipping_id"];
    if (self.bill.length > 0) {
        [dt setObject:@"1" forKey:@"need_inv"];
        [dt setObject:self.bill forKey:@"inv_payee"];
        
    }else{
        [dt setObject:@"0" forKey:@"need_inv"];
    }
    if (tf.text.length > 0) {
        [dt setObject:tf.text forKey:@"postscript"];
    }
    if (tfIntegral.text.length > 0 && ![tfIntegral.text isEqualToString:@"0"]) {
        [dt setObject:tfIntegral.text forKey:@"integral"];
    }
    if (self.rec_id) {
        [dt setObject:self.rec_id forKey:@"rec_id"];
    }
    if (self.addressDict) {
        [dt setObject:self.addressDict[@"id"] forKey:@"address_id"];
    }
    if (self.couponDict) {
        [dt setObject:self.couponDict[@"bonus_id"] forKey:@"bonus"];
    }
    if (self.is_Integral) {
        [dt setObject:@"1"forKey:@"is_integral"];
    }
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,SubmitOrdersUrl) params:dt success:^(id response) {
        LFLog(@"提交订单信息：%@",response);
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        [self.payInfo removeAllObjects];
        if ([str isEqualToString:@"1"]) {
            [self.payInfo addObject:response[@"data"]];
            if ([self.payDict[@"is_cod"] isEqualToString:@"1"]) {//货到付款
                [self presentLoadingTips:@"订单已生成"];
                [self performSelector:@selector(goBlack) withObject:nil afterDelay:2.0];
            }else if ([self.payDict[@"pay_code"] isEqualToString:@"balance"]) {//余额支付
                [self presentLoadingTips:@"订单已生成"];
                [self performSelector:@selector(goBlack) withObject:nil afterDelay:2.0];
            }else{
                [self createOrder];
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self UploadDatagoodsOderSubmit];
                    }
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        LFLog(@"error:%@",error);
    }];
    
    
}
//返回购物车
-(void)goBlack{
    [self.navigationController popViewControllerAnimated:YES];
}
//生成订单
-(void)createOrder{
    
    UIAlertController *alertcontro = [UIAlertController alertControllerWithTitle:@"提示" message:@"订单已生成，是否去支付" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self goBlack];
        NSLog(@"取消了");
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.payInfo) {
            NSDictionary *dt = self.payInfo[0];
            LFLog(@"支付信息：%@",dt);
            NSString * pay_code = [NSString string];
            if ([dt[@"pay_code"]  isEqualToString:@"alipay"]) {
                pay_code = @"支付宝支付";
            }else if ([dt[@"pay_code"]  isEqualToString:@"wxpay"]) {
                pay_code = @"微信支付支付";
            }
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:pay_code otherButtonTitles:nil, nil];
            [sheet showInView:self.view];
        }
        
    }];
    [alertcontro addAction:action];
    [alertcontro addAction:okAction];
    
    [self presentViewController:alertcontro animated:YES completion:nil];
    
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1){
        [self goBlack];
        return;
    };
    //    //向服务器发送订单信息
    //    [self upToOrderinformation];
    NSDictionary *dt = self.payInfo[0];
    NSString * pay_code = dt[@"pay_code"];
    if ([pay_code  isEqualToString:@"alipay"]) {
        ServiceAlipay_Order *alipay = [ServiceAlipay_Order sharedServiceAlipay_Order];
        alipay.orderStr = dt[@"alipayinfo"];
        [alipay setPayResults:^(NSInteger state) {
            LFLog(@"支付宝支付结果%ld",(long)state);//0 成功
            [self goTolist:state];
        }];
        [alipay generate];
    }else if ([pay_code  isEqualToString:@"wxpay"]) {
        if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机未安装微信,请选择其他支付方式" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        NSDictionary *wxdict = self.payInfo[0][@"wxpayinfo"];
        LFLog(@"wxdict:%@",wxdict);
        [WXApiRequestHandler jumpToBizPay:wxdict];
        [[WXApiManager sharedManager] setPayResults:^(NSInteger state) {
            LFLog(@"微信支付结果：%ld",(long)state);//0 成功
            [self goTolist:state];
        }];
        
        
    }

    
}
-(void)goTolist:(NSInteger )state{
    ShopNoPaymentViewController *pay = [[ShopNoPaymentViewController alloc]init];
    if (state == 0) {
        pay.selecIndex = 1;
        pay.titlename = @"待发货";
        
    }else{
        pay.selecIndex = 0;
        pay.titlename = @"待付款";
    }
    [self.navigationController pushViewController:pay animated:YES];
}


-(void)updateTableview{
    double price = 0;
    LFLog(@"payDict:%@",self.payDict);
    LFLog(@"expressDict:%@",self.expressDict);
    LFLog(@"shopmoney:%@",self.shopmoney);
    if (self.payDict) {
        price += [self.payDict[@"pay_fee"]  doubleValue];
    }
    if (self.expressDict) {
        price += [self.expressDict[@"shipping_fee"] doubleValue];
    }
    if (self.couponDict) {
        price -= [self.couponDict[@"type_money"] doubleValue];
    }
    
    price += [[self.shopmoney stringByReplacingOccurrencesOfString:@"￥" withString:@""] doubleValue];
    CGFloat scale = [self.dataArray[0][@"integral_scale"] floatValue];//积分抵消比例
    if (scale > 0) {
        CGFloat Intergral = [tfIntegral.text floatValue];
        LFLog(@"Intergral:%f",Intergral * scale);
        price -= Intergral * scale;
    }
    
    self.totalLabel.text = [NSString stringWithFormat:@"￥%.2f",(float)price];
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self UploadDatagoodsOderInfo:NO];
    }];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self UploadDatagoodsOderInfo:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}



@end
