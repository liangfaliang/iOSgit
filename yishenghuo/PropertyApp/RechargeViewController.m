//
//  RechargeViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/7/20.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "RechargeViewController.h"
#import "WXApiRequestHandler.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "ShopNoPaymentViewController.h"
#import "MyWalletViewController.h"
@interface RechargeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *priceBtnArr;
@property(nonatomic,strong)NSArray *priceArray;
@property(nonatomic,strong)NSArray *paymentArray;
@property(nonatomic,strong)NSDictionary *payDict;
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitle = @"充值";
    [self createTable];
    [self rotateData];
}
-(NSMutableArray *)priceBtnArr{

    if (_priceBtnArr == nil) {
        _priceBtnArr = [[NSMutableArray alloc]init];
    }
    return _priceBtnArr;
}

-(void)createTable{
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height ) style:UITableViewStyleGrouped] ;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"onecell"];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"twocell"];
    UIView *foootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 200)];

    UIButton *submitBtn = [[UIButton alloc]init];
    [submitBtn setImage:[UIImage imageNamed:@"tijiao_chongzhi"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [foootview addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(foootview.mas_centerY);
        make.centerX.equalTo(foootview.mas_centerX);
    }];
    self.tableview.tableFooterView = foootview;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.priceArray.count) {
            return 1;
        }
    }
    return self.paymentArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        if (self.priceArray.count) {
            return (self.priceArray.count/2 + self.priceArray.count%2) * 80;
        }
        return 0;
    }
    return 50;

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 50;
    }
    return 70;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headview = [[UIView alloc]init];
    headview.backgroundColor = [UIColor whiteColor];
    UILabel *lb = [[UILabel alloc]init];
    lb.textColor = JHdeepColor;
    lb.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    if (section == 0) {
        lb.text = @"充值金额";
    }else{
        lb.text = @"选择支付方式";
    }
    [headview addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.equalTo(headview.mas_centerY);
    }];
    return headview;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        //    NSDictionary *dt = self.dataArray[indexPath.row];
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"onecell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.priceArray.count) {
            for (int i = 0; i < self.priceArray.count; i ++) {
                UIButton *priceBtn = [cell viewWithTag:i + 500];
                if (priceBtn == nil) {
                    priceBtn = [[UIButton alloc]initWithFrame:CGRectMake( (i%2 == 0)? 10 : SCREEN.size.width/2 + 5 , (i/2) * 80, (SCREEN.size.width - 30)/2, 75)];
                    priceBtn.tag = i + 500;
                    
                    [priceBtn setBackgroundImage:[UIImage imageNamed:@"weixuanzhong_chongzhi"] forState:UIControlStateNormal];
                    [priceBtn setBackgroundImage:[UIImage imageNamed:@"chongzhijinexuanzhong"] forState:UIControlStateSelected];
                    priceBtn.titleLabel.numberOfLines = 0;
                    priceBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    NSString *integral = @"";
                    if ([[NSString stringWithFormat:@"%@",self.priceArray[i][@"integral"]] intValue] != 0) {
                        integral = [NSString stringWithFormat:@"赠%@积分",self.priceArray[i][@"integral"]];
                    }
                    NSString *Gift = @"";
                    if ([[NSString stringWithFormat:@"%@",self.priceArray[i][@"amount"]] intValue] != 0) {
                        Gift = [NSString stringWithFormat:@"送%@元",self.priceArray[i][@"amount"]];
                    }
                    NSString *price = nil;
                    if (integral.length == 0 && Gift.length == 0 ) {
                        price = [NSString stringWithFormat:@"充%@元",self.priceArray[i][@"price"]];
                    }else{
                        price = [NSString stringWithFormat:@"充%@元\n%@ %@",self.priceArray[i][@"price"],integral,Gift];
                        
                    }
                    
                    priceBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
                    [priceBtn setTitleColor:JHdeepColor forState:UIControlStateNormal];
                    [priceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                    [priceBtn setAttributedTitle:[self AttString:price attstring:[NSString stringWithFormat:@"%@ %@",integral,Gift] backColor:JHdeepColor uicolor:JHColor(239, 90, 61) uifont:[UIFont fontWithName:@"Helvetica-Bold" size:12] Linespace:10] forState:UIControlStateNormal];
                    [priceBtn setAttributedTitle:[self AttString:price attstring:[NSString stringWithFormat:@"%@ %@",integral,Gift] backColor:[UIColor whiteColor] uicolor:JHColor(239, 90, 61) uifont:[UIFont fontWithName:@"Helvetica-Bold" size:12] Linespace:10] forState:UIControlStateSelected];
                    [priceBtn addTarget:self action:@selector(priceBtnclick:) forControlEvents:UIControlEventTouchUpInside];
                     [priceBtn.titleLabel NSParagraphStyleAttributeName:10];
                    [cell.contentView addSubview:priceBtn];
                    if (i == 0) {
                        priceBtn.selected = YES;
                    }
                }
                
                
            }
        }
        return cell;
    }else{
        NSString *Identifier = [NSString stringWithFormat:@"twocell_%ld",(long)indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:Identifier];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *selectImage = [self.view viewWithTag:50 + indexPath.row];
        if (self.paymentArray.count) {
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.text = self.paymentArray[indexPath.row][@"pay_name"];
            cell.imageView.image = nil;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.paymentArray[indexPath.row][@"pay_logo"]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                cell.imageView.image = image;
                [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            
            if (selectImage == nil) {
                selectImage = [[UIImageView alloc]init];
                selectImage.tag = 50 + indexPath.row;
            }

            if ([self.payDict[@"pay_code"] isEqualToString:self.paymentArray[indexPath.row][@"pay_code"] ]) {
                selectImage.image = [UIImage imageNamed:@"xuanzhong_zhifu"];
            }else{
                selectImage.image = [UIImage imageNamed:@"weixuan_zhifu"];
            }
        }
        [cell.contentView addSubview:selectImage];
        [selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10);
            make.centerY.equalTo(cell.contentView.mas_centerY);
        }];
        return cell;
    }
        
  
}
-(NSMutableAttributedString *)AttString:(NSString *)allstring attstring:(NSString *)attstring backColor:(UIColor *)backColor uicolor:(UIColor *)color uifont:(UIFont *)font Linespace:(CGFloat)Linespace {
    NSMutableAttributedString* htinstr = [[NSMutableAttributedString alloc]initWithString:allstring];
    NSString *str = attstring;
    NSRange range =[[htinstr string]rangeOfString:str];
    if (backColor) {
        [htinstr addAttribute:NSForegroundColorAttributeName value:backColor range:[[htinstr string]rangeOfString:allstring]];
    }
    if (color) {
        [htinstr addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    if (font) {
        [htinstr addAttribute:NSFontAttributeName value:font range:range];
    }
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:Linespace];
    [htinstr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [allstring length])];
    
    return htinstr;
    
}
-(void)priceBtnclick:(UIButton *)btn{

    for (int i = 0; i < self.priceArray.count; i ++) {
        UIButton *otherBtn = [self.view viewWithTag:i + 500];
        if (btn != otherBtn) {
            otherBtn.selected = NO;
        }
    }
    btn.selected = YES;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        self.payDict = self.paymentArray[indexPath.row];
        [self.tableview reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
}
#pragma mark 提交按钮
-(void)submitBtnClick{

    if (self.priceArray.count) {
        [self submitData];
    }
}

#pragma mark 请求数据
-(void)rotateData{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSDictionary *dt = @{@"session":session};
    LFLog(@"请求数据dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,RechargeListUrl) params:dt success:^(id response) {
        LFLog(@"请求数据:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            self.priceArray = response[@"data"][@"price_list"];
            self.paymentArray = response[@"data"][@"payment_list"];
            if (self.paymentArray.count) {
                self.payDict = self.paymentArray[0];
            }
            [self.tableview reloadData];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self rotateData];
                    }
                    
                }];
            }
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
        
        
    } failure:^(NSError *error) {

    }];
    
}
#pragma mark 充值
-(void)submitData{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary *dt = [NSMutableDictionary dictionary];
    [dt setObject:session forKey:@"session"];
    for (int i = 0; i < self.priceArray.count; i ++) {
        UIButton *otherBtn = [self.view viewWithTag:i + 500];
        if (otherBtn.selected) {
            [dt setObject:self.priceArray[i][@"price"] forKey:@"price"];
        }
    }
    [dt setObject:self.payDict[@"pay_code"] forKey:@"pay_code"];

    LFLog(@"请求数据dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,RechargeOderUrl) params:dt success:^(id response) {
        LFLog(@"请求数据:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            NSDictionary *dt = response[@"data"];
            NSString * pay_code = dt[@"pay_code"];
            if ([pay_code  isEqualToString:@"alipay"]) {
                ServiceAlipay_Order *alipay = [[ServiceAlipay_Order alloc]init];
                alipay.orderStr = response[@"data"][@"alipayinfo"];
                [alipay setPayResults:^(NSInteger state) {
                    LFLog(@"支付宝支付结果%ld",(long)state);//0 成功
                    if (state == 0) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [self walletRefreshData];
                    }
                }];
                [alipay generate];
            }else if ([pay_code  isEqualToString:@"wxpay"]) {
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
                    if (state == 0) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [self walletRefreshData];
                        //                            [self.navigationController popViewControllerAnimated:YES];
                        //                            [self goBlack];
                    }
                }];
                
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
        
    }];
    
}
-(void)walletRefreshData{

    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[MyWalletViewController class]]) {
            MyWalletViewController *wallet = (MyWalletViewController *)vc;
            [wallet RefreshData];
        }
    }
}

@end
