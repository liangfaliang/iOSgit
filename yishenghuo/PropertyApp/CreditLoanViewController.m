//
//  CreditLoanViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/5/10.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "CreditLoanViewController.h"
#import "customSlider.h"
#import "CreditLoanAmountView.h"
#import "WKViewViewController.h"
#import "CreditLoanFirstViewController.h"
#import "CreditLoanRecordDetailsController.h"
@interface CreditLoanViewController ()<UITableViewDelegate,UITableViewDataSource>{
    CreditLoanAmountView *amview;
    UIButton *TermsBtn;
    UIButton *mobileBtn;
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIImageView *headerView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *listArray;
@property(nonatomic,strong)NSMutableDictionary *imageDt;
@end

@implementation CreditLoanViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createBarButtonItem];
    [self createUI];
    [self UploadDatadynamic];
    [self UploadDatadynamicList];
}
-(NSMutableDictionary *)imageDt{
    if (_imageDt == nil) {
        _imageDt = [[NSMutableDictionary alloc]init];
    }
    return _imageDt;
}
-(NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [[NSMutableArray alloc]init];
    }
    return _listArray;
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
//
-(void)createBarButtonItem{

    UIButton *backBtn = [[UIButton alloc]init];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick:)];
    backItem.tintColor = JHdeepColor;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"biaoti"]]];
    NSArray *itemArr = @[backItem,leftBtn];
    self.navigationItem.leftBarButtonItems = itemArr;

}
-(void)backItemClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createUI{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = JHColor(222, 222, 222);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"iscell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"D0informationTableViewCell" bundle:nil] forCellReuseIdentifier:@"cuscell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self tz_addPopGestureToView:self.tableView];
    
    UIView *foootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 70)];
    
    UIButton *submitBtn = [[UIButton alloc]init];
    [submitBtn setImage:[UIImage imageNamed:@"chaxundaikuanjilu"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(listBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [foootview addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(foootview.mas_centerY);
        make.centerX.equalTo(foootview.mas_centerX);
    }];
    self.tableView.tableFooterView = foootview;
}
-(void)listBtnClick:(UIButton *)btn{
    if (self.listArray.count) {
        CreditLoanRecordDetailsController *detail = [[CreditLoanRecordDetailsController alloc]init];
        detail.sdid = self.listArray[0][@"sdid"];
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        [self presentLoadingTips:@"您尚没有申请纪录"];
    }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        if (!self.imageDt[@"product"]) {
            return 0;
        }
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIImageView *view = [[UIImageView alloc]init];
    view.image = [UIImage imageNamed:@"fengexiantongyong"];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //        NSString *CellIdentifier = @"iscell";
    //        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        NSString *CellIdentifier = @"onecell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.headerView == nil) {
            self.headerView = [[UIImageView alloc]init];
            self.headerView.userInteractionEnabled = YES;
            self.headerView.image = [UIImage imageNamed:@"banner_xinyongdai"];
            [cell.contentView addSubview:self.headerView];
            [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
                make.top.offset(0);
                make.right.offset(0);
                make.bottom.offset(0);
            }];
            
            UIImage *im = [UIImage imageNamed:@"lijishenqing"];
            UIView *backview = [[UIView alloc]init];
            backview.backgroundColor = JHColoralpha(255, 255, 255, 0.6);
            [self.headerView addSubview:backview];
            [backview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-10);
                make.height.offset(195);
                make.width.offset(im.size.width + 30);
                make.bottom.offset(-20);
            }];
            NSArray *imArr = @[@"xingming_xinyongdai",@"shenfenzhenghao_xinyongdai"];
            NSArray *placeholderArr = @[@"请输入您的姓名",@"请输入您的身份证号码"];
            for (int i = 0; i < 2; i ++) {
                UIImageView *subview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15 + 45 * i, im.size.width, 40)];
                subview.userInteractionEnabled = YES;
                subview.contentMode = UIViewContentModeScaleToFill;
                subview.image = [UIImage imageNamed:@"shurukuang_xinyongdai"];
                [backview addSubview:subview];
                UITextField *tf = [[UITextField alloc]init];
                tf.textColor = JHmiddleColor;
                tf.font = [UIFont systemFontOfSize:13];
                tf.tag = 55 + i;
                tf.placeholder = placeholderArr[i];
                tf.leftViewMode = UITextFieldViewModeAlways;
                if (i == 1) {
                    tf.keyboardType = UIKeyboardTypeNumberPad;
                }
                [tf setLeftView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:imArr[i]]]];
                [subview addSubview:tf];
                [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(0);
                    make.top.offset(0);
                    make.right.offset(0);
                    make.bottom.offset(0);
                }];
                
            }
            TermsBtn = [[UIButton alloc]init];
