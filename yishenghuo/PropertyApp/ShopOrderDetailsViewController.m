//
//  ShopOrderDetailsViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/14.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ShopOrderDetailsViewController.h"
#import "ShopAddressTableViewCell.h"
#import "ShopgoodsDecTableViewCell.h"
#import "ShopOtherTableViewCell.h"
#import "DoodsDetailsViewController.h"
#import "WXApiRequestHandler.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "ShopDoodsDetailsViewController.h"
#import "JXTAlertManagerHeader.h"
#import "IntegralShopDetailViewController.h"
@interface ShopOrderDetailsViewController ()<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)UIView *footview;
@property(nonatomic,strong)UILabel *totalLabel;
@property(nonatomic,strong)NSString *shopmoney;//商品金额
@property(nonatomic,strong)NSMutableArray *payInfo;

@end

@implementation ShopOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"订单详情";
    [self createTableview];
    [self setupRefresh];
    [self UploadDatagoodsOderInfo];
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"quxiaodingdan"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarclick:)];
//    rightBtn.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

-(void)rightBarclick:(UIBarButtonItem *)barbtn{

    UIAlertController *alertcontro = [UIAlertController alertControllerWithTitle:@"提示" message:@"订单已生成，是否去查看" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消了");
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self UploadDatagoodsOderCancel];
        
    }];
    [alertcontro addAction:action];
    [alertcontro addAction:okAction];
    
    [self presentViewController:alertcontro animated:YES completion:nil];

}

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

