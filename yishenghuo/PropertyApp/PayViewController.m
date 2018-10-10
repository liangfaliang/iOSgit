//
//  PayViewController.m
//  shop
//
//  Created by FGH on 16/4/13.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//


#define RGBACOLOR [UIColor colorWithRed: 4/255.0f green:146/255.0f blue:245/255.0f alpha:1.0]

#import "PayViewController.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "AttestViewController.h"
#import "LFLaccount.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"
#import "WXApi.h"
#import "JXTAlertManagerHeader.h"
#import "PayModel.h"
@implementation PayViewController
-(instancetype)init{
    if (self =[super init]) {
        self.selectIndex = 0;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.total = 0;
    self.totalcount = 0;
    // [self requestUnpayData];
    // [self requestPayData];
    
    self.moneyStr = @"已选0.00元";//初始化底部标题
    
    self.imageStr = @"weixuanze";
    self.image = @"weixuanze";
    [[UITableView appearance]setTableFooterView:[UIView new]];
    //    self.navigationBarLeft  = [UIImage imageNamed:@"nav_back.png"];
    self.navigationBarTitle = @"缴物业费";
    [self creatSegment];
    [self creatView];
    [self creatTelTableView];
    [self creatBottomView];
    
    //        [self presentLoadingTips:@"请稍后~~"];
    [self presentLoadingTips];
    [self requestPayData];
    [self requestUnpayData];
    [self setupRefresh];
}
- (NSMutableArray *)unpayArr
{
    if (_unpayArr == nil) {
        _unpayArr = [[NSMutableArray alloc]init];
    }
    return _unpayArr;
}
- (NSMutableArray *)keyArr
{
    if (!_keyArr) {
        _keyArr = [[NSMutableArray alloc]init];
    }
    return _keyArr;
}

- (NSMutableArray *)unpayNoteArr
{
    if (!_unpayNoteArr) {
        _unpayNoteArr = [[NSMutableArray alloc]init];
    }
    return _unpayNoteArr;
}

- (NSMutableArray *)payNoteArr
{
    if (!_payNoteArr) {
        _payNoteArr = [[NSMutableArray alloc]init];
    }
    return _payNoteArr;
}

//- (NSMutableDictionary *)idDicArr
//{
//    if (!_idDicArr) {
//        _idDicArr = [[NSMutableDictionary alloc]init];
//    }
//    return _idDicArr;
//}
//- (NSMutableDictionary *)amouDicArr
//{
//    if (!_amouDicArr) {
//        _amouDicArr = [[NSMutableDictionary alloc]init];
//    }
//    return _amouDicArr;
//}
//
//- (NSMutableDictionary *)nameDicArr
//{
//    if (!_nameDicArr) {
//        _nameDicArr = [[NSMutableDictionary alloc]init];
//    }
//    return _nameDicArr;
//}

- (NSMutableArray *)orderArray
{
    if (_orderArray == nil) {
        _orderArray = [[NSMutableArray alloc]init];
    }
    return _orderArray;
}
#pragma mark 未交费数据
-(void)requestUnpayData{
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSDictionary *dt = @{@"userid":uid};
    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"10") params:dt success:^(id response) {
        
        [_tableView.mj_header endRefreshing];
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        [self.unpayArr removeAllObjects];
        self.totalcount = 0;
        if ([str isEqualToString:@"0"]) {
            NSError *error;
            for (NSDictionary *dt in response[@"note"]) {
                PayModel *model = [[PayModel alloc]initWithDictionary:dt error:&error];
                NSMutableArray *modelArr = [NSMutableArray array];
                for (PayinfoModel *infomodel in model.note) {
                    PayinfoModel *tempmodel = infomodel;
                    tempmodel.isSelect = @"0";
                    [modelArr addObject:tempmodel];
                    self.totalcount ++;
                }
                model.note =(NSArray <PayinfoModel>*) modelArr;
                LFLog(@"未交费error:%@",error);
                LFLog(@"未交费%@",model.note[0]);
                [self.unpayArr addObject:model];
            }
            
            //            self.unpayArr= [response objectForKey:@"note"];
            if (!self.unpayArr.count) {
                
                [self presentLoadingTips:@"您没有交费账单"];
            }
            [self.selectedBtn setTitle:[NSString stringWithFormat:@"已选0.00元"] forState:UIControlStateNormal];
            self.allSelectedBtn.selected = NO;
            self.keyArr = nil;
        }else{
            LFLog(@"获取失败---%@",response[@"err_msg"]);
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self dismissTips];
        [self.tableView reloadData];
        [_tableView.mj_header endRefreshing];
    }];
    
}
#pragma mark 支付方式
- (void)updatePropertyPayCodeUrl{

    [self presentLoadingTips];
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PropertyPayCodeUrl) params:nil success:^(id response) {
        [_tableView.mj_header endRefreshing];
        [self dismissTips];
        LFLog(@"支付方式:%@",response);
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {

            NSArray *payArr = response[@"data"];
            if (payArr.count) {
                float price = 0.00;
                for (PayModel *model in self.unpayArr) {
                    for (PayinfoModel *Inmodel in model.note) {
                        if ([Inmodel.isSelect isEqualToString:@"1"]) {
                            price += [Inmodel.fr_amou floatValue];
                        }
                        
                    }
                    
                }
                
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
                                [self WinxinupToOrderinformation:@"alipay"];
                            }else if ([payArr[i][@"pay_code"] isEqualToString:@"wxpay"]) {
                                [self WinxinupToOrderinformation:@"wxpay"];;
                            }
                            
                        }
                    }
