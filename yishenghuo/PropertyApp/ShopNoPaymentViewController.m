//
//  ShopNoPaymentViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/11.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ShopNoPaymentViewController.h"
#import "ShopgoodsDecTableViewCell.h"
#import "ShopOrderDetailsViewController.h"
#import "WXApiRequestHandler.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "ShopEvaluateViewController.h"
#import "DoodsDetailsViewController.h"
#import "AFNetworking.h"
#import "ShopDoodsDetailsViewController.h"
@interface ShopNoPaymentViewController ()<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSArray * btnNameArr;
@property(nonatomic,strong)UIButton * selectBtn;
@property (strong,nonatomic)UIView *vline;
@property (assign,nonatomic)NSInteger page;
@property(nonatomic,strong)NSDictionary *orderDt;//付款订单
@property(nonatomic,strong)NSDictionary *paginatedDt;
@end

@implementation ShopNoPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.titlename) {
        self.navigationBarTitle = self.titlename;
    }else{
        self.navigationBarTitle = @"我的商城";
    }
    self.btnNameArr = @[@"待付款",@"待收货",@"待评价",@"全部订单"];
    self.page = 1;
    if (!self.selecIndex) {
        self.selecIndex = 0;
    }
    [self createTableview];
    if (!self.is_Integral) {
        [self createHeaderview];
    }
    [self setupRefresh];

}
-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
    
}
-(void)createHeaderview{
    self.vline =[[UIView alloc]initWithFrame:CGRectMake(5, 48, SCREEN.size.width/4 - 20, 2)];
    self.vline.backgroundColor = JHshopMainColor;
    self.vline.center = CGPointMake(SCREEN.size.width/4 *(self.selecIndex)  + SCREEN.size.width/8, 48);
    UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.size.width, 50)];
    headerview.backgroundColor = [UIColor whiteColor];
    [headerview addSubview:self.vline];
    [self.view addSubview:headerview];
    for (int i = 0; i < 4; i ++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * SCREEN.size.width/4, 0, SCREEN.size.width/4, 50)];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button setTitle:self.btnNameArr[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:JHColor(51, 51, 51) forState:UIControlStateNormal];
        [button setTitleColor:JHshopMainColor forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(OrderlistClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 30 + i;
        if (i == self.selecIndex) {
            button.selected = YES;
            self.selectBtn = button;
        }else{
            
            
        }
        
        [headerview addSubview:button];
        
    }
    
    
}
-(void)OrderlistClick:(UIButton *)btn{
    if (self.selectBtn.tag == btn.tag) {
        self.selectBtn.selected = YES;
        
        
    }else{
        
        self.selectBtn.selected = NO;
        self.selectBtn = btn;
        btn.selected = YES;
        
    }
    self.vline.center = CGPointMake(SCREEN.size.width/4 *(btn.tag  - 30)  + SCREEN.size.width/8, 48);
    self.page = 1;
    [self UploadDatagoodsOderInfo:1];
//    [self.tableview.mj_header beginRefreshing];
}

