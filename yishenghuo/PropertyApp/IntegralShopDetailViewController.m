//
//  IntegralShopDetailViewController.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/11/8.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "IntegralShopDetailViewController.h"
#import "JWCycleScrollView.h"
//#import "SelectCountControl.h"
#import "GoodsReviewTableViewCell.h"
#import "ConfirmOrderViewController.h"
#import "ShopListCollectionViewCell.h"
#import "ShoppingCartViewController.h"
#import "UIButton+WebCache.h"
#import "STPhotoBroswer.h"
#import "CZCountDownView.h"
#import "LPLabel.h"
#import <WebKit/WebKit.h>
#import "UIView+TYAlertView.h"
#import "ConfirmOrderViewController.h"
#define headerhigth SCREEN.size.width
@interface IntegralShopDetailViewController ()<UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate,JWCycleScrollImageDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate>{
    //    SelectCountControl *control;
    UIView *SpikeVIew;
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)JWCycleScrollView *jwView;
@property (nonatomic,strong)UICollectionView * collectionview;
//@property(nonatomic,strong)UIView *footview;
@property(nonatomic,strong)UIView *tablefootview;
@property (nonatomic,strong)NSMutableArray *goodsArr;//详情
@property (nonatomic,strong)NSMutableArray *evaluateArr;//评论列表
@property(nonatomic,strong)UITableView *detailview;
@property(nonatomic,strong)UIView *detailHeaderview;
@property (strong, nonatomic) NSArray *segementArray;
@property (strong, nonatomic) NSArray *likeArray;//猜你喜欢
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UIView *vline;
@property(nonatomic,strong)WKWebView *wkview;
@property(nonatomic,assign)CGFloat wkviewHeight;
@property(nonatomic,strong)NSString *htmlStr;
@property(nonatomic,strong)UIView *popview;//弹出层视图
@property(nonatomic,strong)NSMutableArray * specArray;//规格id
@property(nonatomic,strong)NSMutableArray * explainArray;
@property(nonatomic,strong)CZCountDownView * countDown;//倒计时


@end

@implementation IntegralShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBarTitle = @"商品详情";
    self.segementArray = @[@"商品详情",@"商品描述",@"商品评论"];
    self.wkviewHeight = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTableview];
    [self setupRefresh];
    [self presentLoadingTips];
    [self UploadDatagoods:NO];
    
}

- (NSMutableArray *)explainArray
{
    if (!_explainArray) {
        _explainArray = [[NSMutableArray alloc]init];
    }
    return _explainArray;
}
- (NSMutableArray *)evaluateArr
{
    if (!_evaluateArr) {
        _evaluateArr = [[NSMutableArray alloc]init];
    }
    return _evaluateArr;
}
- (NSMutableArray *)specArray
{
    if (!_specArray) {
        _specArray = [[NSMutableArray alloc]init];
    }
    return _specArray;
}
- (NSMutableArray *)goodsArr
{
    if (!_goodsArr) {
        _goodsArr = [[NSMutableArray alloc]init];
    }
    return _goodsArr;
}


-(void)createTableview{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, headerhigth )];
    self.tablefootview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 0)];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height) style:UITableViewStyleGrouped];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsReviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"shopGoodsReview"];
    [self.view addSubview:self.tableView];
    
}
//图片轮播
- (void)ceratCycleScrollView
{
    //采用网络图片实现
    _jwView = nil;
    _jwView=[[JWCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, headerhigth)];
    //    self.headerView.frame = CGRectMake(0, 0, SCREEN.size.width, _jwView.frame.size.height + 30);
    NSMutableArray *imagesURLStrings = [NSMutableArray array];
    if (self.goodsArr.count == 0) {
        imagesURLStrings = [NSMutableArray arrayWithObjects:@"banner",nil];
        _jwView.localImageArray = imagesURLStrings;
    }else{
        for (NSDictionary *dt in self.goodsArr[0][@"img"]) {
            if (IS_IPHONE_6_PLUS) {
                [imagesURLStrings addObject:dt[@"imgurl2"]];
            }else{
                [imagesURLStrings addObject:dt[@"imgurl3"]];
            }
        }
        
        _jwView.imageURLArray=imagesURLStrings;
    }    // 图片配文字
    _jwView.imageMode = UIViewContentModeScaleAspectFill;
    _jwView.placeHolderColor=[UIColor grayColor];
    //轮播时间间隔
    _jwView.autoScrollTimeInterval=3.0f;
    //显示分页符
    _jwView.showPageControl=YES;
    //分页符位置
    _jwView.delegate=self;
    _jwView.pageControlAlignmentType=pageControlAlignmentTypeRight;
    _jwView.jwCycleScrollDirection=JWCycleScrollDirectionHorizontal; //横向
    [_jwView startAutoCarousel];
    
    [self.headerView addSubview:self.jwView];
    
}