-(void)creafootview{
    if (self.footview == nil) {
        self.footview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN.size.height - 60, SCREEN.size.width, 60)];
        self.footview.backgroundColor = JHColor(236, 236, 236);
        [self.view addSubview:self.footview];
        
        UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN.size.width - 110, 13, 100, 34)];
        NSString *title = [NSString string];
        if ([self.dataArray[0][@"status"] isEqualToString:@"1"]) {
            title = @"付款";
        }else if ([self.dataArray[0][@"status"] isEqualToString:@"2"]){
            title = @"确认收货";
        }
        [submitBtn setTitle:title forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
        [submitBtn setTitleColor:JHshopMainColor forState:UIControlStateNormal];
        submitBtn.layer.borderColor = [JHshopMainColor CGColor];
        submitBtn.layer.borderWidth  = 1;
        submitBtn.layer.cornerRadius = 3;
        submitBtn.layer.masksToBounds = YES;
        submitBtn.backgroundColor = JHColor(236, 236, 236);
        [self.footview addSubview:submitBtn];
    }

    
    

}
-(void)createTableview{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height ) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"confirmCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"ShopAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopAddressTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"ShopgoodsDecTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopgoodsDecTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"ShopOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopOtherTableViewCell"];
    [self.view addSubview:self.tableview];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count) {
        if (self.is_Integral) {
            return 3;
        }
        return 5;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 4;
    }
    if (section == 3) {
        return 4;
    }
    if (section == 1) {
        if (self.dataArray.count) {
            if (![self.dataArray[0][@"goods_list"]isKindOfClass:[NSString class]]) {
                NSArray *goodslist = self.dataArray[0][@"goods_list"];
                return goodslist.count;
            }
        }
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 85;
    }else if (indexPath.section == 1){
        
        return 100;
    }else if (indexPath.section == 3){
    
        return 35;
    }else if (indexPath.section == 2){
        if (self.is_Integral) {
            return 30;
        }else{
            if (indexPath.row == 0) {
                if (self.dataArray.count) {
                    if ([self.dataArray[0][@"status"] isEqualToString:@"1"]) {
                        return 0;
                    }
                }
                
            }
        }

    }

    return 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 50;
    }
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShopOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopOtherTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.MustImHeight.constant = 0;
    cell.rigthtIm.hidden = YES;
    NSArray * array = [[NSArray alloc]init];
    if (self.dataArray.count) {
         NSDictionary *dict = self.dataArray[0];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        if (indexPath.section == 0) {
                ShopAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopAddressTableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];

                cell.rightImage.hidden = YES;
                if (![dict[@"address"]isKindOfClass:[NSString class]]) {
                    NSDictionary *dt = dict[@"address"];
                    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",dt[@"consignee"],dt[@"mobile"]];
                    cell.addLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",dt[@"country"],dt[@"province"],dt[@"city"],dt[@"address"]];
                        
                }
     
                cell.bottomImage.hidden = YES;
                [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN.size.width, 0, 0)];
                [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN.size.width, 0, 0)];
                return cell;

        }else if (indexPath.section == 1){
            ShopgoodsDecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopgoodsDecTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (![dict[@"goods_list"]isKindOfClass:[NSString class]]) {
                NSArray *goodslist = dict[@"goods_list"];
                if (self.is_Integral) {
                    cell.appraiseBtn.hidden = NO;
                    cell.appraiseBtn.layer.borderWidth = 0;
                    cell.numLabe.font = [UIFont systemFontOfSize:15];
                    cell.numLabe.textColor = JHdeepColor;
                    cell.goodsName.font = [UIFont systemFontOfSize:13];
                    cell.goodsName.textColor = JHmiddleColor;
                    cell.goodsName.text = goodslist[indexPath.row][@"goods_type"];
                    cell.numLabe.text = goodslist[indexPath.row][@"goods_name"];
                    [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:goodslist[indexPath.row][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                    NSString *integralStr = [NSString stringWithFormat:@"%@ 积分",goodslist[indexPath.row][@"integral"]];
                    cell.parameterLb.textColor = JHdeepColor;
                    cell.parameterLb.attributedText = [integralStr AttributedString:@"积分" backColor:nil uicolor:JHmiddleColor uifont:nil];
                    [cell.appraiseBtn setImage:nil forState:UIControlStateNormal];
                    [cell.appraiseBtn setTitle:[NSString stringWithFormat:@"*%@",goodslist[indexPath.row][@"goods_number"]] forState:UIControlStateNormal];
                    [cell.appraiseBtn setTitleColor:JHmiddleColor forState:UIControlStateNormal];
                    cell.appraiseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                }else{
                    cell.goodsName.text = goodslist[indexPath.row][@"name"];
                    cell.numLabe.text = [NSString stringWithFormat:@"×%@",goodslist[indexPath.row ][@"goods_number"]];
                    cell.priceLabel.text = [NSString stringWithFormat:@"%@",goodslist[indexPath.row ][@"subtotal"]];
                    cell.priceLbWidth.constant = [cell.priceLabel.text selfadapUifont:[UIFont fontWithName:@"Helvetica-Bold" size:14] weith:14].width + 5;
                    cell.priceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14] ;
                    [cell.goodsImage sd_setImageWithURL:goodslist[indexPath.row][@"img"][@"url"] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                    NSArray *goods_attr = [NSArray array];
                    if ([goodslist[indexPath.row][@"goods_attr"] isKindOfClass:[NSArray class]]) {
                        goods_attr = goodslist[indexPath.row][@"goods_attr"];
                    }
                    NSMutableString *mstr = [NSMutableString string];
                    if (goods_attr.count) {
                        for (int i = 0; i < goods_attr.count; i ++) {
                            [mstr appendFormat:@"%@ ", goods_attr[i][@"value"]];
                        }
                    }
                    cell.parameterLb.text = mstr;
                }

            }
            [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN.size.width, 0, 0)];
            [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN.size.width, 0, 0)];
            return cell;

        
        }else if (indexPath.section == 2){
            if (self.is_Integral) {
                if (indexPath.row == 0) {
                    cell.nameLabel.text = [NSString stringWithFormat:@"实付：%@积分",dict[@"integral"]];
                }else if (indexPath.row == 1){
                    cell.nameLabel.text = [NSString stringWithFormat:@"运费：%@￥",dict[@"shipping_fee"]];
                }else if (indexPath.row == 2){
                    cell.nameLabel.text = [NSString stringWithFormat:@"订单时间：%@",dict[@"add_time"]];
                }
                [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN.size.width, 0, 0)];
                [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN.size.width, 0, 0)];
            }else{
                array = @[@"支付方式",@"配送方式",@"订单状态",@"留言"];
                cell.nameLabel.text = array[indexPath.row];
                cell.contentLb.textColor = JHColor(151, 151, 151);
                
                if (indexPath.row == 0) {
                    if (![dict[@"status"] isEqualToString:@"1"]) {
                        cell.contentLb.text = dict[@"pay_name"];
                    }else{
                        cell.nameLabel.text = nil;
                        cell.contentLb.text = nil;
                        
                    }
                    
                    
                }else if (indexPath.row == 1){
                    
                    cell.contentLb.text = dict[@"shipping_name"];
                    
                }else if (indexPath.row == 2){
                    
                    cell.contentLb.text = dict[@"status_name"];
                    
                }else if (indexPath.row == 3){
                    
                    cell.contentLb.text = dict[@"pay_note"];
                    
                }
            }
        }else if (indexPath.section == 3){
            array = @[@"商品金额",@"优惠券抵扣金额",@"积分抵扣金额",@"运费"];
            cell.nameLabel.text = array[indexPath.row];
            cell.MustImHeight.constant = 0;
            cell.contentLb.textColor = JHshopMainColor;
            cell.contentLb.text = nil;
            if (indexPath.row == 0) {
                cell.contentLb.text = dict[@"goods_amount"];
            }else if (indexPath.row == 1) {
                cell.contentLb.text = dict[@"bonus_amount"];
            }else if (indexPath.row == 2) {
                cell.contentLb.text = dict[@"formated_integral_fee"];
            }else if (indexPath.row == 3) {
                cell.contentLb.text = dict[@"formated_shipping_fee"];
            }
            [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN.size.width, 0, 0)];
            [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN.size.width, 0, 0)];
            
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"confirmCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView removeAllSubviews];
  
            UILabel *lb = [[UILabel alloc]init];
            [cell.contentView addSubview:lb];
            lb.textAlignment = NSTextAlignmentRight;
            lb.textColor = JHdeepColor;
            NSString *price = [NSString stringWithFormat:@"实付款：%@",dict[@"order_amount"]];
            lb.font = [UIFont systemFontOfSize:14];
            lb.attributedText = [price AttributedString:dict[@"order_amount"] backColor:nil uicolor:JHshopMainColor uifont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.right.offset(-10);
                make.height.offset(30);
                
            }];
            
            UILabel *timelb = [[UILabel alloc]init];
            [cell.contentView addSubview:timelb];
            timelb.textColor = JHmiddleColor;
            timelb.textAlignment = NSTextAlignmentRight;
            timelb.text = [NSString stringWithFormat:@"下单时间：%@",dict[@"reserve_time"]];
            timelb.font = [UIFont systemFontOfSize:12];
            [timelb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.right.offset(-10);
                make.top.equalTo(lb.mas_bottom);
                
            }];

            
            

            return cell;
        }
        
        CGSize namesize = [cell.nameLabel.text selfadaption:15];
        cell.nameHeight.constant = namesize.width + 5;
        
    }
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIImageView *view = [[UIImageView alloc]init];
    view.image = [UIImage imageNamed:@"fengexiantongyong"];
    
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (self.dataArray.count) {
            if (self.is_Integral) {
                IntegralShopDetailViewController *good = [[IntegralShopDetailViewController alloc]init];
                good.goods_id = self.dataArray[0][@"goods_id"];
                [self.navigationController pushViewController:good animated:YES];
            }else{
                ShopDoodsDetailsViewController *good = [[ShopDoodsDetailsViewController alloc]init];
                good.goods_id = self.dataArray[0][@"goods_id"];
                [self.navigationController pushViewController:good animated:YES];
            }
        }
    }


}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.dataArray.count) {
            UIView *header = [[UIView alloc]init];
            header.backgroundColor = [UIColor whiteColor];
            UILabel *lb = [[UILabel alloc]init];
            lb.font = [UIFont systemFontOfSize:15];
            lb.textColor = JHdeepColor;
            
            lb.text = [NSString stringWithFormat:@"订单号：%@",self.dataArray[0][@"order_sn"]];
            [header addSubview:lb];
            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.width.offset([lb.text selfadap:15 weith:20].width + 10);
                make.top.offset(0);
                make.bottom.offset(1);
            }];
            if (self.is_Integral) {
                UILabel *statusLb = [[UILabel alloc]init];
                statusLb.backgroundColor = [UIColor whiteColor];
                statusLb.font = [UIFont systemFontOfSize:15];
                statusLb.textColor = JHAssistColor;
                statusLb.textAlignment = NSTextAlignmentRight;
                
                statusLb.text = [NSString stringWithFormat:@"%@",self.dataArray[0][@"order_status"]];
                [header addSubview:statusLb];
                [statusLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lb.mas_right).offset(0);
                    make.top.offset(0);
                    make.right.offset(-10);
                    make.bottom.offset(0);
                }];
            }
            UIView *vline = [[UIView alloc]init];
            vline.backgroundColor = JHbgColor;
            [header addSubview:vline];
            [vline mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
                make.right.offset(0);
                make.height.offset(1);
                make.bottom.offset(0);
            }];
            return header;
        }
        
    }
    return nil;
}