-(void)createTableview{
    
    //    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, SCREEN.size.width, SCREEN.size.height)];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, self.is_Integral ? 64:114, SCREEN.size.width, SCREEN.size.height - (self.is_Integral ? 64:114)) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [UIView new];
    self.tableview.separatorColor = JHColor(244, 244, 244);
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"confirmCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"ShopgoodsDecTableViewCell" bundle:nil] forCellReuseIdentifier:@"orderShopgoodsDecTableViewCell"];
    
    [self.view addSubview:self.tableview];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count) {
        return self.dataArray.count;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count) {
        if (!self.is_Integral) {
            if (self.selectBtn.tag != 32) {
                NSArray *arr = self.dataArray[section][@"goods_list"];
                return arr.count;
            }
        }
        return 1;

    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count) {
        return 100;
    }
    return SCREEN.size.height - 114;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count){
        if (self.selectBtn.tag != 32) {
            return 40;
        }
    }

    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.dataArray.count) {
        if (!self.is_Integral) {
            if (self.selectBtn.tag != 32) {
                if (self.selectBtn.tag == 33) {
                    return 60;
                }
                return 110;
            }
            return 10;
        }
        return 60;
    }
    return 0.001;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (self.dataArray.count) {
        ShopgoodsDecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderShopgoodsDecTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.is_Integral) {
//            cell.rightImage.hidden = NO;
            cell.parameterHeight.constant = 50;
            cell.parameterLb.numberOfLines = 0;
            cell.appraiseBtn.hidden = YES;
            cell.numLabe.font = [UIFont systemFontOfSize:15];
            cell.numLabe.textColor = JHdeepColor;
            cell.goodsName.font = [UIFont systemFontOfSize:13];
            cell.goodsName.textColor = JHmiddleColor;
            cell.goodsName.text = self.dataArray[indexPath.section][@"goods_type"];
            cell.parameterLb.text = self.dataArray[indexPath.section][@"goods_name"];
            [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.section][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
//            cell.parameterLbRight.constant = 100;
        }else{
            if (self.selectBtn.tag != 32) {
                cell.appraiseBtn.hidden = YES;
                if (![self.dataArray[indexPath.section][@"goods_list"]isKindOfClass:[NSString class]]) {
                    NSArray *goodslist = self.dataArray[indexPath.section][@"goods_list"];
                    cell.goodsName.text = goodslist[indexPath.row][@"name"];
                    cell.numLabe.text = [NSString stringWithFormat:@"×%@",goodslist[indexPath.row][@"goods_number"]];
                    cell.priceLabel.text = [NSString stringWithFormat:@"%@",goodslist[indexPath.row][@"subtotal"]];
                    cell.priceLbWidth.constant = [cell.priceLabel.text selfadapUifont:[UIFont fontWithName:@"Helvetica-Bold" size:14] weith:14].width + 5;
                    cell.priceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14] ;
                    [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:goodslist[indexPath.row][@"img"][@"url"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                    NSArray *goods_attr = [NSArray array];
                    if ([goodslist[indexPath.row][@"goods_attr"] isKindOfClass:[NSArray class]]) {
                        goods_attr  = goodslist[indexPath.row][@"goods_attr"];
                    }
                    
                    NSMutableString *mstr = [NSMutableString string];
                    if (goods_attr.count) {
                        for (int i = 0; i < goods_attr.count; i ++) {
                            [mstr appendFormat:@"%@ ", goods_attr[i][@"value"]];
                        }
                    }
                    cell.parameterLb.text = mstr;
                    cell.parameterLbRight.constant = 100;
                }
            }else{
                cell.parameterLbRight.constant = 10;
                cell.appraiseBtn.hidden = NO;
                NSDictionary *dt = self.dataArray[indexPath.section];
                cell.goodsName.text = dt[@"goods_name"];
                cell.numLabe.text = [NSString stringWithFormat:@"×%@",self.dataArray[indexPath.section][@"number"]];;
                cell.priceLabel.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.section][@"price"]];
                cell.priceLbWidth.constant = [cell.priceLabel.text selfadapUifont:[UIFont fontWithName:@"Helvetica-Bold" size:14] weith:14].width + 5;
                cell.priceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14] ;
                [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.section][@"url"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                NSArray *goods_attr = [NSArray array];
                if ([dt[@"goods_attr"] isKindOfClass:[NSArray class]]) {
                    goods_attr = dt[@"goods_attr"];
                }
                NSMutableString *mstr = [NSMutableString string];
                if (goods_attr.count) {
                    for (int i = 0; i < goods_attr.count; i ++) {
                        [mstr appendFormat:@"%@ ", goods_attr[i][@"value"]];
                    }
                }
                cell.parameterLb.text = mstr;
                [cell setBlock:^(NSString *str) {
                    ShopEvaluateViewController *eva = [[ShopEvaluateViewController alloc]init];
                    
                    eva.imageurl = self.dataArray[indexPath.section][@"url"];
                    eva.goods_id = self.dataArray[indexPath.section][@"goods_id"];
                    eva.order_id = self.dataArray[indexPath.section][@"order_id"];
                    [self.navigationController pushViewController:eva animated:YES];
                }];
            }

        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"confirmCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView removeAllSubviews];
        UIImageView *plImview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuneirong"]];
        [cell.contentView addSubview:plImview];
        [plImview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(20);
            make.centerX.equalTo(cell.contentView.mas_centerX);
        }];
        return cell;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.dataArray.count) {
        
        if (self.selectBtn.tag != 32) {
            UIView *headerview = [[UIView alloc]init];
            headerview.backgroundColor = JHbgColor;
            
            UIView *vbview = [[UIView alloc]init];
            vbview.backgroundColor = [UIColor whiteColor];
            [headerview addSubview:vbview];
            [vbview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
                make.top.offset(0);
                make.right.offset(0);
                make.bottom.offset(-1);
            }];
            UILabel *label = [[UILabel alloc]init];
            label.backgroundColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = JHmiddleColor;
            label.text = [NSString stringWithFormat:@"订单号：%@",self.dataArray[section][@"order_sn"]];
            [vbview addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.top.offset(0);
                make.right.offset(0);
                make.bottom.offset(0);
            }];
            if (self.is_Integral) {
                UILabel *statusLb = [[UILabel alloc]init];
                statusLb.backgroundColor = [UIColor whiteColor];
                statusLb.font = [UIFont systemFontOfSize:15];
                statusLb.textColor = JHAssistColor;
                statusLb.textAlignment = NSTextAlignmentRight;
                statusLb.text = [NSString stringWithFormat:@"%@",self.dataArray[section][@"order_status"]];
                [vbview addSubview:statusLb];
                [statusLb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(label.mas_right).offset(0);
                    make.top.offset(0);
                    make.right.offset(-10);
                    make.bottom.offset(0);
                }];
            }
            return headerview;
        }
        return nil;
    }
    return nil;

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.dataArray.count) {
        
        if (self.selectBtn.tag != 32) {

            UIView *view = [[UIView alloc]init];
            view.backgroundColor = JHColor(229, 229, 229);
            
            UIView *lbview = [[UIView alloc]initWithFrame:CGRectMake(0, 1, SCREEN.size.width, 49)];
            lbview.backgroundColor= [UIColor whiteColor];
            [view addSubview:lbview];
            UILabel *timalabel =[[UILabel alloc]init];
            timalabel.font = [UIFont systemFontOfSize:13];
            if (!self.is_Integral) {
                timalabel.textColor = JHColor(102, 102, 102);
                timalabel.text = self.dataArray[section][@"reserve_time"];
            }else{
                timalabel.textColor = JHdeepColor;
                NSString *integral = [NSString stringWithFormat:@"%@",self.dataArray[section][@"integral"]];
                NSString *integralAtt = [NSString stringWithFormat:@"共%@件商品，实付: %@ 积分",self.dataArray[section][@"goods_number"],integral];
                timalabel.attributedText = [integralAtt AttributedString:integral backColor:nil uicolor:JHAssistColor uifont:nil];
            }
            [lbview addSubview:timalabel];
            [timalabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.top.offset(0);
                make.height.offset(49);
                make.width.offset([timalabel.text selfadaption:13].width + 10);
            }];
             if (!self.is_Integral) {
                 UILabel *pricelabel =[[UILabel alloc]init];
                 pricelabel.textColor = JHColor(51, 51, 51);
                 NSArray *arr = self.dataArray[section][@"goods_list"];
                 NSString *str = [NSString stringWithFormat:@"共%d件 应付总额：%@",(int)arr.count,self.dataArray[section][@"total_fee"]];
                 pricelabel.attributedText =[str AttributedString:self.dataArray[section][@"total_fee"] backColor:nil uicolor:[UIColor redColor] uifont:[UIFont systemFontOfSize:15]];
                 pricelabel.font = [UIFont systemFontOfSize:14];
                 pricelabel.textAlignment = NSTextAlignmentRight;
                 pricelabel.numberOfLines = 0;
                 [lbview addSubview:pricelabel];
                 [pricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.right.offset(-10);
                     make.top.offset(0);
                     make.height.offset(49);
                     make.left.equalTo(timalabel.mas_right).offset(0);
                 }];
                 if (self.selectBtn.tag != 33) {
                     NSArray *namearr = [NSArray array];
                     if (self.selectBtn.tag == 30) {
                         namearr = @[@"quxiaodingdan",@"lijifukuan"];
                     }else if (self.selectBtn.tag == 31) {
                         namearr = @[@"查看物流",@"querenshouhuo"];
                     }else if (self.selectBtn.tag == 33) {
                         //                namearr = @[@"查看物流",@"评价"];
                     }
                     
                     UIView *btnview = [[UIView alloc]initWithFrame:CGRectMake(0, 51, SCREEN.size.width, 49)];
                     btnview.backgroundColor= [UIColor whiteColor];
                     [view addSubview:btnview];
                     for (int i = 0; i < 2; i ++) {
                         if (self.selectBtn.tag == 31) {
                             if (i == 0) {
                                 continue;
                             }
                             
                         }
                         UIButton *button = [[UIButton alloc]init];
                         button.tag = 1000 + section * 2 + i;
                         [button setImage:[UIImage imageNamed:namearr[i]] forState:UIControlStateNormal];
                         //                button.layer.borderWidth = 1;
                         CGFloat right = 15;
                         if (i == 0) {
                             //                    [button setTitleColor:JHColor(51, 51, 51) forState:UIControlStateNormal];
                             //                    button.layer.borderColor = [JHColor(229, 229, 229) CGColor];
                             right = button.imageView.image.size.width + 30;
                         }else{
                             //                    [button setTitleColor:JHshopMainColor forState:UIControlStateNormal];
                             //                    button.layer.borderColor = [JHshopMainColor CGColor];
                             
                         }
                         //                button.layer.cornerRadius = 3;
                         //                button.layer.masksToBounds =YES;
                         //                button.titleLabel.font = [UIFont systemFontOfSize:15];
                         //                [button setTitle:namearr[i] forState:UIControlStateNormal];
                         [btnview addSubview:button];
                         [button mas_makeConstraints:^(MASConstraintMaker *make) {
                             make.centerY.equalTo(btnview.mas_centerY);
                             make.width.offset(button.imageView.image.size.width);
                             make.height.offset(button.imageView.image.size.height);
                             make.right.offset(-right);
                             
                         }];
                         [button addTarget:self action:@selector(orderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                     }
                     
                     
                 }
                 
                 UIImageView *imaggeview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fengexiantongyong"]];
                 [view addSubview:imaggeview];
                 [imaggeview mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.right.offset(0);
                     make.left.offset(0);
                     make.bottom.offset(0);
                     make.height.offset(10);
                 }];
             }
            
        return view;
            
        }else{
            return nil;
        }
    }else{
        return nil;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count) {
        if (self.selectBtn.tag == 32) {
            ShopDoodsDetailsViewController *good = [[ShopDoodsDetailsViewController alloc]init];
            if (self.selectBtn.tag != 32) {
                NSArray *goodslist = self.dataArray[indexPath.section][@"goods_list"];
                good.goods_id = goodslist[indexPath.row][@"goods_id"];
            }else{
                good.goods_id = self.dataArray[indexPath.section][@"goods_id"];
            }
            
            [self.navigationController pushViewController:good animated:YES];

        }else{
            ShopOrderDetailsViewController *good = [[ShopOrderDetailsViewController alloc]init];
            good.orderid = self.dataArray[indexPath.section][@"order_id"];
            if (self.is_Integral) {
                good.is_Integral = self.is_Integral;
            }
            [self.navigationController pushViewController:good animated:YES];
        }
        

    }

}
-(void)orderBtnClick:(UIButton *)btn{
    if (self.selectBtn.tag == 30) {
        if ((btn.tag % 2) == 0) {
            [self alertController:@"提示" prompt:@"取消订单" sure:@"取消" cancel:@"不取消" success:^{
                [self UploadDatagoodsOderCancel:self.dataArray[(btn.tag - 1000)/2][@"order_id"]];
            } failure:^{
                
            }];
            
        }else{
            ShopOrderDetailsViewController *good = [[ShopOrderDetailsViewController alloc]init];
            good.orderid = self.dataArray[(btn.tag - 1001)/2][@"order_id"];
            
            [self.navigationController pushViewController:good animated:YES];
//            [self createOrder:self.dataArray[(btn.tag - 1001)/2]];
            
        }
    }else if (self.selectBtn.tag == 31) {
        if ((btn.tag % 2) == 0) {
            
        }else{
            ShopOrderDetailsViewController *good = [[ShopOrderDetailsViewController alloc]init];
            good.orderid = self.dataArray[(btn.tag - 1001)/2][@"order_id"];
            
            [self.navigationController pushViewController:good animated:YES];
//            [self UploadDatagoodsOderAffirm:self.dataArray[(btn.tag - 1001)/2][@"order_id"]];
            
        }
        
    }else if (self.selectBtn.tag == 33) {
        
    }
    
}
-(NSMutableAttributedString *)AttributedString:(NSString *)allstr attstring:(NSString *)attstring{
    NSMutableAttributedString* htinstr = [[NSMutableAttributedString alloc]initWithString:allstr];
    if (attstring.length > 0) {
        NSRange range =[[htinstr string]rangeOfString:attstring];
        //    [htinstr addAttribute:NSForegroundColorAttributeName value:JHColor(102, 102, 102) range:range];
        [htinstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:range];
    }

    return htinstr;
    
}