//            [TermsBtn setImage:[UIImage imageNamed:@"lijishenqing"] forState:UIControlStateNormal];
            [TermsBtn setImage:[UIImage imageNamed:@"gouxuankuang_xinyongdai"] forState:UIControlStateNormal];
            [TermsBtn setImage:[UIImage imageNamed:@"tongyigouxuan_xinyongdai"] forState:UIControlStateSelected];
            TermsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [TermsBtn addTarget:self action:@selector(TermsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [backview addSubview:TermsBtn];
            [TermsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.offset(0);
                make.left.offset(10);
                make.right.offset(-10);
                make.height.offset(40);
            }];
            UIButton *readBtn = [[UIButton alloc]init];
            NSString *str  = @" 本人同意《客户授权与说明》条款内容";
            NSAttributedString *attStr = [str AttributedString:@"《客户授权与说明》" backColor:nil uicolor:JHColor(0, 169, 224) uifont:[UIFont systemFontOfSize:12]];
            
            [readBtn setAttributedTitle:attStr forState:UIControlStateNormal];
            [readBtn setTitleColor:JHmiddleColor forState:UIControlStateNormal];
            readBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            readBtn.titleLabel.textColor = JHmiddleColor;
            [readBtn addTarget:self action:@selector(readBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [TermsBtn addSubview:readBtn];
            
            [readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(TermsBtn.imageView.image.size.width + 5);
                make.top.offset(0);
                make.right.offset(0);
                make.bottom.offset(0);
            }];
            
            UIButton *submitBtn = [[UIButton alloc]init];
            //            [TermsBtn setImage:[UIImage imageNamed:@"lijishenqing"] forState:UIControlStateNormal];
            [submitBtn setImage:im forState:UIControlStateNormal];
            [submitBtn setImage:[UIImage imageNamed:@"tongyigouxuan_xinyongdai"] forState:UIControlStateSelected];
            [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [backview addSubview:submitBtn];
            [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.equalTo(backview.mas_centerX);
                make.left.offset(10);
                make.bottom.equalTo(TermsBtn.mas_top).offset(0);
            }];
            
            
            
        }
        
        return cell;
        
    }else if (indexPath.section == 1) {
        NSString *CellIdentifier3 = @"threecell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView removeAllSubviews];
        if (self.imageDt[@"product"]) {
            UIImage *im = self.imageDt[@"product"];
            UIImageView *imview = [[UIImageView alloc]initWithImage:im];
            [cell.contentView addSubview:imview];
            [imview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.top.offset(15);
                make.right.offset(-10);
                make.bottom.offset(-15);
            }];
        }

            return cell;
        
    }else {
        NSString *CellIdentifier2 = @"Informationcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (amview == nil) {
            amview = [[NSBundle mainBundle]loadNibNamed:@"CreditLoanAmountView" owner:nil options:nil][0];
            [self tz_addPopGestureToView:amview];
            [self tz_addPopGestureToView:amview.slider];
            [cell.contentView addSubview:amview];
            [amview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
                make.top.offset(0);
                make.right.offset(0);
                make.bottom.offset(0);
            }];
        }
        
        return cell;
    }
    
}
//点击条款
-(void)TermsBtnClick:(UIButton *)btn{

    btn.selected = !btn.selected;
}
-(void)readBtnClick:(UIButton *)btn{

    if (self.dataArray.count) {
        WKViewViewController *wk = [[WKViewViewController alloc]init];
        wk.urlStr = self.dataArray[0][@"qdesc"];
        wk.titleStr = @"详情";
        [self.navigationController pushViewController:wk animated:YES];
    }

}
//立即申请

-(void)submitBtnClick:(UIButton *)btn{
    UITextField *tf1 = [self.headerView viewWithTag:55];
    UITextField *tf2 = [self.headerView viewWithTag:56];
    if (tf1.text.length == 0) {
        [self presentLoadingTips:@"请输入您的姓名"];
        return;
    }
    if (tf2.text.length == 0) {
        [self presentLoadingTips:@"请输入您的身份证号"];
        return;
    }
    
#ifdef DEBUG //测试阶段

#else
    if (tf2.text.length != 18) {
        [self presentLoadingTips:@"请输入正确的身份证号"];
        return;
    }
    
    if (!TermsBtn.selected) {
        [self presentLoadingTips:@"请阅读并勾选《客户授权与说明》条款"];
        return;
    }
#endif

    if (self.listArray.count) {
        [self presentLoadingTips:@"您已有贷款申请，暂时不能重复申请"];
        return;
    }
    if (self.dataArray.count) {
        CreditLoanFirstViewController *first = [[CreditLoanFirstViewController alloc]init];
        NSString *mobile = [userDefaults objectForKey:@"mobile"];
        if (mobile == nil) {
            mobile = @"";
        }
        first.keyArr1 = @[tf1.text,tf2.text,mobile];
        first.dataDt = self.dataArray[0];
        [self.navigationController pushViewController:first animated:YES];
    }else{
        [self presentLoadingTips:@"数据获取失败"];
    }

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        UIImage *backIm = [UIImage imageNamed:@"banner_xinyongdai"];
        return backIm.size.height / backIm.size.width * SCREEN.size.width;
    }else if(indexPath.section == 1){
        if (self.imageDt[@"product"]) {
            UIImage *im = self.imageDt[@"product"];
            return im.size.height/im.size.width * (SCREEN.size.width - 20) + 30;
        }
    }else if(indexPath.section == 2){
        return 330;
    }
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.001;
}