#pragma mark JWCycleScrollImageDelegate
-(void)cycleScrollView:(JWCycleScrollView *)cycleScrollView didSelectIndex:(NSInteger)index{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dt in self.goodsArr[0][@"pictures"]) {
        [arr addObject:dt[@"url"]];
    }
    if (arr.count > 0) {
        STPhotoBroswer * broser = [[STPhotoBroswer alloc]initWithImageArray:arr currentIndex:index];
        [broser show];
    }
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.explainArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.goodsArr.count) {
        if (indexPath.section == 0) {
            
            CGSize descsize = [self.goodsArr[0][@"goods_name"] selfadap:15 weith:20];
            //秒杀
            NSInteger nowTime = [[NSDate date] timeIntervalSince1970];
            NSInteger endtimeTem  = [[NSString stringWithFormat:@"%@",self.goodsArr[0][@"promote_end_date"]] integerValue];
            NSInteger begaintimeTem  = [[NSString stringWithFormat:@"%@",self.goodsArr[0][@"promote_start_date"]] integerValue];
            CGFloat hh = 0;
            if (nowTime < endtimeTem && nowTime > begaintimeTem) {
                return descsize.height + 110 + hh;
            }
            return descsize.height + 70 + hh;
        }else if (indexPath.section == self.explainArray.count +1 ){//评论
            return self.wkviewHeight;
        }
        NSString *contLb = [NSString stringWithFormat:@"%@",self.explainArray[indexPath.section - 1][@"content"]];
        return [contLb selfadap:15 weith:20].height + 25;
    }else{
        return 0.001;
    }

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        NSString *onecellid = @"onecell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:onecellid];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:onecellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for (UIView *subview in cell.contentView.subviews) {
            if (subview != SpikeVIew) {
                [subview removeFromSuperview];
            }
        }
        if (self.goodsArr.count) {
            
            UILabel *descLabel = [cell viewWithTag:100];
            if (descLabel == nil) {
                descLabel = [[UILabel alloc]init];
                //                    descLabel.tag = 100;
                descLabel.font = [UIFont systemFontOfSize:15];
                descLabel.textColor  = JHColor(51, 51, 51);
                [cell.contentView addSubview: descLabel];
                descLabel.numberOfLines = 0;
            }
            descLabel.text = [NSString stringWithFormat:@"%@",self.goodsArr[0][@"goods_name"]];
            
            CGSize descsize = [descLabel.text selfadap:15 weith:20];
            [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.right.offset(-10);
                make.top.offset(10);
                make.height.offset(descsize.height + 10);
            }];
            //秒杀
            NSInteger nowTime = [[NSDate date] timeIntervalSince1970];
            //                NSInteger timeTem = [[NSString stringWithFormat:@"%@",self.goodsArr[0][@"promote_start_date"]] integerValue];
            NSInteger endtimeTem  = [[NSString stringWithFormat:@"%@",self.goodsArr[0][@"promote_end_date"]] integerValue];
            NSInteger begaintimeTem  = [[NSString stringWithFormat:@"%@",self.goodsArr[0][@"promote_start_date"]] integerValue];
            if (nowTime < endtimeTem && nowTime > begaintimeTem) {
                
                if (SpikeVIew == nil) {
                    SpikeVIew = [[UIView alloc]initWithFrame:CGRectMake(0, descsize.height + 20, SCREEN.size.width, 40)];
                    SpikeVIew.backgroundColor = JHColor(255, 234, 234);
                    
                    self.countDown = [CZCountDownView countDown];
                    
                    _countDown.timestamp = endtimeTem;
                    _countDown.font = 13;
                    _countDown.backColor = [UIColor redColor];
                    _countDown.textColor = [UIColor whiteColor];
                    //    countDown.backgroundImageName = @"search_k";
                    __weak typeof(self) weakSelf = self;
                    _countDown.timerStopBlock = ^{
                        NSLog(@"时间停止");
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            [weakSelf.tableView reloadData];
                        });
                        
                        
                    };
                    [SpikeVIew addSubview:_countDown];
                    [_countDown mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(SpikeVIew.mas_centerX);
                        make.centerY.equalTo(SpikeVIew.mas_centerY);
                        make.height.offset(25);
                        make.width.offset(135);
                    }];
                    NSArray *strArr = @[@"秒杀",@"结束"];
                    for (int i = 0; i < 2; i ++) {
                        UILabel *lb = [[UILabel alloc]init];
                        lb.text = strArr[i];
                        lb.font = [UIFont systemFontOfSize:14];
                        lb.textColor = [UIColor redColor];
                        lb.textAlignment = NSTextAlignmentCenter;
                        [SpikeVIew addSubview:lb];
                        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerY.equalTo(SpikeVIew.mas_centerY);
                            if (i == 0) {
                                make.right.equalTo(_countDown.mas_left).offset(-10);
                            }else{
                                make.left.equalTo(_countDown.mas_right).offset(10);
                            }
                        }];
                    }
                }
                [cell.contentView addSubview:SpikeVIew];
                
            }else{
                [SpikeVIew removeAllSubviews];
                [SpikeVIew removeFromSuperview];
                SpikeVIew = nil;
            }
            
            //价格
            
            UIButton *priceLabel1 = [self.view viewWithTag:101];
            if (priceLabel1 == nil) {
                priceLabel1 = [[UIButton alloc]init];
                priceLabel1.tag = 101;
                [priceLabel1 setTitleColor:JHAssistColor forState:UIControlStateNormal];
                priceLabel1.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
                [cell.contentView addSubview: priceLabel1];
                [priceLabel1 setImage:[UIImage imageNamed:@"jifenicon"] forState:UIControlStateNormal];
            }
            [priceLabel1 setTitle:[NSString stringWithFormat:@" %@",self.goodsArr[0][@"exchange_integral"]] forState:UIControlStateNormal];
            [priceLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                if (nowTime < endtimeTem && nowTime > begaintimeTem) {
                    make.top.equalTo(SpikeVIew.mas_bottom).offset(10);
                }else{
                    make.top.equalTo(descLabel.mas_bottom).offset(10);
                }
                make.height.offset(30);
            }];
            
            //兑换
            UIButton *alreadyLb = [cell viewWithTag:103];
            if (alreadyLb == nil) {
                alreadyLb = [[UIButton alloc]init];
                alreadyLb.tag = 103;
            }
            [alreadyLb addTarget:self action:@selector(exchangeClick:) forControlEvents:UIControlEventTouchUpInside];
            [alreadyLb setImage:[UIImage imageNamed:@"duihuanshangpin_buttun"] forState:UIControlStateNormal];
            [cell.contentView addSubview: alreadyLb];
            [alreadyLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-10);
                make.centerY.equalTo(priceLabel1.mas_centerY).offset(0);
            }];
            
            
            
        }
        return cell;
    }else if (indexPath.section == self.explainArray.count +1){
        NSString *twocellid = @"twocell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twocellid];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:twocellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.wkview == nil) {
            WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
            // 自适应屏幕宽度js
            NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
            WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
            // 添加自适应屏幕宽度js调用的方法
            WKUserContentController *wkUController = [[WKUserContentController alloc]init];
            [wkUController addUserScript:wkUserScript];
            self.wkview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 0) configuration:wkWebConfig];
            self.wkview.scrollView.delegate = self;
            self.wkview.UIDelegate = self;
            self.wkview.navigationDelegate = self;
            [self.wkview setAutoresizesSubviews:YES];
        }
        if (self.wkviewHeight == 0) {
            if (self.htmlStr) {
                [self.wkview loadHTMLString:self.htmlStr baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
            }
        }
        [cell.contentView addSubview:self.wkview];
        [self.wkview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.offset(0);
            make.top.offset(0);
            make.bottom.offset(0);
        }];
    
        return cell;
    }else {
        NSString *twocellid = @"exlpaincell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twocellid];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:twocellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell.contentView removeAllSubviews];
        UILabel *descLabel = [[UILabel alloc]init];
        descLabel.font = [UIFont systemFontOfSize:15];
        descLabel.textColor  = JHmiddleColor;
        descLabel.numberOfLines = 0;
        [cell.contentView addSubview: descLabel];
        descLabel.text = [NSString stringWithFormat:@"%@",self.explainArray[indexPath.section - 1][@"content"]];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-10);
            make.top.offset(10);
            make.bottom.offset(-10);
        }];
        return cell;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 35;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *foot = [[UIView alloc]init];
    foot.backgroundColor = JHbgColor;
    UILabel *nameLab = [[UILabel alloc]init];
    nameLab.font = [UIFont systemFontOfSize:15];
    nameLab.textColor  = JHmiddleColor;
    if (section  < self.explainArray.count) {
        nameLab.text = [NSString stringWithFormat:@"%@",self.explainArray[section][@"title"]];
    }else{
        nameLab.text = @"商品简介";
    }
    [foot addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
    return foot;
}
#pragma mark 兑换
-(void)exchangeClick:(UIButton *)btn{
    if (self.goodsArr.count) {
        if (self.goodsArr[0][@"is_real"]) {
            if ([[NSString stringWithFormat:@"%@",self.goodsArr[0][@"is_real"]] isEqualToString:@"0"]) {//0是虚拟
                TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"" message:@"\n确定兑换吗？\n"];
                //    alertView.backgroundColor = [UIColor whiteColor];
                [alertView addAction:[TYAlertAction actionWithTitle:[UIImage imageNamed:@"quxiao_buttun"] style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
                    
                }]];
                
                [alertView addAction:[TYAlertAction actionWithTitle:[UIImage imageNamed:@"queding_buttun"] style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
                    NSString *integalStr = [userDefaults objectForKey:@"user_pay_points"];
                    if (integalStr) {
                        double integal = [integalStr doubleValue];
                        double exchange_integral = [self.goodsArr[0][@"exchange_integral"] doubleValue];
                        if (integal >= exchange_integral) {
                            [self UploadDatagoodsOderSubmit];
                            return ;
                        }
                    }
                    TYAlertView *alertView1 = [TYAlertView alertViewWithTitle:@"" message:@"您的积分余额不足哦~\n快去多赚些积分再来吧~"];
                    //    alertView.backgroundColor = [UIColor whiteColor];
                    [alertView1 addAction:[TYAlertAction actionWithTitle:[UIImage imageNamed:@"haoda_buttun"] style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
                        
                    }]];
                    [alertView1 showInWindowWithOriginY:0 backgoundTapDismissEnable:NO];
                }]];
                
                [alertView showInWindowWithOriginY:0 backgoundTapDismissEnable:NO];
            }else{
                ConfirmOrderViewController *con  = [[ConfirmOrderViewController alloc]init];
                con.is_Integral = @"is_Integral";
                [self.navigationController pushViewController:con animated:YES];
            }
        }
    }
    
}
#pragma mark UIWebViewDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [self presentLoadingTips];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self dismissTips];
    [_wkview evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        LFLog(@"_wkview高度：%f",[result doubleValue]);
        self.tablefootview.height = [result doubleValue] + 30;
        self.tableView.tableFooterView = self.tablefootview;
    }];
    
}
#pragma mark - *************collectionView*************
//collectionview协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.likeArray.count;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.likeArray.count) {
        
        return CGSizeMake((SCREEN.size.width-5)/3.5, (SCREEN.size.width-10)/3.5 * 25/21 + 80);
        
    }
    return CGSizeZero;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShopListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailShopListCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor =[UIColor whiteColor];
    
    cell.contentView.backgroundImage = [UIImage imageNamed:@"shangpinditu"];
    cell.cartBtn.hidden = YES;
    NSDictionary *dt = self.likeArray[indexPath.item];
    [cell.imagePic sd_setImageWithURL:[NSURL URLWithString:dt[@"goods_thumb"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    cell.contentLb.text = dt[@"goods_name"];
    cell.contentLb.font = [UIFont systemFontOfSize:13];
    cell.newpriceLb.font = [UIFont systemFontOfSize:13];
    cell.newpriceLb.text = dt[@"price"];

    cell.PriceWidth.constant = [cell.newpriceLb.text selfadap:13 weith:SCREEN.size.width - 100].width + 10;
    cell.oldPrice.text = @"";

    
    
    return cell;
    
}


// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.collectionview) {
        return 0.001;
    }
    return 0.001;
}
// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.001;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ( NO == [UserModel online] )
    {
        [self showLogin:^(id response) {
            
        }];
        return;
    }

    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