//                    else if ([action.title isEqualToString:@"支付宝支付"]) {
//                        [self WinxinupToOrderinformation:@"alipay"];
//                        
//                    }
//                    else if ([action.title isEqualToString:@"微信支付"]) {
//                        if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])) {
//                            
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机未安装微信,请选择其他支付方式" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                            [alert show];
//                            [self dismissTips];
//                            return;
//                        }
//                        [self WinxinupToOrderinformation:@"wxpay"];
//                    }
                    
                }];
            }

            
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@""]) {
                        [self updatePropertyPayCodeUrl];
                    }
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"获取支付方式失败"];
        [_tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark 微信提交订单信息
- (void)WinxinupToOrderinformation:(NSString *)orderType{
    [self presentLoadingTips];
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSMutableArray *mFrid = [[NSMutableArray alloc]init];
    for (PayModel *model in self.unpayArr) {
        for (PayinfoModel *Inmodel in model.note) {
            if ([Inmodel.isSelect isEqualToString:@"1"]) {
                [mFrid addObject:Inmodel.frid];
            }
            
        }
        
    }
    
    NSMutableString *no = [[NSMutableString alloc]init];
    for (int i = 0; i < mFrid.count; i ++) {
        [no appendString:mFrid[i]];
        if (i < mFrid.count - 1) {
            [no appendString:@","];
        }
    }
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:no,@"frid",orderType,@"pay_code", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    LFLog(@"提交订单信息dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,PropertyOrderInfoUrl) params:dt success:^(id response) {
        [_tableView.mj_header endRefreshing];
        [self dismissTips];
        LFLog(@"提交订单信息:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            if ([orderType isEqualToString:@"wxpay"]) {
                [WXApiRequestHandler jumpToBizPay:response[@"data"][@"wxpayinfo"]];
                [[WXApiManager sharedManager] setPayResults:^(NSInteger state) {
                    LFLog(@"微信支付结果：%ld",(long)state);//0 成功
                    if (state == 0) {
                        [self upToOrderinforServer:@"微信支付" tradeNO:no];
                        [self didPaySuccess];
                    }else{
                        [self didPayFail];
                    }
                }];
            }else if([response[@"data"][@"pay_code"] isEqualToString:@"alipay"]){
                
                NSDictionary *alipaydict = response[@"data"];
                ServiceAlipay_Order *alipay = [ServiceAlipay_Order sharedServiceAlipay_Order];
                alipay.orderStr = alipaydict[@"alipayinfo"];
                [alipay generate];
                [alipay setPayResults:^(NSInteger state) {
                    LFLog(@"支付结果%ld",(long)state);
                    if (state == 0) {
                        [self upToOrderinforServer:@"支付宝支付" tradeNO:no];
                        [self didPaySuccess];
                    }else{
                        [self didPayFail];
                    }
                }];
                
                
            }
            
            
        }else{
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
        }
        
    } failure:^(NSError *error) {
        [self dismissTips];
        [_tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark 已交费数据
-(void)requestPayData{
    
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSDictionary *dt = @{@"userid":uid};
    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"11") params:dt success:^(id response) {
        [_tableView.mj_header endRefreshing];
        [self dismissTips];
        LFLog(@"已交费数据%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            if ([[response objectForKey:@"note"] isKindOfClass:[NSString class]] ) {
                [self.tableView reloadData];
                first = YES;
                
            }else{
                
                self.payArr= [response objectForKey:@"note"];
                [self.tableView reloadData];
                first = YES;
            }
            
            
            
        }else{
            LFLog(@"获取失败---%@",response[@"err_msg"]);
            [self.tableView reloadData];
            [self presentLoadingTips:response[@"err_msg"]];
        }
        
    } failure:^(NSError *error) {
        [self dismissTips];
        [self.tableView reloadData];
        [_tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark 提交订单信息
//-(void)upToOrderinformation{
//
//    NSString *uid = [UserDefault objectForKey:@"useruid"];
//    if (uid == nil) {
//        uid = @"";
//    }
//    LFLog(@"订单编号数组--%@",self.idDicArr);
//    NSArray *arr1 = [self.idDicArr allValues];
//    LFLog(@"--------%@",arr1);
//    NSMutableString *no = [[NSMutableString alloc]init];
//    for (NSString *str in arr1) {
//        no = [no stringByAppendingFormat:@"%@,",str];
//    }
//
//    NSUserDefaults *defaut = [NSUserDefaults standardUserDefaults];
//
//    NSString *cardid = [defaut objectForKey:@"cardId"];
//    NSString *leid = [defaut objectForKey:@"leid"];
//    NSDictionary *dt = @{@"userid":uid,@"cardid":cardid,@"leid":leid,@"paytype":@"支付宝支付",@"frid":no};
//
//    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"11") params:dt success:^(id response) {
//
//            NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
//            if ([str isEqualToString:@"0"]) {
//
//
//            }else{
//                //在这保存一下订单信息
//                [self presentLoadingTips:response[@"err_no"]];
//            }
//
//    } failure:^(NSError *error) {
//
//    }];
//
//}




//**************************************************************************************************
#pragma mark - 创建Segment
- (void)creatSegment
{
    NSArray *arr = [[NSArray alloc]initWithObjects:@"未缴费账单",@"已缴费记录",nil];
    self.segment = [[UISegmentedControl alloc]initWithItems:arr ];
    self.segment.selectedSegmentIndex = self.selectIndex;
    self.segment.tintColor  = JHMaincolor;
    self.segment.bounds = CGRectMake(0, 0, SCREEN.size.width-40, 40);
    self.segment.center = CGPointMake(SCREEN.size.width/2, 25);
    [self.segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    
    
    
    
}


#pragma mark - 创建creatTelTableView
- (void)creatTelTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height -60) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView  = self.view1;
    self.tableView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:self.tableView];
    if (self.selectIndex == 1) {
        self.tableView.height = SCREEN.size.height;
    }
}
#pragma mark - 创建表头View，在次view上放置segment
- (void)creatView
{
    
    self.view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 50)];
    [self.view1 addSubview:self.segment];
    self.view1.backgroundColor = [UIColor whiteColor];
    
    
}
#pragma mark - 创建底部View
- (void)creatBottomView
{
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN.size.height-60, SCREEN.size.width, 60)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    //    //全选
    self.allSelectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.allSelectedBtn setImage:[UIImage imageNamed:@"weixuanze"] forState:UIControlStateNormal];
    self.allSelectedBtn.imageEdgeInsets = UIEdgeInsetsMake(22, 13, 22, 11);
    [self.allSelectedBtn setImage:[UIImage imageNamed:@"yixuanze"] forState:UIControlStateSelected];
    [self.allSelectedBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.allSelectedBtn setTitle:@"全选" forState:UIControlStateSelected];
    self.allSelectedBtn.titleLabel.textColor = JHdeepColor;
    self.allSelectedBtn.frame = CGRectMake(0, 0, 40, 60);
    [self.allSelectedBtn addTarget:self action:@selector(allSelectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.allSelectedBtn];
    ////
    //已选xx元
    self.selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectedBtn setTitle:self.moneyStr forState:UIControlStateNormal];
    self.selectedBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [self.selectedBtn setTitleColor:JHAssistColor forState:UIControlStateNormal];
    self.selectedBtn.frame = CGRectMake(80, 0, SCREEN.size.width-140, 60);
    [self.bottomView addSubview:self.selectedBtn];
    //付款按钮
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [payBtn setTitle:@"立即付款" forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [payBtn setBackgroundColor:[UIColor redColor]];
    [payBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
    payBtn.frame = CGRectMake(SCREEN.size.width-80, 0, 80, 60);
    [self.bottomView addSubview:payBtn];
    if (self.selectIndex == 1) {
        self.bottomView.y = SCREEN.size.height+60;
        self.keyArr = nil;
    }
}

#pragma mark -全选
-(void)allSelectedBtnClick:(UIButton *)Bbtn{
    Bbtn.selected = !Bbtn.selected;
    
    
    float price = 0.00;
    for (PayModel *model in self.unpayArr) {
        for (PayinfoModel *Inmodel in model.note) {
            if (Bbtn.selected) {
                Inmodel.isSelect = @"1";
                price += [Inmodel.fr_amou floatValue];
            }else{
                Inmodel.isSelect = @"0";
            }
            
        }
        
    }
    [self.selectedBtn setTitle:[NSString stringWithFormat:@"已选%.2f元",price] forState:UIControlStateNormal];
    
    [self.tableView reloadData];
    
}

#pragma mark - 配置TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.segment.selectedSegmentIndex == 0)
    {
        
        
        return self.unpayArr.count ;
        
    }
    
    return self.payArr.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segment.selectedSegmentIndex == 0)
    {
        
        PayModel *model = self.unpayArr[section];
        return model.note.count;
    }
    self.payNoteArr = [self.payArr[section] objectForKey:@"note"];
    
    return self.payNoteArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //************************segment.selectedSegmentIndex == 0    第一个页面cell******************************
    if (self.segment.selectedSegmentIndex == 0) {
        //         self.unpayNoteArr = [self.unpayArr[indexPath.section] objectForKey:@"note"];
        
        //        long uniqueIndex  = indexPath.row +(indexPath.section + 1) * 100;
        //        NSNumber *longNumber = [NSNumber numberWithLong:uniqueIndex];
        //        NSString *stringFloat = [longNumber stringValue];
        
        //        [self.keyArr addObject:stringFloat];
        
        PayModel *model = self.unpayArr[indexPath.section];
        
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //        if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //选中imageview
        
        //        if (selectedArr [indexPath.row +(indexPath.section + 1) * 100]== YES) {
        //            self.imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yixuanze"]];
        //        }else{
        //            self. imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weixuanze"]];
        //        }
        PayinfoModel *infomodel = model.note[indexPath.row];
        if ([infomodel.isSelect isEqualToString:@"1"]) {
            self.imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yixuanze"]];
        }else{
            self. imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weixuanze"]];
        }
        
        self. imgView.frame = CGRectMake(8, 23, 14, 14);
        self. imgView.tag = indexPath.row +(indexPath.section + 1) * 100;
        
        [cell.contentView addSubview:self. imgView];
        
        //缴费项目title
        UILabel *itemTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 50, 30)];
        itemTitleLabel.text = @"缴费项目:";
        itemTitleLabel.font = [UIFont systemFontOfSize:11.0];
        [cell.contentView addSubview:itemTitleLabel];
        //缴费内容
        UILabel *itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 0, SCREEN.size.width-170, 30)];
        //        itemLabel.text = [self.unpayNoteArr[indexPath.row] objectForKey:@"it_name"];
        itemLabel.text = infomodel.it_name;
        itemLabel.font = [UIFont systemFontOfSize:11.0];
        [cell.contentView addSubview:itemLabel];
        
        //缴费周期title
        UILabel *cycleTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 30, 50, 30)];
        cycleTitleLabel.text = @"缴费周期:";
        cycleTitleLabel.font = [UIFont systemFontOfSize:11.0];
        [cell.contentView addSubview:cycleTitleLabel];
        //缴费周期内容
        UILabel *cycleLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 30, SCREEN.size.width-170, 30)];
        //        NSString *beginStr = [self.unpayNoteArr[indexPath.row] objectForKey:@"fr_beginT"];
        //        NSString *endStr = [self.unpayNoteArr[indexPath.row] objectForKey:@"fr_endT"];
        NSString *cycleStr = [NSString stringWithFormat:@"%@-%@",infomodel.fr_beginT,infomodel.fr_endT];
        cycleLabel.text = cycleStr;
        cycleLabel.font = [UIFont systemFontOfSize:11.0];
        [cell.contentView addSubview:cycleLabel];
        //总价itle
        UILabel *tPTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN.size.width-100, 30, 45, 30)];
        tPTitleLabel.text = @"总价:";
        tPTitleLabel.font = [UIFont systemFontOfSize:11.0];
        [cell.contentView addSubview:tPTitleLabel];
        //总价内容
        UILabel *tPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN.size.width-65, 30, 70, 30)];
        //        NSString *amoutStr = [self.unpayNoteArr[indexPath.row] objectForKey:@"fr_amou"];
        NSString *amoutYStr = [NSString stringWithFormat:@"%@元",infomodel.fr_amou];
        tPriceLabel.text = amoutYStr;
        tPriceLabel.font = [UIFont systemFontOfSize:11.0];
        [cell.contentView addSubview:tPriceLabel];
        //单价title
        UILabel *pTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN.size.width-100, 0, 45, 30)];
        pTitleLabel.text = @"单价:";
        pTitleLabel.font = [UIFont systemFontOfSize:11.0];
        [cell.contentView addSubview:pTitleLabel];
        //单价内容
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN.size.width-65, 0, 70, 30)];
        //        NSString *pricStr = [self.unpayNoteArr[indexPath.row] objectForKey:@"fr_pric"];
        NSString *pricYStr = [NSString stringWithFormat:@"%@元",infomodel.fr_pric];
        priceLabel.text = pricYStr;
        priceLabel.font = [UIFont systemFontOfSize:11.0];
        [cell.contentView addSubview:priceLabel];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
        
    }else{
        self.payNoteArr = [self.payArr[indexPath.section] objectForKey:@"note"];
        static NSString *BOtherCellIdentifier = @"BOtherCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BOtherCellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BOtherCellIdentifier] ;
            //缴费项目title
            UILabel *itemTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 30)];
            itemTitleLabel.text = @"缴费项目:";
            itemTitleLabel.font = [UIFont systemFontOfSize:11.0];
            [cell.contentView addSubview:itemTitleLabel];
            //缴费项目内容
            UILabel *itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, SCREEN.size.width-170, 30)];
            itemLabel.text = [self.payNoteArr[indexPath.row] objectForKey:@"it_name"];
            itemLabel.font = [UIFont systemFontOfSize:11.0];
            [cell.contentView addSubview:itemLabel];
            
            //缴费周期title
            UILabel *cycleTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 50, 30)];
            cycleTitleLabel.text = @"缴费周期:";
            cycleTitleLabel.font = [UIFont systemFontOfSize:11.0];
            [cell.contentView addSubview:cycleTitleLabel];
            //缴费周期内容
            UILabel *cycleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, SCREEN.size.width-170, 30)];
            NSString *paybeginStr = [self.payNoteArr[indexPath.row] objectForKey:@"fr_beginT"];
            NSString *payendStr = [self.payNoteArr[indexPath.row] objectForKey:@"fr_endT"];
            NSString *paycycleStr = [NSString stringWithFormat:@"%@ %@",paybeginStr,payendStr];
            cycleLabel.text = paycycleStr;
            cycleLabel.font = [UIFont systemFontOfSize:11.0];
            [cell.contentView addSubview:cycleLabel];
            //缴费时间title
            UILabel *timeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 50, 30)];
            timeTitleLabel.text = @"缴费时间:";
            timeTitleLabel.font = [UIFont systemFontOfSize:11.0];
            [cell.contentView addSubview:timeTitleLabel];
            //缴费时间内容
            UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 60, SCREEN.size.width-170, 30)];
            timeLabel.text = [self.payNoteArr[indexPath.row] objectForKey:@"fa_date"];;
            timeLabel.font = [UIFont systemFontOfSize:11.0];
            [cell.contentView addSubview:timeLabel];
            
            
            //缴费金额
            UILabel *pTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN.size.width-80, 0, 80, 30)];
            NSString *amoutpricStr = [self.payNoteArr[indexPath.row] objectForKey:@"fr_amou"];
            NSString *amoutpricYStr = [NSString stringWithFormat:@"%@元",amoutpricStr];
            pTitleLabel.text = amoutpricYStr;
            pTitleLabel.font = [UIFont systemFontOfSize:11.0];
            [cell.contentView addSubview:pTitleLabel];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
        return cell;
    }
}