-(void)submitClick:(UIButton *)btn{

    if ([self.dataArray[0][@"status"] isEqualToString:@"1"]) {
        if (![self.dataArray[0][@"payment_list"] isKindOfClass:[NSArray class]]) {
            [self presentLoadingTips:@"支付方式有误！请联系相关人员"];
            return;
        }
        NSArray *payArr = self.dataArray[0][@"payment_list"];
        
        [self jxt_showActionSheetWithTitle:@"请选择" message:@"" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.
            addActionCancelTitle(@"取消");
            for (int i = 0 ; i < payArr.count; i ++) {
                alertMaker.
                addActionDefaultTitle(payArr[i][@"pay_name"]);
            }
            
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            
            if ([action.title isEqualToString:@"取消"]) {
                NSLog(@"取消");
            }
            for (int i = 0 ; i < payArr.count; i ++) {
                if ([action.title isEqualToString:payArr[i][@"pay_name"]]) {
                    if ([payArr[i][@"pay_code"] isEqualToString:@"alipay"]) {
                        [self UploadDatagoodsOderPayOrRequer:OrderPayUrl paytype:@"alipay"];
                    }else if ([payArr[i][@"pay_code"] isEqualToString:@"wxpay"]) {
                        [self UploadDatagoodsOderPayOrRequer:OrderPayUrl paytype:@"wxpay"];
                    }else if ([payArr[i][@"pay_code"] isEqualToString:@"balance"]) {
                        [self UploadDatagoodsOderPayOrRequer:OrderPayUrl paytype:@"balance"];
                    }
                    
                }
            }
            
        }];
        

        
    }else if ([self.dataArray[0][@"status"] isEqualToString:@"2"]){
        if ([self.dataArray[0][@"shipping_status"] isEqualToString:@"0"]) {
            [self presentLoadingTips:@"亲！您的商品尚未发货呢，请耐心等待一下"];
            return;
        }
        [self UploadDatagoodsOderPayOrRequer:OrderAffirmUrl paytype:nil];
    }
}