-(void)PopUplayer{
    if (self.goodsArr.count) {
        if (_popview == nil) {
            
            _popview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height - 50)];
            _popview.tag = 222;
            //    popview.alpha = 0.5;
            _popview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            [[UIApplication sharedApplication].keyWindow addSubview:_popview];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            [_popview addGestureRecognizer:tap];
            UIScrollView *backview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREEN.size.height/2, SCREEN.size.width , SCREEN.size.height/2 - 50)];
            //            backview.scrollEnabled = YES;
            backview.backgroundColor = JHColor(255, 255, 255);
            [_popview addSubview:backview];
            UIImageView *picture = [[UIImageView alloc]init];
            picture.backgroundColor = [UIColor whiteColor];
            if ([self.goodsArr[0][@"img"] isKindOfClass:[NSDictionary class]]) {
                [picture sd_setImageWithURL:[NSURL URLWithString:self.goodsArr[0][@"img"][@"url"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            }
            backview.layer.masksToBounds = NO;
            [backview addSubview:picture];
            [picture mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10);
                make.top.offset(-20);
                make.width.offset(100);
                make.height.offset(120);
                
            }];
            
            UILabel *oldPrice = [[UILabel alloc]init];
            oldPrice.text = self.goodsArr[0][@"goods_name"];
            oldPrice.textColor = JHColor(51, 51, 51);
            oldPrice.numberOfLines = 0;
            oldPrice.font = [UIFont systemFontOfSize:13];
            CGSize oldsize = [oldPrice.text selfadap:13 weith:130];
            [backview addSubview:oldPrice];
            [oldPrice mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(picture.mas_right).offset(10);
                make.width.offset(SCREEN.size.width - 130 );
                make.bottom.equalTo(picture.mas_bottom);
                make.height.offset(oldsize.height + 5);
            }];
            UILabel *newPrice = [_popview viewWithTag:24];
            if (newPrice == nil) {
                newPrice = [[UILabel alloc]init];
                newPrice.tag = 24;
                newPrice.textColor = [UIColor redColor];
                newPrice.font = [UIFont systemFontOfSize:17];
            }
            
            newPrice.text = self.goodsArr[0][@"shop_price"];
            
            [backview addSubview:newPrice];
            [newPrice mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(picture.mas_right).offset(10);
                make.right.offset(-10);
                make.bottom.equalTo(oldPrice.mas_top);
            }];
            UIView *vline = [[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREEN.size.width, 1)];
            vline.backgroundColor = JHColor(229, 229, 229);
            [backview addSubview:vline];
            
            NSArray *arr = self.goodsArr[0][@"specification"];
            //    NSArray *arr = @[@"线控耳机",@"线控耳机",@"线控耳机",@"线控耳机"];
            CGFloat btnid = 0;
            CGFloat viewH = 121;
            for (int j = 0; j < arr.count; j ++) {
                UIButton *selectview = [[UIButton alloc]init];
                [backview addSubview:selectview];
                UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN.size.width - 40, 25)];
                if ([arr[j][@"attr_type"] isEqualToString:@"2"]) {
                    namelabel.text = [NSString stringWithFormat:@"%@（多选）",arr[j][@"name"]];
                    
                }else{
                    namelabel.text = [NSString stringWithFormat:@"%@（单选）",arr[j][@"name"]];
                }
                //        namelabel.text = arr[j][@"name"];
                
                namelabel.textColor = JHColor(102, 102, 102);
                namelabel.font = [UIFont systemFontOfSize:15];
                [selectview addSubview:namelabel];
                NSArray *valuearr = arr[j][@"value"];
                CGFloat wieth = 0;
                CGFloat heigth = 25;
                CGFloat totalwieth = 0;
                int count = 0;
                for (int i = 0; i < valuearr.count; i++) {
                    
                    UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
                    //            NSString *str = valuearr[i][@"label"];
                    NSString *str = [NSString stringWithFormat:@"%@",valuearr[i][@"label"]];;
                    [button setTitle:str forState:UIControlStateNormal];
                    CGSize size = [str selfadap:12 weith:30];
                    button.titleLabel.font = [UIFont systemFontOfSize:12];
                    button.frame = CGRectMake(15 + count* 15 + wieth, heigth, size.width + 10, 35);
                    NSString *str1 = [[NSString alloc]init];
                    
                    if (i == valuearr.count-1) {
                        
                    }else{
                        
                        //                str1 = valuearr[i+1][@"label"];
                        str1 = [NSString stringWithFormat:@"%@",valuearr[i+1][@"label"]];
                    }
                    LFLog(@"%@",str1);
                    CGSize size1 = [str1 selfadap:12 weith:30];
                    if (i < valuearr.count - 1) {
                        if (totalwieth + size1.width + size.width + count* 15 + 20 < SCREEN.size.width -30 ) {
                            
                            wieth  += size.width;
                            count ++;
                        }else{
                            heigth += 40;
                            totalwieth = 0;
                            wieth = 0;
                            count = 0;
                            
                        }
                    }
                    
                    button.backgroundColor = JHbgColor;
                    [button setTitleColor:JHdeepColor forState:UIControlStateNormal];
                    if ([arr[j][@"attr_type"] isEqualToString:@"1"]) {
                        //                        if (i == 0) {//取消默认单选
                        //                            button.backgroundColor = JHshopMainColor;
                        //                            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        //                            newPrice.text = [NSString stringWithFormat:@"%ld",([[self.goodsArr[0][@"shop_price"] stringByReplacingOccurrencesOfString:@"￥" withString:@""] integerValue] +[valuearr[i][@"price"] integerValue])];
                        //                        }
                    }
                    
                    //                    button.layer.borderWidth = 1;
                    //                    button.layer.borderColor = [[UIColor colorWithRed:214/256.0 green:214/256.0 blue:214/256.0 alpha:1]CGColor];
                    button.tag = 1000 +btnid + i;
                    button.layer.cornerRadius = 3;
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    [selectview addSubview:button];
                    
                    totalwieth = 15 + count* 15 + wieth;
                    
                }
                btnid += valuearr.count;
                selectview.frame = CGRectMake(0, viewH , SCREEN.size.width, heigth + 45);
                viewH += heigth + 45;
                
            }
            if (backview.height < viewH + 20) {//20留白
                backview.frame = CGRectMake(0, SCREEN.size.height - (viewH + 20) - 50, SCREEN.size.width, viewH + 20);
                backview.contentSize =  CGSizeMake(0, viewH + 20);
            }
            
        }else{
            _popview.hidden = NO;
        }
    }
}