#pragma mark - cell点击事件，选中或取消
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    //    long uniqueIndex  = indexPath.row +(indexPath.section + 1) * 100;
    
    
    
    
    if (self.segment.selectedSegmentIndex == 0)
    {
        PayModel *model = self.unpayArr[indexPath.section];
        PayinfoModel *infomodel = model.note[indexPath.row];
        NSMutableArray *modelArr = [NSMutableArray arrayWithArray:model.note];
        if ([infomodel.isSelect isEqualToString:@"0"]) {
            infomodel.isSelect = @"1";
        }else{
            infomodel.isSelect = @"0";
        }
        
        [modelArr replaceObjectAtIndex:indexPath.row withObject:infomodel];
        model.note = (NSArray <PayinfoModel>*)modelArr;
        
        int single = 0;
        
        float price = 0.00;
        for (PayModel *model in self.unpayArr) {
            for (PayinfoModel *Inmodel in model.note) {
                if ([Inmodel.isSelect isEqualToString:@"1"]) {
                    price += [Inmodel.fr_amou floatValue];
                    single ++;
                }
            }
        }
        [self.selectedBtn setTitle:[NSString stringWithFormat:@"已选%.2f元",price] forState:UIControlStateNormal];
        
        
        if (single == self.totalcount) {
            LFLog(@"全选了");
            self.allSelectedBtn.selected = YES;
            //            [self.allSelectedBtn setImage:[UIImage imageNamed:@"yixuanze"] forState:UIControlStateNormal];
        }else{
            self.allSelectedBtn.selected = NO;
            LFLog(@"取消全选");
            //            [self.allSelectedBtn setImage:[UIImage imageNamed:@"weixuanze"] forState:UIControlStateNormal];
            
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 60)];
    header.backgroundColor = [UIColor whiteColor];
    //房间title
    UILabel *roomTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 50, 30)];
    roomTitleLabel.text = @"房间号:";
    roomTitleLabel.font = [UIFont systemFontOfSize:13.0];
    [header addSubview:roomTitleLabel];
    //房间内容
    UILabel *roomLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, SCREEN.size.width-170, 30)];
    
    
    roomLabel.font = [UIFont systemFontOfSize:13.0];
    [header addSubview:roomLabel];
    if (self.segment.selectedSegmentIndex == 1) {
        roomLabel.text = [self.payArr[section] objectForKey:@"po_name"];
        //付费人title
        UILabel *nameTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 30)];
        nameTitleLabel.text = @"付费人:";
        nameTitleLabel.textColor = JHAssistColor;
        nameTitleLabel.font = [UIFont systemFontOfSize:13.0];
        [header addSubview:nameTitleLabel];
        //付费人内容
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 50, 30)];
        nameLabel.text = [self.payArr[section] objectForKey:@"cu_name"];
        nameLabel.font = [UIFont systemFontOfSize:13.0];
        nameLabel.textColor = JHAssistColor;
        [header addSubview:nameLabel];
    }
    
    
    if (self.segment.selectedSegmentIndex == 0) {
        
        PayModel *model = self.unpayArr[section];
        //        roomLabel.text = [self.unpayArr[section] objectForKey:@"po_name"];
        roomLabel.text = model.po_name;
        NSUserDefaults *defuat = [NSUserDefaults standardUserDefaults];
        NSString *name = [NSString stringWithFormat:@"%@",[defuat objectForKey:@"name"]];
        
        //付费人title
        UILabel *nameTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 30)];
        nameTitleLabel.text = @"付费人:";
        nameTitleLabel.textColor = JHAssistColor;
        nameTitleLabel.font = [UIFont systemFontOfSize:13.0];
        [header addSubview:nameTitleLabel];
        //付费人内容
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 50, 30)];
        nameLabel.text = name;
        nameLabel.textColor = JHAssistColor;
        nameLabel.font = [UIFont systemFontOfSize:13.0];
        [header addSubview:nameLabel];
        //面积title
        UILabel *areaTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN.size.width-110, 30, 60, 30)];
        areaTitleLabel.text = @"面积:";
        areaTitleLabel.font = [UIFont systemFontOfSize:13.0];
        [header addSubview:areaTitleLabel];
        //面积内容
        UILabel *areaLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN.size.width-75, 30, 80, 30)];
        //        NSString *spuaStr = [self.unpayArr[section] objectForKey:@"sp_spua"];
        NSString *sp_spuaStr = [NSString stringWithFormat:@"%@m²",model.sp_spua];
        areaLabel.text = sp_spuaStr;
        areaLabel.font = [UIFont systemFontOfSize:13.0];
        [header addSubview:areaLabel];
    }
    
    
    return header;
    
    
}