#pragma mark - *************商品订单详情请求*************
-(void)UploadDatagoodsOderInfo{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.orderid,@"order_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSString *url = OrderDetailUrl;
    if (self.is_Integral) {
        url = ShopIntegraOrderDetailUrl;
    }
    LFLog(@"订单详情dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt success:^(id response) {
        [self.tableview.mj_header endRefreshing];
        LFLog(@"订单详情：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        [self.dataArray removeAllObjects];
        if ([str isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObject:response[@"data"]];
            if (![self.dataArray[0][@"goods_list"]isKindOfClass:[NSString class]]) {
                double price = 0.0;
                NSArray *goodslist = self.dataArray[0][@"goods_list"];
                for (NSDictionary *dt in goodslist) {
                    price += [[dt[@"subtotal"] stringByReplacingOccurrencesOfString:@"￥" withString:@""] doubleValue];
                }
                //                self.totalLabel.text = [NSString stringWithFormat:@"￥%ld",(long)price];
                self.shopmoney = [NSString stringWithFormat:@"￥%ld",(long)price];
            }
            if (!self.is_Integral) {
                if (![self.dataArray[0][@"status"] isEqualToString:@"3"]) {
                    self.tableview.frame = CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height-60);
                    [self creafootview];
                }else{
                    [self.footview removeFromSuperview];
                    self.tableview.frame = CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height);
                    
                }
            }

            [self.tableview reloadData];
            
            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self UploadDatagoodsOderInfo];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
    }];
    
    
}
#pragma mark - *************商品付款/确认收货*************
-(void)UploadDatagoodsOderPayOrRequer:(NSString *)urlstr paytype:(NSString *)paytype{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.orderid,@"order_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    if (paytype) {
        [dt setObject:paytype forKey:@"pay_code"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,urlstr) params:dt success:^(id response) {
        [self.tableview.mj_header endRefreshing];
        LFLog(@"商品付款/确认收货：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {

            if ([urlstr isEqualToString:OrderPayUrl]) {
                if ([paytype isEqualToString:@"alipay"]) {
                    ServiceAlipay_Order *alipay = [[ServiceAlipay_Order alloc]init];
                    alipay.orderStr = response[@"data"][@"alipayinfo"];
                    [alipay setPayResults:^(NSInteger state) {
                        [self UploadDatagoodsOderInfo];
                    }];
                    [alipay generate];
                }else if([paytype isEqualToString:@"wxpay"]){
                    if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])) {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机未安装微信,请选择其他支付方式" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                        return;
                    }
                    
                    NSDictionary *wxdict = response[@"data"][@"wxpayinfo"];
                    LFLog(@"wxdict:%@",wxdict);
                    [WXApiRequestHandler jumpToBizPay:wxdict];
                    [[WXApiManager sharedManager] setPayResults:^(NSInteger state) {
                        LFLog(@"微信支付结果：%ld",(long)state);//0 成功
                        [self UploadDatagoodsOderInfo];
                    }];
                    
                }else if([paytype isEqualToString:@"balance"]){
                    [self UploadDatagoodsOderInfo];
                }
                
            }else{
                [self presentLoadingTips:@"您已成功确认收货"];
                [self UploadDatagoodsOderInfo];
            }
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
    }];
    
    
}

#pragma mark - *************取消商品订单请求*************
-(void)UploadDatagoodsOderCancel{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.orderid,@"order_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,OrderCancelUrl) params:dt success:^(id response) {
        [self.tableview.mj_header endRefreshing];
        LFLog(@"取消商品订单：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
      
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"您已成功取消订单"];
            [self performSelector:@selector(goBlack) withObject:nil afterDelay:2.0];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
    } failure:^(NSError *error) {
        [self.tableview.mj_header endRefreshing];
    }];
    
    
}
-(void)goBlack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self UploadDatagoodsOderInfo];
    }];
    
    
}
@end