#pragma mark - *************信用贷*************
-(void)UploadDatadynamic{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    if (session == nil) {
        session = @{};
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:session,@"session", nil];
    //    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    //    NSDictionary *pagination = @{@"count":@"5",@"page":page};
    //    [dt setObject:pagination forKey:@"pagination"];
    [LFLHttpTool get:NSStringWithFormat(ZJShopBaseUrl,CreditLoanHomeUrl) params:dt success:^(id response) {
        LFLog(@"信用贷:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {

            [self.dataArray removeAllObjects];
            if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
                [self.dataArray addObject:response[@"data"]];
            }
            if ([response[@"data"][@"product"] isKindOfClass:[NSDictionary class]]) {
                if (response[@"data"][@"product"][@"imgurl"]) {
                    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:response[@"data"][@"product"][@"imgurl"]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        if (image) {
                            [self.imageDt setObject:image forKey:@"product"];
                            [self.tableView reloadData];
                        }

                    }];
                }
            }
            if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
                if ([response[@"data"][@"mobile"] isKindOfClass:[NSString class]]) {
                    if (mobileBtn == nil) {
                        mobileBtn = [[UIButton alloc]init];
                        [mobileBtn setTitle:[NSString stringWithFormat:@"   %@",response[@"data"][@"mobile"]] forState:UIControlStateNormal];
                        [mobileBtn setTitleColor:JHColor(251, 62, 17) forState:UIControlStateNormal];
                        mobileBtn.titleLabel.font = [UIFont systemFontOfSize:15];
                        [mobileBtn setImage:[UIImage imageNamed:@"kefurexian"] forState:UIControlStateNormal];
                        mobileBtn.frame = CGRectMake(0, 0, mobileBtn.imageView.image.size.width + [mobileBtn.titleLabel.text selfadap:15 weith:20].width + 10, 44);
                        [mobileBtn addTarget:self action:@selector(mobileBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:mobileBtn];
                        self.navigationItem.rightBarButtonItem = rightItem;
                    }
                }
            }
            
            
            [self.tableView reloadData];
            
        }else{
            
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self UploadDatadynamic];
                    }
                    
                }];
            }
            
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    
}
#pragma mark - *************记录列表*************
-(void)UploadDatadynamicList{
    [self presentLoadingTips];
    NSString *leid = [UserDefault objectForKey:@"leid"];
    if (leid == nil) {
        leid = @"";
    }
    NSString *coid = [UserDefault objectForKey:@"coid"];
    if (coid == nil) {
        coid = @"";
    }
    NSString *mobile = [UserDefault objectForKey:@"mobile"];
    if (mobile == nil) {
        mobile = @"";
    }
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:leid,@"leid",coid,@"coid",mobile,@"mobile", nil];
    //    NSString *page = [NSString stringWithFormat:@"%ld",(long)pagenum];
    //    NSDictionary *pagination = @{@"count":@"5",@"page":page};
    //    [dt setObject:pagination forKey:@"pagination"];
    [LFLHttpTool get:NSStringWithFormat(ZJERPIDBaseUrl,@"101") params:dt success:^(id response) {
        LFLog(@"记录列表:%@",response);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"error"]];
        if ([str isEqualToString:@"0"]) {
            [self.listArray removeAllObjects];
            for (NSDictionary *dic in response[@"note"]) {
                [self.listArray addObject:dic];
            }
            
        }else{
            
         
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark 拨打电话
-(void)mobileBtnClick:(UIButton *)btn{

    if (self.dataArray.count && self.dataArray[0][@"mobile"]) {
        NSString *tell = [NSString stringWithFormat:@"telprompt://%@",self.dataArray[0][@"mobile"]];
        NSURL *url = [NSURL URLWithString:tell];
        NSComparisonResult compare = [[UIDevice currentDevice].systemName compare:@"10.0"];
        if (compare == NSOrderedDescending || compare == NSOrderedSame) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }else{
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    
//    [self alertController:@"拨打电话" prompt:[NSString stringWithFormat:@"%@",self.dataArray[0][@"mobile"]] sure:@"确认" cancel:@"取消" success:^{

        
//    } failure:^{
//        
//    }];

}
@end