#pragma mark - 区头高度设置

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 60;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000001;
    
    
}

#pragma mark - 单元格高度设置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segment.selectedSegmentIndex == 0) {
        return 60;
    }
    return 90;
}
#pragma mark - segment点击事件
- (void)segmentClick:(UISegmentedControl *)seg
{
    
    if (seg.selectedSegmentIndex == 0) {
        self.bottomView.frame = CGRectMake(0, SCREEN.size.height-80, SCREEN.size.width, 80);
        self.keyArr = nil;
        self.tableView.height = SCREEN.size.height - 80;
        [self.tableView reloadData];
        
    }else{
        
        //        [self setupRefresh];
        self.bottomView.frame = CGRectMake(0, SCREEN.size.height, 0, 0);
        self.tableView.height = SCREEN.size.height;
        self.keyArr = nil;
        if (self.payArr.count == 0) {
            [self presentLoadingTips:@"没有交费记录~~"];
        }
        [self.tableView reloadData];
    }
}

#pragma mark - 点击付款
- (void)playClick
{
    if ([self.selectedBtn.titleLabel.text isEqualToString:@"已选0.00元" ] || [self.selectedBtn.titleLabel.text isEqualToString:@"0.00" ]) {
        [self presentLoadingTips:@"请选择缴费项目"];
        return;
    }
    
    [self updatePropertyPayCodeUrl];

    
}