//配件点击事件
-(void)buttonClick:(UIButton *)btn{
    NSArray *arr = self.goodsArr[0][@"specification"];
    CGFloat btnid = 0;
    for (int j = 0; j < arr.count; j ++) {
        NSArray *valuearr = arr[j][@"value"];
        
        if ( (btn.tag - 1000) >= btnid && (btn.tag - 1000) < (btnid + valuearr.count)) {
            for (int i = 0; i < valuearr.count; i++) {
                LFLog(@"tag:%ld",(long)btn.tag);
                UIButton *button = [_popview viewWithTag:1000 +btnid + i];
                if ([arr[j][@"attr_type"] isEqualToString:@"1"]) {//单选
                    if (btn.tag == button.tag) {
                        btn.backgroundColor = JHshopMainColor;
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }else{
                        button.backgroundColor =JHbgColor;
                        [button setTitleColor:JHdeepColor forState:UIControlStateNormal];
                    }
                }else{
                    
                    if ([btn.backgroundColor isEqual:JHshopMainColor]) {
                        btn.backgroundColor = JHbgColor;
                        [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
                        [self ergodicButton];
                        return;
                        
                    }else{
                        btn.backgroundColor = JHshopMainColor;
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [self ergodicButton];
                        return;
                    }
                    
                    
                }
            }
            
        }
        
        
        btnid += valuearr.count;
        
        
    }
    [self ergodicButton];
}
//隐藏弹出层
-(void)tapClick:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
    if (!_popview.hidden) {
        _popview.hidden = YES;
        [self ergodicButton];
    }
    
}