#pragma mark 支付
-(void)createOrder:(NSDictionary *)orderDict{
    
    UIAlertController *alertcontro = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否支付" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"取消了");
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.orderDt = orderDict;
        if (orderDict) {
            LFLog(@"支付信息：%@",orderDict);
            LFLog(@"支付信息：%@",orderDict[@"pay_code"]);
            NSString * pay_code = [NSString string];
            if ([orderDict[@"order_info"][@"pay_code"] isEqualToString:@"alipay"]) {
                pay_code = @"支付宝支付";
            }else if ([orderDict[@"order_info"][@"pay_code"]  isEqualToString:@"wxpay"]) {
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
        
        return;
    };
    
    NSDictionary *dt = self.orderDt[@"order_info"];
    NSString * pay_code = dt[@"pay_code"];
    if ([pay_code  isEqualToString:@"alipay"]) {
        ServiceAlipay_Order *alipay = [[ServiceAlipay_Order alloc]init];
        alipay.tradeNO = dt[@"order_sn"];
        alipay.productName = dt[@"subject"];
        alipay.desc = dt[@"desc"];
        alipay.price = dt[@"order_amount"];
        [alipay setPayResults:^(NSInteger state) {
            LFLog(@"支付宝支付结果%ld",(long)state);//0 成功
            if (state == 0) {
                [self UploadDatagoodsOderInfo:0];
            }
        }];
        [alipay generate];
        
    }else if ([pay_code  isEqualToString:@"wxpay"]) {
        //        if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])) {
        //
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机未安装微信,请选择其他支付方式" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //            [alert show];
        //            return;
        //        }
        //        NSString *status = [NSString stringWithFormat:@"%@",self.payInfo[0][@"wxpayinfo"][@"status"]];
        //        if ([status isEqualToString:@"1"]) {
        //            NSDictionary *wxdict = self.payInfo[0][@"wxpayinfo"][@"data"];
        //            [WXApiRequestHandler jumpToBizPay:wxdict];
        //            [[WXApiManager sharedManager] setPayResults:^(NSInteger state) {
        //                LFLog(@"微信支付结果：%ld",(long)state);//0 成功
        //            }];
        //        }else{
        //
        //        }
        //
    }
    
    
    
    
    
}

#pragma mark - *************商品订单列表请求*************
-(void)UploadDatagoodsOderInfo:(NSInteger)pagenum{

    [self presentLoadingTips];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr.operationQueue cancelAllOperations];//取消所有的数据请求
    if (pagenum== 1) {
        [self.dataArray removeAllObjects];
        self.paginatedDt = nil;
    }
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    switch (self.selectBtn.tag) {
        case 30:{
            
            self.urlstr = await_payUrl;
        }
            break;
        case 31:{
            
            self.urlstr = shippedUrl;
        }
            break;
        case 32:{
            
            self.urlstr = appraiseUrl;
        }
            break;
        case 33:{
            
            self.urlstr = OrderfinishedUrl;
        }
            break;
            
        default:
            break;
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    NSString *url = [NSString string];
    if (self.selectBtn.tag != 32) {
        if (self.is_Integral) {
            url = ShopIntegraOrderListUrl;
        }else{
            url = OrderListUrl;
        }
        if (self.urlstr) {
            [dt setObject:self.urlstr forKey:@"type"];
        }
    }else{
        url = appraiseUrl;
    }

    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    NSDictionary *pagination = @{@"count":@"5",@"page":page};
    [dt setObject:pagination forKey:@"pagination"];
    LFLog(@"dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,url) params:dt success:^(id response) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [self dismissTips];
        LFLog(@"订单列表：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {

            NSArray *arr = response[@"data"];
            for (NSDictionary *dt in arr) {
                [self.dataArray addObject:dt];
            }
            self.paginatedDt = response[@"paginated"];
            if (pagenum > 1) {
                if (arr.count == 0) {
                    [self presentLoadingTips:@"没有更多数据了"];
                }
            }
           
            
            //
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@""]) {
                        [self UploadDatagoodsOderInfo:self.page];
                    }
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        LFLog(@"dataArray:%@",self.dataArray);
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        [self dismissTips];
        [self.tableview reloadData];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        
    }];
    
    
}
#pragma mark - *************取消商品订单请求*************
-(void)UploadDatagoodsOderCancel:(NSString *)orderid{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:orderid,@"order_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,OrderCancelUrl) params:dt success:^(id response) {
        [self.tableview.mj_header endRefreshing];
        LFLog(@"取消商品订单：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"您已成功取消订单"];
            [self UploadDatagoodsOderInfo:1];
            //            [self performSelector:@selector(goBlack) withObject:nil afterDelay:2.0];
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
#pragma mark - *************确认商品订单请求*************
-(void)UploadDatagoodsOderAffirm:(NSString *)orderid{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:orderid,@"order_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,OrderAffirmUrl) params:dt success:^(id response) {
        [self.tableview.mj_header endRefreshing];
        LFLog(@"确认商品订单：%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"您已成功确认订单"];
            [self UploadDatagoodsOderInfo:1];
            //            [self performSelector:@selector(goBlack) withObject:nil afterDelay:2.0];
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
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self UploadDatagoodsOderInfo:1];
        
    }];
    
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.paginatedDt) {
            NSString *str = [NSString stringWithFormat:@"%@",self.paginatedDt[@"more"]];
            if ( [str isEqualToString:@"0"]) {
                [self presentLoadingTips:@"没有更多数据了"];
                [self.tableview.mj_footer endRefreshing];
            }else{
                self.page ++;
                [self UploadDatagoodsOderInfo:self.page];
                
            }
        }else{
            [self presentLoadingTips:@"没有更多数据了"];
            [self.tableview.mj_footer endRefreshing];
        }
    }] ;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self UploadDatagoodsOderInfo:1];
}

@end