//支付失败
- (void)didPayFail
{
    
    //    [self presentLoadingTips:@"支付失败"];
}

// 支付成功
- (void)didPaySuccess
{
    
    
    //向服务器发送订单信息
    //    [self upToOrderinformation];
    //    如果付款成功的话
    //    初始化
    self.moneyStr  = @"已选0.00元";
    
    [self.selectedBtn setTitle:self.moneyStr forState:UIControlStateNormal];
    self.allSelectedBtn.selected = NO;
    
    //请求数据，刷新表格
    [self requestUnpayData];
    [self requestPayData];
    
    [self presentLoadingTips:@"支付成功"];
}

//支付成功提交订单信息
- (void)upToOrderinforServer:(NSString *)paytype tradeNO:(NSString *)tradeNO
{
    NSString *cardid = [userDefaults objectForKey:@"cardId"];
    NSString *leid = [userDefaults objectForKey:@"leid"];
    NSString *uid = [UserDefault objectForKey:@"useruid"];
    if (uid == nil) {
        uid = @"";
    }
    NSDictionary *dt = @{@"userid":uid,@"cardId":cardid,@"leid":leid,@"paytype":paytype,@"frid":tradeNO};
    [LFLHttpTool get:NSStringWithFormat(ZJguokaihangBaseUrl,@"18") params:dt success:^(id response) {
        [_tableView.mj_header endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"err_no"]];
        if ([str isEqualToString:@"0"]) {
            LFLog(@"获取成功");
            
        }else{
            LFLog(@"获取失败---%@",response[@"err_msg"]);
            
        }
        
    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
    }];
    
}