//遍历选中配件的属性
-(void)ergodicButton{
    
    if (self.goodsArr.count) {
        NSArray *arr = self.goodsArr[0][@"specification"];
        if (arr.count) {
            UILabel *newPrice = [_popview viewWithTag:24];
            NSInteger price = 0;
            UILabel *accessories = [self.view viewWithTag:103];
            NSMutableString *mstr = [NSMutableString string];
            NSArray *arr = self.goodsArr[0][@"specification"];
            CGFloat btnid = 0;
            NSMutableArray *marray = [[NSMutableArray alloc]init];
            [self.specArray removeAllObjects];
            for (int j = 0; j < arr.count; j ++) {
                NSArray *valuearr = arr[j][@"value"];
                for (int i = 0; i < valuearr.count; i++) {
                    
                    UIButton *button = [_popview viewWithTag:1000 +btnid + i];
                    if ([button.backgroundColor isEqual:JHshopMainColor]) {
                        NSDictionary *dt = [NSDictionary dictionaryWithObjectsAndKeys:valuearr[i][@"id"],@"id",valuearr[i][@"label"],@"label",valuearr[i][@"price"],@"price", nil];
                        [marray addObject:dt];
                        [self.specArray addObject:valuearr[i][@"id"]];
                        [mstr appendFormat:@"%@ ",valuearr[i][@"label"]];
                        price += [valuearr[i][@"price"] integerValue];
                    }
                    
                }
                
                btnid += valuearr.count;
            }
            
            self.totailPrice = [NSString stringWithFormat:@"￥%ld",([[self.goodsArr[0][@"shop_price"] stringByReplacingOccurrencesOfString:@"￥" withString:@""] integerValue] +price)];
            LFLog(@"totailPrice:%@",self.totailPrice);
            newPrice.text = self.totailPrice;
            self.priceLb.text = self.totailPrice;
            UILabel *priceLabel1 = [self.view viewWithTag:101];//cell上的价格
            NSArray *priceArr = [self.totailPrice componentsSeparatedByString:@"."];
            if (priceArr.count > 1) {
                NSMutableAttributedString* htinstr = [[NSMutableAttributedString alloc]initWithString:self.totailPrice];
                NSString *str = @".";
                NSRange range =[[htinstr string]rangeOfString:str];
                NSRange newrange = {range.location + 1,self.totailPrice.length - range.location -1};
                [htinstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:newrange];
                NSRange rangeSymbol =[[htinstr string]rangeOfString:@"￥"];
                [htinstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:rangeSymbol];
                
                priceLabel1.attributedText = htinstr;
            }else{
                priceLabel1.text = self.totailPrice;
            }
            accessories.text = mstr;
            LFLog(@"marray:%@",marray);
        }
        
    }
    
}
#pragma mark - *************商品详情请求*************
-(void)UploadDatagoods:(BOOL)isCart{
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.goods_id,@"goods_id", nil];
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    LFLog(@"商品详情请求dt:%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,ShopIntegraDetailUrl) params:dt success:^(id response) {
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        LFLog(@"商品详情:%@",response);
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self.goodsArr removeAllObjects];
            [self.explainArray removeAllObjects];
            [self.goodsArr addObject:response[@"data"]];
            if ([self.goodsArr[0][@"explain"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *exdt in self.goodsArr[0][@"explain"]) {
                    [self.explainArray addObject:exdt];
                }
            }
            if ([response[@"data"][@"desc"] isKindOfClass:[NSString class]]) {
                self.htmlStr = response[@"data"][@"desc"];
            }
            if (self.wkview == nil) {
                WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
                // 自适应屏幕宽度js
                NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
                WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
                // 添加自适应屏幕宽度js调用的方法
                WKUserContentController *wkUController = [[WKUserContentController alloc]init];
                [wkUController addUserScript:wkUserScript];
                self.wkview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.size.width, 0) configuration:wkWebConfig];
                self.wkview.scrollView.delegate = self;
                self.wkview.UIDelegate = self;
                self.wkview.navigationDelegate = self;
                [self.wkview setAutoresizesSubviews:YES];
            }
            if (self.htmlStr) {
                [self.wkview loadHTMLString:self.htmlStr baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
            }
            [self.tablefootview addSubview:self.wkview];
            [self.wkview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
                make.right.offset(0);
                make.top.offset(0);
                make.bottom.offset(0);
            }];
            [self ceratCycleScrollView];
            [self.tableView reloadData];
        }else{
            NSString *error_code = [NSString stringWithFormat:@"%@",response[@"status"][@"error_code"]];
            if ([error_code isEqualToString:@"100"]) {
                [self showLogin:^(id response) {
                    if ([response isEqualToString:@"1"]) {
                        [self UploadDatagoods:NO];
                    }
                    
                }];
            }
            [self presentLoadingTips:response[@"status"][@"error_desc"]];
            
        }
    } failure:^(NSError *error) {
        [self dismissTips];
        [self presentLoadingTips:@"请求失败！"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    
}

#pragma mark - *************商品订单提交请求*************
-(void)UploadDatagoodsOderSubmit{
    [self presentLoadingTips];
    NSDictionary * session =[userDefaults objectForKey:@"session"];
    NSMutableDictionary * dt = [[NSMutableDictionary alloc]init];
    LFLog(@"session：%@",session);
    if (session) {
        [dt setObject:session forKey:@"session"];
    }
    [dt setObject:@"1" forKey:@"is_integral"];
    LFLog(@"提交订单信息dt：%@",dt);
    [LFLHttpTool post:NSStringWithFormat(ZJShopBaseUrl,SubmitOrdersUrl) params:dt success:^(id response) {
        LFLog(@"提交订单信息：%@",response);
        [self dismissTips];
        NSString *str = [NSString stringWithFormat:@"%@",response[@"status"][@"succeed"]];
        if ([str isEqualToString:@"1"]) {
            [self presentLoadingTips:@"兑换成功"];
            [self performSelector:@selector(goBlack) withObject:nil afterDelay:.2];
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
        LFLog(@"error:%@",error);
    }];
    
    
}
-(void)goBlack{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 集成刷新控件
- (void)setupRefresh
{
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self UploadDatagoods:NO];
    }];
    
    //    }];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self tapClick:nil];
    
    
}


@end