#pragma mark 页面将要显示
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //    if (![[LFLaccount shareaccount] isConnectionAvailable]) {
    //
    //        [[BeeUITipsCenter sharedInstance] presentFailureTips:__TEXT(@"error_network")];
    //        //[[BeeUITipsCenter sharedInstance] presentLoadingTips:@"正在加载。。。。"];
    //
    //    }
    
    //    if ( NO == [UserModel online] )
    //    {
    //        bee.ui.appBoard.pay = self;
    //        [bee.ui.appBoard showLogin];
    //        return;
    //    }
    [self paywillappear];
    
    
}


-(void)paywillappear{
    
    NSUserDefaults *defuat = [NSUserDefaults standardUserDefaults];
    
    if ([self.isPop isEqualToString:@"pop"]) {
        
        
        
        
        NSString *str = [NSString stringWithFormat:@"%@",[defuat objectForKey:@"name"]];
        
        if ([str isEqualToString: @"(null)"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self requestPayData];
            [self requestUnpayData];

            
            
        }
    }else {
        
        
        NSString *str = [NSString stringWithFormat:@"%@",[defuat objectForKey:@"name"]];
        LFLog(@"6554:%@",str);
        if ([str isEqualToString: @"(null)"]) {
            //            AttestViewController *att = [[AttestViewController alloc]init];
            //
            //            [self.navigationController pushViewController:att animated:YES];
        }else{
            
            [self requestPayData];
            [self requestUnpayData];
            
        }
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.isPop = nil;
    
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.segment.selectedSegmentIndex == 0) {
            [self requestUnpayData];
        }else{
            [self requestPayData];
        }
        
    }];
    
}




@end
